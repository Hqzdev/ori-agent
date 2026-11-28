#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
bundle="${1:?Pass the app bundle}"
products="${2:?Pass Xcode built products}"
service="$bundle/Contents/XPCServices/OriWorkspaceExecutor.xpc"
cache="$(dirname "$bundle")/NativeExecutorCache"
mkdir -p "$service/Contents/MacOS" "$cache"
xcrun swiftc -O -swift-version 6 -module-cache-path "$cache" \
    -I "$products" -I packages/OriWorkspace/Sources/CSQLite \
    "$products/OriDomain.o" "$products/OriWorkspace.o" -lsqlite3 native/WorkspaceExecutor/main.swift \
    -o "$service/Contents/MacOS/OriWorkspaceExecutor"
cp native/WorkspaceExecutor/Info.plist "$service/Contents/Info.plist"
set -- --identifier dev.blot.workspace-executor
if [ "${CONFIGURATION:-Release}" = Debug ]; then
    set -- "$@" --entitlements native/WorkspaceExecutor/Debug.entitlements
fi
scripts/sign-native.sh "$@" "$service"
