package dev.ori.core.workspace.billing;

public record BudgetData(long limit, long reserved, long spent, boolean usageUnknown) {}
