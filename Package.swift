import PackageDescription

let alpha = Version(2,0,0, prereleaseIdentifiers: ["alpha"])

let package = Package(
    name: "VaporApp",
    targets: [
        Target(name: "AppLogic"),
        Target(name: "Run", dependencies: ["AppLogic"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", alpha),
        .Package(url: "https://github.com/vapor/fluent-provider.git", majorVersion: 0),
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
    ]
)
