import OriDesign
import SwiftUI

/// Apply shared state outside the entire window tree, including auxiliary background views.
struct OriWindowContent: View {
    let state: AppState

    private var textSize: TextSizePreference {
        TextSizePreference(rawValue: state.settings.fontSize) ?? .standard
    }

    var body: some View {
        RootView()
            .environment(state)
            .oriTheme(state.theme)
            .tint(K.inverse)
            .dynamicTypeSize(textSize.dynamicTypeSize)
            .onChange(of: textSize, initial: true) { _, size in KTextScale.shared.value = size.scale }
            .frame(minWidth: 1024, minHeight: 666)
    }
}
