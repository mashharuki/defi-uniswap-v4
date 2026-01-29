// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// BalanceDelta = int256
// PositionInfo = uint256

/// @title ISubscriber
/// @notice v4 position managerから更新を受け取るためにサブスクライバーコントラクトが実装すべきインターフェース
interface ISubscriber {
    /// @notice ポジションがこのサブスクライバーコントラクトに登録した時に呼び出される
    /// @param tokenId ポジションのトークンID
    /// @param data 呼び出し元から渡された追加データ
    function notifySubscribe(uint256 tokenId, bytes memory data) external;

    /// @notice ポジションがサブスクライバーから登録解除した時に呼び出される
    /// @dev この呼び出しのガスは`unsubscribeGasLimit`（デプロイ時に設定）で制限される
    /// @dev EIP-150により、solidityはgasleft()の63/64のみを割り当てる可能性がある
    /// @param tokenId ポジションのトークンID
    function notifyUnsubscribe(uint256 tokenId) external;

    /// @notice ポジションがバーンされた時に呼び出される
    /// @param tokenId ポジションのトークンID
    /// @param owner tokenIdの現在の所有者
    /// @param info ポジションに関する情報
    /// @param liquidity ポジションで減少した流動性の量、0の場合もある
    /// @param feesAccrued 流動性が減少した場合にポジションが蓄積した手数料
    function notifyBurn(
        uint256 tokenId,
        address owner,
        uint256 info,
        uint256 liquidity,
        int256 feesAccrued
    ) external;

    /// @notice ポジションが流動性を変更したり手数料を収集した時に呼び出される
    /// @param tokenId ポジションのトークンID
    /// @param liquidityChange 基礎となるポジションの流動性変化
    /// @param feesAccrued modifyLiquidity呼び出しの結果としてポジションから収集される手数料
    /// @dev feesAccruedは悪意のあるユーザーによって人為的に膨張させることができることに注意
    /// 単一の流動性ポジションを持つプールは、自分自身に寄付することでfeeGrowthGlobal（したがってfeesAccrued）を膨張させることができる。
    /// 同じunlockCallback内で原子的に寄付と手数料収集を行うと、feeGrowthGlobal/feesAccruedをさらに膨張させる可能性がある
    function notifyModifyLiquidity(
        uint256 tokenId,
        int256 liquidityChange,
        int256 feesAccrued
    ) external;
}
