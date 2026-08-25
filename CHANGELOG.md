# Changelog

All notable changes to this project are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Nothing yet.

### Changed

- Nothing yet.

### Fixed

- Nothing yet.

## [v0.0.1] - 2026-08-25

### Added

- Balena application for running an XMRig Monero miner on Raspberry Pi devices.
- Configurable Docker base images, device types, and architecture-specific builds.
- Native and Buildx build convenience script for aarch64, ARMv7, and amd64.
- GitHub Actions workflow for ARM64 and ARMv7 container build verification.
- Automated stable-tag GitHub releases followed by Balena fleet deployment.

### Changed

- Updated Raspberry Pi build and runtime images for 64-bit and ARMv7 targets.
- Documented Balena deployment, miner configuration, local builds, and supported architectures.
- Improved XMRig startup defaults, argument quoting, and donation-level configuration.

### Fixed

- Corrected wallet, pool, password, and device-name handling in the runtime entrypoint.
- Corrected ARMv7 base-image and device-type mappings used by builds and CI.
- Added repository guidance, release automation, and local-tooling ignore rules.

## Links

[unreleased]: https://github.com/cniweb/monero-balena/compare/v0.0.1...HEAD

[v0.0.1]: https://github.com/cniweb/monero-balena/releases/tag/v0.0.1
