package dev.ori.core.workspace.agent;

import java.util.UUID;

public record AssignmentData(UUID taskId, UUID sessionId, String role, String reason) {}
