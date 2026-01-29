# 指値注文演習

この演習では、指値注文フックコントラクトの書き方を学びます。

この演習のスターターコードは [`foundry/src/exercises/LimitOrder.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/exercises/LimitOrder.sol) にあります

ソリューションは [`foundry/src/solutions/LimitOrder.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/solutions/LimitOrder.sol) にあります

## タスク1 - 初期化後フック

```solidity
function afterInitialize(
    address sender,
    PoolKey calldata key,
    uint160 sqrtPriceX96,
    int24 tick
) external onlyPoolManager returns (bytes4) {
    // ここにコードを書いてください
    return this.afterInitialize.selector;
}
```

- プールの現在のティックを状態変数`ticks`に保存します。

## タスク2 - 指値注文を発注

```solidity
function place(
    PoolKey calldata key,
    int24 tickLower,
    bool zeroForOne,
    uint128 liquidity
) external payable setAction(ADD_LIQUIDITY) {
    // ここにコードを書いてください
}
```

この関数は`msg.sender`の指値注文を発注します。

- `tickLower`がプールのティック間隔の倍数でない場合はリバートします
- `poolManager.unlock`を呼び出し、`unlockCallback`内で流動性を追加するコードを書きます
  - 流動性は`tickLower`と`tickLower + tickSpacing`の間に追加する必要があります
  - 現在のティックに流動性が追加される場合はリバートします
- 現在のスロットに保存されている`Bucket`を更新します
  - `getBucketId`を呼び出して`Bucket`のIDを取得します
  - このバケットの現在のスロットは`slots[id]`に保存されています
  - 現在の`Bucket`は`buckets[id][slots[id]]`に保存されています
- `Place`イベントを発行します

## タスク3 - 指値注文をキャンセル

```solidity
function cancel(PoolKey calldata key, int24 tickLower, bool zeroForOne)
    external
    setAction(REMOVE_LIQUIDITY)
{
    // ここにコードを書いてください
}
```

この関数は`msg.sender`の指値注文をキャンセルします。

- 指値注文を削除する`Bucket`が`filled`の場合はリバートします
- `Bucket`から`msg.sender`の流動性を削除します
- `poolManager.unlock`を呼び出し、`unlockCallback`内で流動性を削除するコードを書きます
  - 流動性を削除し、このポジションに発生した手数料を返します
  - バケット内の流動性が0より大きい場合、手数料を`Bucket`に割り当てます
  - バケット内の流動性が0の場合、手数料を`msg.sender`に渡します
- `Cancel`イベントを発行します

## タスク4 - スワップされたトークンを受け取る

```solidity
function take(
    PoolKey calldata key,
    int24 tickLower,
    bool zeroForOne,
    uint256 slot
) external {
    // ここにコードを書いてください
}
```

この関数は、指値注文が処理された後にスワップされたトークンを引き出すために`msg.sender`によって呼び出されます。

- `Bucket`が`filled`でない場合はリバートします
- `Bucket`を更新します
- 適切な量の`currency0`と`currency1`を`msg.sender`に送信します
- `Take`イベントを発行します

## タスク5 - スワップ後フック

```solidity
function afterSwap(
    address sender,
    PoolKey calldata key,
    SwapParams calldata params,
    BalanceDelta delta,
    bytes calldata hookData
)
    external
    onlyPoolManager
    setAction(REMOVE_LIQUIDITY)
    returns (bytes4, int128)
{
    // ここにコードを書いてください
    return (this.afterSwap.selector, 0);
}
```

このフックはスワップ後にトリガーされ、処理された`Bucket`から流動性を削除する責任があります。

- 流動性を削除するティック範囲を見つけます
  - 範囲は、最後に保存されたティック（`ticks[key.toId()]`）から現在の`tick`までで、両方とも`tickSpacing`の倍数に切り捨てられ、`+/-` `tickSpacing`されます
  - ヒント：`_getTickRange`を呼び出してください
- 上記のティック範囲から流動性を削除します
  - `Bucket.filled`を`true`に設定します
  - 返された`currency0`と`currency1`の量を`Bucket`に保存します
  - `Fill`イベントを発行します
  - このバケットのスロットを1インクリメントします
- 最新のティックを`ticks[key.toId()]`に保存します

## テスト

1. 有効なアドレスにフックコントラクトをデプロイするために必要な`salt`の値を見つけます。

```shell
forge test --match-path test/FindHookSalt.test.sol -vvv
```

2. 前のステップで実行したコマンドにより端末に出力されたsaltをエクスポートします。

```shell
export SALT=YOUR_SALT
forge test --fork-url $FORK_URL --match-path test/LimitOrder.test.sol -vvv
```
