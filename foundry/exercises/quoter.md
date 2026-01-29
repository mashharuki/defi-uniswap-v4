# ミックスドルートクォーター演習

この演習では、[`MixedRouteQuoterV2`](https://github.com/Uniswap/mixed-quoter/blob/main/src/MixedRouteQuoterV2.sol)コントラクトの使い方を学びます。

## タスク1 - `git clone`

[`mixed-quoter`](https://github.com/Uniswap/mixed-quoter/tree/main)リポジトリをクローンします

```shell
git clone git@github.com:Uniswap/mixed-quoter.git
```

## タスク2 - リポジトリをインストールしてコンパイル

`mixed-quoter`リポジトリ内で実行します

```shell
npm i
forge build
```

## タスク3 - 環境変数をコメントアウト

[`foundry.toml`](https://github.com/Uniswap/mixed-quoter/blob/d576527bff2e7c9db5434bb2b3806fd184610865/foundry.toml#L12-L53)の`rpc_endpoints`と`etherscan`の下にある環境変数をコメントアウトします。

これらの環境変数はこの演習には必要ありません。

## タスク4 - `MixedRouteQuoterV2Example.sol`をコピー

[`MixedRouteQuoterV2Example.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/exercises/MixedRouteQuoterV2Example.sol)を[`test`](https://github.com/Uniswap/mixed-quoter/tree/main/test)フォルダにコピーします。

## テスト

`mixed-quoter`リポジトリ内でテストコマンドを実行します。

```shell
forge test --fork-url $FORK_URL --match-path test/MixedRouteQuoterV2Example.sol -vvv
```
