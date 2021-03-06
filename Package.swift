// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TCA-Modules",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "ApphudClient",
                 targets: ["ApphudClient"]),
        .library(name: "IDFA",
                 targets: ["IDFA"]),
        .library(
            name: "RemoteNotificationsClient",
            targets: ["RemoteNotificationsClient"]),
        .library(
            name: "UserNotificationClient",
            targets: ["UserNotificationClient"]),
        .library(
            name: "UIClient",
            targets: ["UIClient"]),
        .library(
            name: "UIClient+Toast",
            targets: ["UIClient+Toast"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apphud/ApphudSDK", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.0.0")),
        .package(name: "Toast", url: "https://github.com/scalessec/Toast-Swift", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ApphudClient",
            dependencies: [
                .product(name: "ApphudSDK", package: "ApphudSDK"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .target(
            name: "IDFA",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .target(
            name: "RemoteNotificationsClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .target(
            name: "UserNotificationClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .target(
            name: "UIClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .target(
            name: "UIClient+Toast",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Toast", package: "Toast"),
                .target(name: "UIClient")
            ]),
    ],
    swiftLanguageVersions: [.v5]
)
