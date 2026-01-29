# V3からV4へのスワップ演習

この演習では、[`UniversalRouter`](https://github.com/Uniswap/universal-router/blob/main/contracts/UniversalRouter.sol)コントラクトを使用して、V3からV4へのマルチホップスワップを実行する方法を学びます。

この演習のスターターコードは [`foundry/src/exercises/SwapV3ToV4.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/exercises/SwapV3ToV4.sol) にあります

ソリューションは [`foundry/src/solutions/SwapV3ToV4.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/src/solutions/SwapV3ToV4.sol) にあります

## タスク1 - スワップ

```solidity
function swap(V3Params calldata v3, V4Params calldata v4) external {}
```

`UniversalRouter`を呼び出して、Uniswap V3プールでトークン`A`を`B`にスワップし、次にV4プールで`B`を`C`にスワップします。

- `v3.tokenIn`を`msg.sender`から`UniversalRouter`コントラクトに転送します
- `V3_SWAP_EXACT_IN`、`UNWRAP_WETH`（`v3.tokenOut`が`WETH`の場合）、そして`V4_SWAP`のコマンドで`UniversalRouter.execute`を呼び出します
- スワップされた通貨を`msg.sender`に引き出します

## テスト

```shell
forge test --fork-url $FORK_URL --match-path test/SwapV3ToV4.test.sol -vvv
```
