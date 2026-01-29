// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {PoolId} from "../types/PoolId.sol";

interface IStateView {
    /// @notice プールのSlot0を取得: sqrtPriceX96、tick、protocolFee、lpFee
    /// @dev pools[poolId].slot0に対応
    /// @param poolId プールのID
    /// @return sqrtPriceX96 Q96精度でのプールの価格の平方根
    /// @return tick プールの現在のtick
    /// @return protocolFee プールのプロトコル手数料
    /// @return lpFee プールのスワップ手数料
    function getSlot0(PoolId poolId)
        external
        view
        returns (
            uint160 sqrtPriceX96,
            int24 tick,
            uint24 protocolFee,
            uint24 lpFee
        );

    /// @notice 特定のtickでのプールのtick情報を取得
    /// @dev pools[poolId].ticks[tick]に対応
    /// @param poolId プールのID
    /// @param tick 情報を取得するtick
    /// @return liquidityGross このtickを参照する総ポジション流動性
    /// @return liquidityNet tickが左から右（右から左）に横切られた時に追加（減算）されるネット流動性の量
    /// @return feeGrowthOutside0X128 このtickの反対側（現在のtickに対して）での流動性単位あたりの手数料成長
    /// @return feeGrowthOutside1X128 このtickの反対側（現在のtickに対して）での流動性単位あたりの手数料成長
    function getTickInfo(PoolId poolId, int24 tick)
        external
        view
        returns (
            uint128 liquidityGross,
            int128 liquidityNet,
            uint256 feeGrowthOutside0X128,
            uint256 feeGrowthOutside1X128
        );

    /// @notice 特定のtickでのプールの流動性情報を取得
    /// @dev pools[poolId].ticks[tick].liquidityGrossとpools[poolId].ticks[tick].liquidityNetに対応。getTickInfoのよりガス効率の良いバージョン
    /// @param poolId プールのID
    /// @param tick 流動性を取得するtick
    /// @return liquidityGross このtickを参照する総ポジション流動性
    /// @return liquidityNet tickが左から右（右から左）に横切られた時に追加（減算）されるネット流動性の量
    function getTickLiquidity(PoolId poolId, int24 tick)
        external
        view
        returns (uint128 liquidityGross, int128 liquidityNet);

    /// @notice プールのtick範囲外の手数料成長を取得
    /// @dev pools[poolId].ticks[tick].feeGrowthOutside0X128とpools[poolId].ticks[tick].feeGrowthOutside1X128に対応。getTickInfoのよりガス効率の良いバージョン
    /// @param poolId プールのID
    /// @param tick 手数料成長を取得するtick
    /// @return feeGrowthOutside0X128 このtickの反対側（現在のtickに対して）での流動性単位あたりの手数料成長
    /// @return feeGrowthOutside1X128 このtickの反対側（現在のtickに対して）での流動性単位あたりの手数料成長
    function getTickFeeGrowthOutside(PoolId poolId, int24 tick)
        external
        view
        returns (uint256 feeGrowthOutside0X128, uint256 feeGrowthOutside1X128);

    /// @notice プールのグローバル手数料成長を取得
    /// @dev pools[poolId].feeGrowthGlobal0X128とpools[poolId].feeGrowthGlobal1X128に対応
    /// @param poolId プールのID
    /// @return feeGrowthGlobal0 token0のグローバル手数料成長
    /// @return feeGrowthGlobal1 token1のグローバル手数料成長
    function getFeeGrowthGlobals(PoolId poolId)
        external
        view
        returns (uint256 feeGrowthGlobal0, uint256 feeGrowthGlobal1);

    /// @notice プールの総流動性を取得
    /// @dev pools[poolId].liquidityに対応
    /// @param poolId プールのID
    /// @return liquidity プールの流動性
    function getLiquidity(PoolId poolId)
        external
        view
        returns (uint128 liquidity);

    /// @notice 特定のtickでのプールのtickビットマップを取得
    /// @dev pools[poolId].tickBitmap[tick]に対応
    /// @param poolId プールのID
    /// @param tick ビットマップを取得するtick
    /// @return tickBitmap tickのビットマップ
    function getTickBitmap(PoolId poolId, int16 tick)
        external
        view
        returns (uint256 tickBitmap);

    /// @notice `positionId`を計算する必要なくポジション情報を取得
    /// @dev pools[poolId].positions[positionId]に対応
    /// @param poolId プールのID
    /// @param owner 流動性ポジションの所有者
    /// @param tickLower 流動性範囲の下限tick
    /// @param tickUpper 流動性範囲の上限tick
    /// @param salt ポジション状態をさらに区別するためのbytes32のランダム性
    /// @return liquidity ポジションの流動性
    /// @return feeGrowthInside0LastX128 token0のポジション内の手数料成長
    /// @return feeGrowthInside1LastX128 token1のポジション内の手数料成長
    function getPositionInfo(
        PoolId poolId,
        address owner,
        int24 tickLower,
        int24 tickUpper,
        bytes32 salt
    )
        external
        view
        returns (
            uint128 liquidity,
            uint256 feeGrowthInside0LastX128,
            uint256 feeGrowthInside1LastX128
        );

    /// @notice 特定のポジションIDでのプールのポジション情報を取得
    /// @dev pools[poolId].positions[positionId]に対応
    /// @param poolId プールのID
    /// @param positionId ポジションのID
    /// @return liquidity ポジションの流動性
    /// @return feeGrowthInside0LastX128 token0のポジション内の手数料成長
    /// @return feeGrowthInside1LastX128 token1のポジション内の手数料成長
    function getPositionInfo(PoolId poolId, bytes32 positionId)
        external
        view
        returns (
            uint128 liquidity,
            uint256 feeGrowthInside0LastX128,
            uint256 feeGrowthInside1LastX128
        );

    /// @notice ポジションの流動性を取得
    /// @dev pools[poolId].positions[positionId].liquidityに対応。getPositionInfoと比較して流動性のみを取得する場合によりガス効率が良い
    /// @param poolId プールのID
    /// @param positionId ポジションのID
    /// @return liquidity ポジションの流動性
    function getPositionLiquidity(PoolId poolId, bytes32 positionId)
        external
        view
        returns (uint128 liquidity);

    /// @notice プールのtick範囲内の手数料成長を計算
    /// @dev Position.InfoのfeeGrowthInside0LastX128はキャッシュされており古くなる可能性がある。この関数は最新のfeeGrowthInsideを計算する
    /// @param poolId プールのID
    /// @param tickLower 範囲の下限tick
    /// @param tickUpper 範囲の上限tick
    /// @return feeGrowthInside0X128 token0のtick範囲内の手数料成長
    /// @return feeGrowthInside1X128 token1のtick範囲内の手数料成長
    function getFeeGrowthInside(PoolId poolId, int24 tickLower, int24 tickUpper)
        external
        view
        returns (uint256 feeGrowthInside0X128, uint256 feeGrowthInside1X128);
}
