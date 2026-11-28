// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "OriGraph",
    platforms: [.macOS(.v26), .iOS(.v26)],
    products: [.library(name: "OriGraph", targets: ["OriGraph"])],
    dependencies: [.package(path: "../OriDomain"), .package(path: "../OriDesign")],
    targets: [
        .target(name: "OriGraph", dependencies: ["OriDomain", "OriDesign"]),
        .testTarget(name: "OriGraphTests", dependencies: ["OriGraph"]),
    ]
)
