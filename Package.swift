// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "VaporApp",
    dependencies: [
        // 💧 A server-side Swift web framework. 
        .package(url: "https://github.com/vapor/vapor.git", .exact("3.0.0-alpha.5")),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: ["Routing", "Service", "Vapor"]
        ),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"]),
    ]
)
