// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "OriWidgetSupport",
    platforms: [.macOS(.v26), .iOS(.v26)],
    products: [.library(name: "OriWidgetSupport", targets: ["OriWidgetSupport"])],
    dependencies: [.package(path: "../OriDomain")],
    targets: [
        .target(name: "OriWidgetSupport", dependencies: ["OriDomain"]),
        .testTarget(name: "OriWidgetSupportTests", dependencies: ["OriWidgetSupport"]),
    ]
)
