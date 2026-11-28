import Testing
@testable import OriDesign

@Suite struct OriGlyphTests {
    @Test(arguments: [
        ("house", "house.fill"), ("person", "person.crop.circle.fill"),
        ("person.2", "person.3.fill"), ("envelope", "envelope.fill"),
        ("bubble.left.and.bubble.right", "bubble.left.and.bubble.right.fill"),
        ("checkmark.circle", "checkmark.circle.fill"), ("mic", "mic.fill"),
        ("xmark.circle", "xmark.circle.fill"), ("newspaper", "newspaper.fill"),
    ])
    func filledAliasesUseTheSameOutline(_ pair: (String, String)) {
        #expect(OriGlyph.resolve(symbol: pair.0) != nil)
        #expect(OriGlyph.resolve(symbol: pair.0) == OriGlyph.resolve(symbol: pair.1))
    }

    @Test(arguments: [
        "sidebar.right", "person.badge.plus", "brain", "shippingbox", "clock.arrow.circlepath",
        "creditcard", "chart.bar", "arrow.up.right", "arrow.up.left", "return",
        "chevron.up.chevron.down", "hifispeaker.2", "dollarsign.circle.fill", "externaldrive.fill",
        "key.fill", "number", "n.square.fill", "a.square", "asterisk", "triangle",
        "pause.circle", "arrow.down.circle", "point.3.connected.trianglepath.dotted", "photo.badge.plus",
        "checklist", "exclamationmark.circle", "lock.shield", "newspaper.fill",
    ])
    func workspaceSymbolsHaveDedicatedGlyphs(_ symbol: String) {
        let glyph = OriGlyph.resolve(symbol: symbol)
        #expect(glyph != nil)
        #expect(glyph != .document)
    }

    @Test func catalogNamesResolveToTheirOwnArtwork() {
        for glyph in OriGlyph.allCases {
            #expect(OriGlyph.resolve(symbol: glyph.rawValue) == glyph)
        }
    }

    @Test func legacyMacAndPhoneNamesResolveToRoundedArtwork() {
        #expect(OriGlyph.resolve(symbol: "square-pen") == .compose)
        #expect(OriGlyph.resolve(symbol: "panel-right") == .inspector)
        #expect(OriGlyph.resolve(symbol: "iphone") == .mobile)
        #expect(OriGlyph.resolve(symbol: "internaldrive") == .drive)
        #expect(OriGlyph.resolve(symbol: "photo.on.rectangle") == .image)
    }

    @Test func unsupportedSymbolsCanBeDetected() {
        #expect(OriGlyph.resolve(symbol: "unsupported.symbol") == nil)
    }
}
