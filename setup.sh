#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

# One place owns the exact upstream/tool revisions.
# shellcheck disable=SC1091
source "$ROOT/build-lock.env"

PSYQ_ZIP=""
RESET=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --psyq-zip) shift; PSYQ_ZIP="${1:-}" ;;
        --reset) RESET=1 ;;
        -h|--help)
            cat <<'EOF'
Usage: ./setup.sh [--psyq-zip FILE] [--reset]

--psyq-zip   use a legally obtained compatible converted PsyQ archive
--reset      throw away downloaded/generated setup trees and start again
EOF
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 2 ;;
    esac
    shift
done

need=(git git-lfs curl python3 ffmpeg ffprobe meson cmake ninja make unzip sha256sum)
missing=()
for cmd in "${need[@]}"; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
done
if (( ${#missing[@]} )); then
    echo "Missing build tools: ${missing[*]}"
    echo "Use ./dev.sh setup on Linux to get the known-good Ubuntu tool set."
    exit 1
fi

if (( RESET )); then
    rm -rf upstream official-v084 official-assets psx-week-reference .deps/funkin-assets .deps/psxavenc .deps/mkpsxiso .deps/psyq .deps/psyq-extract build out
fi

mkdir -p .deps .deps/bin official-assets build out

git lfs install --skip-repo >/dev/null

clone_exact() {
    local url="$1" sha="$2" dir="$3"
    if [[ ! -d "$dir/.git" ]]; then
        echo "Fetching $dir..."
        git clone "$url" "$dir"
    fi
    git -C "$dir" fetch --tags --force origin
    git -C "$dir" checkout --detach "$sha"
}

clone_exact https://github.com/cuckydev/PSXFunkin.git "$PSXFUNKIN_COMMIT" upstream
clone_exact https://github.com/Nintendo-Bro385/PSXFunkin-Flop-Engine.git "$WEEK_REFERENCE_COMMIT" psx-week-reference
clone_exact https://github.com/FunkinCrew/funkin.assets.git "$FUNKIN_ASSETS_COMMIT" .deps/funkin-assets
git -C .deps/funkin-assets lfs pull

LINUX_ZIP=official-assets/funkin-linux-64bit.zip
if [[ ! -s "$LINUX_ZIP" ]]; then
    echo "Fetching official Funkin $FUNKIN_LINUX_TAG Linux build..."
    curl -fL --retry 3 --retry-delay 2 "$FUNKIN_LINUX_URL" -o "$LINUX_ZIP"
fi
echo "$FUNKIN_LINUX_SHA256  $LINUX_ZIP" | sha256sum -c -
python3 tools/prepare_assets.py \
    --asset-repo .deps/funkin-assets \
    --linux-zip "$LINUX_ZIP" \
    --out official-v084

clone_exact https://github.com/WonderfulToolchain/psxavenc.git "$PSXAVENC_COMMIT" .deps/psxavenc
if [[ -f .deps/psxavenc/build/meson-private/coredata.dat ]]; then
    meson setup .deps/psxavenc/build .deps/psxavenc --buildtype=release --wipe
else
    meson setup .deps/psxavenc/build .deps/psxavenc --buildtype=release
fi
meson compile -C .deps/psxavenc/build
test -x .deps/psxavenc/build/psxavenc

clone_exact https://github.com/CookiePLMonster/mkpsxiso.git "$MKPSXISO_COMMIT" .deps/mkpsxiso
git -C .deps/mkpsxiso submodule update --init --recursive
cmake -S .deps/mkpsxiso -B .deps/mkpsxiso/build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build .deps/mkpsxiso/build
MKPSXISO="$(find .deps/mkpsxiso/build -type f -name mkpsxiso -perm -111 -print -quit)"
if [[ -z "$MKPSXISO" ]]; then
    echo "mkpsxiso built, but I couldn't find the executable."
    exit 1
fi
ln -sf "$(realpath --relative-to=.deps/bin "$MKPSXISO")" .deps/bin/mkpsxiso

if [[ -n "$PSYQ_ZIP" ]]; then
    if [[ ! -f "$PSYQ_ZIP" ]]; then
        echo "PsyQ archive not found: $PSYQ_ZIP"
        exit 1
    fi
    rm -rf .deps/psyq .deps/psyq-extract
    mkdir -p .deps/psyq .deps/psyq-extract
    unzip -q "$PSYQ_ZIP" -d .deps/psyq-extract
    INC="$(find .deps/psyq-extract -type d -name include -print -quit)"
    LIB="$(find .deps/psyq-extract -type d -name lib -print -quit)"
    if [[ -z "$INC" || -z "$LIB" ]]; then
        echo "Could not find PsyQ include/lib directories in $PSYQ_ZIP"
        exit 1
    fi
    cp -a "$INC" .deps/psyq/include
    cp -a "$LIB" .deps/psyq/lib
fi

cat <<'EOF'

Setup finished.

Next:
  ./build.sh

The project does not distribute PsyQ. If .deps/psyq is missing, rerun setup with
--psyq-zip and a compatible archive you are allowed to use.
EOF
