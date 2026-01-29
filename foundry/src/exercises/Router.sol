// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// import {console} from "forge-std/Test.sol";

import {IERC20} from "../interfaces/IERC20.sol";
import {IPoolManager} from "../interfaces/IPoolManager.sol";
import {IUnlockCallback} from "../interfaces/IUnlockCallback.sol";
import {PoolKey} from "../types/PoolKey.sol";
import {SwapParams} from "../types/PoolOperation.sol";
import {BalanceDelta, BalanceDeltaLibrary} from "../types/BalanceDelta.sol";
import {SafeCast} from "../libraries/SafeCast.sol";
import {CurrencyLib} from "../libraries/CurrencyLib.sol";
import {MIN_SQRT_PRICE, MAX_SQRT_PRICE} from "../Constants.sol";
import {TStore} from "../TStore.sol";

contract Router is TStore, IUnlockCallback {
    using BalanceDeltaLibrary for BalanceDelta;
    using SafeCast for int128;
    using SafeCast for uint128;
    using CurrencyLib for address;

    // アクション
    uint256 private constant SWAP_EXACT_IN_SINGLE = 0x06;
    uint256 private constant SWAP_EXACT_IN = 0x07;
    uint256 private constant SWAP_EXACT_OUT_SINGLE = 0x08;
    uint256 private constant SWAP_EXACT_OUT = 0x09;

    IPoolManager public immutable poolManager;

    struct ExactInputSingleParams {
        PoolKey poolKey;
        bool zeroForOne;
        uint128 amountIn;
        uint128 amountOutMin;
        bytes hookData;
    }

    struct ExactOutputSingleParams {
        PoolKey poolKey;
        bool zeroForOne;
        uint128 amountOut;
        uint128 amountInMax;
        bytes hookData;
    }

    struct PathKey {
        address currency;
        uint24 fee;
        int24 tickSpacing;
        address hooks;
        bytes hookData;
    }

    struct ExactInputParams {
        address currencyIn;
        // 最初の要素 + currencyInで最初のスワップ対象プールを決定
        // 最後の要素 + 前のパス要素の通貨で最後のスワップ対象プールを決定
        PathKey[] path;
        uint128 amountIn;
        uint128 amountOutMin;
    }

    struct ExactOutputParams {
        address currencyOut;
        // 最後の要素 + currencyOutで最後のスワップ対象プールを決定
        // 最初の要素 + 2番目のパス要素の通貨で最初のスワップ対象プールを決定
        PathKey[] path;
        uint128 amountOut;
        uint128 amountInMax;
    }

    error UnsupportedAction(uint256 action);

    modifier onlyPoolManager() {
        require(msg.sender == address(poolManager), "not pool manager");
        _;
    }

    constructor(address _poolManager) {
        poolManager = IPoolManager(_poolManager);
    }

    receive() external payable {}

    function unlockCallback(bytes calldata data)
        external
        onlyPoolManager
        returns (bytes memory)
    {
        uint256 action = _getAction();
        // ここにコードを書いてください
        revert UnsupportedAction(action);
    }

    function swapExactInputSingle(ExactInputSingleParams calldata params)
        external
        payable
        setAction(SWAP_EXACT_IN_SINGLE)
        returns (uint256 amountOut)
    {
        // ここにコードを書いてください
    }

    function swapExactOutputSingle(ExactOutputSingleParams calldata params)
        external
        payable
        setAction(SWAP_EXACT_OUT_SINGLE)
        returns (uint256 amountIn)
    {
        // ここにコードを書いてください
    }

    function swapExactInput(ExactInputParams calldata params)
        external
        payable
        setAction(SWAP_EXACT_IN)
        returns (uint256 amountOut)
    {
        // ここにコードを書いてください
    }

    function swapExactOutput(ExactOutputParams calldata params)
        external
        payable
        setAction(SWAP_EXACT_OUT)
        returns (uint256 amountIn)
    {
        // ここにコードを書いてください
    }
}
