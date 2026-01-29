# フラッシュローン演習

この演習では、[`PoolManager`](https://github.com/Uniswap/v4-core/blob/main/src/PoolManager.sol)コントラクトからフラッシュローンを実行する方法を学びます。

この演習のスターターコードは [`foundry/src/exercises/Flash.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/exercises/Flash.sol) にあります

ソリューションは [`foundry/src/solutions/Flash.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/solutions/Flash.sol) にあります

## タスク1 - フラッシュローンを開始

```solidity
function flash(address currency, uint256 amount) external {
    // ここにコードを書いてください
}
```

- `PoolManager.unlock`を呼び出して`PoolManager`コントラクトをアンロックします
- 入力値（`currency`と`amount`）をABIエンコードするか、ストレージに保存します

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

- `unlockCallback`を実装します
- `flash`関数が呼び出された際に指定された`amount`分の`currency`のフラッシュローンを実行します
- `PoolManager`コントラクトから`currency`を借り入れた直後に、`tester.call("")`を呼び出します。
  この外部呼び出しにより、フラッシュローンが正しく実行されたかが検証されます。

## テスト

```shell
forge test --fork-url $FORK_URL --match-path test/Flash.test.sol -vvv
```
