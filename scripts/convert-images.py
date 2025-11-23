#!/usr/bin/env python3
"""
Markdown形式の画像URL (![](URL)) をHugoフロントマター形式に変換するスクリプト

使用方法:
    python3 scripts/convert-images.py <入力ファイル> <出力ファイル>
    
例:
    python3 scripts/convert-images.py content/gallery/20025/picrsc0620 content/gallery/20025/0620.md
"""

import re
import sys
from pathlib import Path
from datetime import datetime
import yaml


def extract_images_from_markdown(content):
    """Markdown形式の画像URLを抽出"""
    pattern = r'!\[\]\((https?://[^)]+)\)'
    images = re.findall(pattern, content)
    return images


def parse_front_matter(content):
    """フロントマターを解析"""
    if not content.startswith('---'):
        return None, content
    
    parts = content.split('---', 2)
    if len(parts) < 3:
        return None, content
    
    try:
        front_matter = yaml.safe_load(parts[1])
        body = parts[2].strip()
        return front_matter, body
    except yaml.YAMLError:
        return None, content


def update_front_matter(front_matter, images):
    """フロントマターにimagesセクションを追加/更新"""
    if front_matter is None:
        front_matter = {
            'title': '',
            'date': datetime.now().strftime('%Y-%m-%d'),
            'images': images,
            'cover': images[0] if images else '',
            'tags': []
        }
    else:
        front_matter['images'] = images
        if images:
            front_matter['cover'] = images[0]
    
    return front_matter


def convert_file(input_file, output_file):
    """ファイルを変換"""
    input_path = Path(input_file)
    output_path = Path(output_file)
    
    if not input_path.exists():
        print(f"エラー: 入力ファイル '{input_file}' が見つかりません", file=sys.stderr)
        sys.exit(1)
    
    # 入力ファイルを読み込み
    with open(input_path, 'r', encoding='utf-8') as f:
        input_content = f.read()
    
    # 画像URLを抽出
    images = extract_images_from_markdown(input_content)
    
    if not images:
        print(f"警告: 画像URLが見つかりませんでした", file=sys.stderr)
        return
    
    # 出力ファイルが既に存在する場合はフロントマターを保持
    front_matter = None
    body = ''
    
    if output_path.exists():
        with open(output_path, 'r', encoding='utf-8') as f:
            output_content = f.read()
        front_matter, body = parse_front_matter(output_content)
    
    # フロントマターを更新
    front_matter = update_front_matter(front_matter, images)
    
    # 出力ファイルに書き込み
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('---\n')
        yaml.dump(front_matter, f, allow_unicode=True, default_flow_style=False, sort_keys=False)
        f.write('---\n')
        if body:
            f.write(f'\n{body}\n')
    
    print(f"変換完了: {output_file}")
    print(f"画像数: {len(images)}")


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("使用方法: python3 scripts/convert-images.py <入力ファイル> <出力ファイル>", file=sys.stderr)
        print("例: python3 scripts/convert-images.py content/gallery/20025/picrsc0620 content/gallery/20025/0620.md", file=sys.stderr)
        sys.exit(1)
    
    convert_file(sys.argv[1], sys.argv[2])

