// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/// @notice コントラクト内の任意のストレージスロットにアクセスするための関数のインターフェース
interface IExtsload {
    /// @notice 外部コントラクトが詳細なプール状態にアクセスするために呼び出される
    /// @param slot sloadするスロットのキー
    /// @return value bytes32としてのスロットの値
    function extsload(bytes32 slot) external view returns (bytes32 value);

    /// @notice 外部コントラクトが詳細なプール状態にアクセスするために呼び出される
    /// @param startSlot sloadを開始するスロットのキー
    /// @param nSlots 戻り値にロードするスロットの数
    /// @return values ロードされた値のリスト
    function extsload(bytes32 startSlot, uint256 nSlots)
        external
        view
        returns (bytes32[] memory values);

    /// @notice 外部コントラクトがスパースなプール状態にアクセスするために呼び出される
    /// @param slots SLOADするスロットのリスト
    /// @return values ロードされた値のリスト
    function extsload(bytes32[] calldata slots)
        external
        view
        returns (bytes32[] memory values);
}
