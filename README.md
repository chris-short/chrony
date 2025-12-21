# Chrony Container

A minimal, secure container image for running [chrony](https://chrony-project.org/) NTP server/client.

## Image

```
ghcr.io/chris-short/chrony:latest
```

## Security

### Container Hardening

- **~5MB image**: Alpine Linux with only `chrony` package installed
- **Non-root runtime**: Drops to `chrony` user immediately after binding port 123
- **Weekly rebuilds**: Automated builds every Sunday pull the latest Alpine base image with security patches
- **Multi-architecture**: Native builds for `linux/amd64` and `linux/arm64`

### Recommended Runtime Settings

| Setting | Purpose |
|---------|---------|
| `cap_drop: ALL` | Drop all Linux capabilities |
| `cap_add: SYS_TIME` | Add back only what chrony needs |
| `read_only: true` | Immutable root filesystem |
| `no-new-privileges: true` | Prevent privilege escalation |

### Reporting Security Issues

Report security vulnerabilities to: security@chrisshort.net

## Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent build from main branch |
| `YYYYMMDD` | Date-stamped builds |
| `<sha>` | Git commit SHA |

## License

MIT
