package dev.ori.infrastructure.workspace.projects;

import dev.ori.application.ports.ProjectAccess;
import dev.ori.application.workspace.WorkspaceFailure;
import java.nio.file.*;

/** Самостоятельный сервер использует права пользователя, который его запустил. */
public final class LocalProjectAccess implements ProjectAccess {
  public void authorize(Path directory) {
    if (!directory.isAbsolute() || !Files.isDirectory(directory) || !Files.isReadable(directory))
      throw new WorkspaceFailure(403, "project_access_required", "Папка проекта недоступна");
  }
}
