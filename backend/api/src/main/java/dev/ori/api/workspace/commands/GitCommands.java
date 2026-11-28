package dev.ori.api.workspace.commands;

import dev.ori.application.ports.*;
import dev.ori.application.ports.JsonCodec;
import dev.ori.application.workspace.*;
import dev.ori.application.workspace.WorkspaceFailure;
import dev.ori.application.workspace.commands.CommandDispatcher;
import dev.ori.application.workspace.git.GitOperationService;
import dev.ori.application.workspace.git.GitPreparationService;
import java.util.*;

public final class GitCommands {
  record Prepare(UUID runId, Map<String, Object> arguments) {}

  record Id(UUID id) {}

  public GitCommands(
      CommandDispatcher commands,
      JsonCodec json,
      GitOperationService git,
      GitPreparationService preparation) {
    commands.register(
        "git.prepare_commit",
        (tx, actor, command) -> {
          var payload = json.convert(command.payload(), Prepare.class);
          return preparation.prepare(
              tx, actor, payload.runId(), "git.commit", payload.arguments(), null);
        });
    commands.registerPrepared(
        "git.prepare_push",
        (actor, command) -> {
          var payload = json.convert(command.payload(), Prepare.class);
          if (payload.arguments() == null) throw WorkspaceFailure.invalid("Нужны аргументы push");
          var remote =
              preparation.resolveRemote(
                  actor, payload.runId(), (String) payload.arguments().get("remote"));
          return (tx, current, original) ->
              preparation.prepare(
                  tx, current, payload.runId(), "git.push", payload.arguments(), remote);
        });
    commands.register(
        "git.execute",
        (tx, a, c) ->
            git.execute(tx, a, json.convert(c.payload(), Id.class).id(), c.expectedVersion()));
    commands.register(
        "git.reconcile",
        (tx, a, c) -> git.reconcile(tx, a, json.convert(c.payload(), Id.class).id()));
  }
}
