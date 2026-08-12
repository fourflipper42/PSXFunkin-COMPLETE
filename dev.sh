#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE="psxfunkin-complete-dev:local"

if command -v podman >/dev/null 2>&1; then
    ENGINE=podman
elif command -v docker >/dev/null 2>&1; then
    ENGINE=docker
else
    echo "Need Podman or Docker. If you want a native build, use ./setup.sh instead."
    exit 1
fi

if ! "$ENGINE" image inspect "$IMAGE" >/dev/null 2>&1; then
    echo "Building the dev container..."
    "$ENGINE" build -f "$ROOT/Containerfile" -t "$IMAGE" "$ROOT"
fi

if [[ $# -eq 0 || "${1:-}" == "bash" || "${1:-}" == "shell" ]]; then
    set -- bash
elif [[ "$1" != /* && "$1" != ./* ]]; then
    set -- "./$1.sh" "${@:2}"
fi

if [[ "$ENGINE" == podman ]]; then
    exec podman run --rm -it \
        --userns=keep-id \
        -e HOME=/tmp \
        -v "$ROOT:/work:Z" \
        -w /work \
        "$IMAGE" "$@"
else
    exec docker run --rm -it \
        --user "$(id -u):$(id -g)" \
        -e HOME=/tmp \
        -v "$ROOT:/work" \
        -w /work \
        "$IMAGE" "$@"
fi
