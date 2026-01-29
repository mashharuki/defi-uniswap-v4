// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/// @title HookMiner
/// @notice hookアドレスをマイニングするための最小限のライブラリ
library HookMiner {
    // アドレスの下位14ビットを抽出するためのマスク
    uint160 constant FLAG_MASK = uint160((1 << 14) - 1);
    // saltを見つけるための最大反復回数、無限ループやMemoryOOGを回避するため
    // （任意に設定）
    uint256 constant MAX_LOOP = 160_444;

    /// @notice 目的の`flags`を持つhookアドレスを生成するsaltを見つけます
    /// @param deployer hookをデプロイするアドレス。`forge test`では、テストコントラクトの`address(this)`またはpranking addressになります
    /// `forge script`では、`0x4e59b44847b379578588920cA78FbF26c0B4956C`（CREATE2 Deployer Proxy）である必要があります
    /// @param flags hookアドレスに必要なフラグ。例: `uint160(Hooks.BEFORE_SWAP_FLAG | Hooks.AFTER_SWAP_FLAG | ...)`
    /// @param creationCode hookコントラクトのcreation code。例: `type(Counter).creationCode`
    /// @param constructorArgs hookコントラクトのエンコードされたコンストラクタ引数。例: `abi.encode(address(manager))`
    /// @return (hookAddress, salt) `salt`を使用すると、hookは`hookAddress`にデプロイされます。構文: `new Hook{salt: salt}(<constructor arguments>)`
    function find(
        address deployer,
        uint160 flags,
        bytes memory creationCode,
        bytes memory constructorArgs
    ) internal view returns (address, bytes32) {
        flags = flags & FLAG_MASK; // 下位14ビットのみをマスク
        bytes memory creationCodeWithArgs =
            abi.encodePacked(creationCode, constructorArgs);

        address hookAddress;
        for (uint256 salt; salt < MAX_LOOP; salt++) {
            hookAddress = computeAddress(deployer, salt, creationCodeWithArgs);

            // hookの下位14ビットが目的のフラグと一致し、かつアドレスにバイトコードがない場合、一致を発見
            if (
                uint160(hookAddress) & FLAG_MASK == flags
                    && hookAddress.code.length == 0
            ) {
                return (hookAddress, bytes32(salt));
            }
        }
        revert("HookMiner: could not find salt");
    }

    /// @notice CREATE2経由でデプロイされるコントラクトアドレスを事前計算します
    /// @param deployer hookをデプロイするアドレス。`forge test`では、テストコントラクトの`address(this)`またはpranking addressになります
    /// `forge script`では、`0x4e59b44847b379578588920cA78FbF26c0B4956C`（CREATE2 Deployer Proxy）である必要があります
    /// @param salt hookをデプロイするために使用されるsalt
    /// @param creationCodeWithArgs hookコントラクトのcreation codeとエンコードされたコンストラクタ引数。例: `abi.encodePacked(type(Counter).creationCode, abi.encode(constructorArg1, constructorArg2))`
    function computeAddress(
        address deployer,
        uint256 salt,
        bytes memory creationCodeWithArgs
    ) internal pure returns (address hookAddress) {
        return address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xFF),
                            deployer,
                            salt,
                            keccak256(creationCodeWithArgs)
                        )
                    )
                )
            )
        );
    }
}
