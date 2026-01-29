# 清算演習

この演習では、以下を行うコントラクトを書きます：

1. Aave V3からフラッシュローンを取得する
2. Aave V3で担保不足のローンを清算する
3. [`UniversalRouter`](https://github.com/Uniswap/universal-router/blob/main/contracts/UniversalRouter.sol)コントラクトを使用して、清算で受け取った担保を借り入れたトークンにスワップする
4. フラッシュローンを返済し、利益を`msg.sender`に送信する

この演習のスターターコードは [`foundry/src/exercises/Liquidate.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/exercises/Liquidate.sol) にあります

ソリューションは [`foundry/src/solutions/Liquidate.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/solutions/Liquidate.sol) にあります

> **注意**
> この演習では**Aave V3**からのフラッシュローンを使用しています。これは、**Uniswap V4**からフラッシュローンを取得し、`UniversalRouter`経由でUniswap V4でスワップを実行することができないためです。
> Uniswap V4からフラッシュローンを取得すると、`PoolManager`コントラクトがロックされ、`UniversalRouter`がロックを取得できなくなります。
> 実際には、Uniswap V4から直接フラッシュローンを取得し（手数料が**0**のため）、`PoolManager`コントラクトを通じて直接スワップを実行する方がより効率的です。
> ただし、この演習では`UniversalRouter`コントラクトとの連携方法を学ぶことに焦点を当てています。

## タスク1 - 清算を開始

```solidity
function liquidate(
    // フラッシュローンするトークン
    address tokenToRepay,
    // 清算するユーザー
    address user,
    // 担保をスワップするV4プール
    PoolKey calldata key
) external {}
```

この関数はフラッシュローンを取得して清算を開始します。

- `liquidator.getDebt`を呼び出して、担保不足のローンを返済するために必要なトークンの量を取得します
- `flash.flash`を呼び出してフラッシュローンを取得します。`IFlash`は`flashCallback`関数にコールバックします
- 余剰の`tokenToRepay`を`msg.sender`に返金します

## タスク2 - 清算、スワップ、返済

```solidity
function flashCallback(
    address tokenToRepay,
    uint256 amount,
    uint256 fee,
    bytes calldata data
) external {
    // ここにコードを書いてください
}
```

この関数は清算を実行し、受け取った担保を返済トークンにスワップし、フラッシュローンを返済します。

- `liquidator.liquidate`を呼び出して、`user`の担保不足のローンを清算します
- `swap`を呼び出して、担保をフラッシュローンの返済に必要なトークンに変換します
- フラッシュローンを返済します

## テスト

```shell
forge test --fork-url $FORK_URL --match-path test/Liquidate.test.sol -vvv
```
