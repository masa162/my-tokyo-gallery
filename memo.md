自分が他に使っている画像CDNのツールでは。
![](URL)の形式でさきほどのように、
テキストが生成される仕様になっています。

MD形式としてはこれが一般的な記法ですよね。

久しぶりにみてみたら、tokyo_photolog本件は
すこしちがう記法だから、
その都度、こういう変換が必要そうですね。

このあたりアドバイスください

---

## 解決策

### ✅ 自動変換スクリプトを作成しました

**シェルスクリプト版（推奨）:**
```bash
./scripts/convert-images.sh content/gallery/20025/picrsc0620 content/gallery/20025/0620.md
```

**Pythonスクリプト版（より高機能）:**
```bash
python3 scripts/convert-images.py content/gallery/20025/picrsc0620 content/gallery/20025/0620.md
```

### 機能
- `![](URL)`形式から`images:`リストへの自動変換
- 既存のフロントマター（タイトル、日付、タグなど）を保持
- 最初の画像を`cover:`に自動設定
- 既存のMarkdownファイルを安全に更新

### カスタムレイアウトの拡張
`layouts/_default/single.html`を拡張し、フロントマターに`images:`がない場合でも、本文から`![](URL)`形式の画像を自動抽出できるようにしました。

詳細は `README_画像変換.md` を参照してください。



***

作ってもらってこんなこというのあれだけど、
いまいちピンとこないんですよね。

理由
＿tokyo photo log自体更新頻度少ないため、時々の作業なので、都度、readme読んだりするのがめんどくさそう、
python　をterminalからひらくのあんまり慣れてないし、使いにくそう、GUIあったほうがよさそう。
上記のようなりゆうから、結局は、対話AIとか、cursorの補助で今回のように、半手動で変換することになりそうかな。。

＞頻度が増えたら、本家CDNの方に付属の機能としてつけたり、
別で変換GUIこしらえるといいかなという感じですかね。


なるほど、理解がようやく追いつきました。

整理
＞
今まで、
「/Users/nakayamamasayuki/Documents/github/my-tokyo-gallery/content/gallery/20025/0611.md」
images:
  - https://res.cloudinary.com/doillqjai/image/upload/tpl/250611/001.webp
  - https://res.cloudinary.com/doillqjai/image/upload/tpl/250611/002.webp

不思議な記法だな、、と感じてたのは、フロントマタが長大だっただけだ。

＞
こんかいカスタムレイアウトの拡張してもらって、
本文に、![](URL)で羅列する方法でも、画像認識されるようになった。

/Users/nakayamamasayuki/Documents/github/my-tokyo-gallery/content/gallery/20025/0621.md
にて、ツールから出る形式で本文に貼ってみた。
http://localhost:1313/my-tokyo-gallery/gallery/20025/0621/
ちゃんと、ギャラリー表示に対応できていることを確認できた。

＞＞なので、今後も本文にはって、ページ更新編集していけそうです。
ありがとうございます
