import OriDesign
import OriWorkspace
import SwiftUI

enum MacComposerModelPreferences {
    static let tierKey = "blot.mac.composer.model"
    static let effortKey = "blot.mac.composer.effort"

    static var profile: OriInferenceProfile? {
        guard let raw = UserDefaults.standard.string(forKey: tierKey), let tier = OriModelTier(rawValue: raw) else { return nil }
        let effort = UserDefaults.standard.string(forKey: effortKey).flatMap(OriModelEffort.init(rawValue:)) ?? .medium
        return .init(tier: tier, effort: effort)
    }
}

struct MacComposerModelMenu: View {
    @Environment(WorkspaceStore.self) private var store
    @AppStorage(MacComposerModelPreferences.tierKey) private var rawTier = ""
    @AppStorage(MacComposerModelPreferences.effortKey) private var effort = OriModelEffort.medium

    private var tier: OriModelTier? { OriModelTier(rawValue: rawTier) }
    private var automatic: String { store.language == "ru" ? "Модель агента" : "Agent model" }

    private let extraInk = OriColor.dynamic(.init(light: 0x62399DFF, dark: 0xD5BEFFFF))

    var body: some View {
        HStack(spacing: 2) {
            MacActionMenu(edge: .top) {
                ForEach(OriModelTier.allCases, id: \.self) { item in
                    Button { rawTier = item.rawValue } label: { option(item.title, glyph: item.menuGlyph, checked: tier == item) }
                }
                WorkspaceMenuGap()
                Button { rawTier = "" } label: { option(automatic, glyph: .agent, checked: tier == nil) }
            } label: { chip(tier?.title ?? automatic) }
                .macHoverTip(store.language == "ru" ? "Выбрать модель" : "Choose model")
            if let tier, tier != .mini {
                MacActionMenu(edge: .top) {
                    ForEach(OriModelEffort.allCases, id: \.self) { item in
                        Button { effort = item } label: { option(item.rawValue.capitalized, glyph: item.menuGlyph, checked: item == effort, accented: item == .extra && item == effort) }
                    }
                } label: { chip(effort.rawValue.capitalized, highlighted: effort == .extra) }
                    .macHoverTip(store.language == "ru" ? "Уровень рассуждения" : "Reasoning effort")
            }
        }
    }

    private func chip(_ title: String, highlighted: Bool = false) -> some View {
        Text(title)
            .font(.system(size: 13))
            .foregroundStyle(highlighted ? extraInk : OriColor.textSecondary)
            .lineLimit(1)
            .padding(.horizontal, 5)
            .frame(minHeight: 30)
            .oriHover(in: RoundedRectangle(cornerRadius: 7))
    }

    private func option(_ title: String, glyph: OriGlyph, checked: Bool, accented: Bool = false) -> some View {
        HStack {
            Label {
                Text(title)
                    .foregroundStyle(accented ? extraInk : OriColor.text)
            } icon: {
                OriIcon(glyph, size: OriIconSize.control)
            }
            Spacer(minLength: 8)
            if checked {
                OriIcon(.check, size: OriIconSize.inline)
            }
        }
        .frame(minHeight: 25)
        .accessibilityAddTraits(checked ? .isSelected : [])
    }
}

private extension OriModelTier {
    var menuGlyph: OriGlyph {
        switch self {
        case .mini: .skill
        case .pro: .chip
        case .max: .sparkle
        }
    }
}

private extension OriModelEffort {
    var menuGlyph: OriGlyph {
        switch self {
        case .light: .circle
        case .medium: .progress
        case .high: .gauge
        case .extra: .bolt
        }
    }
}
