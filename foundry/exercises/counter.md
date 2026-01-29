# カウンターフック演習

この演習では、カスタムフックコントラクトの書き方を学びます。

この演習のスターターコードは [`foundry/src/exercises/CounterHook.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/exercises/CounterHook.sol) にあります

ソリューションは [`foundry/src/solutions/CounterHook.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/solutions/CounterHook.sol) にあります

## タスク1 - フックパーミッションの設定

```solidity
function getHookPermissions()
    public
    pure
    returns (Hooks.Permissions memory)
{
    return Hooks.Permissions({
        beforeInitialize: false,
        afterInitialize: false,
        beforeAddLiquidity: false,
        afterAddLiquidity: false,
        beforeRemoveLiquidity: false,
        afterRemoveLiquidity: false,
        beforeSwap: false,
        afterSwap: false,
        beforeDonate: false,
        afterDonate: false,
        beforeSwapReturnDelta: false,
        afterSwapReturnDelta: false,
        afterAddLiquidityReturnDelta: false,
        afterRemoveLiquidityReturnDelta: false
    });
}
```

`beforeAddLiquidity`、`beforeRemoveLiquidity`、`beforeSwap`、`afterSwap`を`true`に設定してください。

## タスク2 - カウントをインクリメント

上記の各フック関数で、状態変数`counts`をインクリメントしてください。

`counts`は`PoolId`と関数名から、その関数が呼び出された回数へのネストされたマッピングです。

例えば、`afterSwap`の現在のカウントは以下のように取得できます：

```solidity
counts[key.toId()]["beforeSwap"]
```

## テスト

1. 有効なアドレスにフックコントラクトをデプロイするために必要な`salt`の値を見つけます。

```shell
forge test --match-path test/FindHookSalt.test.sol -vvv
```

2. 前のステップで実行したコマンドにより端末に出力されたsaltをエクスポートします。

```shell
export SALT=YOUR_SALT
forge test --fork-url $FORK_URL --match-path test/CounterHook.test.sol -vvv
```
