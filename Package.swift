import PackageDescription

let package = Package(
    name: "VaporApp",
    targets: [
        Target(name: "App"),
        Target(name: "Run", dependencies: ["App"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/fluent-provider.git", majorVersion: 1),
        .Package(url: "https://github.com/vapor/models-template.git", Version(0,0,0)),
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
    ]
)
