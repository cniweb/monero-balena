# Repository Instructions

## Build Surface

- This is a Balena/Docker image project; `Dockerfile.template` is the source Dockerfile and there is no root `Dockerfile`. Direct Docker commands must use `-f Dockerfile.template`.
- `build.sh` selects base images, device labels, and platforms; inspect its `case` mapping before changing architecture aliases or tags. Its Docker invocations currently omit `-f Dockerfile.template`, so use the explicit Docker command below when building locally.
- `start.sh` is the runtime entrypoint and passes `WALLET_ADDRESS`, `MINER_POOL`, and `PASSWORD` to `xmrig`; `balena.yml` deploys `raspberrypi4-64` by default.

## Verification

```bash
docker build -f Dockerfile.template -t monero-balena:test .
docker run --rm --entrypoint xmrig monero-balena:test --version
./build.sh aarch64
./build.sh armv7 --buildx
balena push <fleet>
```

- Cross-builds require Docker Buildx, QEMU/binfmt, and network access.
- CI builds only `linux/arm/v7` and `linux/arm64` images with Buildx; it does not start the image or validate mining behavior. There is no source-level unit-test or lint suite.
- CI cross-builds typically take about 20 minutes per run; wait at least 20 minutes before treating an in-progress run as stalled, then inspect the final status.
- Keep the architecture mappings in `build.sh`, CI, and README aligned. They currently use different ARMv7 base-image/device aliases, so verify all three before changing one.

## Operational Risks

- Treat wallet, pool, and password values as secrets. `start.sh` currently supplies placeholder defaults and prints these values; do not add or retain secret-bearing logs in production behavior.
- XMRig is cloned from an unpinned Git branch in `Dockerfile.template`; pin a revision and verify checksums or signatures before calling an image release-grade.
- Separate local Docker smoke tests from Balena deployment; a successful image build does not prove mining or device runtime behavior.
