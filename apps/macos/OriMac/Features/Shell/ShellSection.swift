import OriDesign
import Foundation

enum ShellSection: String {
    case chats = "Chats"
    case motes = "Motes"
    case scheduled = "Scheduled"
    case skills = "Skills"
    case ori = "Ori"
}

extension AppState {
    var isMotes: Bool { activeTool == nil && !profileVisible && product == .code && codeRoute == .motes }

    var shellSection: ShellSection {
        if product == .code {
            switch codeRoute {
            case .automations: return .scheduled
            case .skills: return .skills
            case .ori: return .ori
            case .motes: return .motes
            case .home, .task: return .chats
            }
        }
        switch workRoute {
        case .automations: return .scheduled
        case .skills: return .skills
        case .ori: return .ori
        case .home, .chat: return .chats
        }
    }

    var isNewConversation: Bool {
        activeTool == nil && !profileVisible && shellSection == .chats && (product == .code ? codeRoute == .home : workRoute == .home)
    }

    func openOriChat() {
        switchProduct(product)
        if product == .code { codeRoute = shell.lastCodeChat }
        else { workRoute = shell.lastWorkChat }
        sidebarVisible = true
    }

    func openSection(_ section: ShellSection) {
        profileVisible = false
        activeTool = nil
        showingSettings = false
        paletteVisible = false
        reviewVisible = false
        inspectorVisible = false
        shell.previewSource = nil
        sidebarVisible = true
        switch section {
        case .chats:
            if product == .code { openHome() }
            else { openWorkChat() }
        case .motes: product = .code; codeRoute = .motes
        case .scheduled:
            if product == .code { codeRoute = .automations }
            else { workRoute = .automations }
        case .skills:
            if product == .code { codeRoute = .skills }
            else { workRoute = .skills }
        case .ori:
            if product == .code { codeRoute = .ori }
            else { workRoute = .ori }
        }
    }
}
