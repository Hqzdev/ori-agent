package dev.ori.api.workspace.commands;

import dev.ori.application.ports.*;
import dev.ori.application.ports.JsonCodec;
import dev.ori.application.workspace.*;
import dev.ori.application.workspace.automation.AutomationService;
import dev.ori.application.workspace.commands.CommandDispatcher;
import dev.ori.application.workspace.execution.RunService;
import dev.ori.application.workspace.library.LibraryService;
import dev.ori.core.workspace.*;
import dev.ori.core.workspace.EntityKind;
import dev.ori.core.workspace.automation.AutomationData;
import dev.ori.core.workspace.skills.SkillData;
import java.util.*;

public final class LibraryCommands {
  record Skill(UUID id, SkillData data) {}

  record Automation(UUID id, AutomationData data) {}

  record Id(UUID id) {}

  public LibraryCommands(
      CommandDispatcher commands,
      JsonCodec json,
      LibraryService library,
      AutomationService automations,
      RunService runs) {
    commands.register(
        "skill.save",
        (tx, a, c) -> {
          var p = json.convert(c.payload(), Skill.class);
          return library.saveSkill(tx, a, c.projectId(), p.id(), c.expectedVersion(), p.data());
        });
    commands.register(
        "automation.run_now",
        (tx, actor, command) ->
            automations.runNow(
                tx,
                actor,
                json.convert(command.payload(), Id.class).id(),
                command.expectedVersion(),
                runs));
    commands.register(
        "automation.save",
        (tx, a, c) -> {
          var p = json.convert(c.payload(), Automation.class);
          return automations.save(tx, a, c.projectId(), p.id(), c.expectedVersion(), p.data());
        });
    for (var kind : List.of(EntityKind.SKILL, EntityKind.AUTOMATION))
      commands.register(
          kind.name().toLowerCase() + ".delete",
          (tx, a, c) -> {
            library.delete(
                tx, a, kind, json.convert(c.payload(), Id.class).id(), c.expectedVersion());
            return Map.of("deleted", true);
          });
  }
}
