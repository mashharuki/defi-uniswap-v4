# Uniswap V4

## 学習内容

- Uniswap V4 コアコントラクト
  - [`PoolManager`](https://github.com/Uniswap/v4-core/blob/main/src/PoolManager.sol)
  - [`PositionManager`](https://github.com/Uniswap/v4-periphery/blob/main/src/PositionManager.sol)
- 補助コントラクト
  - [`UniversalRouter`](https://github.com/Uniswap/universal-router/blob/main/contracts/UniversalRouter.sol)
- Uniswap V4 フック

## このコースを受講すべき理由

- Uniswap V4コントラクトと連携するスマートコントラクトの開発
- 監査およびバグバウンティ

## 前提条件

- Solidity + Foundry
  - ストレージスロットからの読み取り方法（`extsload`）
  - ユーザー定義型（`Currency`、`PoolId`など）
- Uniswap V3（数学および`slot0`、`ticks`、`feeGrowthGlobal`などの状態変数）
