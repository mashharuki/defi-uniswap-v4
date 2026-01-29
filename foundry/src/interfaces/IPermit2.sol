// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

interface IPermit2 {
    struct PermitDetails {
        // ERC20トークンアドレス
        address token;
        // 使用が許可される最大量
        uint160 amount;
        // spenderのトークン許可が無効になるタイムスタンプ
        uint48 expiration;
        // 各署名に対してowner、token、spenderごとにインデックスされるインクリメント値
        uint48 nonce;
    }
    /// @notice 単一トークン許可のために署名されたpermitメッセージ

    struct PermitSingle {
        // 単一トークン許可のためのpermitデータ
        PermitDetails details;
        // 許可されたトークンに対する権限を持つアドレス
        address spender;
        // permit署名のデッドライン
        uint256 sigDeadline;
    }

    // IAllowanceTransfer
    function approve(
        address token,
        address spender,
        uint160 amount,
        uint48 expiration
    ) external;

    /// @notice トークン所有者アドレスと呼び出し元が指定したワードインデックスからビットマップへのマップ。署名リプレイ保護のためにビットマップのビットを設定するために使用
    /// @dev permitメッセージが特定の順序で使用される必要がないように、順序なしのnonceを使用
    /// @dev マッピングはまずトークン所有者、次にnonceで指定されたインデックスでインデックス付けされる
    /// @dev uint256ビットマップを返す
    /// @dev インデックス、またはwordPositionはtype(uint248).maxに制限される
    function nonceBitmap(address, uint256) external view returns (uint256);

    function permit(
        address owner,
        PermitSingle memory permitSingle,
        bytes calldata signature
    ) external;

    /// @dev chainidとアドレスがコンストラクションから変更されていない場合、キャッシュされたバージョンを使用
    function DOMAIN_SEPARATOR() external view returns (bytes32);

    error SignatureExpired(uint256 signatureDeadline);

    error InvalidNonce();
    /// @notice 渡された署名が有効な長さでない場合にスロー
    error InvalidSignatureLength();

    /// @notice 復元された署名者がゼロアドレスと等しい場合にスロー
    error InvalidSignature();

    /// @notice 復元された署名者がclaimedSignerと等しくない場合にスロー
    error InvalidSigner();

    /// @notice 復元されたコントラクト署名が正しくない場合にスロー
    error InvalidContractSignature();
}
