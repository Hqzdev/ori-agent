import Foundation
import SwiftUI
import Testing
@testable import OriDesign

@Suite struct ThemePreferenceTests {
    private func defaults() -> (UserDefaults, String) {
        let suite = "ori.design.tests." + UUID().uuidString
        return (UserDefaults(suiteName: suite)!, suite)
    }

    @Test func defaultsToSystem() {
        let (store, suite) = defaults()
        defer { store.removePersistentDomain(forName: suite) }
        #expect(ThemeStore.load(from: store) == .system)
    }

    @Test(arguments: ThemePreference.allCases)
    func savesAndLoads(_ preference: ThemePreference) {
        let (store, suite) = defaults()
        defer { store.removePersistentDomain(forName: suite) }
        ThemeStore.save(preference, to: store)
        #expect(ThemeStore.load(from: store) == preference)
    }

    @Test func unknownValueFallsBackToSystem() {
        let (store, suite) = defaults()
        defer { store.removePersistentDomain(forName: suite) }
        store.set("Sepia", forKey: ThemeStore.defaultsKey)
        #expect(ThemeStore.load(from: store) == .system)
    }

    @Test func choosingSystemClearsTheStoredValue() {
        let (store, suite) = defaults()
        defer { store.removePersistentDomain(forName: suite) }
        ThemeStore.save(.dark, to: store)
        ThemeStore.save(.system, to: store)
        #expect(store.string(forKey: ThemeStore.defaultsKey) == nil)
    }

    @Test func colorSchemes() {
        #expect(ThemePreference.system.colorScheme == nil)
        #expect(ThemePreference.light.colorScheme == .light)
        #expect(ThemePreference.dark.colorScheme == .dark)
    }
}

@Suite struct PaletteContrastTests {
    private func contrast(_ foreground: OriColorPair, on background: OriColorPair, dark: Bool) -> Double {
        let back = OriRGBA(dark ? background.dark : background.light)
        let front = OriRGBA(dark ? foreground.dark : foreground.light).over(back)
        return OriRGBA.contrast(front, back)
    }

    @Test(arguments: [false, true])
    func readableTextOnEverySurface(dark: Bool) {
        for surface in [OriPalette.canvas, OriPalette.sidebar, OriPalette.panel, OriPalette.fill, OriPalette.tag] {
            #expect(contrast(OriPalette.text, on: surface, dark: dark) >= 7)
            #expect(contrast(OriPalette.textSecondary, on: surface, dark: dark) >= 4.5)
        }
        #expect(contrast(OriPalette.onInverse, on: OriPalette.inverse, dark: dark) >= 7)
    }

    @Test(arguments: [false, true])
    func focusRingStandsOut(dark: Bool) {
        #expect(contrast(OriPalette.focusRing, on: OriPalette.canvas, dark: dark) >= 3)
        #expect(contrast(OriPalette.focusRing, on: OriPalette.sidebar, dark: dark) >= 3)
    }

    @Test(arguments: [false, true])
    func accessoriesReadOnInkAndPaper(dark: Bool) {
        #expect(contrast(OriPalette.accent, on: OriPalette.text, dark: dark) >= 2.5)
        #expect(contrast(OriPalette.accent, on: OriPalette.canvas, dark: dark) >= 3)
    }
}
