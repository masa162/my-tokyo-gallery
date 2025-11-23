#!/bin/bash

# Markdown形式の画像URL (![](URL)) をHugoフロントマター形式に変換するスクリプト
# 使用方法: ./scripts/convert-images.sh <入力ファイル> <出力ファイル>

INPUT_FILE="$1"
OUTPUT_FILE="$2"

if [ -z "$INPUT_FILE" ] || [ -z "$OUTPUT_FILE" ]; then
    echo "使用方法: $0 <入力ファイル> <出力ファイル>"
    echo "例: $0 content/gallery/20025/picrsc0620 content/gallery/20025/0620.md"
    exit 1
fi

if [ ! -f "$INPUT_FILE" ]; then
    echo "エラー: 入力ファイル '$INPUT_FILE' が見つかりません"
    exit 1
fi

# 画像URLを抽出（![](URL)形式）
IMAGES=$(grep -oP '!\[\]\([^)]+\)' "$INPUT_FILE" | sed 's/!\[\](//;s/)$//')

if [ -z "$IMAGES" ]; then
    echo "警告: 画像URLが見つかりませんでした"
    exit 1
fi

# 最初の画像URLを取得
FIRST_IMAGE=$(echo "$IMAGES" | head -n 1)

# 画像URLのリストをYAML形式に変換
IMAGES_YAML=""
while IFS= read -r url; do
    if [ -n "$url" ]; then
        IMAGES_YAML="${IMAGES_YAML}  - ${url}"$'\n'
    fi
done <<< "$IMAGES"

# 既存のMarkdownファイルがある場合、フロントマターを保持
if [ -f "$OUTPUT_FILE" ]; then
    # フロントマターの終了位置を検出
    FRONT_MATTER_END=$(grep -n "^---$" "$OUTPUT_FILE" | sed -n '2p' | cut -d: -f1)
    
    if [ -n "$FRONT_MATTER_END" ]; then
        # 既存のフロントマターを読み込み
        FRONT_MATTER=$(sed -n "1,${FRONT_MATTER_END}p" "$OUTPUT_FILE")
        CONTENT_AFTER=$(sed "1,${FRONT_MATTER_END}d" "$OUTPUT_FILE")
        
        # imagesセクションを更新または追加
        if echo "$FRONT_MATTER" | grep -q "^images:"; then
            # imagesセクションが存在する場合は置き換え
            FRONT_MATTER=$(echo "$FRONT_MATTER" | awk -v images="images:\n${IMAGES_YAML}" '
                /^images:/ {print images; flag=1; next}
                flag && /^[a-zA-Z-]+:/ {flag=0}
                !flag {print}
            ')
        else
            # imagesセクションを追加（dateの後）
            FRONT_MATTER=$(echo "$FRONT_MATTER" | awk -v images="images:\n${IMAGES_YAML}" '
                /^date:/ {print; print images; next}
                {print}
            ')
        fi
        
        # coverを更新
        if echo "$FRONT_MATTER" | grep -q "^cover:"; then
            FRONT_MATTER=$(echo "$FRONT_MATTER" | sed "s|^cover:.*|cover: \"${FIRST_IMAGE}\"|")
        else
            # coverを追加（imagesの後）
            FRONT_MATTER=$(echo "$FRONT_MATTER" | awk -v cover="cover: \"${FIRST_IMAGE}\"" '
                /^images:/ {print; getline; while (/^  -/) {print; getline}; print cover; next}
                {print}
            ')
        fi
        
        # 出力
        echo "$FRONT_MATTER" > "$OUTPUT_FILE"
        if [ -n "$CONTENT_AFTER" ]; then
            echo "" >> "$OUTPUT_FILE"
            echo "$CONTENT_AFTER" >> "$OUTPUT_FILE"
        fi
    else
        # フロントマターがない場合は新規作成
        {
            echo "---"
            echo "title: \"\""
            echo "date: $(date +%Y-%m-%d)"
            echo "images:"
            echo -n "$IMAGES_YAML"
            echo "cover: \"${FIRST_IMAGE}\""
            echo "tags: []"
            echo "---"
            echo ""
            cat "$OUTPUT_FILE"
        } > "${OUTPUT_FILE}.tmp" && mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"
    fi
else
    # 新規ファイルを作成
    {
        echo "---"
        echo "title: \"\""
        echo "date: $(date +%Y-%m-%d)"
        echo "images:"
        echo -n "$IMAGES_YAML"
        echo "cover: \"${FIRST_IMAGE}\""
        echo "tags: []"
        echo "---"
    } > "$OUTPUT_FILE"
fi

echo "変換完了: $OUTPUT_FILE"
echo "画像数: $(echo "$IMAGES" | wc -l | tr -d ' ')"
