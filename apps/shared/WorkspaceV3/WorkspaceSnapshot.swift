import OriDomain
import OriWorkspace
import Foundation

struct WorkspaceSnapshot: Codable, Equatable, Sendable {
    var localConnectedPluginIDs: [String]?
    var cards: [OriV3.ConversationCard]?
    var projects: [OriV3.Project]?
    var pairedDevices: [WorkspacePairedDevice]?
    var messagePins: [WorkspaceMessagePin]?
    var pinnedGroupPlans: [UUID: UUID]?
    var toolInvocations: [OriV3.ToolInvocation]?
    var tasks: [OriV3.Task]?
    var automationRuns: [OriV3.AutomationRun]?
    var scheduleFailures: [UUID]?
    var preparedActions: [OriV3.PreparedAction]?
    var modelSteps: [OriV3.ModelStep]?
    var ownerID: UUID?
    var localDeviceID: UUID?
    var participants: [OriV3.ConversationParticipant]?
    var reactions: [OriV3.MessageReaction]?
    var readPositions: [OriV3.ConversationReadPosition]?
    var skillAssignments: [WorkspaceSkillAssignment]?
    var skills: [OriV3.Skill]?
    var skillRevisions: [OriV3.SkillRevision]?
    var configurations: [OriV3.AgentConfigurationRevision]?
    var summaries: [OriV3.ContextSummary]?
    var conflicts: [OriV3.ConflictingRevision]?
    var agents: [OriV3.AgentProfile] = []
    var conversations: [OriV3.Conversation] = []
    var messages: [OriV3.Message] = []
    var schedules: [OriV3.Automation] = []
    var devices: [OriV3.Device] = []
    var memories: [OriV3.MemoryEntry] = []
    var connections: [OriV3.Connection] = []
    var artifacts: [OriV3.Artifact] = []
    var mcpConnections: [OriV3.McpConnection] = []
}
