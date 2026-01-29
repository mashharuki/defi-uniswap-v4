// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/// @notice 異なるプールアクションを定義するためのライブラリ
/// @dev これらは推奨される一般的なコマンドですが、必要に応じて追加のコマンドを定義する必要があります
/// これらのアクションの一部はRouterコントラクトやPosition Managerコントラクトではサポートされていませんが、他の周辺コントラクトで役立つコマンドとして残されています
library Actions {
    // プールアクション
    // 流動性アクション
    uint256 internal constant INCREASE_LIQUIDITY = 0x00;
    uint256 internal constant DECREASE_LIQUIDITY = 0x01;
    uint256 internal constant MINT_POSITION = 0x02;
    uint256 internal constant BURN_POSITION = 0x03;
    uint256 internal constant INCREASE_LIQUIDITY_FROM_DELTAS = 0x04;
    uint256 internal constant MINT_POSITION_FROM_DELTAS = 0x05;

    // スワップ
    uint256 internal constant SWAP_EXACT_IN_SINGLE = 0x06;
    uint256 internal constant SWAP_EXACT_IN = 0x07;
    uint256 internal constant SWAP_EXACT_OUT_SINGLE = 0x08;
    uint256 internal constant SWAP_EXACT_OUT = 0x09;

    // 寄付
    // 注意: これはposition managerやrouterではサポートされていません
    uint256 internal constant DONATE = 0x0a;

    // プールマネージャーでのdeltaのクローズ
    // 決済
    uint256 internal constant SETTLE = 0x0b;
    uint256 internal constant SETTLE_ALL = 0x0c;
    uint256 internal constant SETTLE_PAIR = 0x0d;
    // 取得
    uint256 internal constant TAKE = 0x0e;
    uint256 internal constant TAKE_ALL = 0x0f;
    uint256 internal constant TAKE_PORTION = 0x10;
    uint256 internal constant TAKE_PAIR = 0x11;

    uint256 internal constant CLOSE_CURRENCY = 0x12;
    uint256 internal constant CLEAR_OR_TAKE = 0x13;
    uint256 internal constant SWEEP = 0x14;

    uint256 internal constant WRAP = 0x15;
    uint256 internal constant UNWRAP = 0x16;

    // deltaをクローズするための6909のミント/バーン
    // 注意: これはposition managerやrouterではサポートされていません
    uint256 internal constant MINT_6909 = 0x17;
    uint256 internal constant BURN_6909 = 0x18;
}
