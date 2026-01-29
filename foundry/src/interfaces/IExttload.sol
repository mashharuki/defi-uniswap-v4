// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/// @notice コントラクト内の任意のトランジェントストレージスロットにアクセスするための関数のインターフェース
interface IExttload {
    /// @notice 外部コントラクトがコントラクトのトランジェントストレージにアクセスするために呼び出される
    /// @param slot tloadするスロットのキー
    /// @return value bytes32としてのスロットの値
    function exttload(bytes32 slot) external view returns (bytes32 value);

    /// @notice 外部コントラクトがスパースなトランジェントプール状態にアクセスするために呼び出される
    /// @param slots tloadするスロットのリスト
    /// @return values ロードされた値のリスト
    function exttload(bytes32[] calldata slots)
        external
        view
        returns (bytes32[] memory values);
}
