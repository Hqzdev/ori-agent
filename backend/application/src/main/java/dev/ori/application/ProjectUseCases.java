package dev.ori.application;

import dev.ori.application.OriApplicationService.CreateProject;
import dev.ori.application.OriUnitOfWork.ProjectRepository;
import dev.ori.core.Project;
import java.time.Instant;
import java.util.Map;
import java.util.UUID;

final class ProjectUseCases {
  private final UseCaseSupport support;

  ProjectUseCases(UseCaseSupport support) {
    this.support = support;
  }

  ApplicationResult<Project> create(CreateProject command) {
    if (command == null) {
      return UseCaseSupport.invalid("command", "must not be null");
    }
    if (command.name() == null || command.name().isBlank()) {
      return UseCaseSupport.invalid("name", "must not be blank");
    }
    if (command.repositoryPath() == null || !command.repositoryPath().isAbsolute()) {
      return UseCaseSupport.invalid("repositoryPath", "must be an absolute path");
    }

    return support.unitOfWork.transact(
        transaction -> {
          ProjectRepository projects = transaction.projects();
          UUID projectId = support.newId();
          if (projects.findById(projectId).isPresent()) {
            return ApplicationResult.failure(
                new ApplicationError.Conflict("project", projectId, "id already exists"));
          }

          Instant now = support.clock.instant();
          Project project;
          try {
            project = new Project(projectId, command.name(), command.repositoryPath(), now);
          } catch (IllegalArgumentException exception) {
            return UseCaseSupport.invalid("project", exception.getMessage());
          }
          projects.save(project);
          transaction.appendEvent(
              support.event(
                  project.id(),
                  null,
                  project.id(),
                  0,
                  now,
                  "project.created",
                  Map.of("name", project.name())));
          return ApplicationResult.success(project);
        });
  }

  ApplicationResult<Project> get(UUID projectId) {
    if (projectId == null) {
      return UseCaseSupport.invalid("projectId", "must not be null");
    }
    return support.unitOfWork.transact(
        transaction ->
            transaction
                .projects()
                .findById(projectId)
                .<ApplicationResult<Project>>map(ApplicationResult::success)
                .orElseGet(
                    () ->
                        ApplicationResult.failure(
                            new ApplicationError.NotFound("project", projectId))));
  }
}
