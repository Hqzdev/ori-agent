import OriDesign
import OriDomain
import SwiftUI

struct MacComposerAccessMenu: View {
    @Binding var selection: OriV3.AccessMode
    @Environment(WorkspaceStore.self) private var store

    private var russian: Bool { store.language == "ru" }
    private var selectedTitle: String {
        ApprovalOption.allCases.first { $0.mode == selection }?.title(russian: russian) ?? store.t("Observe")
    }

    var body: some View {
        MacActionMenu(edge: .top, width: 310) {
            ForEach(ApprovalOption.allCases, id: \.self) { option in
                let selected = selection == option.mode
                Button { selection = option.mode } label: {
                    HStack(spacing: 10) {
                        OriIcon(option.glyph, size: OriIconSize.control)
                            .foregroundStyle(OriColor.textSecondary)
                            .accessibilityHidden(true)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(option.title(russian: russian))
                            Text(option.detail(russian: russian))
                                .font(.system(size: 12))
                                .foregroundStyle(OriColor.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        OriIcon(.check, size: OriIconSize.inline)
                            .opacity(selected ? 1 : 0)
                            .accessibilityHidden(true)
                    }
                    .padding(.vertical, 6)
                    .accessibilityElement(children: .combine)
                }.accessibilityAddTraits(selected ? .isSelected : [])
            }
        } label: {
            Text(selectedTitle)
                .font(.system(size: 13))
                .lineLimit(1)
                .padding(.horizontal, 5)
                .frame(minHeight: 30)
                .oriHover(in: RoundedRectangle(cornerRadius: 7))
        }.macHoverTip(store.t("Access mode"))
    }
}

private enum ApprovalOption: CaseIterable {
    case ask, trusted

    var mode: OriV3.AccessMode {
        switch self {
        case .ask: .ask_first
        case .trusted: .trusted_scope
        }
    }

    var glyph: OriGlyph {
        switch self {
        case .ask: .question
        case .trusted: .shieldCheck
        }
    }

    func title(russian: Bool) -> String {
        switch self {
        case .ask: russian ? "Спрашивать разрешение" : "Ask for approval"
        case .trusted: russian ? "Разрешать за меня" : "Approve for me"
        }
    }

    func detail(russian: Bool) -> String {
        switch self {
        case .ask: russian ? "Подтверждать вручную действия, требующие разрешения." : "Confirm actions that require approval yourself."
        case .trusted: russian ? "Автоматически разрешать действия в доверенной области." : "Allow actions within the trusted scope automatically."
        }
    }
}
