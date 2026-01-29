// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/// @notice プールを識別するためのキーを返す
struct PoolKey {
    /// @notice プールの小さい方の通貨、数値順にソート
    address currency0;
    /// @notice プールの大きい方の通貨、数値順にソート
    address currency1;
    /// @notice プールのLP手数料、最大1_000_000。最上位ビットが1の場合、プールは動的手数料を持ち、0x800000と正確に等しくなければならない
    uint24 fee;
    /// @notice ポジションに関係するtickはtick spacingの倍数でなければならない
    int24 tickSpacing;
    /// @notice プールのhook
    address hooks;
}
