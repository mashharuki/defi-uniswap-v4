// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {IERC20} from "../interfaces/IERC20.sol";
import {IUniversalRouter} from "../interfaces/IUniversalRouter.sol";
import {IV4Router} from "../interfaces/IV4Router.sol";
import {Actions} from "../libraries/Actions.sol";
import {ActionConstants} from "../libraries/ActionConstants.sol";
import {Commands} from "../libraries/Commands.sol";
import {PoolKey} from "../types/PoolKey.sol";
import {UNIVERSAL_ROUTER, POOL_MANAGER, WETH} from "../Constants.sol";

contract SwapV3ToV4 {
    IUniversalRouter constant router = IUniversalRouter(UNIVERSAL_ROUTER);

    receive() external payable {}

    // トークンA -> V3 -> トークンB -> V4 -> トークンC をスワップ
    struct V3Params {
        address tokenIn;
        address tokenOut;
        uint24 poolFee;
        uint256 amountIn;
    }

    struct V4Params {
        PoolKey key;
        uint128 amountOutMin;
    }

    function swap(V3Params calldata v3, V4Params calldata v4) external {
        // コードをシンプルに保つためWETHプールを無効化
        require(
            v4.key.currency0 != WETH && v4.key.currency1 != WETH,
            "WETH pools disabled"
        );

        // address(0)をWETHにマッピング
        (address v4Token0, address v4Token1) =
            (v4.key.currency0, v4.key.currency1);
        if (v4Token0 == address(0)) {
            v4Token0 = WETH;
        }

        require(
            v3.tokenOut == v4Token0 || v3.tokenOut == v4Token1,
            "invalid pool key"
        );
        (address v4CurrencyIn, address v4CurrencyOut) = v3.tokenOut == v4Token0
            ? (v4.key.currency0, v4.key.currency1)
            : (v4.key.currency1, v4.key.currency0);

        // v3.tokenInをUniversalRouterに送信
        IERC20(v3.tokenIn).transferFrom(
            msg.sender, address(router), v3.amountIn
        );

        // UniversalRouterのコマンドと入力
        bytes memory commands;
        bytes[] memory inputs;

        // v3.tokenOutがWETHの場合、UNWRAP_WETHを挿入
        if (v3.tokenOut == WETH) {
            commands = abi.encodePacked(
                uint8(Commands.V3_SWAP_EXACT_IN),
                uint8(Commands.UNWRAP_WETH),
                uint8(Commands.V4_SWAP)
            );
        } else {
            commands = abi.encodePacked(
                uint8(Commands.V3_SWAP_EXACT_IN), uint8(Commands.V4_SWAP)
            );
        }

        inputs = new bytes[](commands.length);

        // V3_SWAP_EXACT_IN
        inputs[0] = abi.encode(
            // address recipient
            address(router),
            // uint256 amountIn - UniversalRouterコントラクトにロックされているv3.tokenIn残高を使用
            ActionConstants.CONTRACT_BALANCE,
            // uint256 amountOutMin
            uint256(1),
            // bytes path
            abi.encodePacked(v3.tokenIn, v3.poolFee, v3.tokenOut),
            // bool payerIsUser - UniversalRouterコントラクトにロックされているトークンから支払う
            false
        );

        // UNWRAP_WETH
        if (v3.tokenOut == WETH) {
            inputs[1] = abi.encode(
                // 受取人, 最小量
                address(router),
                uint256(1)
            );
        }

        // V4のアクションとパラメータ
        bytes memory actions = abi.encodePacked(
            uint8(Actions.SETTLE),
            uint8(Actions.SWAP_EXACT_IN_SINGLE),
            uint8(Actions.TAKE_ALL)
        );
        bytes[] memory params = new bytes[](3);
        // SETTLE (通貨, 量, 支払者はユーザーか)
        params[0] = abi.encode(
            v4CurrencyIn, uint256(ActionConstants.CONTRACT_BALANCE), false
        );
        // SWAP_EXACT_IN_SINGLE
        params[1] = abi.encode(
            IV4Router.ExactInputSingleParams({
                poolKey: v4.key,
                zeroForOne: v4CurrencyIn == v4.key.currency0,
                amountIn: ActionConstants.OPEN_DELTA,
                amountOutMinimum: v4.amountOutMin,
                hookData: bytes("")
            })
        );
        // TAKE_ALL (通貨, 最小量)
        params[2] = abi.encode(v4CurrencyOut, uint256(v4.amountOutMin));

        // V4_SWAP
        inputs[commands.length - 1] = abi.encode(actions, params);

        router.execute(commands, inputs, block.timestamp);

        withdraw(v4CurrencyOut, msg.sender);
    }

    function withdraw(address currency, address receiver) private {
        if (currency == address(0)) {
            uint256 bal = address(this).balance;
            if (bal > 0) {
                (bool ok,) = receiver.call{value: bal}("");
                require(ok, "Transfer ETH failed");
            }
        } else {
            uint256 bal = IERC20(currency).balanceOf(address(this));
            if (bal > 0) {
                IERC20(currency).transfer(receiver, bal);
            }
        }
    }
}
