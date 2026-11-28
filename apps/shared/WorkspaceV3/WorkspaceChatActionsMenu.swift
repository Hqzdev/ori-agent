import OriDesign
import OriDomain
import SwiftUI

struct WorkspaceChatActionsMenu: View {
    let chat: OriV3.Conversation
    @Environment(WorkspaceStore.self) private var store

    var body: some View {
        if chat.kind == .group {
            OriIconButton(store.t("Group members"), symbol: "person.2") { store.editGroup(chat.metadata.id) }
        }
        OriIconButton(store.t("Rename chat"), symbol: "pencil") { store.beginChatRename(chat.metadata.id) }
        Divider()
        OriIconButton(store.t(chat.pinned ? "Unpin chat" : "Pin chat"), symbol: "pin") {
            store.toggleChatPin(chat.metadata.id)
        }
        OriIconButton(store.t(chat.archived ? "Unarchive chat" : "Archive chat"), symbol: "archivebox") {
            store.setChatArchived(chat.metadata.id, archived: !chat.archived)
        }
        OriIconButton(store.t(store.chatInteractions.unreadCount(in: chat.metadata.id) > 0 ? "Mark as read" : "Mark as unread"), symbol: "envelope") {
            if store.chatInteractions.unreadCount(in: chat.metadata.id) > 0 { store.markChatRead(chat.metadata.id) }
            else { store.markChatUnread(chat.metadata.id) }
        }
        OriIconButton(store.t(store.chatInteractions.isMuted(chat.metadata.id) ? "Unmute chat" : "Mute chat"),
                       symbol: store.chatInteractions.isMuted(chat.metadata.id) ? "bell" : "bell.slash") {
            store.toggleChatMute(chat.metadata.id)
        }
        if store.chatActivity.isResponding(in: chat.metadata.id) {
            OriIconButton(store.t("Stop reply"), symbol: "stop") { store.stopReply(in: chat.metadata.id) }
        }
        if let agentID = chat.agentId, chat.kind != .group {
            Divider()
            OriIconButton(store.t("Agent"), symbol: "person.crop.circle") { store.selectAgent(agentID) }
            OriIconButton(store.t("Edit agent"), symbol: "paintbrush") { store.editChatAgent(agentID) }
        }
        Divider()
        Button(role: .destructive) { store.pendingChatDeletionID = chat.metadata.id } label: {
            OriLabel(store.t("Delete chat"), symbol: "trash")
        }
    }
}
