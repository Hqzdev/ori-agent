package dev.ori.application;

import dev.ori.core.Project;
import dev.ori.core.Run;
import dev.ori.core.RunStatus;
import dev.ori.core.SpecificationRevision;
import dev.ori.core.Task;
import java.nio.file.Path;
import java.time.Clock;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.function.Supplier;

/** Public application boundary delegating each aggregate workflow to its focused use cases. */
public final class OriApplicationService {
  private final ProjectUseCases projects;
  private final RunUseCases runs;
  private final SpecificationUseCases specifications;
  private final TaskUseCases tasks;

  public OriApplicationService(OriUnitOfWork unitOfWork, Clock clock, Supplier<UUID> idGenerator) {
    UseCaseSupport support = new UseCaseSupport(unitOfWork, clock, idGenerator);
    this.projects = new ProjectUseCases(support);
    this.runs = new RunUseCases(support);
    this.specifications = new SpecificationUseCases(support);
    this.tasks = new TaskUseCases(support);
  }

  public ApplicationResult<Project> createProject(CreateProject command) {
    return projects.create(command);
  }

  public ApplicationResult<Project> getProject(UUID projectId) {
    return projects.get(projectId);
  }

  public ApplicationResult<Run> createRun(CreateRun command) {
    return runs.create(command);
  }

  public ApplicationResult<Run> getRun(UUID runId) {
    return runs.get(runId);
  }

  public ApplicationResult<Run> changeRunStatus(ChangeRunStatus command) {
    return runs.changeStatus(command);
  }

  public ApplicationResult<List<SpecificationRevision>> getSpecificationHistory(UUID runId) {
    return specifications.history(runId);
  }

  public ApplicationResult<SpecificationRevision> addSpecificationRevision(
      AddSpecificationRevision command) {
    return specifications.add(command);
  }

  public ApplicationResult<List<Task>> getTasks(UUID runId) {
    return tasks.list(runId);
  }

  public ApplicationResult<Task> createTask(CreateTask command) {
    return tasks.create(command);
  }

  public record CreateProject(String name, Path repositoryPath) {}

  public record CreateRun(UUID projectId, String goal) {}

  public record ChangeRunStatus(UUID runId, long expectedVersion, RunStatus status) {}

  public record AddSpecificationRevision(UUID runId, String content) {}

  public record CreateTask(
      UUID projectId,
      UUID runId,
      String title,
      List<String> acceptanceCriteria,
      Set<UUID> dependencyIds) {}
}
