# テストセットアップ

```shell
# .env内の環境変数を設定
cp .env.sample .env

# 演習をビルド
forge build

# ソリューションをビルド
FOUNDRY_PROFILE=solution forge build

# ブロック番号を取得
FORK_URL=...
FORK_BLOCK_NUM=$(cast block-number --rpc-url $FORK_URL)

# 演習をテスト
forge test --fork-url $FORK_URL --fork-block-number $FORK_BLOCK_NUM --match-path test/Router.test.sol -vvv

# ソリューションをテスト
FOUNDRY_PROFILE=solution forge test --fork-url $FORK_URL --fork-block-number $FORK_BLOCK_NUM --match-path test/Router.test.sol -vvv

# 問題が発生した場合は、最初からビルドし直してください
forge clean
```
