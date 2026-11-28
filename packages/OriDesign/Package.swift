// swift-tools-version: 6.2
import PackageDescription

/// Shared look of the Mac and iPhone apps: tokens, theme choice, control styles, data states
/// and the Ori character. Platform navigation stays in the apps.
let package = Package(
    name: "OriDesign",
    platforms: [.macOS(.v26), .iOS(.v26)],
    products: [.library(name: "OriDesign", targets: ["OriDesign"])],
    dependencies: [],
    targets: [
        .target(name: "OriDesign", resources: [.process("Resources")],
                swiftSettings: [.defaultIsolation(MainActor.self)]),
        .testTarget(name: "OriDesignTests", dependencies: ["OriDesign"],
                    swiftSettings: [.defaultIsolation(MainActor.self)]),
    ]
)
