// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {IERC20} from "../src/interfaces/IERC20.sol";
import {POOL_MANAGER, USDC} from "../src/Constants.sol";
import {TestHelper} from "./TestHelper.sol";
import {Flash} from "@exercises/Flash.sol";

/**
 * Check コントラクト
 */
contract Check {
    address immutable coin;
    uint256 public val;

    constructor (address _coin) {
        coin = _coin;
    }

    // 残高確認
    fallback() external {
        val = IERC20(coin).balanceOf(msg.sender);
    }
}

/**
 * フラッシュローンテストコード
 */
contract FlashTest is Test, TestHelper {
    IERC20 constant usdc = IERC20(USDC);

    TestHelper helper;
    Check check;
    Flash flash;

    receive() external payable {}

    /**
     * セットアップ
     */
    function setUp() public {
        helper = new TestHelper();
        // チェックコントラクトとフラッシュローンコントラクトのデプロイ
        check = new Check(USDC);
        flash = new Flash(POOL_MANAGER, address(check));
    }

     /**
      * フラッシュローンをテストするコード
      */
    function test_flash() public {
        // フラッシュローンの実行(借りてすぐに返済する - その間に処理を入れる)
        flash.flash(USDC, 1000 * 1e6);
        // 送信元の残高を取得する(コントラクトの呼び出しの中で借り入れと返済が済んでいるので変わらないはず)
        uint256 amount = check.val();
        console.log("Borrowed amount: %e USDC", amount);
        assertEq(amount, 1000 * 1e6);
    }
}
