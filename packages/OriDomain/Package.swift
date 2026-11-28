// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "OriDomain",
    platforms: [.macOS(.v26), .iOS(.v26)],
    products: [.library(name: "OriDomain", targets: ["OriDomain"])],
    dependencies: [],
    targets: [
        .target(name: "OriDomain", dependencies: []),
        .testTarget(name: "OriDomainTests", dependencies: ["OriDomain"]),
    ]
)
