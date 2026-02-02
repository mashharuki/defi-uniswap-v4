// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// import {console} from "forge-std/Test.sol";

import {IERC20} from "../interfaces/IERC20.sol";
import {IPoolManager} from "../interfaces/IPoolManager.sol";
import {IUnlockCallback} from "../interfaces/IUnlockCallback.sol";
import {CurrencyLib} from "../libraries/CurrencyLib.sol";

contract Flash is IUnlockCallback {
    using CurrencyLib for address;

    IPoolManager public immutable poolManager;
    // フラッシュローンをテストするためのコントラクトアドレス
    address private immutable tester;

    modifier onlyPoolManager() {
        require(msg.sender == address(poolManager), "not pool manager");
        _;
    }

    /**
     * コンストラクター
     */
    constructor(address _poolManager, address _tester) {
        poolManager = IPoolManager(_poolManager);
        tester = _tester;
    }

    receive() external payable {}

    /**
     * unclockが呼び出された時に実行されるコールバックメソッド
     */
    function unlockCallback(bytes calldata data)
        external
        onlyPoolManager
        returns (bytes memory)
    {
        // デコードして通貨と金額を取得
        (address currency, uint256 amount) =
            abi.decode(data, (address, uint256));

        // 借り入れ
        poolManager.take({currency: currency, to: address(this), amount: amount});

        // ここにフラッシュローンのロジックを書いてください(実際には呼び出すコントラクトのメソッドをエンコードした値を詰める)
        (bool ok,) = tester.call("");
        require(ok, "test failed");

        // 同期
        poolManager.sync(currency);

        if (currency == address(0)) {
            // ネイティブトークン(ETH)の場合
            poolManager.settle{value: amount}();
        } else {
            // ERC20トークンの場合
            IERC20(currency).transfer(address(poolManager), amount);
            // settleメソッドを呼び出す
            poolManager.settle();
        }

        return "";
    }

    /**
     * フラッシュローンをするためのメソッド
     */
    function flash(address currency, uint256 amount) external {
        // コールバック関数を呼び出す
        poolManager.unlock(abi.encode(currency, amount));
    }
}
