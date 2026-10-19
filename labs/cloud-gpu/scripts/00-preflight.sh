#!/usr/bin/env bash
# Check that the rented machine can actually do the cloud labs before you spend time on setup.
set -u
fail=0
[ "$(id -u)" -eq 0 ] || { echo "Run as root (sudo)."; exit 1; }
echo "== OS"; . /etc/os-release && echo "$PRETTY_NAME"
echo "== Driver / GPUs"
if ! nvidia-smi --query-gpu=index,name,driver_version,memory.total,mig.mode.current --format=csv; then
  echo "FAIL: nvidia-smi does not work. Pick an image with the NVIDIA data-center driver preinstalled."; exit 1
fi
if nvidia-smi --query-gpu=mig.mode.current --format=csv,noheader | grep -q "N/A"; then
  echo "WARN: GPU is not MIG-capable; Lab A and MIG part of Lab D will not work."; fail=1
fi
echo "== Container or VM?"
if [ -f /.dockerenv ] || grep -qa 'container=' /proc/1/environ 2>/dev/null; then
  echo "WARN: this looks like a container rental. MIG / GPU reset / DCGM diag usually need a full VM."; fail=1
fi
echo "== Disk"; df -h / | tail -1
echo "== Fabric Manager (needed only on NVSwitch systems: HGX/DGX 8-GPU)"
systemctl is-active nvidia-fabricmanager 2>/dev/null || echo "not running (fine for 1-2 GPU VMs)"
[ $fail -eq 0 ] && echo "Preflight OK." || echo "Preflight finished with warnings."
