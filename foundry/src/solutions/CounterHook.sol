// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// BaseHookを基にしています
// https://github.com/Uniswap/v4-periphery/blob/main/src/utils/BaseHook.sol

// 関数の入力と出力の説明についてはこちらを参照してください
// https://github.com/Uniswap/v4-core/blob/main/src/interfaces/IHooks.sol

import {IPoolManager} from "../interfaces/IPoolManager.sol";
import {Hooks} from "../libraries/Hooks.sol";
import {PoolId, PoolIdLibrary} from "../types/PoolId.sol";
import {PoolKey} from "../types/PoolKey.sol";
import {SwapParams, ModifyLiquidityParams} from "../types/PoolOperation.sol";
import {BalanceDelta} from "../types/BalanceDelta.sol";
import {
    BeforeSwapDelta,
    BeforeSwapDeltaLibrary
} from "../types/BeforeSwapDelta.sol";

/**
 * Uniswapの処理の前後でCounterをインクリメントするフックコントラクト(サンプルコード)
 * @title 
 * @author 
 * @notice 
 */
contract CounterHook {
    using PoolIdLibrary for PoolKey;

    error NotPoolManager();
    error HookNotImplemented();

    IPoolManager public immutable poolManager;
    // カウンターのマッピング: PoolId => (フック名 => カウント)
    mapping(PoolId => mapping(string => uint256)) public counts;

    modifier onlyPoolManager() {
        if (msg.sender != address(poolManager)) revert NotPoolManager();
        _;
    }

    /**
     * コンストラクター
     * @param _poolManager プールマネージャーのアドレス
     */
    constructor(address _poolManager) {
        poolManager = IPoolManager(_poolManager);
        // このコントラクトに設定されているフック権限が正しいことを検証します
        Hooks.validateHookPermissions(address(this), getHookPermissions());
    }

    /**
     * フックの権限を取得します
     * @return フックの権限
     */
    function getHookPermissions()
        public
        pure
        returns (Hooks.Permissions memory)
    {
        return Hooks.Permissions({
            beforeInitialize: false,
            afterInitialize: false,
            beforeAddLiquidity: true,
            afterAddLiquidity: false,
            beforeRemoveLiquidity: true,
            afterRemoveLiquidity: false,
            beforeSwap: true,  // Swapの前にフックを有効化
            afterSwap: true,   // Swapの後にフックを有効化
            beforeDonate: false,
            afterDonate: false,
            beforeSwapReturnDelta: false,
            afterSwapReturnDelta: false,
            afterAddLiquidityReturnDelta: false,
            afterRemoveLiquidityReturnDelta: false
        });
    }

    /**
     * beforeInitializeフック
     * @param sender spender address
     * @param key  プールキー
     * @param sqrtPriceX96 初期価格の平方根（Q64.96形式）
     */
    function beforeInitialize(
        address sender,
        PoolKey calldata key,
        uint160 sqrtPriceX96
    ) external onlyPoolManager returns (bytes4) {
        revert HookNotImplemented();
    }

    /**
     * afterInitializeフック
     * @param sender spender address
     * @param key  プールキー
     * @param sqrtPriceX96 初期価格の平方根（Q64.96形式）
     * @param tick 現在のティック
     */
    function afterInitialize(
        address sender,
        PoolKey calldata key,
        uint160 sqrtPriceX96,
        int24 tick
    ) external onlyPoolManager returns (bytes4) {
        revert HookNotImplemented();
    }

    /**
     * Swapの前に呼び出されるフック
     * @param sender spender address
     * @param key  プールキー
     * @param params パラメーター
     * @param hookData フックデータ
     */
    function beforeSwap(
        address sender,
        PoolKey calldata key,
        SwapParams calldata params,
        bytes calldata hookData
    ) external onlyPoolManager returns (bytes4, BeforeSwapDelta, uint24) {
        // カウンターをインクリメント
        counts[key.toId()]["beforeSwap"]++;
        return (this.beforeSwap.selector, BeforeSwapDeltaLibrary.ZERO_DELTA, 0);
    }

    /**
     * Swapの後に呼び出されるフック
     */
    function afterSwap(
        address sender,
        PoolKey calldata key,
        SwapParams calldata params,
        BalanceDelta delta,
        bytes calldata hookData
    ) external onlyPoolManager returns (bytes4, int128) {
        // カウンターをインクリメント
        counts[key.toId()]["afterSwap"]++;
        return (this.afterSwap.selector, 0);
    }

    /**
     * 流動性を提供する前に呼び出されるフック
     */
    function beforeAddLiquidity(
        address sender,
        PoolKey calldata key,
        ModifyLiquidityParams calldata params,
        bytes calldata hookData
    ) external onlyPoolManager returns (bytes4) {
        // カウンターをインクリメント
        counts[key.toId()]["beforeAddLiquidity"]++;
        return this.beforeAddLiquidity.selector;
    }

    /**
     * 流動性を提供した後に呼び出されるフック
     */
    function afterAddLiquidity(
        address sender,
        PoolKey calldata key,
        ModifyLiquidityParams calldata params,
        BalanceDelta delta,
        BalanceDelta feesAccrued,
        bytes calldata hookData
    ) external onlyPoolManager returns (bytes4, BalanceDelta) {
        revert HookNotImplemented();
    }

    function beforeRemoveLiquidity(
        address sender,
        PoolKey calldata key,
        ModifyLiquidityParams calldata params,
        bytes calldata hookData
    ) external onlyPoolManager returns (bytes4) {
        // カウンターをインクリメント
        counts[key.toId()]["beforeRemoveLiquidity"]++;
        return this.beforeRemoveLiquidity.selector;
    }

    function afterRemoveLiquidity(
        address sender,
        PoolKey calldata key,
        ModifyLiquidityParams calldata params,
        BalanceDelta delta,
        BalanceDelta feesAccrued,
        bytes calldata hookData
    ) external onlyPoolManager returns (bytes4, BalanceDelta) {
        revert HookNotImplemented();
    }

    function beforeDonate(
        address sender,
        PoolKey calldata key,
        uint256 amount0,
        uint256 amount1,
        bytes calldata hookData
    ) external onlyPoolManager returns (bytes4) {
        revert HookNotImplemented();
    }

    function afterDonate(
        address sender,
        PoolKey calldata key,
        uint256 amount0,
        uint256 amount1,
        bytes calldata hookData
    ) external onlyPoolManager returns (bytes4) {
        revert HookNotImplemented();
    }
}
