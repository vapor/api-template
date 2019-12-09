// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "app",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .executable(name: "serve", targets: ["Run"]),
        .executable(name: "jobs", targets: ["Run"]),
        .library(name: "App", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", .branch("master")),
        .package(url: "https://github.com/vapor/fluent.git", .branch("master")),
        .package(url: "https://github.com/vapor/fluent-mysql-driver.git", .branch("master")),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", .branch("master")),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", .branch("master")),
        .package(url: "https://github.com/vapor/leaf.git", .branch("master")),
        .package(url: "https://github.com/vapor/jobs.git", .branch("master")),
        .package(url: "https://github.com/vapor/jwt.git", .branch("master")),
        .package(url: "https://github.com/vapor/jobs-redis-driver.git", .branch("master")),
        .package(url: "https://github.com/vapor/apns.git", .branch("master")),
    ],
    targets: [
        .target(name: "App", dependencies: [
            "APNS",
            "Fluent",
            "FluentMySQLDriver",
            "FluentPostgresDriver",
            "FluentSQLiteDriver",
            "Leaf",
            "Jobs",
            "JobsRedisDriver",
            "JWT",
            "Vapor"
        ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
