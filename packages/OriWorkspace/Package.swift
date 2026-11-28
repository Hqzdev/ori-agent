// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "OriWorkspace",
    platforms: [.macOS(.v26), .iOS(.v26)],
    products: [.library(name: "OriWorkspace", targets: ["OriWorkspace"])],
    dependencies: [.package(path: "../OriDomain")],
    targets: [
        .systemLibrary(name: "CSQLite"),
        .target(name: "OriWorkspace", dependencies: ["OriDomain", "CSQLite"]),
        .testTarget(name: "OriWorkspaceTests", dependencies: ["OriWorkspace"]),
    ]
)
