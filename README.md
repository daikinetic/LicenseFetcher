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
   git clone https://github.com/daikinetic/LicenseFetcher.git
   ```

## 使用方法

1. LicenseFetcher ツールをビルドします。 
   ```sh
   cd LicenseFetcher
   swift build
   ```
   
2. 依存パッケージのライセンス情報を収集し、`license.json`ファイルとして出力します。
   ```sh
   .build/debug/LicenseFetcher fetch-licenses
   ```

   ```sh
   cd .build/checkouts/LicenseFetcher
   swift run LicenseFetcher fetch-licenses
   ```

3. 生成された `licenses.json`ファイルをプロジェクトのルートディレクトリに移動します。
   ```sh
   mv licenses.json ../
   ```

4. `licenses.json`ファイルを Xcode プロジェクトに追加します。
   - Xcode でプロジェクトを開きます。
   - `Resources`フォルダに`licenses.json`ファイルをドラッグ＆ドロップします。
   - 「Copy items if needed」にチェックを入れて、「Add to targets」にプロジェクトのターゲットを選択します。









