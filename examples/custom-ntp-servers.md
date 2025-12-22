# Example: Custom NTP Servers

This example shows how to configure chrony with custom NTP servers.

## Create custom configuration

```bash
cat > custom-chrony.conf << 'EOF'
# Custom NTP servers
server time.google.com iburst
server time.cloudflare.com iburst
server time.apple.com iburst

# Drift file
driftfile /var/lib/chrony/drift

# Step the system clock if offset is larger than 1 second
makestep 1.0 3

# Enable RTC sync
rtcsync

# Local stratum when disconnected
local stratum 10
EOF
```

## Run with custom configuration

```bash
docker run -d \
  --name chrony \
  --cap-drop=ALL \
  --cap-add=SYS_TIME \
  --read-only \
  -v $(pwd)/custom-chrony.conf:/etc/chrony/chrony.conf:ro \
  -v chrony-data:/var/lib/chrony \
  -v chrony-run:/run/chrony \
  -v chrony-log:/var/log/chrony \
  ghcr.io/chris-short/chrony:latest
```

## Verify configuration

```bash
docker exec chrony chronyc sources -v
```
