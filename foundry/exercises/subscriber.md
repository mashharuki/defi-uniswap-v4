# サブスクライバー演習

この演習では、[`PositionManager`](https://github.com/Uniswap/v4-periphery/blob/main/src/PositionManager.sol)コントラクト用のサブスクライバーコントラクトの書き方を学びます。

この演習のスターターコードは [`foundry/src/exercises/Subscriber.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/exercises/Subscriber.sol) にあります

ソリューションは [`foundry/src/solutions/Subscriber.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/solutions/Subscriber.sol) にあります

`Subscriber`コントラクトは、ユーザーが追加または削除した流動性の量に対応する譲渡不可トークンをミントおよびバーンします。

## タスク1 - サブスクライブ通知

```solidity
function notifySubscribe(uint256 tokenId, bytes memory data)
    external
    onlyPositionManager
{
    // ここにコードを書いてください
}
```

- `tokenId`にロックされている流動性の量を、`tokenId`の所有者にミントします
- `tokenId`の`PoolId`と所有者を状態変数`poolIds`と`ownerOf`に保存します。これらのデータは後で`notifyUnsubscribe`と`notifyBurn`で使用されます。

## タスク2 - サブスクライブ解除通知

```solidity
function notifyUnsubscribe(uint256 tokenId) external onlyPositionManager {
    // ここにコードを書いてください
}
```

- `tokenId`のすべての譲渡不可トークンをバーンします
- `tokenId`の`poolIds`と`ownerOf`のデータを削除します。

## タスク3 - バーン通知

```solidity
function notifyBurn(
    uint256 tokenId,
    address owner,
    uint256 info,
    uint256 liquidity,
    int256 feesAccrued
) external onlyPositionManager {
    // ここにコードを書いてください
}
```

- `tokenId`のすべての譲渡不可トークンをバーンします
- `tokenId`の`poolIds`と`ownerOf`のデータを削除します。

## タスク4 - 流動性変更通知

```solidity
function notifyModifyLiquidity(
    uint256 tokenId,
    int256 liquidityChange,
    int256 feesAccrued
) external onlyPositionManager {
    // ここにコードを書いてください
}
```

- `liquidityChange`が正の場合は追加の譲渡不可トークンをミントし、そうでなければバーンします。

## テスト

```shell
forge test --fork-url $FORK_URL --match-path test/Subscriber.test.sol -vvv
```
