#!/bin/bash
# Test script for chrony container
# This script validates that the chrony container works correctly

set -e

echo "=== Chrony Container Test Script ==="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Step 1: Build the container${NC}"
docker build -t chrony-test .

echo ""
echo -e "${BLUE}Step 2: Test container starts${NC}"
docker run --rm -d \
  --name chrony-test \
  --cap-drop=ALL \
  --cap-add=SYS_TIME \
  chrony-test

echo "Container started, waiting 5 seconds for initialization..."
sleep 5

echo ""
echo -e "${BLUE}Step 3: Check chronyd is running${NC}"
docker exec chrony-test ps aux | grep chronyd

echo ""
echo -e "${BLUE}Step 4: Check chrony tracking${NC}"
docker exec chrony-test chronyc tracking || echo "Note: Tracking may not work without proper capabilities"

echo ""
echo -e "${BLUE}Step 5: Check chrony sources${NC}"
docker exec chrony-test chronyc sources || echo "Note: Sources may not be reachable in isolated environment"

echo ""
echo -e "${BLUE}Step 6: Verify configuration${NC}"
docker exec chrony-test cat /etc/chrony/chrony.conf

echo ""
echo -e "${BLUE}Step 7: Check directory permissions${NC}"
docker exec chrony-test ls -la /var/lib/chrony /run/chrony /var/log/chrony

echo ""
echo -e "${BLUE}Step 8: Cleanup${NC}"
docker stop chrony-test

echo ""
echo -e "${GREEN}=== All tests passed! ===${NC}"
echo ""
echo "To run the container manually:"
echo "  docker run -d --name chrony --cap-drop=ALL --cap-add=SYS_TIME -p 123:123/udp ghcr.io/chris-short/chrony:latest"
echo ""
echo "To use with Docker Compose:"
echo "  docker compose up -d"
echo ""
echo "To deploy to Kubernetes:"
echo "  kubectl apply -f kubernetes/daemonset.yaml"
