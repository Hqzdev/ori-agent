import OriAPI
import OriDesign
import SwiftUI

struct PhoneWorkspaceView: View {
    let client: BackendClient
    let disconnect: () -> Void
    @State private var model: PhoneWorkspaceModel
    @State private var confirmingDisconnect = false
    @AppStorage(ThemeStore.defaultsKey) private var theme: ThemePreference = .system

    init(client: BackendClient, disconnect: @escaping () -> Void) {
        self.client = client
        self.disconnect = disconnect
        _model = State(initialValue: PhoneWorkspaceModel(client: client))
    }

    var body: some View {
        TabView {
            Tab {
                NavigationStack { chats }
            } label: { OriLabel("Chats", symbol: "bubble.left.and.bubble.right") }
            Tab {
                NavigationStack { code }
            } label: { OriLabel("Code", symbol: "terminal") }
            Tab {
                NavigationStack { PhoneApprovalsView(client: client) }
            } label: { OriLabel("Decisions", symbol: "checkmark.shield") }
            Tab {
                NavigationStack { connection }
            } label: { OriLabel("Connection", symbol: "network") }
        }
        .toolbarBackground(OriColor.canvas, for: .tabBar)
        .toolbarBackgroundVisibility(.visible, for: .tabBar)
        .task(id: client.baseURL) { await model.refresh() }
    }

    private var chats: some View {
        @Bindable var model = model
        return List {
            loadStatus
            Section {
                TextField("Conversation title", text: $model.title)
                    .oriFont(.body)
                    .frame(minHeight: OriLayout.minimumTapTarget)
                    .disabled(model.busy || model.chatPending)
                Button {
                    Task { await model.createChat() }
                } label: {
                    OriLabel(model.chatPending ? "Retry creating chat" : "Create chat",
                          symbol: model.chatPending ? "arrow.clockwise" : "square.and.pencil")
                }
                .buttonStyle(PhoneButtonStyle(kind: .primary, fullWidth: true))
                .disabled(!model.canCreateChat)
                if let error = model.chatError { PhoneErrorText(error) }
            } header: { PhoneSectionHeader("New conversation") }
            .phoneRow()
            Section {
                ForEach(model.chats, id: \.id) { row in
                    let title = row.data.text("title")
                    NavigationLink {
                        PhoneChatView(client: client, conversation: row.id, title: title)
                    } label: {
                        WorkspaceLocalizedText(title.isEmpty ? "Untitled conversation" : title)
                            .oriFont(.body)
                            .foregroundStyle(OriColor.text)
                            .frame(minHeight: OriLayout.minimumTapTarget, alignment: .leading)
                    }
                }
                if !model.loading && model.loadError == nil && model.chats.isEmpty {
                    OriEmptyState(symbol: "bubble.left.and.bubble.right", title: "No conversations yet",
                                   message: "Create a chat above to start working with Ori.")
                }
            } header: { PhoneSectionHeader("Conversations") }
            .phoneRow()
        }
        .phoneList()
        .navigationTitle("Chats")
        .refreshable { await model.refresh() }
    }

    private var code: some View {
        @Bindable var model = model
        return List {
            loadStatus
            Section {
                if model.projects.isEmpty {
                    OriStatusLabel("Add a project in Ori on your Mac to create a run.", status: .info, role: .body)
                } else {
                    Picker("Project", selection: $model.selectedProject) {
                        ForEach(model.projects, id: \.id) { Text($0.data.text("name")).tag(Optional($0.id)) }
                    }
                    .frame(minHeight: OriLayout.minimumTapTarget)
                    .disabled(model.busy || model.runPending)
                }
                TextField("What should Ori do?", text: $model.goal, axis: .vertical)
                    .oriFont(.body)
                    .lineLimit(3...8)
                    .disabled(model.busy || model.runPending)
                Button {
                    Task { await model.createRun() }
                } label: {
                    OriLabel(model.runPending ? "Retry creating plan" : "Create plan",
                          symbol: model.runPending ? "arrow.clockwise" : "list.bullet.clipboard")
                }
                .buttonStyle(PhoneButtonStyle(kind: .primary, fullWidth: true))
                .disabled(!model.canCreateRun)
                if let error = model.runError { PhoneErrorText(error) }
            } header: { PhoneSectionHeader("New run") } footer: {
                Text("Review the plan before the team starts working.")
                    .oriFont(.caption).foregroundStyle(OriColor.textSecondary)
            }
            .phoneRow()
            Section {
                ForEach(model.runs, id: \.id) { row in
                    NavigationLink { PhoneRunView(client: client, run: row) } label: {
                        VStack(alignment: .leading, spacing: OriSpace.element) {
                            Text(row.data.text("goal")).oriFont(.body, weight: .medium).foregroundStyle(OriColor.text)
                                .lineLimit(3)
                            PhoneStatusPill(raw: row.data.text("status"))
                        }
                        .padding(.vertical, 4)
                    }
                }
                if !model.loading && model.loadError == nil && model.runs.isEmpty {
                    OriEmptyState(symbol: "terminal", title: "No runs yet",
                                   message: "Runs from your Mac appear here. You can also create a plan above.")
                }
            } header: { PhoneSectionHeader("Runs") }
            .phoneRow()
        }
        .phoneList()
        .navigationTitle("Code")
        .refreshable { await model.refresh() }
    }

    @ViewBuilder private var loadStatus: some View {
        if model.loading {
            OriLoadingState("Loading workspace…").phoneRow()
        }
        if let error = model.loadError {
            OriErrorState(error) { Task { await model.refresh() } }
                .disabled(model.busy)
                .listRowBackground(Color.clear)
        }
        if model.busy {
            OriLoadingState("Saving…").phoneRow()
        }
    }

    private var connection: some View {
        Form {
            Section {
                OriStatusLabel("Connected to your Mac", status: .success, role: .body)
            } footer: {
                Text("Keep Ori open on your Mac to receive updates and respond to decisions.")
                    .oriFont(.caption).foregroundStyle(OriColor.textSecondary)
            }
            .phoneRow()
            Section {
                Picker("Theme", selection: $theme) {
                    ForEach(ThemePreference.allCases) { option in
                        OriLabel(option.title, symbol: option.symbol).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .frame(minHeight: OriLayout.minimumTapTarget)
                .accessibilityLabel("Theme")
            } header: { PhoneSectionHeader("Appearance") } footer: {
                Text("System follows your iPhone. Light and Dark apply to Ori on this iPhone only.")
                    .oriFont(.caption).foregroundStyle(OriColor.textSecondary)
            }
            .phoneRow()
            Section {
                Button(role: .destructive) { confirmingDisconnect = true } label: {
                    OriLabel("Disconnect…", symbol: "xmark.circle")
                }
                .buttonStyle(PhoneButtonStyle(kind: .destructive, fullWidth: true))
            }
            .phoneRow()
        }
        .phoneList()
        .navigationTitle("Connection")
        .confirmationDialog("Disconnect from your Mac?", isPresented: $confirmingDisconnect, titleVisibility: .visible) {
            Button("Disconnect", role: .destructive, action: disconnect)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You can reconnect to your saved Mac from the connection screen.")
        }
    }
}
