// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "LicenseFetcher",
  products: [
    .executable(
      name: "LicenseFetcher",
      targets: ["LicenseFetcher"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/jakeheis/SwiftCLI", from: "6.0.0")
  ],
  targets: [
    .executableTarget(
      name: "LicenseFetcher",
      dependencies: ["SwiftCLI"]
    ),
  ]
)
