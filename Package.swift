// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "userinfo-representable",
    platforms: [.iOS(.v13), .macOS(.v10_15), .watchOS(.v6), .tvOS(.v13)],
    products: [
        .library(name: "UserInfoRepresentable", targets: ["UserInfoRepresentable"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "UserInfoRepresentable",
            dependencies: ["UserInfoRepresentableMacro"]
        ),
        .macro(
            name: "UserInfoRepresentableMacro",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .testTarget(name: "UserInfoRepresentableTests", dependencies: ["UserInfoRepresentable"]),
        .testTarget(
            name: "UserInfoRepresentableMacroTests",
            dependencies: [
                "UserInfoRepresentableMacro",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        )
    ]
)
