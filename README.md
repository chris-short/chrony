# Chrony Container

A minimal, secure container image for running [chrony](https://chrony-project.org/) NTP server/client in Docker and Kubernetes environments.

## Image

```
ghcr.io/chris-short/chrony:latest
```

## Quick Start

### Docker

Run with Docker:
```bash
docker run -d \
  --name chrony \
  --cap-drop=ALL \
  --cap-add=SYS_TIME \
  --read-only \
  -v chrony-data:/var/lib/chrony \
  -p 123:123/udp \
  ghcr.io/chris-short/chrony:latest
```

### Docker Compose

```bash
docker compose up -d
```

See [docker-compose.yaml](docker-compose.yaml) for the full configuration.

### Kubernetes

Deploy as a DaemonSet for cluster-wide time synchronization:
```bash
kubectl apply -f kubernetes/daemonset.yaml
```

Or as a single Deployment:
```bash
kubectl apply -f kubernetes/deployment.yaml
```

## Configuration

### Default Configuration

The container includes a default `/etc/chrony/chrony.conf` that:
- Uses `pool.ntp.org` NTP servers
- Stores drift file in `/var/lib/chrony`
- Allows system clock stepping for large offsets
- Enables kernel RTC synchronization
- Acts as local stratum 10 server when disconnected

### Custom Configuration

Mount your own configuration file:
```bash
docker run -d \
  --name chrony \
  --cap-drop=ALL \
  --cap-add=SYS_TIME \
  -v /path/to/chrony.conf:/etc/chrony/chrony.conf:ro \
  -v chrony-data:/var/lib/chrony \
  ghcr.io/chris-short/chrony:latest
```

## Security

### Container Hardening

- **~5MB image**: Alpine Linux with only `chrony` package installed
- **Non-root runtime**: Runs as `chrony` user (UID 100)
- **Weekly rebuilds**: Automated builds every Sunday pull the latest Alpine base image with security patches
- **Multi-architecture**: Native builds for `linux/amd64` and `linux/arm64`

### Recommended Runtime Settings

| Setting | Purpose |
|---------|---------|
| `cap_drop: ALL` | Drop all Linux capabilities |
| `cap_add: SYS_TIME` | Add back only what chrony needs |
| `read_only: true` | Immutable root filesystem |
| `no-new-privileges: true` | Prevent privilege escalation |

### Required Capabilities

- **SYS_TIME**: Required to set system time
- **NET_BIND_SERVICE**: Only needed if serving time on privileged ports (< 1024)

### Volumes

The following directories should be mounted as volumes:

| Path | Purpose | Type |
|------|---------|------|
| `/var/lib/chrony` | Persistent drift file and state | Persistent |
| `/run/chrony` | Runtime files and sockets | tmpfs (Memory) |
| `/var/log/chrony` | Log files (if enabled) | Optional |

### Reporting Security Issues

Report security vulnerabilities to: security@chrisshort.net

## Kubernetes Deployment

### DaemonSet Mode

The DaemonSet configuration runs chrony on every node for consistent cluster-wide time:
- Uses `hostNetwork: true` for accurate time synchronization
- Configured with `system-node-critical` priority class
- Tolerates all taints to run on all nodes
- Includes resource limits and health checks

### Required Kubernetes Configuration

```yaml
securityContext:
  capabilities:
    drop:
    - ALL
    add:
    - SYS_TIME
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
  runAsNonRoot: true
  runAsUser: 100
```

### Health Checks

Both Deployment and DaemonSet include:
- **Liveness probe**: Checks if chronyd is tracking time sources
- **Readiness probe**: Ensures chronyd is operational

## Troubleshooting

### Check chrony status

```bash
docker exec chrony chronyc tracking
```

### Check NTP sources

```bash
docker exec chrony chronyc sources -v
```

### View logs

```bash
docker logs chrony
```

### Common Issues

**Container exits immediately**
- Ensure required volumes are mounted
- Check that CAP_SYS_TIME capability is granted

**Time not synchronizing**
- Verify network connectivity to NTP servers
- Check firewall rules allow UDP port 123
- Examine logs for error messages

**Permission denied errors**
- Ensure volumes have correct permissions for UID 100 (chrony user)
- Check SELinux/AppArmor policies if applicable

## Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent build from main branch |
| `YYYYMMDD` | Date-stamped builds |
| `<sha>` | Git commit SHA |

## License

MIT
