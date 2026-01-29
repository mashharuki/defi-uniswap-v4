# ユニバーサルルーター演習

この演習では、[`UniversalRouter`](https://github.com/Uniswap/universal-router/blob/main/contracts/UniversalRouter.sol)コントラクトの使い方を学びます。

この演習のスターターコードは [`foundry/src/exercises/UniversalRouter.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/exercises/UniversalRouter.sol) にあります

ソリューションは [`foundry/src/solutions/UniversalRouter.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/solutions/UniversalRouter.sol) にあります

## タスク1 - スワップ

```solidity
function swap(
    PoolKey calldata key,
    uint128 amountIn,
    uint128 amountOutMin,
    bool zeroForOne
) external payable {
    // ここにコードを書いてください
}
```

`UniversalRouter`を呼び出して、Uniswap V4プールで通貨をスワップします。

- スワップする通貨を`msg.sender`からこのコントラクトに転送します
- `UniversalRouter`に`Permit2`の承認を付与します
- `UniversalRouter.execute`を呼び出すための入力を準備します
  - 実行するコマンドは`Commands.V4_SWAP`です
  - このコマンドの入力は`actions`と`params`をエンコードします
    - `actions`は`Actions.SWAP_EXACT_IN_SINGLE`、`Actions.SETTLE_ALL`、`Actions.TAKE_ALL`です
    - `params`は各アクションに対応する入力です。正しい入力については[`_handleAction`](https://github.com/Uniswap/v4-periphery/blob/60cd93803ac2b7fa65fd6cd351fd5fd4cc8c9db5/src/V4Router.sol#L32-L80)を参照してください
- `UniversalRouter.execute`を呼び出します
- currency 0とcurrency 1の両方を`msg.sender`に引き出します

## テスト

```shell
forge test --fork-url $FORK_URL --match-path test/UniversalRouter.test.sol -vvv
```
