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

# Function to detect protocol support
detect_protocol() {
    if curl -fsI --connect-timeout 5 https://packages.tol-project.org >/dev/null 2>&1; then
        echo "https"
    else
        echo "http"
    fi
}

# Allow protocol override via environment variable, otherwise auto-detect
BASE_PROTO="${TOL_FORCE_PROTO:-$(detect_protocol)}"
[ -n "${VERBOSE:-}" ] && echo "Using ${BASE_PROTO^^} protocol for package downloads"
BASE_URL="${BASE_PROTO}://packages.tol-project.org/OfficialTolArchiveNetwork/repository.php"

fetch_pkg() {
    local pkg="$1"
    local url="${BASE_URL}?action=download&format=attachment&tol_package_version=4&package=$pkg"
    [ -n "${VERBOSE:-}" ] && echo "Attempting to download $pkg from $url"
    if ! wget --tries=3 --content-disposition "$url"; then
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
