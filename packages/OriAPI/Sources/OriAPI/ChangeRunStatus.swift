import Foundation
import OriDomain

public struct ChangeRunStatus: Codable, Equatable, Sendable {
    public let runId: UUID
    public let expectedVersion: Int64
    public let status: RunStatus
    public init(runId: UUID, expectedVersion: Int64, status: RunStatus) {
        self.runId = runId
        self.expectedVersion = expectedVersion
        self.status = status
    }
}
