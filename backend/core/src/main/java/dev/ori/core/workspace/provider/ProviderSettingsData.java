package dev.ori.core.workspace.provider;

public record ProviderSettingsData(
    String model, int contextTokens, int outputTokens, long runTokenBudget) {}
