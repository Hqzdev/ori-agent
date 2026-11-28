import OriDomain
import Foundation

/// Consistent read model taken from one SQLite transaction.
public struct WorkspaceProjection: Codable, Equatable, Sendable {
    public var agents: [OriV3.AgentProfile] = []
    public var configurations: [OriV3.AgentConfigurationRevision] = []
    public var conversations: [OriV3.Conversation] = []
    public var messages: [OriV3.Message] = []
    public var participants: [OriV3.ConversationParticipant] = []
    public var reactions: [OriV3.MessageReaction] = []
    public var readPositions: [OriV3.ConversationReadPosition] = []
    public var schedules: [OriV3.Automation] = []
    public var automationRuns: [OriV3.AutomationRun] = []
    public var memories: [OriV3.MemoryEntry] = []
    public var summaries: [OriV3.ContextSummary] = []
    public var skills: [OriV3.Skill] = []
    public var skillRevisions: [OriV3.SkillRevision] = []
    public var artifacts: [OriV3.Artifact] = []
    public var connections: [OriV3.Connection] = []
    public var modelSteps: [OriV3.ModelStep] = []
    public var tasks: [OriV3.Task] = []
    public var sessions: [OriV3.AgentSession] = []
    public var agentMessages: [OriV3.AgentMessage] = []
    public var actions: [OriV3.PreparedAction] = []
    public var grants: [OriV3.ApprovalGrant] = []
    public var invocations: [OriV3.ToolInvocation] = []
    public var budgets: [OriV3.BudgetLedger] = []
    public var conflicts: [OriV3.ConflictingRevision] = []
    public init() {}
}
