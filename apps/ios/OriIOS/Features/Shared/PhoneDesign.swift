//
//  PhoneDesign.swift
//  OriIOS
//
//  iPhone helpers on top of OriDesign: flat lists and forms on the shared palette, compact
//  inline titles, buttons with 44 × 44 pt tap areas and status text that does not rely on colour.
//

import OriDesign
import SwiftUI

extension View {
    /// Flat grouped list: sidebar-tone background, panel rows, hairline separators, no glass bars.
    func phoneList() -> some View {
        self
            .scrollContentBackground(.hidden)
            .background(OriColor.sidebar.ignoresSafeArea())
            .listRowSeparatorTint(OriColor.hairline)
            .phoneBars()
    }

    /// Plain list for conversations: canvas background, no row separators.
    func phonePlainList() -> some View {
        self
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(OriColor.canvas.ignoresSafeArea())
            .phoneBars()
    }

    /// Solid navigation bar on the canvas colour with an inline title (17 pt, below the 24 pt cap).
    func phoneBars() -> some View {
        self
            .toolbarTitleDisplayMode(.inline)
            .toolbarBackground(OriColor.canvas, for: .navigationBar)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
    }

    /// Row background for sections inside `phoneList()`.
    func phoneRow() -> some View {
        listRowBackground(OriColor.panel)
    }
}

/// OriDesign button with a tap area of at least 44 pt.
struct PhoneButtonStyle: ButtonStyle {
    var kind: OriButtonKind = .secondary
    var fullWidth = false

    func makeBody(configuration: Configuration) -> some View {
        OriButtonStyle(kind, size: .large, fullWidth: fullWidth)
            .makeBody(configuration: configuration)
            .frame(minHeight: OriLayout.minimumTapTarget)
            .contentShape(Rectangle())
    }
}

/// Error line: icon + text, ink and medium weight — never red.
struct PhoneErrorText: View {
    let message: String
    init(_ message: String) { self.message = message }
    var body: some View {
        OriStatusLabel(message, status: .error)
            .textSelection(.enabled)
    }
}

/// Backend status («AWAITING_PLAN») as words people read («Plan ready»).
func phoneStatusLabel(_ raw: String) -> String {
    switch raw.uppercased() {
    case "": return "Unknown"
    case "AWAITING_PLAN": return "Plan ready"
    case "READY_FOR_ACCEPTANCE": return "Ready to accept"
    case "PREPARED": return "Needs approval"
    default:
        let words = raw.replacingOccurrences(of: "_", with: " ").lowercased()
        return words.prefix(1).uppercased() + words.dropFirst()
    }
}

/// Tone of a backend status, shown with its own icon.
func phoneStatus(_ raw: String) -> OriStatus {
    switch raw.uppercased() {
    case "RUNNING", "PLANNING", "EXECUTING", "QUEUED", "REVIEWING", "WRITING": .progress
    case "COMPLETED", "DONE", "ACCEPTED", "APPROVED", "PASSED", "MERGED", "SUCCEEDED": .success
    case "AWAITING_PLAN", "READY_FOR_ACCEPTANCE", "PREPARED", "WAITING", "PAUSED", "BLOCKED", "INTERRUPTED": .warning
    case "FAILED", "REJECTED", "DENIED", "ERROR": .error
    default: .neutral
    }
}

/// Status pill for a backend status string.
struct PhoneStatusPill: View {
    let raw: String
    var body: some View { OriStatusPill(phoneStatusLabel(raw), status: phoneStatus(raw)) }
}

/// Section header in the shared caption style.
struct PhoneSectionHeader: View {
    let title: String
    init(_ title: String) { self.title = title }
    var body: some View {
        WorkspaceLocalizedText(title).oriFont(.caption, weight: .medium).foregroundStyle(OriColor.textSecondary).textCase(nil)
    }
}
