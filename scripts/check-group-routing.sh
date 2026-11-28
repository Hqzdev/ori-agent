#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
products="${1:-$PWD/.build/xcode/Build/Products/Debug}"
verification="${2:-scripts/verify-group-routing.swift}"
checks="$PWD/.build/$(basename "$verification" .swift)"
mkdir -p "$checks/cache"
sources=(WorkspaceService WorkspaceForms WorkspacePersonalization WorkspaceMessageContext WorkspaceSnapshot WorkspaceApplicationInterfaces WorkspaceMessagePinProviding WorkspaceAccountApplicationService WorkspaceAccountProfileActions WorkspaceAccountSynchronizing WorkspaceModelCredentials WorkspaceBrowserAuthenticator LocalWorkspaceService WorkspaceScheduleHost WorkspaceSkillCommands WorkspaceSkillToolCatalog WorkspaceFileCommands WorkspaceDeviceCommands WorkspaceGroupResponder WorkspaceGroupBudget WorkspaceExportFormat WorkspaceMCPProviding)
sources+=(WorkspaceDevicePairingCommands WorkspaceNativeProviding WorkspaceBrowserProviding WorkspaceSessionFileProviding)
arguments=()
for source in "${sources[@]}"; do arguments+=("apps/shared/WorkspaceV3/$source.swift"); done
objects=("$products/OriDomain.o" "$products/OriWorkspace.o")
if [[ -f "$products/OriAppleIntegrations.o" && -f apps/shared/WorkspaceV3/WorkspaceAppleIntegrationProviding.swift ]]; then
    objects+=("$products/OriAppleIntegrations.o")
    arguments+=(apps/shared/WorkspaceV3/WorkspaceAppleIntegrationProviding.swift)
fi
xcrun swiftc -parse-as-library -swift-version 5 -default-isolation MainActor -module-cache-path "$checks/cache" \
    -I "$products" -I packages/OriWorkspace/Sources/CSQLite "${objects[@]}" -lsqlite3 \
    "${arguments[@]}" "$verification" -o "$checks/verify"
"$checks/verify"
