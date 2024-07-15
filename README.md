# LicenseFetcher

LicenseFetcher は、Xcode プロジェクトの依存パッケージのライセンス情報を収集し、JSON ファイルとして出力するツールです。

## 特徴

- 依存パッケージのライセンス情報を収集
- JSON ファイルにライセンス情報を書き出し
- Swift CLI を使用

## 前提条件

- Swift 5.3 以上
- Xcode 12 以上

## インストール

このリポジトリをクローンします。

   ```sh
   git clone https://github.com/username/LicenseFetcher.git
   cd LicenseFetcher
   ```

## 使用方法

1. LicenseFetcher ツールをビルドします。 
   ```sh
   swift build
   ```
   
2. 依存パッケージのライセンス情報を収集し、`license.json`ファイルとして出力します。
   ```sh
   .build/debug/LicenseFetcher fetch-licenses
   ```

3. 生成された `licenses.json`ファイルをプロジェクトのルートディレクトリに移動します。
   ```sh
   mv licenses.json ../
   ```





