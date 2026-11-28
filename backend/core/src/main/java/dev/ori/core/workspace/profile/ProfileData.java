package dev.ori.core.workspace.profile;

import dev.ori.core.workspace.provider.ProviderSettingsData;
import java.util.List;

/** Роль остаётся данными; профиль может только сужать доступный роли набор инструментов. */
public record ProfileData(
    String role,
    String instruction,
    ProviderSettingsData settings,
    List<String> tools,
    int maxTurns) {
  public ProfileData {
    tools = tools == null ? null : java.util.List.copyOf(tools);
  }
}
