import OriAPI
import OriDesign
import SwiftUI

struct PhoneChatView: View {
    let client: BackendClient
    let conversation: UUID
    var title = "Conversation"
    @State private var messages: [BackendEntity<Message>] = []
    @State private var text = ""
    @State private var loadError: String?
    @State private var sendError: String?
    @State private var loading = true
    @State private var pending: UUID?
    @State private var pendingContent: String?
    @State private var sending = false
    @State private var reactions = OriReactionController()
    @FocusState private var composing: Bool
    nonisolated private struct Message: Codable, Sendable { let role: String; let content: String; let ordinal: Int64 }
    nonisolated private struct Send: Encodable, Sendable { let conversationId: UUID; let content: String }

    var body: some View {
        ScrollViewReader { proxy in
            List {
                if loading && messages.isEmpty {
                    OriLoadingState("Loading conversation…")
                        .listRowSeparator(.hidden).listRowBackground(Color.clear)
                }
                if let loadError {
                    OriErrorState(loadError) { Task { await refresh() } }
                        .listRowSeparator(.hidden).listRowBackground(Color.clear)
                } else if !loading && messages.isEmpty {
                    OriEmptyState(symbol: "bubble.left.and.bubble.right", title: "Start a conversation",
                                   message: "Send a message to Ori using the field below.")
                        .listRowSeparator(.hidden).listRowBackground(Color.clear)
                }
                ForEach(messages.sorted { $0.data.ordinal < $1.data.ordinal }, id: \.id) { row in
                    PhoneMessageRow(role: row.data.role, content: row.data.content)
                        .id(row.id)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: OriSpace.element, leading: OriSpace.panel,
                                                  bottom: OriSpace.element, trailing: OriSpace.panel))
                }
            }
            .phonePlainList()
            .scrollDismissesKeyboard(.interactively)
            .defaultScrollAnchor(.bottom)
            .onChange(of: sending) { _, value in
                if !value, sendError == nil, let last = messages.max(by: { $0.data.ordinal < $1.data.ordinal }) {
                    proxy.scrollTo(last.id, anchor: .bottom)
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) { composer }
        .navigationTitle(title.isEmpty ? "Conversation" : title)
        .task(id: conversation) {
            while !Task.isCancelled {
                await refresh()
                try? await Task.sleep(for: .seconds(1))
            }
        }
        .onDisappear { reactions.cancel() }
    }

    private var composer: some View {
        VStack(alignment: .leading, spacing: OriSpace.element) {
            PhoneComposerOri(reactions: reactions)
                .padding(.leading, OriSpace.s10)
            if let sendError { PhoneErrorText(sendError) }
            HStack(alignment: .bottom, spacing: OriSpace.s8) {
                TextField("Message Ori", text: $text, axis: .vertical)
                    .oriFont(.body)
                    .foregroundStyle(OriColor.text)
                    .lineLimit(1...6)
                    .padding(.horizontal, OriSpace.s12)
                    .padding(.vertical, OriSpace.s10)
                    .frame(minHeight: OriLayout.minimumTapTarget)
                    .focused($composing)
                    .disabled(sending || pending != nil)
                    .accessibilityLabel("Message Ori")
                OriSendButton(phase: sending ? .sending : pending == nil ? .ready : .retry,
                               size: OriLayout.minimumTapTarget - 8, action: send)
                    .frame(width: OriLayout.minimumTapTarget, height: OriLayout.minimumTapTarget)
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && pending == nil)
            }
            .padding(.trailing, OriSpace.element)
            .oriPanel(fill: OriColor.panel, border: composing ? OriColor.focusRing : OriColor.hairlineStrong)
            .contentShape(Rectangle())
            .onTapGesture { composing = true }
        }
        .padding(.horizontal, OriSpace.panel)
        .padding(.top, OriSpace.element)
        .padding(.bottom, OriSpace.s10)
        .background(OriColor.canvas)
        .onChange(of: text) { _, value in
            if !value.isEmpty { reactions.receive(.typing) }
        }
    }

    private func refresh() async {
        defer { loading = false }
        do {
            let records = try await client.records("MESSAGE", parentId: conversation, as: Message.self)
            guard !Task.isCancelled else { return }
            messages = records
            loadError = nil
        } catch is CancellationError { }
        catch { loadError = error.localizedDescription }
    }

    private func send() {
        guard !sending else { return }
        let id = pending ?? UUID()
        pending = id
        let content = pendingContent ?? text
        pendingContent = content
        sending = true
        reactions.receive(.sent)
        Task {
            defer { sending = false }
            do {
                _ = try await client.command("conversation.send_message", payload: Send(conversationId: conversation, content: content), commandId: id)
                pending = nil; pendingContent = nil; text = ""; sendError = nil
                await refresh()
            } catch let failure as BackendFailure {
                if failure.isDefiniteRejection { pending = nil; pendingContent = nil }
                sendError = failure.localizedDescription
                reactions.receive(.sendFailed)
            } catch {
                sendError = error.localizedDescription
                reactions.receive(.sendFailed)
            }
        }
    }
}

/// 40 pt Ori above the composer. Reacts to typing, sending and a failed send; idles otherwise.
private struct PhoneComposerOri: View {
    let reactions: OriReactionController
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        OriCharacterView(state: reactions.state(over: .idle), size: OriLayout.phoneCharacterSize,
                          replay: reactions.generation, behavior: .subtle, reduceMotion: reduceMotion)
            .accessibilityHidden(true)
            .task(id: reactions.generation) {
                // Typing extends the current reaction, so wait until it has really run out.
                while let remaining = reactions.remaining {
                    do { try await Task.sleep(for: .seconds(remaining + 0.05)) } catch { return }
                    reactions.expire()
                }
            }
    }
}

private struct PhoneMessageRow: View {
    let role: String
    let content: String

    private var isUser: Bool { role.uppercased() == "USER" }
    private var author: String {
        switch role.uppercased() {
        case "USER": "You"
        case "ASSISTANT": "Ori"
        case "SYSTEM": "System"
        case "TOOL": "Tool"
        default: phoneStatusLabel(role)
        }
    }

    var body: some View {
        Group {
            if isUser {
                HStack {
                    Spacer(minLength: 48)
                    Text(content)
                        .oriFont(.body)
                        .foregroundStyle(OriColor.text)
                        .padding(.horizontal, OriSpace.panel)
                        .padding(.vertical, OriSpace.s10)
                        .background(RoundedRectangle(cornerRadius: OriRadius.control, style: .continuous).fill(OriColor.fill))
                        .textSelection(.enabled)
                }
            } else {
                VStack(alignment: .leading, spacing: OriSpace.element) {
                    Text(author).oriFont(.caption, weight: .medium).foregroundStyle(OriColor.textSecondary)
                    Text(content).oriFont(.body).foregroundStyle(OriColor.text)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(author): \(content)")
    }
}
