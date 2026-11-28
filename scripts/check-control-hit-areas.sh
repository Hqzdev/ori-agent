#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
products="$PWD/.build/xcode/Build/Products/Debug"
app="$products/Ori.app/Contents"
check_dir="$PWD/.build/grok-hit-targets/ui"
[[ -f "$app/MacOS/Ori.debug.dylib" ]] || { echo 'Build OriMac Debug first.' >&2; exit 1; }
mkdir -p "$check_dir"
ditto "$products/OriDesign_OriDesign.bundle" "$check_dir/OriDesign_OriDesign.bundle"
swiftc -target "$(uname -m)-apple-macos26.0" -module-cache-path "$PWD/.build/xcode/ModuleCache.noindex" \
    -parse-as-library -swift-version 5 -default-isolation MainActor -enable-upcoming-feature MemberImportVisibility -D DEBUG \
    -I "$products" -I packages/OriWorkspace/Sources/CSQLite \
    scripts/verify-control-hit-areas.swift "$app/MacOS/Ori.debug.dylib" \
    -Xlinker -rpath -Xlinker "$app/MacOS" -o "$check_dir/verify"
"$check_dir/verify"
