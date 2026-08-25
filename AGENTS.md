# Repository Instructions

## Scope and Layout

- This repository builds a Balena/Docker image containing a compiled XMRig binary for Raspberry Pi targets.
- The source Dockerfile is `Dockerfile.template`, not `Dockerfile`; direct Docker commands must pass `-f Dockerfile.template` unless a generated Dockerfile is intentionally created.
- `build.sh` wraps native and Buildx builds; `start.sh` assembles runtime arguments from environment variables; `balena.yml` targets `raspberrypi4-64`.
- CI builds `linux/arm/v7` and `linux/arm64` images with Docker Buildx and QEMU. It does not start the image or validate mining behavior.

## Commands

```bash
docker build -f Dockerfile.template -t monero-balena:test .
docker run --rm --entrypoint xmrig monero-balena:test --version
./build.sh aarch64
./build.sh armv7 --buildx
balena push <fleet>
```

- Use the architecture and base-image mappings in `build.sh` as the executable source of truth. README and CI currently use different Raspberry Pi image/device aliases; verify all three before changing one.
- Cross-builds require Docker Buildx, QEMU/binfmt support, and network access.
- There is no source-level unit-test or lint suite; image construction and the explicit binary smoke test are the meaningful local checks.

## Runtime and Reproducibility

- Runtime variables are `WALLET_ADDRESS`, `MINER_POOL`, `PASSWORD`, and `RESIN_DEVICE_NAME_AT_INIT`.
- The current scripts contain placeholder/default wallet values and print wallet/pool/password-related values. Never add or retain secret-bearing logs in production behavior.
- XMRig is cloned from an unpinned source branch, so builds are not reproducible. Pin a revision and verify checksums/signatures before treating an image as release-grade.
- `build.sh` argument parsing and tag handling are fragile; inspect the script before changing invocation syntax.
- Distinguish local Docker testing from Balena deployment. Do not assume the default image is a safe offline run.
