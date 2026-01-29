// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/// @dev 2つの`int128`値を1つの`int256`にパックし、上位128ビットがamount0を、
/// 下位128ビットがamount1を表す。
type BalanceDelta is int256;

/// @notice BalanceDelta型からamount0とamount1のデルタを取得するためのライブラリ
library BalanceDeltaLibrary {
    /// @notice 0のBalanceDelta
    BalanceDelta public constant ZERO_DELTA = BalanceDelta.wrap(0);

    function amount0(BalanceDelta balanceDelta)
        internal
        pure
        returns (int128 _amount0)
    {
        assembly ("memory-safe") {
            _amount0 := sar(128, balanceDelta)
        }
    }

    function amount1(BalanceDelta balanceDelta)
        internal
        pure
        returns (int128 _amount1)
    {
        assembly ("memory-safe") {
            _amount1 := signextend(15, balanceDelta)
        }
    }
}
