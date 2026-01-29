// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// 以下からコピー
// https://github.com/Uniswap/v4-core/blob/main/src/libraries/StateLibrary.sol

import {IPoolManager} from "../interfaces/IPoolManager.sol";
import {PoolId} from "../types/PoolId.sol";

library StateLibrary {
    bytes32 public constant POOLS_SLOT = bytes32(uint256(6));

    function getSlot0(address manager, PoolId poolId)
        internal
        view
        returns (
            uint160 sqrtPriceX96,
            int24 tick,
            uint24 protocolFee,
            uint24 lpFee
        )
    {
        // Pool.State値のslotキー: `pools[poolId]`
        bytes32 stateSlot = _getPoolStateSlot(poolId);

        bytes32 data = IPoolManager(manager).extsload(stateSlot);

        //   24ビット  |24ビット|24ビット     |24ビット|160ビット
        // 0x000000   |000bb8|000000      |ffff75 |0000000000000000fe3aa841ba359daa0ea9eff7
        // ---------- | fee  |protocolfee | tick  | sqrtPriceX96
        assembly ("memory-safe") {
            // dataの下位160ビット
            sqrtPriceX96 :=
                and(data, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            // dataの次の24ビット
            tick := signextend(2, shr(160, data))
            // dataの次の24ビット
            protocolFee := and(shr(184, data), 0xFFFFFF)
            // dataの最後の24ビット
            lpFee := and(shr(208, data), 0xFFFFFF)
        }
    }

    function _getPoolStateSlot(PoolId poolId) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(PoolId.unwrap(poolId), POOLS_SLOT));
    }
}
