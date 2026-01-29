# スワップ演習

この演習では、[`PoolManager`](https://github.com/Uniswap/v4-core/blob/main/src/PoolManager.sol)コントラクトでトークンをスワップする方法を学びます。

この演習のスターターコードは [`foundry/src/exercises/Swap.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/exercises/Swap.sol) にあります

ソリューションは [`foundry/src/solutions/Swap.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/solutions/Swap.sol) にあります

## タスク1 - スワップを開始

```solidity
function swap(SwapExactInputSingleHop calldata params) external payable {
    // ここにコードを書いてください
}
```

- 呼び出し元から取得する通貨を決定し、コントラクトに転送します
- `PoolManager`コントラクトをアンロックします
- 呼び出し元から取得した残りの通貨を返金します

## タスク2 - アンロックコールバック

```solidity
function unlockCallback(bytes calldata data)
    external
    onlyPoolManager
    returns (bytes memory)
{
    // ここにコードを書いてください
    return "";
}
```

- `PoolManager`コントラクトで通貨をスワップします
- 出力量が指定された最小値（`SwapExactInputSingleHop.amountOutMin`）より少ない場合はリバートします

## テスト

```shell
forge test --fork-url $FORK_URL --match-path test/Swap.test.sol -vvv
```
