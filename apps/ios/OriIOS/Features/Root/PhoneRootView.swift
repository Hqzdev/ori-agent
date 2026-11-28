import OriAPI
import OriDesign
import SwiftUI

struct PhoneRootView: View {
    @State private var connection = PhoneConnection()
    @State private var code = ""
    @State private var bluetooth = false
    @State private var scanner = false
    var body: some View {
        Group {
            if let client = connection.client {
                PhoneWorkspaceView(client: client, disconnect: connection.disconnect)
            } else {
                NavigationStack {
                    Form {
                        Section {
                            VStack(alignment: .leading, spacing: OriSpace.s10) {
                                Text("Connect to your Mac").oriFont(.heading).foregroundStyle(OriColor.text)
                                    .accessibilityAddTraits(.isHeader)
                                Text("Open Ori on your Mac, choose Devices → Connect iPhone, then scan the QR code.")
                                    .oriFont(.body).foregroundStyle(OriColor.textSecondary)
                            }
                            .padding(.vertical, OriSpace.element)
                        }
                        .phoneRow()
                        Section {
                            OriStatusLabel(connection.status, status: .info, role: .body)
                            Toggle("Use Bluetooth", isOn: $bluetooth)
                                .oriFont(.body)
                                .frame(minHeight: OriLayout.minimumTapTarget)
                            Button { scanner = true } label: { OriLabel("Scan QR code", symbol: "qrcode.viewfinder") }
                                .buttonStyle(PhoneButtonStyle(kind: .primary, fullWidth: true))
                            Button { Task { await connection.restore(bluetooth: bluetooth) } } label: {
                                OriLabel("Reconnect saved Mac", symbol: "arrow.clockwise")
                            }
                            .buttonStyle(PhoneButtonStyle(fullWidth: true))
                        } header: { PhoneSectionHeader("Connection") }
                        .phoneRow()
                        Section {
                            TextField("Paste the code from your Mac", text: $code, axis: .vertical)
                                .oriFont(.code)
                                .lineLimit(3...6)
                                .textInputAutocapitalization(.never).autocorrectionDisabled()
                                .accessibilityLabel("Connection code")
                            Button("Connect") { connection.pair(json: code, bluetooth: bluetooth) }
                                .buttonStyle(PhoneButtonStyle(fullWidth: true))
                                .disabled(code.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        } header: { PhoneSectionHeader("Connection code") }
                        .phoneRow()
                        if let error = connection.error {
                            Section { PhoneErrorText(error) } header: { PhoneSectionHeader("Couldn’t connect") }
                                .phoneRow()
                        }
                    }
                    .phoneList()
                    .navigationTitle("Ori")
                }
            }
        }
        .task { await connection.restore() }
        .sheet(isPresented: $scanner) {
            NavigationStack {
                PhoneQRScanner { value in code = value; scanner = false; connection.pair(json: value, bluetooth: bluetooth) }
                    .navigationTitle("Scan connection code")
                    .phoneBars()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) { Button("Cancel") { scanner = false } }
                    }
            }
        }
    }
}
