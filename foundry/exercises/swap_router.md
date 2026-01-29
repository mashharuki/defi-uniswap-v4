# ルーター演習

この演習では、[`PoolManager`](https://github.com/Uniswap/v4-core/blob/main/src/PoolManager.sol)コントラクトでトークンをスワップする方法を学びます。

この演習のスターターコードは [`foundry/src/exercises/Router.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/exercises/Router.sol) にあります

ソリューションは [`foundry/src/solutions/Router.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/solutions/Router.sol) にあります

## タスク1 - シングルホップスワップ（入力量指定）

```solidity
function swapExactInputSingle(ExactInputSingleParams calldata params)
    external
    payable
    setAction(SWAP_EXACT_IN_SINGLE)
    returns (uint256 amountOut)
{
    // ここにコードを書いてください
}
```

この関数を実装して、`PoolManager`コントラクトの単一プールに対してスワップを実行します。

- `ExactInputSingleParams.amountIn`で指定された入力通貨の全量を、プール内の他の通貨の最大可能量とスワップします

- 受け取った出力量が`ExactInputSingleParams.amountOutMin`より少ない場合はリバートします

- 未使用のトークンを呼び出し元に返却します

- 出力通貨の量（`amountOut`）を返します

## タスク2 - シングルホップスワップ（出力量指定）

```solidity
function swapExactOutputSingle(ExactOutputSingleParams calldata params)
    external
    payable
    setAction(SWAP_EXACT_OUT_SINGLE)
    returns (uint256 amountIn)
{
    // ここにコードを書いてください
}
```

この関数を実装して、`PoolManager`コントラクトの単一プールに対してスワップを実行します。

- 最小量の入力通貨を、`ExactOutputSingleParams.amountOut`で指定された正確な出力量のプール内の他の通貨とスワップします

- 入力量が`ExactOutputSingleParams.amountInMax`より大きい場合はリバートします

- 未使用のトークンを呼び出し元に返却します

- 入力通貨の量（`amountIn`）を返します

## タスク3 - マルチホップスワップ（入力量指定）

```solidity
function swapExactInput(ExactInputParams calldata params)
    external
    payable
    setAction(SWAP_EXACT_IN)
    returns (uint256 amountOut)
{
    // ここにコードを書いてください
}
```

この関数を実装して、`PoolManager`コントラクトの複数プールに対してスワップを実行します。

- `ExactInputParams.amountIn`で指定された入力通貨の全量を、`ExactInputParams.path`の最後の要素で指定された最終通貨の最大可能量とスワップします

- 受け取った出力量が`ExactInputParams.amountOutMin`より少ない場合はリバートします

- 未使用のトークンを呼び出し元に返却します

- 出力通貨の量（`amountOut`）を返します

## タスク4 - マルチホップスワップ（出力量指定）

```solidity
function swapExactOutput(ExactOutputParams calldata params)
    external
    payable
    setAction(SWAP_EXACT_OUT)
    returns (uint256 amountIn)
{
    // ここにコードを書いてください
}
```

この関数を実装して、`PoolManager`コントラクトの複数プールに対してスワップを実行します。

- 最小量の入力通貨を、`ExactOutputParams.amountOut`で指定された`ExactOutputParams.currencyOut`で指定された最終通貨の正確な出力量とスワップします

- 入力量が`ExactOutputParams.amountInMax`より大きい場合はリバートします

- 未使用のトークンを呼び出し元に返却します

- 入力通貨の量（`amountIn`）を返します

## テスト

```shell
forge test --fork-url $FORK_URL --fork-block-number $FORK_BLOCK_NUM --match-path test/Router.test.sol -vvv
```
