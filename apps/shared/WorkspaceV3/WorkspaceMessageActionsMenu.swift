import OriDesign
import OriDomain
import SwiftUI

struct WorkspaceMessageActionsMenu: View {
    let message: OriV3.Message
    @Environment(WorkspaceStore.self) private var store
    var body: some View {
        ControlGroup {
            ForEach(WorkspaceChatInteractions.reactions, id: \.self) { reaction in
                Button { store.toggleReaction(reaction, to: message.metadata.id) } label: { Text(reaction).font(.title2) }
                    .accessibilityLabel(store.t("React") + " " + reaction)
            }
        }.controlGroupStyle(.palette)
        OriIconButton(store.t("Copy message"), symbol: "doc.on.doc") { WorkspaceClipboard.copy(store.t(message.content)) }
        OriIconButton(store.t("Reply to message"), symbol: "arrowshape.turn.up.left") { store.beginReply(to: message.metadata.id) }
        #if os(iOS)
        if store.mode == .live {
            OriIconButton(store.t(store.isMessagePinned(message.metadata.id) ? "Unpin message" : "Pin message"),
                           symbol: store.isMessagePinned(message.metadata.id) ? "pin.slash" : "pin") {
                store.toggleMessagePin(message.metadata.id)
            }.disabled(store.pendingMessagePins.contains(message.metadata.id))
        }
        #endif
        if store.mode == .live, message.role == .user {
            OriIconButton(store.t("Retry response"), symbol: "arrow.clockwise") { store.retryResponse(to: message.metadata.id) }
                .disabled(store.isReplying)
        }
        if store.mode == .live {
            OriIconButton(store.t("Remember"), symbol: "brain") { store.rememberMessage(message.metadata.id) }
            WorkspaceMenu(store.t("Export")) {
                ForEach(WorkspaceExportFormat.allCases, id: \.self) { format in
                    Button(format.rawValue.uppercased()) { store.exportMessage(message.metadata.id, format: format) }
                }
            }
        }
    }
}
