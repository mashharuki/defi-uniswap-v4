// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.30;

/// @title Commands
/// @notice コマンドをデコードするために使用されるコマンドフラグ
library Commands {
    // コマンドの特定のビットを抽出するためのマスク
    bytes1 internal constant FLAG_ALLOW_REVERT = 0x80;
    bytes1 internal constant COMMAND_TYPE_MASK = 0x3f;

    // コマンドタイプ。現時点でサポートされる最大コマンドは0x3fです
    // コマンドはガス消費を最小化するためにネストされたifブロックで実行されます

    // value<=0x07のコマンドタイプは、最初のネストされたifブロックで実行されます
    uint256 constant V3_SWAP_EXACT_IN = 0x00;
    uint256 constant V3_SWAP_EXACT_OUT = 0x01;
    uint256 constant PERMIT2_TRANSFER_FROM = 0x02;
    uint256 constant PERMIT2_PERMIT_BATCH = 0x03;
    uint256 constant SWEEP = 0x04;
    uint256 constant TRANSFER = 0x05;
    uint256 constant PAY_PORTION = 0x06;
    // COMMAND_PLACEHOLDER = 0x07;

    // 0x08<=value<=0x0fのコマンドタイプは、2番目のネストされたifブロックで実行されます
    uint256 constant V2_SWAP_EXACT_IN = 0x08;
    uint256 constant V2_SWAP_EXACT_OUT = 0x09;
    uint256 constant PERMIT2_PERMIT = 0x0a;
    uint256 constant WRAP_ETH = 0x0b;
    uint256 constant UNWRAP_WETH = 0x0c;
    uint256 constant PERMIT2_TRANSFER_FROM_BATCH = 0x0d;
    uint256 constant BALANCE_CHECK_ERC20 = 0x0e;
    // COMMAND_PLACEHOLDER = 0x0f;

    // 0x10<=value<=0x20のコマンドタイプは、3番目のネストされたifブロックで実行されます
    uint256 constant V4_SWAP = 0x10;
    uint256 constant V3_POSITION_MANAGER_PERMIT = 0x11;
    uint256 constant V3_POSITION_MANAGER_CALL = 0x12;
    uint256 constant V4_INITIALIZE_POOL = 0x13;
    uint256 constant V4_POSITION_MANAGER_CALL = 0x14;
    // COMMAND_PLACEHOLDER = 0x15 -> 0x20

    // 0x21<=value<=0x3fのコマンドタイプ
    uint256 constant EXECUTE_SUB_PLAN = 0x21;
    // 0x22から0x3fまでのCOMMAND_PLACEHOLDER
}
