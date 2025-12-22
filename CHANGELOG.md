# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Default chrony configuration file (`chrony.conf`) with sensible NTP settings
- Docker Compose example with security best practices
- Kubernetes DaemonSet manifest for cluster-wide time synchronization
- Kubernetes Deployment manifest for single-instance deployments
- Comprehensive usage examples:
  - Custom NTP servers configuration
  - Running as NTP server
  - Kubernetes deployment with persistent volumes
- Test script for container validation
- Volume declarations for persistent drift data
- Health checks (liveness and readiness probes) for Kubernetes
- Detailed troubleshooting guide in README

### Changed
- Dockerfile now creates required directories (`/var/lib/chrony`, `/run/chrony`, `/var/log/chrony`)
- Container runs as non-root `chrony` user (UID 100)
- Changed from `ENTRYPOINT` to `CMD` for better flexibility
- Exposed both UDP port 123 (NTP) and 323 (chrony command)
- Enhanced README with Quick Start guides and comprehensive documentation
- Updated `.dockerignore` to include chrony.conf

### Security
- Enforced read-only root filesystem capability
- Minimal Linux capabilities (SYS_TIME only)
- No privilege escalation allowed
- Proper directory permissions for chrony user
- Security context configurations in Kubernetes manifests

## [1.0.0] - Previous Release
- Initial Alpine-based chrony container
- Multi-architecture support (amd64, arm64)
- Weekly automated builds
