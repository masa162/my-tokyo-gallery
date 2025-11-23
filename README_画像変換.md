# 画像URL変換ガイド

## 問題

画像CDNツールが生成する`![](URL)`形式（Markdownの一般的な記法）を、Hugoのフロントマター形式（YAMLの`images:`リスト）に変換する必要があります。

## 解決策

### 方法1: 自動変換スクリプト（推奨）

#### Pythonスクリプト（推奨）

```bash
python3 scripts/convert-images.py content/gallery/20025/picrsc0620 content/gallery/20025/0620.md
```

**特徴:**
- 既存のフロントマターを保持
- タイトル、日付、タグなどの既存情報を維持
- `images:`セクションのみを更新
- 最初の画像を`cover:`に自動設定

#### Shellスクリプト

```bash
./scripts/convert-images.sh content/gallery/20025/picrsc0620 content/gallery/20025/0620.md
```

### 方法2: カスタムレイアウトによる自動抽出（実験的）

カスタムレイアウト（`layouts/_default/single.html`）を拡張し、フロントマターに`images:`がない場合、本文から`![](URL)`形式の画像を自動抽出します。

**メリット:**
- フロントマターに`images:`を書かなくても動作
- Markdown形式のまま使用可能

**デメリット:**
- 本文に画像が表示される（重複の可能性）
- パフォーマンスへの影響（正規表現処理）

### 方法3: 手動変換

1. `picrsc0620`ファイルから画像URLを抽出
2. `0620.md`のフロントマターに`images:`セクションを追加
3. 各URLを`  - URL`形式でリスト化

## 使用例

### 入力ファイル（picrsc0620）
```
![](https://stk.be2nd.com/00000106.webp)
![](https://stk.be2nd.com/00000107.webp)
...
```

### 出力ファイル（0620.md）
```yaml
---
title: "小田急線_新宿stb"
date: 2025-06-20
images:
  - https://stk.be2nd.com/00000106.webp
  - https://stk.be2nd.com/00000107.webp
  ...
cover: "https://stk.be2nd.com/00000106.webp"
tags: ["小田急線", "新宿"]
---
```

## 推奨ワークフロー

1. 画像CDNツールで`picrsc0620`ファイルを生成
2. 変換スクリプトを実行して`0620.md`を更新
3. 必要に応じてタイトル、日付、タグ、本文を編集

## 注意事項

- Pythonスクリプトを使用する場合、`pyyaml`が必要です（`pip install pyyaml`）
- 既存のMarkdownファイルを上書きするため、バックアップを推奨
- 変換後、本文から`![](URL)`形式の画像を削除することを推奨（重複を避けるため）

