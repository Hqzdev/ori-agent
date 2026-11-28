// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "OriAPI",
    platforms: [.macOS(.v26), .iOS(.v26)],
    products: [.library(name: "OriAPI", targets: ["OriAPI"])],
    dependencies: [.package(path: "../OriDomain")],
    targets: [
        .target(name: "OriAPI", dependencies: ["OriDomain"]),
        .testTarget(name: "OriAPITests", dependencies: ["OriAPI"]),
    ]
)
