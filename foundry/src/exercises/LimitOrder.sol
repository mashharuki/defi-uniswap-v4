// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {IERC20} from "../interfaces/IERC20.sol";
import {IPoolManager} from "../interfaces/IPoolManager.sol";
import {Hooks} from "../libraries/Hooks.sol";
import {SafeCast} from "../libraries/SafeCast.sol";
import {CurrencyLib} from "../libraries/CurrencyLib.sol";
import {StateLibrary} from "../libraries/StateLibrary.sol";
import {PoolId, PoolIdLibrary} from "../types/PoolId.sol";
import {PoolKey} from "../types/PoolKey.sol";
import {SwapParams, ModifyLiquidityParams} from "../types/PoolOperation.sol";
import {BalanceDelta, BalanceDeltaLibrary} from "../types/BalanceDelta.sol";
import {TStore} from "../TStore.sol";

/**
 * LimitOrder コントラクト
 */
contract LimitOrder is TStore {
    using PoolIdLibrary for PoolKey;
    using BalanceDeltaLibrary for BalanceDelta;
    using SafeCast for int128;
    using SafeCast for uint128;
    using CurrencyLib for address;

    error NotPoolManager();

    uint256 constant ADD_LIQUIDITY = 1;
    uint256 constant REMOVE_LIQUIDITY = 2;

    event Place(
        bytes32 indexed poolId,
        uint256 indexed slot,
        address indexed user,
        int24 tickLower,
        bool zeroForOne,
        uint128 liquidity
    );
    event Cancel(
        bytes32 indexed poolId,
        uint256 indexed slot,
        address indexed user,
        int24 tickLower,
        bool zeroForOne,
        uint128 liquidity
    );
    event Take(
        bytes32 indexed poolId,
        uint256 indexed slot,
        address indexed user,
        int24 tickLower,
        bool zeroForOne,
        uint256 amount0,
        uint256 amount1
    );
    event Fill(
        bytes32 indexed poolId,
        uint256 indexed slot,
        int24 tickLower,
        bool zeroForOne,
        uint256 amount0,
        uint256 amount1
    );

    // 指値注文のバケット
    struct Bucket {
        bool filled;
        uint256 amount0;
        uint256 amount1;
        // 合計流動性
        uint128 liquidity;
        // ユーザーごとの提供流動性
        mapping(address => uint128) sizes;
    }

    IPoolManager public immutable poolManager;

    // バケットID => 指値注文を配置する現在のスロット
    mapping(bytes32 => uint256) public slots;
    // バケットID => スロット => バケット
    mapping(bytes32 => mapping(uint256 => Bucket)) public buckets;
    // プールID => 最後のティック
    mapping(PoolId => int24) public ticks;

    modifier onlyPoolManager() {
        if (msg.sender != address(poolManager)) revert NotPoolManager();
        _;
    }

    /**
     * コンストラクター
     */
    constructor(address _poolManager) {
        // プールマネージャーの設定
        poolManager = IPoolManager(_poolManager);
        // フック権限の検証
        Hooks.validateHookPermissions(address(this), getHookPermissions());
    }

    receive() external payable {}

    /**
     * フック権限の取得
     */
    function getHookPermissions()
        public
        pure
        returns (Hooks.Permissions memory)
    {
        return Hooks.Permissions({
            beforeInitialize: false,
            afterInitialize: true,
            beforeAddLiquidity: false,
            afterAddLiquidity: false,
            beforeRemoveLiquidity: false,
            afterRemoveLiquidity: false,
            beforeSwap: false,
            afterSwap: true,
            beforeDonate: false,
            afterDonate: false,
            beforeSwapReturnDelta: false,
            afterSwapReturnDelta: false,
            afterAddLiquidityReturnDelta: false,
            afterRemoveLiquidityReturnDelta: false
        });
    }

    /**
     * 初期化した後に呼び出すHook
     */
    function afterInitialize(
        address sender,
        PoolKey calldata key,
        uint160 sqrtPriceX96,
        int24 tick
    ) external onlyPoolManager returns (bytes4) {
        // stateの更新
        ticks[key.toId()] = tick;
        return this.afterInitialize.selector;
    }

    /**
     * スワップ後に呼び出すHook
     */
    function afterSwap(
        address sender,
        PoolKey calldata key,
        SwapParams calldata params,
        BalanceDelta delta,
        bytes calldata hookData
    )
        external
        onlyPoolManager
        setAction(REMOVE_LIQUIDITY)
        returns (bytes4, int128)
    {
        // PoolIdを取得
        PoolId poolId = key.toId();
        // 現在のティックを取得
        int24 tick = _getTick(poolId);

        (int24 lower, int24 upper) =
            _getTickRange(ticks[poolId], tick, key.tickSpacing);

        if (upper < lower) {
            return (this.afterSwap.selector, 0);
        }

        bool zeroForOne = !params.zeroForOne;
        // 指値注文の方向を反転
        while (lower <= upper) {
            bytes32 id = getBucketId(poolId, lower, zeroForOne);
            uint256 s = slots[id];
            Bucket storage bucket = buckets[id][s];
            if (bucket.liquidity > 0) {
                slots[id] = s + 1;
                // 流動性を削除して、amount0, amount1を取得
                (uint256 amount0, uint256 amount1,,) = _removeLiquidity(
                    key, lower, -int256(uint256(bucket.liquidity))
                );
                bucket.filled = true;
                bucket.amount0 += amount0;
                bucket.amount1 += amount1;
                emit Fill(
                    PoolId.unwrap(poolId),
                    s,
                    lower,
                    zeroForOne,
                    bucket.amount0,
                    bucket.amount1
                );
            }
            lower += key.tickSpacing;
        }

        // stateの更新
        ticks[poolId] = tick;

        return (this.afterSwap.selector, 0);
    }

    /**
     * unlockしたときに呼び出されるコールバック関数
     */
    function unlockCallback(bytes calldata data)
        external
        onlyPoolManager
        returns (bytes memory)
    {
        uint256 action = _getAction();

        if (action == ADD_LIQUIDITY) {
            // デコードして情報を取得する
            (
                address msgSender,
                uint256 msgVal,
                PoolKey memory key,
                int24 tickLower,
                bool zeroForOne,
                uint128 liquidity
            ) = abi.decode(
                data, (address, uint256, PoolKey, int24, bool, uint128)
            );

            // 流動性を追加
            (int256 d,) = poolManager.modifyLiquidity({
                key: key,
                params: ModifyLiquidityParams({
                    tickLower: tickLower,
                    tickUpper: tickLower + key.tickSpacing,
                    liquidityDelta: int256(uint256(liquidity)),
                    salt: bytes32(0)
                }),
                hookData: ""
            });

            // 支払い情報を取得
            BalanceDelta delta = BalanceDelta.wrap(d);
            int128 amount0 = delta.amount0();
            int128 amount1 = delta.amount1();

            address currency;
            uint256 amountToPay;
            if (zeroForOne) {
                require(amount0 < 0 && amount1 == 0, "Tick crossed");
                currency = key.currency0;
                amountToPay = (-amount0).toUint256();
            } else {
                require(amount0 == 0 && amount1 < 0, "Tick crossed");
                currency = key.currency1;
                amountToPay = (-amount1).toUint256();
            }

            // 同期 + 支払い + 決済
            poolManager.sync(currency);
            if (currency == address(0)) {
                require(msgVal >= amountToPay, "Not enough ETH sent");
                poolManager.settle{value: amountToPay}();
                if (msgVal > amountToPay) {
                    _sendEth(msgSender, msgVal - amountToPay);
                }
            } else {
                require(msgVal == 0, "received ETH");
                IERC20(currency).transferFrom(
                    msgSender, address(poolManager), amountToPay
                );
                poolManager.settle();
            }

            return "";
        } else if (action == REMOVE_LIQUIDITY) {
            (PoolKey memory key, int24 tickLower, uint128 size) =
                abi.decode(data, (PoolKey, int24, uint128));
            // 流動性を削除
            (uint256 amount0, uint256 amount1, uint256 fee0, uint256 fee1) =
                _removeLiquidity(key, tickLower, -int256(uint256(size)));
            // 戻り値をエンコードして返す
            return abi.encode(amount0, amount1, fee0, fee1);
        }

        revert("Invalid action");
    }

    /**
     * 指値注文を配置する関数
     */
    function place(
        PoolKey calldata key,
        int24 tickLower,
        bool zeroForOne,
        uint128 liquidity
    ) external payable setAction(ADD_LIQUIDITY) {
        require(tickLower % key.tickSpacing == 0, "Invalid tick");
        require(liquidity > 0, "liquidity = 0");
        
        // unlockを呼び出す(コールバック関数が呼び出される)
        poolManager.unlock(
            abi.encode(
                msg.sender, msg.value, key, tickLower, zeroForOne, liquidity
            )
        );

        PoolId poolId = key.toId();
        bytes32 id = getBucketId(poolId, tickLower, zeroForOne);
        uint256 slot = slots[id];

        Bucket storage bucket = buckets[id][slot];
        bucket.liquidity += liquidity;
        bucket.sizes[msg.sender] += liquidity;

        emit Place(
            PoolId.unwrap(poolId),
            slot,
            msg.sender,
            tickLower,
            zeroForOne,
            liquidity
        );
    }

    /**
     * 指値注文をキャンセルする関数
     */
    function cancel(PoolKey calldata key, int24 tickLower, bool zeroForOne)
        external
        setAction(REMOVE_LIQUIDITY)
    {
        PoolId poolId = key.toId();
        bytes32 id = getBucketId(poolId, tickLower, zeroForOne);
        uint256 slot = slots[id];
        // 現在のスロットを取得
        Bucket storage bucket = buckets[id][slot];
        require(!bucket.filled, "bucket filled");

        uint128 size = bucket.sizes[msg.sender];
        require(size > 0, "limit order size = 0");

        bucket.liquidity -= size;
        bucket.sizes[msg.sender] = 0;
        // unlockを呼び出す(コールバック関数が呼び出される)
        bytes memory res = poolManager.unlock(abi.encode(key, tickLower, size));
        (uint256 amount0, uint256 amount1, uint256 fee0, uint256 fee1) =
            abi.decode(res, (uint256, uint256, uint256, uint256));

        // 最後にキャンセルしたユーザーがすべての手数料を受け取る
        if (bucket.liquidity > 0) {
            bucket.amount0 += fee0;
            bucket.amount1 += fee1;
            // amount0と1には手数料が含まれている
            if (amount0 > fee0) {
                // 手数料を差し引いて転送
                key.currency0.transferOut(msg.sender, amount0 - fee0);
            }
            if (amount1 > fee1) {
                key.currency1.transferOut(msg.sender, amount1 - fee1);
            }
        } else {
            amount0 += bucket.amount0;
            bucket.amount0 = 0;
            if (amount0 > 0) {
                // 全額転送
                key.currency0.transferOut(msg.sender, amount0);
            }
            amount1 += bucket.amount1;
            bucket.amount1 = 0;
            if (amount1 > 0) {
                key.currency1.transferOut(msg.sender, amount1);
            }
        }

        emit Cancel(
            PoolId.unwrap(poolId), slot, msg.sender, tickLower, zeroForOne, size
        );
    }

    /**
     * 指値注文を実行する関数
     */
    function take(
        PoolKey calldata key,
        int24 tickLower,
        bool zeroForOne,
        uint256 slot
    ) external {
        // バケットを取得
        PoolId poolId = key.toId();
        bytes32 id = getBucketId(poolId, tickLower, zeroForOne);
        Bucket storage bucket = buckets[id][slot];
        require(bucket.filled, "bucket not filled");

        uint256 liquidity = uint256(bucket.liquidity);
        uint256 size = uint256(bucket.sizes[msg.sender]);
        require(size > 0, "size = 0");
        bucket.sizes[msg.sender] = 0;

        // 注意: ここではmulDivの使用を推奨します
        uint256 amount0 = bucket.amount0 * size / liquidity;
        uint256 amount1 = bucket.amount1 * size / liquidity;

        if (amount0 > 0) {
            // amount0を転送
            key.currency0.transferOut(msg.sender, amount0);
        }
        if (amount1 > 0) {
            // amount1を転送
            key.currency1.transferOut(msg.sender, amount1);
        }

        emit Take(
            PoolId.unwrap(poolId),
            slot,
            msg.sender,
            tickLower,
            zeroForOne,
            amount0,
            amount1
        );
    }

    /**
     * バケットIDを取得する関数
     */
    function getBucketId(PoolId poolId, int24 tick, bool zeroForOne)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(PoolId.unwrap(poolId), tick, zeroForOne));
    }

    /**
     * バケットを取得するメソッド
     */
    function getBucket(bytes32 id, uint256 slot)
        public
        view
        returns (
            bool filled,
            uint256 amount0,
            uint256 amount1,
            uint128 liquidity
        )
    {
        Bucket storage bucket = buckets[id][slot];
        return (bucket.filled, bucket.amount0, bucket.amount1, bucket.liquidity);
    }

    /**
     * ユーザーごとの注文サイズを取得するメソッド
     */
    function getOrderSize(bytes32 id, uint256 slot, address user)
        public
        view
        returns (uint128)
    {
        return buckets[id][slot].sizes[user];
    }

    function _getTick(PoolId poolId) private view returns (int24 tick) {
        (, tick,,) = StateLibrary.getSlot0(address(poolManager), poolId);
    }

    function _getTickLower(int24 tick, int24 tickSpacing)
        private
        pure
        returns (int24)
    {
        int24 compressed = tick / tickSpacing;
        // 負の無限大方向に丸める
        if (tick < 0 && tick % tickSpacing != 0) compressed--;
        return compressed * tickSpacing;
    }

    function _getTickRange(int24 tick0, int24 tick1, int24 tickSpacing)
        private
        pure
        returns (int24 lower, int24 upper)
    {
        // 前回の下限ティック
        int24 l0 = _getTickLower(tick0, tickSpacing);
        // 現在の下限ティック
        int24 l1 = _getTickLower(tick1, tickSpacing);

        if (tick0 <= tick1) {
            lower = l0;
            upper = l1 - tickSpacing;
        } else {
            lower = l1 + tickSpacing;
            upper = l0;
        }
    }
}
