import OriDomain
import OriWorkspace
import Foundation

/// Message ordering is computed once per snapshot, rather than for every view read.
struct WorkspaceMessageIndex {
    private let conversations: [UUID: [OriV3.Message]]
    private let visible: [UUID: [OriV3.Message]]
    private let byID: [UUID: OriV3.Message]
    private let orderedIDs: [UUID: [UUID]]
    private let lastUsers: [UUID: OriV3.Message]
    private let runningResponses: [UUID: [OriV3.Message]]

    init(_ messages: [OriV3.Message] = [], activityMessageIDs: Set<UUID> = []) {
        conversations = Dictionary(grouping: messages, by: \.conversationId).mapValues(WorkspaceMessageOrder.ordered)
        visible = conversations.mapValues { $0.filter { WorkspaceMessagePresentation.isVisible($0) || activityMessageIDs.contains($0.metadata.id) } }
        byID = Dictionary(messages.map { ($0.metadata.id, $0) }, uniquingKeysWith: { _, latest in latest })
        orderedIDs = conversations.mapValues { $0.map(\.metadata.id) }
        lastUsers = conversations.compactMapValues { $0.last { $0.role == .user } }
        runningResponses = conversations.mapValues { messages in
            guard let source = messages.last(where: { $0.role == .user }) else { return [] }
            return messages.filter { $0.role == .assistant && $0.commandId == source.commandId && $0.delivery == .running }
        }
    }

    func messages(in conversationID: UUID?) -> [OriV3.Message] {
        guard let conversationID else { return [] }
        return conversations[conversationID] ?? []
    }
    func visibleMessages(in conversationID: UUID?) -> [OriV3.Message] {
        guard let conversationID else { return [] }
        return visible[conversationID] ?? []
    }
    func message(_ id: UUID) -> OriV3.Message? { byID[id] }
    func ids(in conversationID: UUID?) -> [UUID] { conversationID.flatMap { orderedIDs[$0] } ?? [] }
    func lastUser(in conversationID: UUID) -> OriV3.Message? { lastUsers[conversationID] }
    func activeResponses(in conversationID: UUID) -> [OriV3.Message] { runningResponses[conversationID] ?? [] }
}
