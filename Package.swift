// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "app",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-alpha.1.2"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0-alpha.1.1"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0-alpha"),
        .package(url: "https://github.com/vapor/jobs.git", from: "1.0.0-alpha"),
        .package(url: "https://github.com/vapor/redis.git", from: "4.0.0-alpha"),
        .package(url: "https://github.com/vapor/jobs-redis-driver.git", from: "1.0.0-alpha"),
    ],
    targets: [
        .target(name: "App", dependencies: [
            "Fluent",
            "FluentSQLiteDriver",
            "Vapor",
            "Jobs",
            "JobsRedisDriver",
            "Redis"
        ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
