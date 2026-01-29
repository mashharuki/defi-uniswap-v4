// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.30;

interface IUniversalRouter {
    /// @notice 必要なコマンドが失敗した時にスロー
    error ExecutionFailed(uint256 commandIndex, bytes message);

    /// @notice コントラクトに直接ETHを送信しようとした時にスロー
    error ETHNotAccepted();

    /// @notice 期限切れのデッドラインでコマンドを実行しようとした時にスロー
    error TransactionDeadlinePassed();

    /// @notice コマンドを実行しようとして、入力の数が正しくない場合にスロー
    error LengthMismatch();

    // @notice WETHでないアドレスがcalldataなしでルーターにETHを送信しようとした時にスロー
    error InvalidEthSender();

    /// @notice エンコードされたコマンドを提供された入力と共に実行する。デッドラインが過ぎている場合はリバート
    /// @param commands 連結されたコマンドのセット、それぞれ1バイトの長さ
    /// @param inputs 各コマンドのabiエンコードされた入力を含むバイト文字列の配列
    /// @param deadline トランザクションが実行されなければならないデッドライン
    function execute(
        bytes calldata commands,
        bytes[] calldata inputs,
        uint256 deadline
    ) external payable;
}
