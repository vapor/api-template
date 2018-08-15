// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "VaporApp",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0"),

        .package(url: "https://github.com/vapor/jwt.git", from: "3.0.0-rc")
    ],
    targets: [
        .target(name: "App", dependencies: ["Authentication", "JWT", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
