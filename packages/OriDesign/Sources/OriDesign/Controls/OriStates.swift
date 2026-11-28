//
//  OriStates.swift
//  OriDesign
//
//  Status and data states that read without colour: each tone has its own symbol and the
//  text says what happened. Errors and warnings also use a heavier weight.
//

import SwiftUI

nonisolated public enum OriStatus: Sendable, Equatable, CaseIterable {
    case neutral, info, progress, success, warning, error

    /// Distinct glyph per tone (outline circle, i, half circle, check, triangle, cross).
    public var symbol: String {
        switch self {
        case .neutral: "circle"
        case .info: "info.circle"
        case .progress: "circle.lefthalf.filled"
        case .success: "checkmark.circle"
        case .warning: "exclamationmark.triangle"
        case .error: "xmark.octagon"
        }
    }

    /// Spoken before the message so VoiceOver users hear the tone.
    public var spokenPrefix: String {
        switch self {
        case .neutral, .info: ""
        case .progress: "In progress: "
        case .success: "Done: "
        case .warning: "Warning: "
        case .error: "Error: "
        }
    }

    public var weight: Font.Weight {
        switch self {
        case .warning, .error: .medium
        default: .regular
        }
    }

    /// Body text is ink for things that need attention, secondary otherwise.
    public var foreground: Color {
        switch self {
        case .warning, .error: OriColor.text
        default: OriColor.textSecondary
        }
    }

    /// Background used by banners and pills; stronger veil for problems.
    public var background: Color {
        switch self {
        case .warning, .error: OriColor.pressed
        case .success, .progress: OriColor.hover
        case .neutral, .info: OriColor.fill
        }
    }
}

/// Icon + text line for inline feedback, toasts and banners.
public struct OriStatusLabel: View {
    private let text: String
    private let status: OriStatus
    private let role: OriTextRole

    public init(_ text: String, status: OriStatus, role: OriTextRole = .caption) {
        self.text = text
        self.status = status
        self.role = role
    }

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: OriSpace.element) {
            OriIcon(symbol: status.symbol, size: role.size)
                .font(OriFont.role(role, weight: .semibold))
                .accessibilityHidden(true)
            Text(text)
                .oriFont(role, weight: status.weight)
                .fixedSize(horizontal: false, vertical: true)
        }
        .foregroundStyle(status.foreground)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(status.spokenPrefix + text)
    }
}

/// Square-cornered pill with icon and label, e.g. run and task status.
public struct OriStatusPill: View {
    private let text: String
    private let status: OriStatus

    public init(_ text: String, status: OriStatus) {
        self.text = text
        self.status = status
    }

    public var body: some View {
        HStack(spacing: 4) {
            OriIcon(symbol: status.symbol, size: 11).font(.system(size: 11, weight: .semibold)).accessibilityHidden(true)
            Text(text).font(OriFont.role(.meta, weight: status.weight == .regular ? .medium : .semibold)).lineLimit(1)
        }
        .foregroundStyle(status == .neutral ? OriColor.textSecondary : OriColor.text)
        .padding(.horizontal, OriSpace.element)
        .padding(.vertical, 3)
        .background(Rectangle().fill(status.background))
        .fixedSize()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Status: \(text)")
    }
}

/// Centered empty state with an optional action.
public struct OriEmptyState: View {
    private let symbol: String
    private let title: String
    private let message: String
    private let actionTitle: String?
    private let action: (() -> Void)?

    public init(symbol: String, title: String, message: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.symbol = symbol
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        VStack(spacing: OriSpace.s10) {
            OriIcon(symbol: symbol)
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(OriColor.textSecondary)
                .frame(width: 44, height: 44)
                .oriPanel(fill: OriColor.fill)
                .accessibilityHidden(true)
            Text(LocalizedStringKey(title)).oriFont(.body, weight: .semibold).foregroundStyle(OriColor.text)
                .multilineTextAlignment(.center)
            Text(LocalizedStringKey(message)).oriFont(.caption).foregroundStyle(OriColor.textSecondary)
                .multilineTextAlignment(.center).frame(maxWidth: 380)
                .fixedSize(horizontal: false, vertical: true)
            if let actionTitle, let action {
                Button(actionTitle, action: action).buttonStyle(OriButtonStyle()).padding(.top, OriSpace.element)
            }
        }
        .padding(.vertical, 40).padding(.horizontal, OriSpace.section)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .contain)
    }
}

/// Spinner with a label.
public struct OriLoadingState: View {
    private let label: String

    public init(_ label: String = "Loading…") { self.label = label }

    public var body: some View {
        HStack(spacing: OriSpace.s8) {
            ProgressView().controlSize(.small)
            Text(label).oriFont(.caption).foregroundStyle(OriColor.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(OriSpace.panel)
        .accessibilityElement(children: .combine)
    }
}

/// Error message with a retry action.
public struct OriErrorState: View {
    private let message: String
    private let retryTitle: String
    private let retry: (() -> Void)?

    public init(_ message: String, retryTitle: String = "Try again", retry: (() -> Void)? = nil) {
        self.message = message
        self.retryTitle = retryTitle
        self.retry = retry
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: OriSpace.s10) {
            OriStatusLabel(message, status: .error)
                .textSelection(.enabled)
            if let retry {
                Button(retryTitle, action: retry).buttonStyle(OriButtonStyle(size: .compact))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(OriSpace.panel)
        .oriPanel(fill: OriColor.fill, border: OriColor.hairlineStrong)
    }
}
