// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {IExtsload} from "./IExtsload.sol";
import {IExttload} from "./IExttload.sol";
import {PoolKey} from "../types/PoolKey.sol";
import {ModifyLiquidityParams, SwapParams} from "../types/PoolOperation.sol";

interface IPoolManager is IExtsload, IExttload {
    /// @notice コントラクトがアンロックされた後に通貨がネットされていない場合にスロー
    error CurrencyNotSettled();

    /// @notice 初期化されていないプールとやり取りしようとした時にスロー
    error PoolNotInitialized();

    /// @notice unlockが呼ばれたが、コントラクトが既にアンロックされている場合にスロー
    error AlreadyUnlocked();

    /// @notice コントラクトがアンロックされている必要がある関数が呼ばれたが、アンロックされていない場合にスロー
    error ManagerLocked();

    /// @notice オーバーフローを防ぐため、プールは#initializeでtype(int16).maxのtickSpacingに制限される
    error TickSpacingTooLarge(int24 tickSpacing);

    /// @notice プールは#initializeに正の非ゼロtickSpacingを渡す必要がある
    error TickSpacingTooSmall(int24 tickSpacing);

    /// @notice PoolKeyはaddress(currency0) < address(currency1)となる通貨を持つ必要がある
    error CurrenciesOutOfOrderOrEqual(address currency0, address currency1);

    /// @notice hookではないアドレスからupdateDynamicLPFeeが呼ばれた場合、
    /// または動的スワップ手数料を持たないプールで呼ばれた場合にスロー
    error UnauthorizedDynamicLPFeeUpdate();

    /// @notice 0の量でスワップしようとした時にスロー
    error SwapAmountCannotBeZero();

    ///@notice ネイティブ通貨以外の決済にネイティブ通貨が渡された時にスロー
    error NonzeroNativeValue();

    /// @notice オープンな通貨デルタと正確に等しくない量で`clear`が呼ばれた時にスロー
    error MustClearExactPositiveDelta();

    function unlock(bytes calldata data) external returns (bytes memory);

    function initialize(PoolKey memory key, uint160 sqrtPriceX96)
        external
        returns (int24 tick);

    function modifyLiquidity(
        PoolKey memory key,
        ModifyLiquidityParams memory params,
        bytes calldata hookData
    ) external returns (int256 callerDelta, int256 feesAccrued);

    function swap(
        PoolKey memory key,
        SwapParams memory params,
        bytes calldata hookData
    ) external returns (int256 swapDelta);

    function donate(
        PoolKey memory key,
        uint256 amount0,
        uint256 amount1,
        bytes calldata hookData
    ) external returns (int256);

    function sync(address currency) external;

    function take(address currency, address to, uint256 amount) external;

    function settle() external payable returns (uint256 paid);

    function settleFor(address recipient)
        external
        payable
        returns (uint256 paid);

    function clear(address currency, uint256 amount) external;

    function mint(address to, uint256 id, uint256 amount) external;

    function burn(address from, uint256 id, uint256 amount) external;

    function updateDynamicLPFee(PoolKey memory key, uint24 newDynamicLPFee)
        external;
}
