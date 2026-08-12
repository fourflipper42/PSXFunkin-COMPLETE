#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

PSXFUNKIN_COMMIT=850e0207479d8fb658bdc7637f6bfbc28a2b4066
FUNKIN_ASSETS_COMMIT=d1d027d4747aaba151c6df121ea736c31d6aed38
WEEK_REFERENCE_COMMIT=b3f4c5ff0f7656af8ed17498de6b6d7b7a8d967e
FUNKIN_LINUX_SHA=50eb30c89de03a6ef34431bb75930219b897aebb59e456a169247d8b0a414321
FUNKIN_LINUX_URL=https://github.com/FunkinCrew/Funkin/releases/download/v0.8.4/funkin-linux-64bit.zip
PSYQ_URL=http://psx.arthus.net/sdk/Psy-Q/psyq-4_7-converted-light.zip

FETCH_PSYQ=0
PSYQ_ZIP=""
RESET=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --fetch-psyq) FETCH_PSYQ=1 ;;
        --psyq-zip) shift; PSYQ_ZIP="${1:-}" ;;
        --reset) RESET=1 ;;
        -h|--help)
            cat <<'EOF'
Usage: ./setup.sh [--fetch-psyq | --psyq-zip FILE] [--reset]

--fetch-psyq   fetch the converted PsyQ archive used by the existing toolchain
--psyq-zip     use a local converted PsyQ archive
--reset        throw away downloaded/generated setup trees and start again
EOF
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 2 ;;
    esac
    shift
done

need=(git git-lfs curl python3 ffmpeg ffprobe meson cmake ninja make)
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
    rm -rf upstream official-v084 official-assets psx-week-reference .deps build out
fi

mkdir -p .deps .deps/bin official-assets build out

git lfs install --skip-repo >/dev/null

clone_exact() {
    local url="$1" sha="$2" dir="$3"
    if [[ ! -d "$dir/.git" ]]; then
        echo "Fetching $dir..."
        git clone "$url" "$dir"
    fi
    git -C "$dir" fetch --tags origin
    git -C "$dir" checkout --detach "$sha"
}

clone_exact https://github.com/cuckydev/PSXFunkin.git "$PSXFUNKIN_COMMIT" upstream
clone_exact https://github.com/Nintendo-Bro385/PSXFunkin-Flop-Engine.git "$WEEK_REFERENCE_COMMIT" psx-week-reference
clone_exact https://github.com/FunkinCrew/funkin.assets.git "$FUNKIN_ASSETS_COMMIT" .deps/funkin-assets
git -C .deps/funkin-assets lfs pull

LINUX_ZIP=official-assets/funkin-linux-64bit.zip
if [[ ! -s "$LINUX_ZIP" ]]; then
    echo "Fetching official Funkin v0.8.4 Linux build..."
    curl -fL --retry 3 --retry-delay 2 "$FUNKIN_LINUX_URL" -o "$LINUX_ZIP"
fi
echo "$FUNKIN_LINUX_SHA  $LINUX_ZIP" | sha256sum -c -
python3 tools/prepare_assets.py \
    --asset-repo .deps/funkin-assets \
    --linux-zip "$LINUX_ZIP" \
    --out official-v084

if [[ ! -d .deps/psxavenc/.git ]]; then
    git clone https://github.com/WonderfulToolchain/psxavenc.git .deps/psxavenc
fi
if [[ -f .deps/psxavenc/build/meson-private/coredata.dat ]]; then
    meson setup .deps/psxavenc/build .deps/psxavenc --buildtype=release --wipe
else
    meson setup .deps/psxavenc/build .deps/psxavenc --buildtype=release
fi
meson compile -C .deps/psxavenc/build

test -x .deps/psxavenc/build/psxavenc

if [[ ! -d .deps/mkpsxiso/.git ]]; then
    git clone --recursive https://github.com/CookiePLMonster/mkpsxiso.git .deps/mkpsxiso
fi
git -C .deps/mkpsxiso submodule update --init --recursive
cmake -S .deps/mkpsxiso -B .deps/mkpsxiso/build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build .deps/mkpsxiso/build
MKPSXISO="$(find .deps/mkpsxiso/build -type f -name mkpsxiso -perm -111 -print -quit)"
if [[ -z "$MKPSXISO" ]]; then
    echo "mkpsxiso built, but I couldn't find the executable."
    exit 1
fi
ln -sf "$(realpath --relative-to=.deps/bin "$MKPSXISO")" .deps/bin/mkpsxiso

if [[ -n "$PSYQ_ZIP" || "$FETCH_PSYQ" == 1 ]]; then
    if [[ -z "$PSYQ_ZIP" ]]; then
        PSYQ_ZIP=.deps/psyq.zip
        echo "Fetching converted PsyQ compatibility archive..."
        curl -fL --retry 3 --retry-delay 2 "$PSYQ_URL" -o "$PSYQ_ZIP"
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

If the build complains about PsyQ, rerun setup with --psyq-zip FILE or --fetch-psyq.
EOF
