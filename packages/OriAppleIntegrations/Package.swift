// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "OriAppleIntegrations",
    platforms: [.macOS(.v26), .iOS(.v26)],
    products: [.library(name: "OriAppleIntegrations", targets: ["OriAppleIntegrations"])],
    dependencies: [.package(path: "../OriWorkspace"), .package(path: "../OriDomain")],
    targets: [
        .target(name: "OriAppleIntegrations", dependencies: ["OriWorkspace", "OriDomain"]),
        .testTarget(name: "OriAppleIntegrationsTests", dependencies: ["OriAppleIntegrations"]),
    ]
)
