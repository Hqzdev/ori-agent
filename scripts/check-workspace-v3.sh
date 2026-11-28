#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
work_dir="$PWD/.build/workspace-v3-check"
mkdir -p "$work_dir"
# Use Xcode's actual package modules and resource accessors; OriDesign has bundled assets.
./script/build_and_run.sh --build-only > "$work_dir/build.log" 2>&1
products="$PWD/.build/xcode/Build/Products/Debug"
ditto "$products/OriDesign_OriDesign.bundle" "$work_dir/OriDesign_OriDesign.bundle"
sources=()
while IFS= read -r -d '' source; do sources+=("$source"); done < <(find apps/macos/OriMac apps/shared -name '*.swift' ! -name 'OriMacApp.swift' ! -name 'ContentView.swift' -print0)
swiftc -module-cache-path "$work_dir/cache" -parse-as-library -whole-module-optimization -swift-version 5 -default-isolation MainActor -D DEBUG \
    -I "$products" -I packages/OriWorkspace/Sources/CSQLite \
    "$products/OriDomain.o" "$products/OriAPI.o" "$products/OriDesign.o" "$products/OriWorkspace.o" "$products/OriAppleIntegrations.o" -lsqlite3 \
    "${sources[@]}" scripts/verify-workspace-v3.swift -o "$work_dir/verify"
"$work_dir/verify" "$@"
