package dev.ori.application.workspace.conversation;

import dev.ori.application.ports.*;
import dev.ori.application.ports.WorkspaceStore;
import dev.ori.application.workspace.Records;
import dev.ori.application.workspace.WorkspaceFailure;
import dev.ori.application.workspace.identity.TokenGenerator;
import dev.ori.core.workspace.*;
import dev.ori.core.workspace.EntityKind;
import dev.ori.core.workspace.identity.Actor;
import dev.ori.core.workspace.identity.AuthSessionData;
import dev.ori.core.workspace.identity.DeviceData;
import java.time.*;
import java.util.*;

public final class SessionService {
  public record SessionToken(String token, Instant expiresAt) {}

  private final WorkspaceStore store;
  private final TokenGenerator tokens;
  private final Records records;
  private final Clock clock;

  public SessionService(WorkspaceStore store, TokenGenerator tokens, Records records, Clock clock) {
    this.store = store;
    this.tokens = tokens;
    this.records = records;
    this.clock = clock;
  }

  public SessionToken create(UUID account, UUID device, boolean remember) {
    String token = tokens.token();
    Instant until = clock.instant().plus(Duration.ofHours(remember ? 720 : 12));
    store.transact(
        tx -> {
          records.create(
              tx,
              EntityKind.AUTH_SESSION,
              account,
              null,
              null,
              new AuthSessionData(tokens.digest(token), device, until, false));
          return null;
        });
    return new SessionToken(token, until);
  }

  public Actor authenticate(String token, boolean local) {
    if (token == null || token.length() > 512) throw denied();
    String hash = tokens.digest(token);
    return store.transact(
        tx -> {
          var e =
              tx.authSession(hash).stream()
                  .filter(
                      s ->
                          s.data().tokenHash().equals(hash)
                              && !s.data().revoked()
                              && s.data().expiresAt().isAfter(clock.instant()))
                  .findFirst()
                  .orElseThrow(SessionService::denied);
          UUID device = e.data().deviceId();
          if (device != null
              && Records.require(tx, EntityKind.DEVICE, e.ownerId(), device, DeviceData.class)
                  .data()
                  .revoked()) throw denied();
          if (device == null && !local) throw denied();
          return new Actor(e.ownerId(), e.id(), device, local);
        });
  }

  public void logout(Actor actor) {
    store.transact(
        tx -> {
          tx.delete(EntityKind.AUTH_SESSION, actor.accountId(), actor.sessionId());
          return null;
        });
  }

  private static WorkspaceFailure denied() {
    return new WorkspaceFailure(401, "unauthenticated", "Требуется действующая сессия");
  }
}
