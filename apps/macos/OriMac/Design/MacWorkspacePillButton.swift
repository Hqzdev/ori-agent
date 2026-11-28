import OriDesign
import SwiftUI

struct MacWorkspacePillButton<Label: View>: View {
    let action: () -> Void
    @ViewBuilder let label: () -> Label

    var body: some View {
        Button(action: action) {
            label()
                .font(.system(size: 13, weight: .medium))
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .frame(height: 38)
                .background(WorkspaceStyle.surface, in: Capsule())
                .overlay(Capsule().strokeBorder(OriColor.hairline))
                .oriHitArea()
        }
        .buttonStyle(OriHitTargetButtonStyle(hoverIn: Capsule(), hoverColor: .clear))
        .macSidebarHoverTarget(radius: 19)
    }
}
