Monero-Miner for Single board computers like Raspberry Pi, powered by [balena](https://balena.io)

![](https://raw.githubusercontent.com/cniweb/monero-balena/master/assets/logo.png)

## Introduction
Support Monero blockchain, validating the transactions by lending your compute power from SBCs like a Raspberry Pi and earn XMRs (cryptocurrency of Monero blockchain) in return.

--------------------
## Hardware required

- A Raspberry Pi 4 (the more RAM it has the better) -- currently tested to work
- 16GB Micro-SD Card (recommended Sandisk Extreme Pro SD cards)
- Power supply for the Pi

--------------------
## Software required

- Monero Wallet to receive the XMR rewards, download from [here](http://getmonero.org/downloads/#gui)

--------------------
## Deploy a fleet

You can deploy this app to a new balenaCloud fleet in one click using the button below:

[![deploy button](https://balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/cniweb/monero-balena)


Or, you can create a fleet in your balenaCloud dashboard, clone this repo and `balena push` this code to it, the traditional way.

--------------------

#### Configuring the miner

The following [Device Configuration](https://www.balena.io/docs/learn/manage/configuration/#configuration-variables) variables are required, these can be set at balenaCloud dashboard :


| Name                                  | Value                                                                                     |
| ------------------------------------- | ----------------------------------------------------------------------------------------- |
| WALLET_ADDRESS                        | Change this to your monero wallet address which you install and set
| MINER_POOL                            | (Optional) Change this to the mining pool you want to join
| PASSWORD                              | (Optional) Change this to yor pool password  

--------------------

Attribution

- [XMRig project](https://github.com/xmrig)

## Building locally (arch-specific notes)

If you want to build the Docker image locally (outside of balenaCloud), here are a few helpful examples. The repository's `Dockerfile.template` accepts build arguments so you can select appropriate base images for your target device.

1) Default (aarch64 / raspberrypi4-64)

```bash
docker build -t monero-balena:latest .
```

2) Armv7 (32-bit Raspberry Pi / linux/arm/v7)

```bash
docker build \
	--build-arg BASE_BUILD_IMAGE=balenalib/raspberrypi-debian:bookworm-build \
	--build-arg BASE_RUN_IMAGE=balenalib/raspberrypi-debian:bookworm-run \
	--build-arg DEVICE_TYPE=raspberrypi \
	-t monero-balena:armv7 .
```

3) Cross-build on x86 with buildx + QEMU

```bash
docker buildx create --use --name mybuilder || true
docker run --rm --privileged tonistiigi/binfmt --install all
docker buildx build --platform linux/arm/v7 \
	--build-arg BASE_BUILD_IMAGE=balenalib/raspberrypi-debian:bookworm-build \
	--build-arg BASE_RUN_IMAGE=balenalib/raspberrypi-debian:bookworm-run \
	--build-arg DEVICE_TYPE=raspberrypi \
	-t monero-balena:armv7 --load .
```

Replace the `BASE_*` arguments with the exact balena base images for your device if necessary.

### Supported ARCH aliases

The `build.sh` script and examples in this README accept several aliases for convenience:

| Alias(es) | Meaning | Recommended BASE_BUILD_IMAGE | Recommended BASE_RUN_IMAGE | Recommended DEVICE_TYPE |
| --- | --- | --- | --- | --- |
| `aarch64`, `arm64`, `rpi4-64` | 64-bit Raspberry Pi 4 (64-bit runtime) | `balenalib/aarch64-debian:bookworm-build` | `balenalib/aarch64-debian:bookworm-run` | `raspberrypi4-64` |
| `armv7`, `rpi3` | 32-bit Raspberry Pi (arm/v7 runtime) | `balenalib/raspberrypi-debian:bookworm-build` | `balenalib/raspberrypi-debian:bookworm-run` | `raspberrypi` |
| `amd64` | x86_64 (for local testing/build hosts) | `debian:bookworm` | `debian:bookworm` | `generic-amd64` |

Use the alias instead of the full arch name when calling `build.sh` or `docker build`.

### Convenience script

You can also use the included `build.sh` to simplify builds. Examples:

```bash
# Build native aarch64 (default)
./build.sh aarch64

# Build armv7 using buildx (cross-build on x86)
./build.sh armv7 --buildx
```

#### Overrides

You can override the generated tag (3rd argument) or force different base images via environment variables:

```bash
# Custom tag
./build.sh armv7 --buildx myrepo/monero-balena:custom-tag

# Override base images (useful for private/base image forks or pinned tags)
BASE_BUILD_IMAGE_OVERRIDE=myregistry/mybase:tag \
BASE_RUN_IMAGE_OVERRIDE=myregistry/myrun:tag \
./build.sh armv7 --buildx myrepo/monero-balena:custom-tag
```