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

 `Package.swift` ファイルに以下を追加します。

   ```swift
   dependencies: [
       .package(url: "https://github.com/yourusername/LicenseFetcher.git", from: "1.0.0")
   ],
   targets: [
       .target(
           name: "YourTargetName",
           dependencies: ["LicenseFetcher"]),
   ]
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
  

## 使用される特定の型について

`LicenseFetcher` ツールは、以下の構造体 `LicenseInfo` を使用してライセンス情報を管理します。この構造体は、依存関係ごとのライセンス情報を含む JSON ファイルにエンコードされます。

```swift
struct LicenseInfo: Codable {
    let packageName: String
    let licenseName: String
    let copyright: String
    let conditions: String
    let disclaimer: String
}
```

この構造体は、以下のフィールドを含みます:

- packageName: パッケージの名前
- licenseName: ライセンスの名前（例: MIT License, Apache License 2.0）
- copyright: 著作権情報
- conditions: ライセンスの条件
- disclaimer: 免責事項

## ライセンス情報の取得方法

`LicenseFetcher` は、依存関係のリポジトリから以下のパスにあるライセンスファイルをチェックします:

- LICENSE
- LICENSE.txt
- LICENSE.md
- LICENSE.rst

リポジトリの `master` ブランチと `main` ブランチの両方をチェックし、最初に見つかったライセンスファイルの情報を使用します。















