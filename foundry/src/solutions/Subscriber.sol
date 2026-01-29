// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {console} from "forge-std/Test.sol";
import {IERC20} from "../interfaces/IERC20.sol";
import {IPositionManager} from "../interfaces/IPositionManager.sol";
import {ISubscriber} from "../interfaces/ISubscriber.sol";
import {PoolKey} from "../types/PoolKey.sol";
import {PoolId, PoolIdLibrary} from "../types/PoolId.sol";
import {POSITION_MANAGER, USDC, PERMIT2} from "../Constants.sol";

contract Token {
    // プールID => 所有者 => uint256
    mapping(bytes32 => mapping(address => uint256)) public balanceOf;

    function _mint(bytes32 poolId, address dst, uint256 amount) internal {
        balanceOf[poolId][dst] += amount;
    }

    function _burn(bytes32 poolId, address src, uint256 amount) internal {
        balanceOf[poolId][src] -= amount;
    }
}

contract Subscriber is ISubscriber, Token {
    using PoolIdLibrary for PoolKey;
    // PositionManager

    IPositionManager public immutable posm = IPositionManager(POSITION_MANAGER);
    mapping(uint256 tokenId => bytes32 poolId) private poolIds;
    mapping(uint256 tokenId => address owner) private ownerOf;

    modifier onlyPositionManager() {
        require(msg.sender == address(posm), "not PositionManager");
        _;
    }

    constructor(address _posm) {
        posm = IPositionManager(_posm);
    }

    function getInfo(uint256 tokenId)
        public
        view
        returns (bytes32 poolId, address owner, uint128 liquidity)
    {
        // 注意: データはnotifyUnsubscribeとnotifyBurnの前に削除されます
        (PoolKey memory key,) = posm.getPoolAndPositionInfo(tokenId);
        poolId = PoolId.unwrap(key.toId());
        // 注意: tokenIdが存在しない場合、ownerOfはリバートします
        owner = posm.ownerOf(tokenId);
        liquidity = posm.getPositionLiquidity(tokenId);
    }

    function notifySubscribe(uint256 tokenId, bytes memory data)
        external
        onlyPositionManager
    {
        (bytes32 poolId, address owner, uint128 liquidity) = getInfo(tokenId);
        _mint(poolId, owner, liquidity);
        poolIds[tokenId] = poolId;
        ownerOf[tokenId] = owner;
    }

    function notifyUnsubscribe(uint256 tokenId) external onlyPositionManager {
        bytes32 poolId = poolIds[tokenId];
        address owner = ownerOf[tokenId];
        _burn(poolId, owner, balanceOf[poolId][owner]);
        delete poolIds[tokenId];
        delete ownerOf[tokenId];
    }

    function notifyBurn(
        uint256 tokenId,
        address owner,
        uint256 info,
        uint256 liquidity,
        int256 feesAccrued
    ) external onlyPositionManager {
        bytes32 poolId = poolIds[tokenId];
        // 注意: ポジションの流動性はbalanceOf[poolId][owner]より大きい場合があります
        // ポジションは手数料を蓄積するため
        _burn(poolId, owner, balanceOf[poolId][owner]);
        delete poolIds[tokenId];
        delete ownerOf[tokenId];
    }

    function notifyModifyLiquidity(
        uint256 tokenId,
        int256 liquidityChange,
        int256 feesAccrued
    ) external onlyPositionManager {
        bytes32 poolId = poolIds[tokenId];
        address owner = ownerOf[tokenId];
        if (liquidityChange > 0) {
            _mint(poolId, owner, uint256(liquidityChange));
        } else {
            _burn(
                poolId,
                owner,
                min(uint256(-liquidityChange), balanceOf[poolId][owner])
            );
        }
    }

    function min(uint256 x, uint256 y) private pure returns (uint256) {
        return x <= y ? x : y;
    }
}
