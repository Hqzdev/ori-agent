import OriDomain
import Foundation

/// The view owns its history window. Older records stay persisted and can be revealed or reached by a pin/reply.
struct WorkspaceTranscriptWindow {
    static let pageSize = 80
    private(set) var count = pageSize

    func messages(in messages: [OriV3.Message]) -> ArraySlice<OriV3.Message> { messages.suffix(count) }
    func hasEarlier(in messages: [OriV3.Message]) -> Bool { messages.count > count }
    mutating func loadEarlier() { count += Self.pageSize }
    mutating func reset() { count = Self.pageSize }
    mutating func reveal(_ id: UUID, in messages: [OriV3.Message]) {
        guard let index = messages.firstIndex(where: { $0.metadata.id == id }) else { return }
        count = max(count, messages.count - index)
    }
    mutating func retainPosition(added: Int, followingLatest: Bool) {
        if !followingLatest, added > 0 { count += added }
    }
}
