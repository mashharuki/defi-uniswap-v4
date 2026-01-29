# リーダー演習

この演習では、[`PoolManager`](https://github.com/Uniswap/v4-core/blob/main/src/PoolManager.sol)コントラクトからトランジェントストレージを読み取る方法を学びます。

この演習のスターターコードは [`foundry/src/exercises/Reader.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/exercises/Reader.sol) にあります

ソリューションは [`foundry/src/solutions/Reader.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/solutions/Reader.sol) にあります

## タスク1 - 通貨デルタを取得

```solidity
function getCurrencyDelta(address target, address currency)
    public
    view
    returns (int256 delta)
{
    // ここにコードを書いてください
}
```

`target`と`currency`で識別される通貨デルタを取得します。

テストでは`PoolManager`コントラクトからトークンを取り出し、`PoolManager`に保存されている通貨デルタと、あなたのコードから返される値を比較して検証します。

## テスト

```shell
forge test --fork-url $FORK_URL --match-path test/Reader.test.sol -vvv
```
