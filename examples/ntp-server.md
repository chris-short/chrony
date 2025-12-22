# Example: Chrony as NTP Server

This example shows how to configure chrony to serve time to other systems.

## Create server configuration

```bash
cat > server-chrony.conf << 'EOF'
# Use public NTP pool
pool pool.ntp.org iburst

# Drift file
driftfile /var/lib/chrony/drift

# Allow NTP client access from local network
# Adjust the subnet to match your network
allow 192.168.0.0/16
allow 10.0.0.0/8
allow 172.16.0.0/12

# Step the system clock if offset is larger than 1 second
makestep 1.0 3

# Enable RTC sync
rtcsync

# Serve time even if not synchronized (useful for isolated networks)
local stratum 10

# Log settings
logdir /var/log/chrony
log measurements statistics tracking
EOF
```

## Run as NTP server

```bash
docker run -d \
  --name chrony-server \
  --cap-drop=ALL \
  --cap-add=SYS_TIME \
  --read-only \
  -p 123:123/udp \
  -v $(pwd)/server-chrony.conf:/etc/chrony/chrony.conf:ro \
  -v chrony-data:/var/lib/chrony \
  -v chrony-run:/run/chrony \
  -v chrony-log:/var/log/chrony \
  ghcr.io/chris-short/chrony:latest
```

## Test from client

From another system on the network:

```bash
# Check if server is reachable
chronyc -h <container-host-ip> sources

# Or use ntpdate
ntpdate -q <container-host-ip>
```

## Monitor server status

```bash
# Check server statistics
docker exec chrony-server chronyc serverstats

# Check active clients
docker exec chrony-server chronyc clients
```
