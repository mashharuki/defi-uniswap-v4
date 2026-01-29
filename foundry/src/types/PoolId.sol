// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {PoolKey} from "./PoolKey.sol";

type PoolId is bytes32;

/// @notice プールのIDを計算するためのライブラリ
library PoolIdLibrary {
    /// @notice keccak256(abi.encode(poolKey))と等しい値を返す
    function toId(PoolKey memory poolKey)
        internal
        pure
        returns (PoolId poolId)
    {
        assembly ("memory-safe") {
            // 0xa0はpoolKey構造体の総サイズを表す（32バイトのスロット5つ分）
            poolId := keccak256(poolKey, 0xa0)
        }
    }
}
