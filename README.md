# 📈 note記事アクセス分析レポート

このプロジェクトは、仮想のnote記事アクセスデータを用いて、どの記事がよく読まれたりスキされたりしているかを分析・可視化したレポートです。  

---

## 🔍 分析の目的

- note記事のPV（閲覧数）やスキ数の傾向を把握
- カテゴリ別、投稿時間別などの特徴分析
- データを可視化し、今後のnote運営に役立てる

---

## 📁 ディレクトリ構成
├── step01_note_virtual_data.csv # 仮想のnote記事データ
├── note-report.Rmd # R Markdownによる分析レポート
├── note-report.pdf # 出力されたPDF（オプション）
├── .gitignore
├── LICENSE
└── README.md # 本ファイル

---

## 🛠 使用技術・パッケージ

- R / RStudio
- tidyverse（dplyr, ggplot2, tidyr など）
- lubridate（日時処理）
- kableExtra（表の装飾）
- rmarkdown（レポート出力）
- TinyTeX（PDF出力のためのLaTeX環境）

---

👤 作者
まさひと（masahito-SciBiz）

本プロジェクトは、ポートフォリオとしての公開や、レポートテンプレートとしての再利用も歓迎します。
