# リポジション演習

この演習では、流動性をリポジションするシンプルなコントラクトを書きます。

この演習のスターターコードは [`foundry/src/exercises/Reposition.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/exercises/Reposition.sol) にあります

ソリューションは [`foundry/src/solutions/Reposition.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/solutions/Reposition.sol) にあります

## タスク1 - リポジション

```solidity
function reposition(uint256 tokenId, int24 tickLower, int24 tickUpper)
    external
    returns (uint256 newTokenId) {}
```

この関数は`tokenId`の流動性を、指定された`tickLower`と`tickUpper`の境界にリポジションします。

## テスト

```shell
forge test --fork-url $FORK_URL --match-path test/Reposition.test.sol -vvv
```
