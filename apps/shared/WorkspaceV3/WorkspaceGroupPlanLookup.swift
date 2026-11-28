import OriDomain
import OriWorkspace

extension WorkspaceStore {
    func groupPlan(for message: OriV3.Message) -> WorkspaceGroupPlanProgress? {
        chatContent.plan(for: message)
    }
}
