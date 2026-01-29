// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/// @title INotifier
/// @notice Notifierコントラクトのインターフェース
interface INotifier {
    /// @notice サブスクライバーなしで登録解除しようとした時にスロー
    error NotSubscribed();
    /// @notice サブスクライバーがコードを持っていない時にスロー
    error NoCodeSubscriber();
    /// @notice ユーザーが有効な登録解除通知を回避するために低すぎるガスリミットを指定した時にスロー
    error GasLimitTooLow();
    /// @notice 登録時にリバートしたサブスクライバーコントラクトのリバートメッセージをラップ
    error SubscriptionReverted(address subscriber, bytes reason);
    /// @notice 流動性変更通知時にリバートしたサブスクライバーコントラクトのリバートメッセージをラップ
    error ModifyLiquidityNotificationReverted(address subscriber, bytes reason);
    /// @notice バーン通知時にリバートしたサブスクライバーコントラクトのリバートメッセージをラップ
    error BurnNotificationReverted(address subscriber, bytes reason);
    /// @notice tokenIdが既にサブスクライバーを持っている時にスロー
    error AlreadySubscribed(uint256 tokenId, address subscriber);

    /// @notice subscribeの呼び出しが成功した時に発行
    event Subscription(uint256 indexed tokenId, address indexed subscriber);
    /// @notice unsubscribeの呼び出しが成功した時に発行
    event Unsubscription(uint256 indexed tokenId, address indexed subscriber);

    /// @notice 対応するポジションのサブスクライバーを返す
    /// @param tokenId ERC721のtokenId
    /// @return subscriber サブスクライバーコントラクト
    function subscriber(uint256 tokenId)
        external
        view
        returns (address subscriber);

    /// @notice サブスクライバーが対応するポジションの通知を受け取れるようにする
    /// @param tokenId ERC721のtokenId
    /// @param newSubscriber サブスクライバーコントラクトのアドレス
    /// @param data 呼び出し元が提供し、サブスクライバーコントラクトに転送されるデータ
    /// @dev ポジションが既に登録済みの場合、subscribeを呼び出すとリバートする
    /// @dev NATIVE関連のアクションとマルチコールできるようにpayable
    /// @dev pool managerがロックされている場合はリバートする
    function subscribe(
        uint256 tokenId,
        address newSubscriber,
        bytes calldata data
    ) external payable;

    /// @notice サブスクライバーが対応するポジションの通知を受け取らないようにする
    /// @param tokenId ERC721のtokenId
    /// @dev 呼び出し元はサブスクライバーに通知できるよう高いガスリミット（残りガスがunsubscriberGasLimitより高くあるべき）を指定する必要がある
    /// @dev NATIVE関連のアクションとマルチコールできるようにpayable
    /// @dev ユーザーが常に登録解除できるようにする必要がある。悪意のあるサブスクライバーの場合でも、ユーザーは常に安全に登録解除でき、流動性は常に変更可能
    /// @dev pool managerがロックされている場合はリバートする
    function unsubscribe(uint256 tokenId) external payable;

    /// @notice 登録解除通知に使用できる最大ガスを返し決定する
    /// @return uint256 サブスクライバーの`notifyUnsubscribe`関数に通知する際の最大ガスリミット
    function unsubscribeGasLimit() external view returns (uint256);
}
