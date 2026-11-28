import OriDesign
import SwiftUI

struct MacChatWallpaperSettings: View {
    @AppStorage(MacChatWallpaper.defaultsKey) private var wallpaper: MacChatWallpaper = .standard
    @AppStorage(MacChatWallpaper.blurDefaultsKey) private var blurred = false
    @Environment(\.macCompactSettings) private var compact
    @Environment(\.locale) private var locale

    private var russian: Bool { locale.language.languageCode?.identifier == "ru" }

    var body: some View {
        MacTeamSettingsSection(title: russian ? "Фон чатов" : "Chat background") {
            preview.padding(.top, 14)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: compact ? 2 : 4), spacing: 14) {
                ForEach(MacChatWallpaper.allCases) { option in
                    swatch(option)
                }
            }
            .padding(.vertical, 14)
            Divider()
            MacTeamSettingsToggle(title: russian ? "Размыть обои" : "Blur wallpaper", isOn: $blurred)
                .disabled(wallpaper == .standard)
                .accessibilityIdentifier("workspace.chat-wallpaper.blur")
        }
    }

    private var preview: some View {
        let shape = RoundedRectangle(cornerRadius: OriRadius.control)
        return VStack(alignment: .leading, spacing: 8) {
            previewMessage(russian ? "Подготовь итоги встречи." : "Summarize the meeting.")
                .frame(maxWidth: .infinity, alignment: .trailing)
            previewMessage(russian ? "Собрал решения и следующие шаги." : "Here are the decisions and next steps.")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background {
            WorkspaceStyle.canvas.overlay {
                MacChatWallpaperArtwork(wallpaper: wallpaper, blurred: blurred)
            }
        }
        .clipShape(shape)
        .overlay { shape.strokeBorder(OriColor.hairline).allowsHitTesting(false) }
        .accessibilityHidden(true)
    }

    private func previewMessage(_ text: String) -> some View {
        Text(verbatim: text)
            .font(.system(size: 13))
            .foregroundStyle(WorkspaceStyle.ink)
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background(MacChatStyle.incoming, in: RoundedRectangle(cornerRadius: 16))
    }

    private func swatch(_ option: MacChatWallpaper) -> some View {
        let selected = wallpaper == option
        let title = option.title(russian: russian)
        let shape = RoundedRectangle(cornerRadius: OriRadius.control)
        return Button {
            wallpaper = option
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                Rectangle()
                    .fill(WorkspaceStyle.canvas)
                    .aspectRatio(16.0 / 9.0, contentMode: .fit)
                    .overlay { MacChatWallpaperArtwork(wallpaper: option) }
                    .clipShape(shape)
                    .overlay { shape.strokeBorder(selected ? WorkspaceStyle.ink : OriColor.hairline, lineWidth: selected ? 2 : 1) }
                    .overlay(alignment: .bottomTrailing) {
                        if selected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundStyle(WorkspaceStyle.canvas)
                                .frame(width: 18, height: 18)
                                .background(WorkspaceStyle.ink, in: Circle())
                                .padding(6)
                        }
                    }
                Text(verbatim: title).font(.system(size: 12)).lineLimit(2)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(OriPlainButtonStyle(hoverIn: shape))
        .accessibilityLabel(title)
        .accessibilityAddTraits(selected ? .isSelected : [])
        .accessibilityIdentifier("workspace.chat-wallpaper.\(option.id)")
    }
}
