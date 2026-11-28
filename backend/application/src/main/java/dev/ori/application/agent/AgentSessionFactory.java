package dev.ori.application.agent;

import dev.ori.core.agent.AgentCapability;
import dev.ori.core.agent.AgentCapabilityPolicy;
import dev.ori.core.agent.AgentInstructionRevision;
import dev.ori.core.agent.AgentProfile;
import dev.ori.core.agent.AgentSession;
import dev.ori.core.agent.AgentSessionStatus;
import java.time.Clock;
import java.time.Instant;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;
import java.util.function.Supplier;

/** Creates immutable session snapshots from trusted project and permission policy data. */
public final class AgentSessionFactory {
  private final AgentCapabilityPolicy capabilityPolicy;
  private final Clock clock;
  private final Supplier<UUID> idGenerator;

  public AgentSessionFactory(
      AgentCapabilityPolicy capabilityPolicy, Clock clock, Supplier<UUID> idGenerator) {
    this.capabilityPolicy = Objects.requireNonNull(capabilityPolicy, "capabilityPolicy");
    this.clock = Objects.requireNonNull(clock, "clock");
    this.idGenerator = Objects.requireNonNull(idGenerator, "idGenerator");
  }

  public AgentSession create(
      UUID projectId,
      UUID runId,
      AgentProfile profile,
      AgentInstructionRevision instruction,
      Set<AgentCapability> projectCapabilities,
      Set<AgentCapability> activePermissionCapabilities) {
    Objects.requireNonNull(projectId, "projectId");
    Objects.requireNonNull(runId, "runId");
    Objects.requireNonNull(profile, "profile");
    Objects.requireNonNull(instruction, "instruction");
    Objects.requireNonNull(projectCapabilities, "projectCapabilities");
    Objects.requireNonNull(activePermissionCapabilities, "activePermissionCapabilities");

    if (!profile.enabled()) {
      throw new IllegalArgumentException("Cannot create a session for a disabled profile");
    }
    if (profile.role() != instruction.role()
        || !profile.instructionKey().equals(instruction.key())
        || profile.instructionRevision() != instruction.revision()) {
      throw new IllegalArgumentException("Instruction revision does not match the profile");
    }

    Set<AgentCapability> grantedCapabilities =
        capabilityPolicy.effectiveCapabilities(
            profile, projectCapabilities, activePermissionCapabilities);
    Instant now = clock.instant();
    return new AgentSession(
        Objects.requireNonNull(idGenerator.get(), "generated session id"),
        projectId,
        runId,
        profile.id(),
        profile.version(),
        instruction.key(),
        instruction.revision(),
        grantedCapabilities,
        AgentSessionStatus.CREATED,
        now,
        now,
        0);
  }
}
