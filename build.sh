#!/usr/bin/env bash
# build.sh - convenience script to build the Docker image for different platforms
# Usage: ./build.sh [aarch64|armv7] [--buildx]

set -euo pipefail

# Support -h/--help
if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  cat <<EOF
Usage: $0 [ARCH] [--buildx] [TAG]

ARCH options (aliases supported):
  aarch64, arm64, rpi4-64    -> 64-bit Raspberry Pi 4 (default)
  armv7, rpi3               -> 32-bit Raspberry Pi / linux/arm/v7
  amd64                     -> x86_64 (not recommended for runtime)

Examples:
  $0 aarch64
  $0 armv7 --buildx myrepo/monero:armv7

Environment overrides:
  BASE_BUILD_IMAGE_OVERRIDE, BASE_RUN_IMAGE_OVERRIDE

EOF
  exit 0
fi

ARCH=${1:-aarch64}
USE_BUILDX=false
if [ "${2:-}" = "--buildx" ]; then
  USE_BUILDX=true
fi
# Optional 3rd arg: tag override
TAG=${3:-"monero-balena:${ARCH}"}

case "$ARCH" in
  aarch64|arm64|rpi4-64)
    BASE_BUILD_IMAGE="balenalib/aarch64-debian:bookworm-build"
    BASE_RUN_IMAGE="balenalib/aarch64-debian:bookworm-run"
    DEVICE_TYPE="raspberrypi4-64"
    PLATFORM="linux/arm64"
    ;;
  armv7|rpi3)
    BASE_BUILD_IMAGE="balenalib/raspberrypi3-debian:bookworm-build"
    BASE_RUN_IMAGE="balenalib/raspberrypi3-debian:bookworm-run"
    DEVICE_TYPE="raspberrypi3"
    PLATFORM="linux/arm/v7"
    ;;
  amd64)
    # For completeness: build base images for x86_64 (mostly useful for testing/build hosts)
    BASE_BUILD_IMAGE="debian:bookworm"
    BASE_RUN_IMAGE="debian:bookworm"
    DEVICE_TYPE="generic-amd64"
    PLATFORM="linux/amd64"
    ;;
  *)
    echo "Unknown arch: $ARCH" >&2
    exit 2
    ;;
esac

# Allow overriding base images via env variables (useful for custom tags)
BASE_BUILD_IMAGE=${BASE_BUILD_IMAGE_OVERRIDE:-${BASE_BUILD_IMAGE}}
BASE_RUN_IMAGE=${BASE_RUN_IMAGE_OVERRIDE:-${BASE_RUN_IMAGE}}

if [ "$USE_BUILDX" = true ]; then
  # Ensure builder exists
  docker buildx create --use --name monero-builder || true
  # Register qemu if not already present (harmless if already installed)
  docker run --rm --privileged tonistiigi/binfmt --install all || true

  docker buildx build --platform ${PLATFORM} \
    --build-arg BASE_BUILD_IMAGE=${BASE_BUILD_IMAGE} \
    --build-arg BASE_RUN_IMAGE=${BASE_RUN_IMAGE} \
    --build-arg DEVICE_TYPE=${DEVICE_TYPE} \
    -t ${TAG} --load .
else
  docker build \
    --build-arg BASE_BUILD_IMAGE=${BASE_BUILD_IMAGE} \
    --build-arg BASE_RUN_IMAGE=${BASE_RUN_IMAGE} \
    --build-arg DEVICE_TYPE=${DEVICE_TYPE} \
    -t ${TAG} .
fi

echo "Built ${TAG}"