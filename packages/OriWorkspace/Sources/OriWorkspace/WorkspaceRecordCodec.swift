import OriDomain
import Foundation

struct DecodedWorkspaceRecord {
    let metadata: OriV3.RecordMetadata
    let payload: String
    let content: String?
}

/// Generated from the v3 model catalog. New wire entities must pass typed validation before persistence.
enum WorkspaceRecordCodec {
    static let supportedKinds: Set<String> = ["Account", "Device", "TrustedPair", "Workspace", "Project", "AgentProfile", "AgentConfigurationRevision", "Conversation", "Message", "Task", "TaskAttempt", "Assignment", "AgentSession", "AgentMessage", "PreparedAction", "ApprovalGrant", "ToolInvocation", "Artifact", "MemoryEntry", "ContextSummary", "Connection", "McpConnection", "Automation", "AutomationRun", "BudgetLedger", "SyncCursor", "ConversationParticipant", "MessageReaction", "ConversationReadPosition", "Skill", "SkillRevision", "RecordChange", "RecordTombstone", "ReplicationCheckpoint", "ConflictingRevision", "ExecutionLease", "ModelStep"]
    static func decode(kind: String, payload: String) throws -> DecodedWorkspaceRecord {
        switch kind {
        case "Account": return try record(OriV3.Account.self, payload: payload)
        case "Device": return try record(OriV3.Device.self, payload: payload)
        case "TrustedPair": return try record(OriV3.TrustedPair.self, payload: payload)
        case "Workspace": return try record(OriV3.Workspace.self, payload: payload)
        case "Project": return try record(OriV3.Project.self, payload: payload)
        case "AgentProfile": return try record(OriV3.AgentProfile.self, payload: payload)
        case "AgentConfigurationRevision": return try record(OriV3.AgentConfigurationRevision.self, payload: payload)
        case "Conversation": return try record(OriV3.Conversation.self, payload: payload)
        case "Message": return try record(OriV3.Message.self, payload: payload)
        case "Task": return try record(OriV3.Task.self, payload: payload)
        case "TaskAttempt": return try record(OriV3.TaskAttempt.self, payload: payload)
        case "Assignment": return try record(OriV3.Assignment.self, payload: payload)
        case "AgentSession": return try record(OriV3.AgentSession.self, payload: payload)
        case "AgentMessage": return try record(OriV3.AgentMessage.self, payload: payload)
        case "PreparedAction": return try record(OriV3.PreparedAction.self, payload: payload)
        case "ApprovalGrant": return try record(OriV3.ApprovalGrant.self, payload: payload)
        case "ToolInvocation": return try record(OriV3.ToolInvocation.self, payload: payload)
        case "Artifact": return try record(OriV3.Artifact.self, payload: payload)
        case "MemoryEntry": return try record(OriV3.MemoryEntry.self, payload: payload)
        case "ContextSummary": return try record(OriV3.ContextSummary.self, payload: payload)
        case "Connection": return try record(OriV3.Connection.self, payload: payload)
        case "McpConnection": return try record(OriV3.McpConnection.self, payload: payload)
        case "Automation": return try record(OriV3.Automation.self, payload: payload)
        case "AutomationRun": return try record(OriV3.AutomationRun.self, payload: payload)
        case "BudgetLedger": return try record(OriV3.BudgetLedger.self, payload: payload)
        case "SyncCursor": return try record(OriV3.SyncCursor.self, payload: payload)
        case "ConversationParticipant": return try record(OriV3.ConversationParticipant.self, payload: payload)
        case "MessageReaction": return try record(OriV3.MessageReaction.self, payload: payload)
        case "ConversationReadPosition": return try record(OriV3.ConversationReadPosition.self, payload: payload)
        case "Skill": return try record(OriV3.Skill.self, payload: payload)
        case "SkillRevision": return try record(OriV3.SkillRevision.self, payload: payload)
        case "RecordChange": return try record(OriV3.RecordChange.self, payload: payload)
        case "RecordTombstone": return try record(OriV3.RecordTombstone.self, payload: payload)
        case "ReplicationCheckpoint": return try record(OriV3.ReplicationCheckpoint.self, payload: payload)
        case "ConflictingRevision": return try record(OriV3.ConflictingRevision.self, payload: payload)
        case "ExecutionLease": return try record(OriV3.ExecutionLease.self, payload: payload)
        case "ModelStep": return try record(OriV3.ModelStep.self, payload: payload)
        default: throw WorkspaceSyncError.unsupportedRecord
        }
    }

    private static func record<T: OriWorkspaceRecord>(_ type: T.Type, payload: String) throws -> DecodedWorkspaceRecord {
        let data = Data(payload.utf8)
        let record = try WorkspaceCoding.decode(type, from: data)
        let encoded = try WorkspaceCoding.encode(record)
        let supplied = try JSONFields.object(payload)
        let canonical = try JSONFields.object(String(decoding: encoded, as: UTF8.self))
        guard Set(supplied.keys).isSubset(of: Set(canonical.keys)) else { throw WorkspaceSyncError.invalidChange }
        return DecodedWorkspaceRecord(metadata: record.metadata, payload: String(decoding: encoded, as: UTF8.self), content: (record as? OriV3.Message)?.content)
    }
}
