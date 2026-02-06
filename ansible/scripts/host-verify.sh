#!/bin/bash
# Run verification checks against proxmox hosts
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="$(dirname "$SCRIPT_DIR")"

ansible-playbook \
  -i "$ANSIBLE_DIR/inventory/hosts.yml" \
  "$ANSIBLE_DIR/site.yml" \
  --tags verify \
  "$@"