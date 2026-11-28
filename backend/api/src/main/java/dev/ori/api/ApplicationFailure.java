package dev.ori.api;

import dev.ori.application.ApplicationError;

final class ApplicationFailure extends RuntimeException {
  private final ApplicationError error;

  ApplicationFailure(ApplicationError error) {
    this.error = error;
  }

  ApplicationError error() {
    return error;
  }
}
