# defi-uniswap-v4

<div align="center">
<img src=".github/images/uni.png" width="145" alt=""/>
<p align="center">
    <a href="https://cyfrin.io/">
        <img src=".github/images/poweredbycyfrinbluehigher.png" width="145" alt=""/></a>
            <a href="https://updraft.cyfrin.io/courses/defi-uniswap-v4">
        <img src=".github/images/coursebadge.png" width="242.3" alt=""/></a>
    <br />
</p>
</div>

このリポジトリには、コースのリソースと[ディスカッション](https://github.com/Cyfrin/defi-uniswap-v4/discussions)が含まれています。

詳細な説明については、以下を参照してください：

- [ウェブサイト](https://updraft.cyfrin.io) - Cyfrin Updraftに参加して、50時間以上のスマートコントラクト開発コースをお楽しみください
- [Twitter](https://twitter.com/CyfrinUpdraft) - 最新のコースリリース情報をチェック
- [LinkedIn](https://www.linkedin.com/school/cyfrin-updraft/) - Updraftを学習体験に追加
- [Discord](https://discord.gg/cyfrin) - 3000人以上の開発者・監査者のコミュニティに参加
- [Codehawks](https://codehawks.com) - Web3のセキュリティを支えるスマートコントラクト監査コンペティション

# コース概要

- [コース概要](./notes/course_intro.md)
- [セットアップ](./notes/course_setup.md)

# 概要

- [V4とV3の比較](./notes/v4.md)
- [リポジトリ](./notes/repos.png)

# Pool Manager（プールマネージャー）

- [Currency（通貨）](https://github.com/Uniswap/v4-core/blob/main/src/types/Currency.sol)
- Pool KeyとPool ID
  - [PoolKey](https://github.com/Uniswap/v4-core/blob/main/src/types/PoolKey.sol)
  - [PoolId](https://github.com/Uniswap/v4-core/blob/main/src/types/PoolId.sol)
  - [例](./foundry/src/examples/pool_id.sol)
  - [Dune - PoolIdからPoolKeyを取得する方法](https://dune.com/queries/5671549?category=decoded_project&namespace=uniswap_v4&blockchain=ethereum&contract=PoolManager&blockchains=ethereum&id=uniswap_v4_ethereum.poolmanager_evt_initialize)
- Lock（ロック）
  - [`Lock`](https://github.com/Uniswap/v4-core/blob/main/src/libraries/Lock.sol)
  - [`unlock`](https://github.com/Uniswap/v4-core/blob/59d3ecf53afa9264a16bba0e38f4c5d2231f80bc/src/PoolManager.sol#L104-L114)
  - [`NonzeroDeltaCount`](https://github.com/Uniswap/v4-core/blob/main/src/libraries/NonzeroDeltaCount.sol)
- [Transient Storage（一時ストレージ）](./foundry/src/examples/transient_storage.sol)
  - [`NonzeroDeltaCount`](https://github.com/Uniswap/v4-core/blob/main/src/libraries/NonzeroDeltaCount.sol)
  - [`_accountDelta`](https://github.com/Uniswap/v4-core/blob/59d3ecf53afa9264a16bba0e38f4c5d2231f80bc/src/PoolManager.sol#L368-L378)
  - [アカウントデルタ](./notes/account_delta.png)
- [通貨リザーブ](https://github.com/Uniswap/v4-core/blob/59d3ecf53afa9264a16bba0e38f4c5d2231f80bc/src/PoolManager.sol#L279-L288)
- [スワップコントラクト呼び出し](./notes/swap.png)
  - [`BalanceDelta`](https://github.com/Uniswap/v4-core/blob/main/src/types/BalanceDelta.sol)
  - [演習 - フラッシュローン](./foundry/exercises/flash.md)
  - [演習 - スワップ](./foundry/exercises/swap.md)
- データの読み取り
  - [`extsload`](https://github.com/Uniswap/v4-core/blob/main/src/Extsload.sol)
  - [`exttload`](https://github.com/Uniswap/v4-core/blob/main/src/Exttload.sol)
  - [`StateLibrary`](https://github.com/Uniswap/v4-core/blob/main/src/libraries/StateLibrary.sol)
    - [`StateView`](https://github.com/Uniswap/v4-periphery/blob/main/src/lens/StateView.sol)
  - [`TransientStateLibrary`](https://github.com/Uniswap/v4-core/blob/main/src/libraries/TransientStateLibrary.sol)
    - [`DeltaResolver`](https://github.com/Uniswap/v4-periphery/blob/main/src/base/DeltaResolver.sol)
  - [演習 - 通貨デルタの取得](./foundry/exercises/reader.md)
- [アプリケーション - スワップルーター](./foundry/exercises/swap_router.md)

# Hooks（フック）

- 主要概念
  - スワップや流動性変更などのプール操作の前後に呼び出される外部コントラクト
    - [`PoolManager`](https://github.com/Uniswap/v4-core/blob/main/src/PoolManager.sol)
    - [`IHooks`](https://github.com/Uniswap/v4-core/blob/main/src/interfaces/IHooks.sol)
    - [`Hooks`](https://github.com/Uniswap/v4-core/blob/main/src/libraries/Hooks.sol)
  - [フックは`PoolId`の導出に含まれる](./notes/hooks.png)
- フックフラグはどのようにフックアドレスにエンコードされるか？
  - 下位14ビット
    - [フラグ](https://github.com/Uniswap/v4-core/blob/59d3ecf53afa9264a16bba0e38f4c5d2231f80bc/src/libraries/Hooks.sol#L27-L47)
    - [`hasPermission`](https://github.com/Uniswap/v4-core/blob/59d3ecf53afa9264a16bba0e38f4c5d2231f80bc/src/libraries/Hooks.sol#L337-L339)
  - [`HookMiner`](https://github.com/Uniswap/v4-periphery/blob/main/src/utils/HookMiner.sol)
    - [`FindHookSalt.sol`](https://github.com/Cyfrin/defi-uniswap-v4/blob/main/foundry/test/FindHookSalt.test.sol)
- [フックコントラクト内でmsg.senderにアクセスする](./notes/hooks_msg_sender.png)
- [演習 - カウンターフック](./foundry/exercises/counter.md)
- [アプリケーション - 指値注文](./foundry/exercises/limit_order.md)
  - [指値注文とは](https://app.uniswap.org/limit)
  - [ティックと流動性の復習](https://www.desmos.com/calculator/x31s77joxw)
  - [アルゴリズム](./notes/limit_order.png)

# Position Manager（ポジションマネージャー）

- 主要概念
  - [`PositionManager`](https://github.com/Uniswap/v4-periphery/blob/main/src/PositionManager.sol)
  - エントリーポイント
    - [`modifyLiquidities`](https://github.com/Uniswap/v4-periphery/blob/60cd93803ac2b7fa65fd6cd351fd5fd4cc8c9db5/src/PositionManager.sol#L172-L179)
    - [`BaseActionsRouter`](https://github.com/Uniswap/v4-periphery/blob/main/src/base/BaseActionsRouter.sol)
    - [`Actions`](https://github.com/Uniswap/v4-periphery/blob/main/src/libraries/Actions.sol)
  - ミント、バーン、流動性の追加/削減、手数料の収集
    - [`V4Resolver`](https://github.com/Uniswap/v4-periphery/blob/main/src/base/DeltaResolver.sol)
  - [`permit2`](./notes/permit2.png)
    - [`permit2`](https://github.com/Uniswap/permit2)
    - [`Permit2Forwarder.sol`](https://github.com/Uniswap/v4-periphery/blob/main/src/base/Permit2Forwarder.sol)
    - [`Multicall_v4`](https://github.com/Uniswap/v4-periphery/blob/main/src/base/Multicall_v4.sol)
- [演習 - ポジションマネージャー](./foundry/exercises/posm.md)
  - [サブスクライバー](./notes/subscribe.png)
    - [`Notifier`](https://github.com/Uniswap/v4-periphery/blob/main/src/base/Notifier.sol)
- [演習 - サブスクライバー](./foundry/exercises/subscriber.md)
- [アプリケーション - 流動性のリポジション](./foundry/exercises/reposition.md)

# Universal Router（ユニバーサルルーター）

- [`UniversalRouter`](https://docs.uniswap.org/contracts/universal-router/overview)
- 仕組み
  - [`execute`](https://github.com/Uniswap/universal-router/blob/3663f6db6e2fe121753cd2d899699c2dc75dca86/contracts/UniversalRouter.sol#L44-L62)
  - [`dispatch`](https://github.com/Uniswap/universal-router/blob/3663f6db6e2fe121753cd2d899699c2dc75dca86/contracts/base/Dispatcher.sol#L47-L286)
  - [`Commands`](https://github.com/Uniswap/universal-router/blob/main/contracts/libraries/Commands.sol)
    - [例 - `Permit2`とリバートしないコマンド](./foundry/test/UniversalRouterPermit2.test.sol)
  - [コマンドと入力](https://docs.uniswap.org/contracts/universal-router/technical-reference)
  - [`V4SwapRouter`](https://github.com/Uniswap/universal-router/blob/main/contracts/modules/uniswap/v4/V4SwapRouter.sol)
  - [`IV4Router`](https://github.com/Uniswap/v4-periphery/blob/main/src/interfaces/IV4Router.sol)
- UniversalRouterとPermit2
  - [`V4SwapRouter`](https://github.com/Uniswap/universal-router/blob/main/contracts/modules/uniswap/v4/V4SwapRouter.sol)
  - [`DeltaResolver`](https://github.com/Uniswap/v4-periphery/blob/main/src/base/DeltaResolver.sol)
  - [`payOrPermit2Transfer`](https://github.com/Uniswap/universal-router/blob/3663f6db6e2fe121753cd2d899699c2dc75dca86/contracts/modules/Permit2Payments.sol#L42-L45)
- [演習 - UniversalRouterコマンドの実行](./foundry/exercises/universal_router.md)
- [V3からV4へのマルチホップスワップ](./notes/uni_router_v3_v4_swap.png)
- [演習 - V3とV4でのマルチホップスワップ](./foundry/exercises/swap_v3_v4.md)
- [演習 - クォーター](./foundry/exercises/quoter.md)
- [アプリケーション - 清算](./foundry/exercises/liquidation.md)

# リソース

- [Uniswap V4](https://v4.uniswap.org/)
- [Uniswap V4プール](https://app.uniswap.org/explore/pools)
- [Uniswap V4ドキュメント](https://docs.uniswap.org/contracts/v4/overview)
- [GitHub - v4-core](https://github.com/Uniswap/v4-core)
- [GitHub - v4-periphery](https://github.com/Uniswap/v4-periphery)
- [GitHub - universal-router](https://github.com/Uniswap/universal-router)
- [GitHub - v4-template](https://github.com/uniswapfoundation/v4-template)
- [GitHub - permit2](https://github.com/Uniswap/permit2)
- [GitHub - mixed-quoter](https://github.com/Uniswap/mixed-quoter)
- [YouTube - Uniswap v4 on Unichain](https://www.youtube.com/watch?v=ZisqLqbakfM)
- [Cyfrin - Uniswap V4スワップ：実行とアカウンティングの詳細解説](https://www.cyfrin.io/blog/uniswap-v4-swap-deep-dive-into-execution-and-accounting)
- [PoolManager - ストレージレイアウト](https://www.evm.codes/contract?address=0x000000000004444c5dc75cb358380d2e3de08a90)
- [Dune - PoolIdからPoolKeyを取得する方法](https://dune.com/queries/5671549?category=decoded_project&namespace=uniswap_v4&blockchain=ethereum&contract=PoolManager&blockchains=ethereum&id=uniswap_v4_ethereum.poolmanager_evt_initialize)
- [Uniswap v4 by Example](https://www.v4-by-example.org/)
- [Bunni](https://bunni.xyz/)
- [Damian Rusinek - Uniswap V4の秘密：フックセキュリティの詳細解説](https://www.youtube.com/watch?v=VhEbnGSUdYY)
- [`BaseHook`](https://github.com/Uniswap/v4-periphery/blob/main/src/utils/BaseHook.sol)
- [`LimitOrder`](https://github.com/Uniswap/v4-periphery/blob/example-contracts/contracts/hooks/examples/LimitOrder.sol)
- [Permit2](https://github.com/dragonfly-xyz/useful-solidity-patterns/tree/main/patterns/permit2)
- [UniversalRouterを使用したV3からV4へのスワップ方法](https://x.com/saucepoint/status/1950588162578817460)

## 動かし方

### インストール

```bash
git submodule update --init --recursive
```

以降のコマンドは`foundry`フォルダ配下で実行する

### ビルド

```bash
forge build
```

### 事前準備

- Alchemy等のRPCプロバイダーでEthereumメインネット用のAPIキーを発行すること
- 上記値を環境変数にセットする。
    ```bash
    FORK_URL=
    ```

    そして環境変数有効化

    ```bash
    source .env
    ```
- 次に以下のコマンドで最新ブロック高を取得する
    ```bash
    FORK_BLOCK_NUM=$(cast block-number --rpc-url $FORK_URL)
    echo $FORK_BLOCK_NUM
    ```
- 次に以下のコマンドでSaltを発行する
    ```bash
    forge test --match-path test/FindHookSalt.test.sol -vvv
    ```

    ここで得られたSALTを環境変数にセットする

    ```bash
    SALT=
    ```

    そして有効化

    ```bash
    source .env
    ```

### テスト

```bash
forge test
```

以下のように1機能ずつテストしていく

#### CounterHook

```bash
forge test --fork-url $FORK_URL --fork-block-number $FORK_BLOCK_NUM --match-path test/CounterHook.test.sol -vvv
# 回答の方を実行する場合は FOUNDRY_PROFILE=solutionをつける
FOUNDRY_PROFILE=solution forge test --fork-url $FORK_URL --fork-block-number $FORK_BLOCK_NUM --match-path test/CounterHook.test.sol -vvv
```

テスト実行結果例

```bash
Suite result: ok. 3 passed; 0 failed; 0 skipped; finished in 44.85s (42.33s CPU time)

Ran 1 test suite in 50.55s (44.85s CPU time): 3 tests passed, 0 failed, 0 skipped (3 total tests)
```

#### フラッシュローン

```bash
forge test --fork-url $FORK_URL --fork-block-number $FORK_BLOCK_NUM --match-path test/Flash.test.sol -vvv
```

```bash
Logs:
  Borrowed amount: 1e9 USDC

Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 1.10s (101.25ms CPU time)
```

#### LimitOrder(コンパイルエラーが起きてテストが通らない)

```bash
forge test --fork-url $FORK_URL --fork-block-number $FORK_BLOCK_NUM --match-path test/LimitOrder.test.sol -vvv
```