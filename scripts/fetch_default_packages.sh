#!/bin/bash
set -euo pipefail

# Fetch default TOL packages (StdLib and TclCore).
# The script now prefers HTTPS when contacting packages.tol-project.org.
# If the server does not support HTTPS or the download fails, it falls back
# to querying the Internet Archive Wayback API for the most recent snapshot.

DEST="${1:-/usr/local/tol3.2-release/bin/stdlib/DefaultPackages}"
mkdir -p "$DEST"
cd "$DEST"

if [[ "$(uname -m)" == "x86_64" ]]; then
    TOL_PLATFORM="Linux64GNU"
else
    TOL_PLATFORM="Linux32GNU"
fi

# Determine whether the package server supports HTTPS. If the probe fails,
# continue with plain HTTP.
if curl -fsI https://packages.tol-project.org >/dev/null 2>&1; then
    BASE_PROTO="https"
else
    BASE_PROTO="http"
fi
BASE_URL="${BASE_PROTO}://packages.tol-project.org/OfficialTolArchiveNetwork/repository.php"

fetch_pkg() {
    local pkg="$1"
    local url="${BASE_URL}?action=download&format=attachment&tol_package_version=4&package=$pkg"
    if ! wget --content-disposition "$url"; then
        echo "Failed to fetch $pkg from official repository. Searching Wayback..."
        api_url="https://archive.org/wayback/available?url=$url"
        snapshot=$(curl -fsSL "$api_url" | grep -o '"url":"[^"]*"' | head -n1 | cut -d'"' -f4)
        if [ -n "$snapshot" ]; then
            wget --content-disposition "$snapshot"
        else
            echo "No Wayback snapshot found for $pkg" >&2
        fi
    fi
}

fetch_pkg "StdLib"
fetch_pkg "TclCore%23${TOL_PLATFORM}"

echo "Packages downloaded to $DEST"
