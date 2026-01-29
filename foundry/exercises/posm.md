# ポジションマネージャー演習

この演習では、[`PositionManager`](https://github.com/Uniswap/v4-periphery/blob/main/src/PositionManager.sol)コントラクトの使い方を学びます。

この演習のスターターコードは [`foundry/src/exercises/Posm.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/exercises/Posm.sol) にあります

ソリューションは [`foundry/src/solutions/Posm.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/solutions/Posm.sol) にあります

## タスク1 - 流動性を追加

```solidity
function increaseLiquidity(
    uint256 tokenId,
    uint256 liquidity,
    uint128 amount0Max,
    uint128 amount1Max
) external payable {
    // ここにコードを書いてください
}
```

`tokenId`で識別されるポジションの流動性を追加する関数を完成させてください。

## タスク2 - 流動性を削減

```solidity
function decreaseLiquidity(
    uint256 tokenId,
    uint256 liquidity,
    uint128 amount0Min,
    uint128 amount1Min
) external {
    // ここにコードを書いてください
}
```

`tokenId`で識別されるポジションの流動性を削減する関数を完成させてください。

## タスク3 - バーン

```solidity
function burn(uint256 tokenId, uint128 amount0Min, uint128 amount1Min)
    external
{
    // ここにコードを書いてください
}
```

`tokenId`で識別されるポジションをバーンする関数を完成させてください。

## テスト

```shell
forge test --fork-url $FORK_URL --match-path test/Posm.test.sol -vvv
```
