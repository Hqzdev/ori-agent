package dev.ori.api;

import dev.ori.application.ports.WorkspaceStore;
import java.util.Map;
import org.springframework.web.bind.annotation.*;

@RestController
public final class OriController {
  private final WorkspaceStore store;

  public OriController(WorkspaceStore store) {
    this.store = store;
  }

  @GetMapping("/health")
  public Object health() {
    return Map.of("status", "UP");
  }

  @GetMapping("/ready")
  public Object ready() {
    store.transact(tx -> null);
    return Map.of("status", "UP", "schemaVersion", 2);
  }
}
