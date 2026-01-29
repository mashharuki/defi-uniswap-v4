// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// beforeSwap hookの戻り値の型。
// 上位128ビットは指定トークンのデルタ。下位128ビットは未指定トークンのデルタ（afterSwap hookと一致させるため）
type BeforeSwapDelta is int256;

// specifiedとunspecifiedからBeforeSwapDeltaを作成
function toBeforeSwapDelta(int128 deltaSpecified, int128 deltaUnspecified)
    pure
    returns (BeforeSwapDelta beforeSwapDelta)
{
    assembly ("memory-safe") {
        beforeSwapDelta :=
            or(shl(128, deltaSpecified), and(sub(shl(128, 1), 1), deltaUnspecified))
    }
}

/// @notice BeforeSwapDelta型から指定・未指定のデルタを取得するためのライブラリ
library BeforeSwapDeltaLibrary {
    /// @notice 0のBeforeSwapDelta
    BeforeSwapDelta public constant ZERO_DELTA = BeforeSwapDelta.wrap(0);

    /// beforeSwapが返すBeforeSwapDeltaの上位128ビットからint128を抽出
    function getSpecifiedDelta(BeforeSwapDelta delta)
        internal
        pure
        returns (int128 deltaSpecified)
    {
        assembly ("memory-safe") {
            deltaSpecified := sar(128, delta)
        }
    }

    /// beforeSwapとafterSwapが返すBeforeSwapDeltaの下位128ビットからint128を抽出
    function getUnspecifiedDelta(BeforeSwapDelta delta)
        internal
        pure
        returns (int128 deltaUnspecified)
    {
        assembly ("memory-safe") {
            deltaUnspecified := signextend(15, delta)
        }
    }
}
