import OriDesign
import SwiftUI

struct PrimaryOri: View {
    @Environment(AppState.self) private var app
    @Environment(\.oriNamespace) private var namespace
    let context: OriContext
    var body: some View {
        Group {
            if let namespace { pet.matchedGeometryEffect(id: "primary-ori", in: namespace) }
            else { pet }
        }
    }
    private var pet: some View {
        OriView(state: app.activeOriContext == context ? app.activeOriState : .idle,
                 size: K.primaryOriSize, followsPointer: true, behavior: .lively, tappable: true, intro: true, context: context)
    }
}
