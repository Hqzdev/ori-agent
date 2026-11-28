package dev.ori.core.agent;

public enum AgentSessionStatus {
  CREATED,
  RUNNING,
  WAITING_FOR_USER,
  PAUSED,
  COMPLETED,
  FAILED,
  CANCELLED
}
