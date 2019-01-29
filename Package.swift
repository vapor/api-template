// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "#(name)",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),


        #if(fluent) {
            .package(url: "https://github.com/vapor/fluent-#lowercase(fluentdb).git", from: "#(fluentversion)")
        }
    ],
    targets: [
        .target(name: "App", dependencies: [
            "Vapor",
            #if(fluent) {
            "Fluent#(fluentdb)", }
        ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
