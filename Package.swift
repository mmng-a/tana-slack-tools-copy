// swift-tools-version:5.8
import PackageDescription

// Enable better optimizations when building in Release configuration. Despite the use of
// the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
// builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
extension SwiftSetting {
  enum UnsafeFlags {
    static var crossModuleOptimization: SwiftSetting {
      return .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
    }
  }
}

let package = Package(
  name: "tana-slack-tools",
  platforms: [
    .macOS(.v13)
  ],
//  products: [
//    .executable(name: "Run", targets: ["Run"]),
//    .library(name: "SlackClient", targets: ["SlackClient"]),
//    .library(name: "BlockKitBuilder", targets: ["BlockKitBuilder"])
//  ],
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
    .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0"),
    .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.6.0"),
  ],
  targets: [
    .executableTarget(name: "Run", dependencies: [
      .target(name: "ApplicationFlow"),
      .product(name: "Vapor", package: "vapor")
    ]),
    .target(
      name: "ApplicationFlow",
      dependencies: [
        .product(name: "Fluent", package: "fluent"),
        .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
        .product(name: "Vapor", package: "vapor"),
        .product(name: "AnyCodable", package: "AnyCodable"),
        .target(name: "BlockKitBuilder"),
        .target(name: "SlackClient"),
      ],
      swiftSettings: [.UnsafeFlags.crossModuleOptimization]
    ),
    .target(
      name: "SlackClient",
      dependencies: [
        .product(name: "Vapor", package: "vapor"),
        .product(name: "AnyCodable", package: "AnyCodable"),
        .target(name: "BlockKitBuilder"),
        .target(name: "SlackPrimaryTypes")
      ]
    ),
    .target(name: "BlockKitBuilder", dependencies: ["SlackPrimaryTypes"]),
    .target(name: "SlackPrimaryTypes"),

    .testTarget(
      name: "ApplicationFlowTests",
      dependencies: [
        .target(name: "ApplicationFlow"),
        .product(name: "XCTVapor", package: "vapor"),
      ]),
  ]
)
