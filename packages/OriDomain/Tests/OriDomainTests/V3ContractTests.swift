import Foundation
import Testing
@testable import OriDomain

private let fixtureDirectory = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("fixtures/v3")

private func checkRecord<T: Codable & Equatable>(_ type: T.Type, name: String) throws {
    let data = try Data(contentsOf: fixtureDirectory.appendingPathComponent(name + ".json"))
    let decoder = JSONDecoder(); decoder.dateDecodingStrategy = .iso8601
    let encoder = JSONEncoder(); encoder.dateEncodingStrategy = .iso8601
    let value = try decoder.decode(type, from: data)
    let encoded = try encoder.encode(value)
    #expect(try decoder.decode(type, from: encoded) == value)
    var original = try JSONSerialization.jsonObject(with: data) as! [String: Any]
    var serialized = try JSONSerialization.jsonObject(with: encoded) as! [String: Any]
    // The additive delegation proof may be absent or null in legacy task records.
    if name == "Task" {
        if original["authorizationJSON"] is NSNull { original.removeValue(forKey: "authorizationJSON") }
        if serialized["authorizationJSON"] is NSNull { serialized.removeValue(forKey: "authorizationJSON") }
    }
    #expect((original as NSDictionary) == (serialized as NSDictionary))
}
@Test func v3PublicRecordsShareTheWireShape() throws {
    try checkRecord(OriV3.Project.self, name: "Project")
    try checkRecord(OriV3.Account.self, name: "Account")
    try checkRecord(OriV3.Device.self, name: "Device")
    try checkRecord(OriV3.TrustedPair.self, name: "TrustedPair")
    try checkRecord(OriV3.Workspace.self, name: "Workspace")
    try checkRecord(OriV3.AgentProfile.self, name: "AgentProfile")
    try checkRecord(OriV3.AgentConfigurationRevision.self, name: "AgentConfigurationRevision")
    try checkRecord(OriV3.Conversation.self, name: "Conversation")
    try checkRecord(OriV3.Message.self, name: "Message")
    try checkRecord(OriV3.Message.self, name: "Message-rich")
    try checkRecord(OriV3.Task.self, name: "Task")
    try checkRecord(OriV3.TaskAttempt.self, name: "TaskAttempt")
    try checkRecord(OriV3.Assignment.self, name: "Assignment")
    try checkRecord(OriV3.AgentSession.self, name: "AgentSession")
    try checkRecord(OriV3.AgentMessage.self, name: "AgentMessage")
    try checkRecord(OriV3.PreparedAction.self, name: "PreparedAction")
    try checkRecord(OriV3.ApprovalGrant.self, name: "ApprovalGrant")
    try checkRecord(OriV3.ToolInvocation.self, name: "ToolInvocation")
    try checkRecord(OriV3.Artifact.self, name: "Artifact")
    try checkRecord(OriV3.MemoryEntry.self, name: "MemoryEntry")
    try checkRecord(OriV3.ContextSummary.self, name: "ContextSummary")
    try checkRecord(OriV3.Connection.self, name: "Connection")
    try checkRecord(OriV3.McpConnection.self, name: "McpConnection")
    try checkRecord(OriV3.Automation.self, name: "Automation")
    try checkRecord(OriV3.AutomationRun.self, name: "AutomationRun")
    try checkRecord(OriV3.BudgetLedger.self, name: "BudgetLedger")
    try checkRecord(OriV3.SyncCursor.self, name: "SyncCursor")
    try checkRecord(OriV3.ConversationParticipant.self, name: "ConversationParticipant")
    try checkRecord(OriV3.MessageReaction.self, name: "MessageReaction")
    try checkRecord(OriV3.ConversationReadPosition.self, name: "ConversationReadPosition")
    try checkRecord(OriV3.Skill.self, name: "Skill")
    try checkRecord(OriV3.SkillRevision.self, name: "SkillRevision")
    try checkRecord(OriV3.RecordChange.self, name: "RecordChange")
    try checkRecord(OriV3.RecordTombstone.self, name: "RecordTombstone")
    try checkRecord(OriV3.ReplicationCheckpoint.self, name: "ReplicationCheckpoint")
    try checkRecord(OriV3.ConflictingRevision.self, name: "ConflictingRevision")
    try checkRecord(OriV3.ExecutionLease.self, name: "ExecutionLease")
    try checkRecord(OriV3.ModelStep.self, name: "ModelStep")
}
@Test func v3StatesMatchAcrossPlatforms() throws {
    let data = try Data(contentsOf: fixtureDirectory.appendingPathComponent("states.json"))
    let states = try JSONDecoder().decode([String: [String]].self, from: data)
    #expect(states["DeviceKind"] == OriV3.DeviceKind.allCases.map(\.rawValue))
    #expect(states["TrustState"] == OriV3.TrustState.allCases.map(\.rawValue))
    #expect(states["TaskState"] == OriV3.TaskState.allCases.map(\.rawValue))
    #expect(states["DeliveryState"] == OriV3.DeliveryState.allCases.map(\.rawValue))
    #expect(states["ActionState"] == OriV3.ActionState.allCases.map(\.rawValue))
    #expect(states["AttemptState"] == OriV3.AttemptState.allCases.map(\.rawValue))
    #expect(states["AssignmentState"] == OriV3.AssignmentState.allCases.map(\.rawValue))
    #expect(states["SessionState"] == OriV3.SessionState.allCases.map(\.rawValue))
    #expect(states["AccessMode"] == OriV3.AccessMode.allCases.map(\.rawValue))
    #expect(states["GrantKind"] == OriV3.GrantKind.allCases.map(\.rawValue))
    #expect(states["ConnectionState"] == OriV3.ConnectionState.allCases.map(\.rawValue))
    #expect(states["AutomationKind"] == OriV3.AutomationKind.allCases.map(\.rawValue))
    #expect(states["MissedRunPolicy"] == OriV3.MissedRunPolicy.allCases.map(\.rawValue))
    #expect(states["MemoryScope"] == OriV3.MemoryScope.allCases.map(\.rawValue))
    #expect(states["MemoryState"] == OriV3.MemoryState.allCases.map(\.rawValue))
    #expect(states["BudgetState"] == OriV3.BudgetState.allCases.map(\.rawValue))
    #expect(states["MessageRole"] == OriV3.MessageRole.allCases.map(\.rawValue))
    #expect(states["PetState"] == OriV3.PetState.allCases.map(\.rawValue))
    #expect(states["ConversationKind"] == OriV3.ConversationKind.allCases.map(\.rawValue))
    #expect(states["ParticipantKind"] == OriV3.ParticipantKind.allCases.map(\.rawValue))
    #expect(states["ChangeOperation"] == OriV3.ChangeOperation.allCases.map(\.rawValue))
    #expect(states["ReplicationState"] == OriV3.ReplicationState.allCases.map(\.rawValue))
    #expect(states["AutomationTrigger"] == OriV3.AutomationTrigger.allCases.map(\.rawValue))
    #expect(states["ExecutionMode"] == OriV3.ExecutionMode.allCases.map(\.rawValue))
    #expect(states["ModelStepState"] == OriV3.ModelStepState.allCases.map(\.rawValue))
    #expect(states["LeaseState"] == OriV3.LeaseState.allCases.map(\.rawValue))
}
@Test func v3RejectsInvalidCountersOnDecode() throws {
    let data = Data(#"{"executorDeviceId":"00000000-0000-4000-8000-000000000001","originDeviceId":"00000000-0000-4000-8000-000000000001","taskId":"00000000-0000-4000-8000-000000000001","revision":-1}"#.utf8)
    #expect(throws: OriV3.ValidationError.self) { try JSONDecoder().decode(OriV3.ExecutionContext.self, from: data) }
}
