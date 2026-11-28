import OriDesign
import SwiftUI

/// Native toolbar controls receive the system's shared Liquid Glass treatment.
struct ShellToolbar: ToolbarContent {
    @Environment(AppState.self) private var app

    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .navigation) {
            if app.showingSettings || app.profileVisible || app.activeTool != nil {
                Button { app.openQuickChat() } label: { OriLabel("На главную", symbol: "house", size: 16) }
                    .help("На главную")
            }
            Button { app.navigateHistory(-1) } label: { OriLabel("Назад", symbol: "chevron.left", size: 16) }
                .disabled(!app.shell.history.canGoBack).help("Назад · ⌘[")
            Button { app.navigateHistory(1) } label: { OriLabel("Вперёд", symbol: "chevron.right", size: 16) }
                .disabled(!app.shell.history.canGoForward).help("Вперёд · ⌘]")
        }
        ToolbarItemGroup(placement: .primaryAction) {
            if app.runControlsAvailable {
                Button { app.pauseOrResumeRun() } label: {
                    OriLabel(app.currentRunPaused ? "Продолжить" : "Пауза", symbol: app.currentRunPaused ? "play" : "pause", size: 16)
                }.disabled(!app.canPauseOrResumeRun)
                Button { app.confirmingStopRun = true } label: { OriLabel("Остановить", symbol: "stop", size: 16) }
                    .disabled(!app.canStopRun)
            }
            if let conversation = app.currentConversation { ConversationToolbarMenu(item: conversation) }
            if app.shellSupportsProjectPanel {
                Button { app.toggleShellPanel() } label: { OriLabel("Панель проекта", symbol: "sidebar.right", size: 16) }
                    .help("Панель проекта · ⌥⌘0")
            }
        }
    }
}
