# Chrony Container

A minimal, configurable, secure container image for running [chrony](https://chrony-project.org/) NTP server/client, optimized for systems without a Real-Time Clock (RTC) such as Raspberry Pi.

## Image

```
ghcr.io/chris-short/chrony:latest
```

## Tested Platforms

This container has been tested and verified on:
- **macOS** (Docker Desktop / Podman)
- **Raspberry Pi 5** (arm64, no RTC)
- **x86_64 Linux**

## Features

- **RTC-free operation**: Optimized configuration for devices without hardware clocks
- **Fast sync on boot**: Uses `makestep` to quickly correct time after restart
- **Drift tracking**: Maintains accuracy across reboots via persistent drift file
- **External DNS**: Configured to use public DNS servers (1.1.1.1, 8.8.8.8) for reliable NTP server resolution
- **Custom NTP servers**: Includes local and public time sources for redundancy

## Quick Start

### Using Docker Compose

```bash
docker compose up -d
```

### Using Docker/Podman CLI

```bash
# Build the image
docker build -t chrony:latest .

# Run with minimal configuration
docker run -d --name chrony \
  --cap-add SYS_TIME \
  --dns 1.1.1.1 \
  --dns 8.8.8.8 \
  -p 123:123/udp \
  chrony:latest

# Run with persistent drift/logs
docker run -d --name chrony \
  -v chrony-data:/var/lib/chrony \
  -v chrony-logs:/var/log/chrony \
  --cap-add SYS_TIME \
  --dns 1.1.1.1 \
  --dns 8.8.8.8 \
  -p 123:123/udp \
  chrony:latest
```

### Podman with systemd

```bash
# Generate systemd service
podman generate systemd --new --name chrony > ~/.config/systemd/user/chrony.service
systemctl --user enable --now chrony
```

## Configuration

### Custom NTP Servers

Edit [chrony.conf](chrony.conf) to add your preferred NTP servers:

```conf
server your.ntp.server iburst
```

### Serving Time to Local Network

Uncomment in [chrony.conf](chrony.conf):

```conf
allow 10.0.5.0/24
```

## Monitoring

```bash
# Check sync status
docker exec chrony chronyc tracking

# View sources
docker exec chrony chronyc sources -v

# Check server stats
docker exec chrony chronyc serverstats
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
