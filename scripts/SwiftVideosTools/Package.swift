// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "SwiftVideosTools",
    platforms: [
        .macOS(.v10_14)
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files.git", from: "3.1.0"),
        .package(url: "https://github.com/mtynior/ColorizeSwift.git", .branch("master")),
        .package(url: "https://github.com/eneko/CommandRegistry.git", from: "0.0.1"),
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "SwiftVideosTools",
            dependencies: ["Files", "ColorizeSwift", "CommandRegistry", "SwiftPM"],
            path: "."),
    ]
)
