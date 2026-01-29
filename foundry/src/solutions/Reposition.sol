// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {IPositionManager} from "../interfaces/IPositionManager.sol";
import {PoolKey} from "../types/PoolKey.sol";
import {PoolId, PoolIdLibrary} from "../types/PoolId.sol";
import {
    PositionInfo,
    PositionInfoLibrary
} from "../libraries/PositionInfoLibrary.sol";
import {Actions} from "../libraries/Actions.sol";

contract Reposition {
    using PoolIdLibrary for PoolKey;
    using PositionInfoLibrary for PositionInfo;

    IPositionManager public immutable posm;

    constructor(address _posm) {
        posm = IPositionManager(_posm);
    }

    receive() external payable {}

    function reposition(uint256 tokenId, int24 tickLower, int24 tickUpper)
        external
        returns (uint256 newTokenId)
    {
        require(tickLower < tickUpper, "tick lower >= tick upper");

        address owner = posm.ownerOf(tokenId);

        // プールキーを取得
        (PoolKey memory key,) = posm.getPoolAndPositionInfo(tokenId);

        // ポジションを再配置
        bytes memory actions = abi.encodePacked(
            uint8(Actions.BURN_POSITION),
            uint8(Actions.MINT_POSITION_FROM_DELTAS),
            uint8(Actions.TAKE_PAIR)
        );
        bytes[] memory params = new bytes[](3);

        // BURN_POSITIONのパラメータ
        params[0] = abi.encode(
            tokenId,
            // amount0Min
            0,
            // amount1Min
            0,
            // hookデータ
            ""
        );

        // MINT_POSITION_FROM_DELTASのパラメータ
        params[1] = abi.encode(
            key,
            tickLower,
            tickUpper,
            // amount0Max
            type(uint128).max,
            // amount1Max
            type(uint128).max,
            // 所有者
            owner,
            // hookデータ
            ""
        );

        // TAKE_PAIRのパラメータ
        // 通貨0, 通貨1, 受取人
        params[2] = abi.encode(key.currency0, key.currency1, owner);

        newTokenId = posm.nextTokenId();

        posm.modifyLiquidities{value: address(this).balance}(
            abi.encode(actions, params), block.timestamp
        );
    }
}
