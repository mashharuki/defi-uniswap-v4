// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/// @notice `ModifyLiquidity`プール操作のパラメータ構造体
struct ModifyLiquidityParams {
    // ポジションの下限と上限のtick
    int24 tickLower;
    int24 tickUpper;
    // 流動性をどのように変更するか
    int256 liquidityDelta;
    // 同じ範囲でユニークな流動性ポジションが必要な場合に設定する値
    bytes32 salt;
}

/// @notice `Swap`プール操作のパラメータ構造体
struct SwapParams {
    /// token0をtoken1にスワップするか、その逆か
    bool zeroForOne;
    /// 負の場合は希望する入力量（exactIn）、正の場合は希望する出力量（exactOut）
    int256 amountSpecified;
    /// 到達した場合にスワップが実行を停止するsqrt価格
    uint160 sqrtPriceLimitX96;
}
