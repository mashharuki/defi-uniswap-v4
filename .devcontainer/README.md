# Dev Container Configuration

このプロジェクトは VS Code Dev Container をサポートしています。

## 含まれる機能

- **Git**: バージョン管理
- **Rust**: Foundry の依存関係
- **Foundry**: Solidity 開発ツールチェーン（forge, cast, anvil）
- **Node.js**: パッケージマネージャーとツール
- **VS Code 拡張機能**:
  - Solidity サポート（シンタックスハイライト、オートコンプリート）
  - Solidity Visual Auditor（セキュリティ監査）
  - Rust Analyzer

## 使い方

1. VS Code で [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) 拡張機能をインストール

2. プロジェクトを VS Code で開く

3. コマンドパレット（`Cmd+Shift+P` または `Ctrl+Shift+P`）を開き、`Dev Containers: Reopen in Container` を選択

4. 初回起動時は自動的に環境がセットアップされます（数分かかります）

## 利用可能なコマンド

```bash
# コントラクトのコンパイル
forge build

# テストの実行
forge test

# テストの実行（詳細表示）
forge test -vvv

# コードフォーマット
forge fmt

# ローカル Ethereum ノードの起動
anvil

# ガススナップショット
forge snapshot
```

## カスタマイズ

設定を変更したい場合は、[.devcontainer/devcontainer.json](.devcontainer/devcontainer.json) を編集してください。
