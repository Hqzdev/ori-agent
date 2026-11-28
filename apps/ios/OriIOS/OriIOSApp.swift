import OriDesign
import SwiftUI

@main
struct OriIOSApp: App {
    @State private var workspace = WorkspaceBootstrap.makeStore()
    init() { OriIconAppearance.configureNavigation() }
    var body: some Scene {
        WindowGroup { WorkspaceRootView(store: workspace) }
    }
}
