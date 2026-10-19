#!/usr/bin/env bash
# Install Docker, the NVIDIA Container Toolkit and DCGM on Ubuntu 22.04 (skips what is already installed).
# Based on the public NVIDIA Container Toolkit and DCGM install guides.
set -euo pipefail
[ "$(id -u)" -eq 0 ] || { echo "Run as root (sudo)."; exit 1; }
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y curl gnupg ca-certificates

if ! command -v docker >/dev/null; then
  echo "== Installing Docker"
  curl -fsSL https://get.docker.com | sh
fi

if ! command -v nvidia-ctk >/dev/null; then
  echo "== Installing NVIDIA Container Toolkit"
  curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
    | gpg --dearmor --yes -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
  curl -fsSL https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
    | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
    > /etc/apt/sources.list.d/nvidia-container-toolkit.list
  apt-get update -y
  apt-get install -y nvidia-container-toolkit
fi
nvidia-ctk runtime configure --runtime=docker
systemctl restart docker

if ! command -v dcgmi >/dev/null; then
  echo "== Installing DCGM"
  . /etc/os-release
  repo="ubuntu${VERSION_ID//./}"
  curl -fsSLO "https://developer.download.nvidia.com/compute/cuda/repos/${repo}/x86_64/cuda-keyring_1.1-1_all.deb"
  dpkg -i cuda-keyring_1.1-1_all.deb && rm -f cuda-keyring_1.1-1_all.deb
  apt-get update -y
  cuda_major=$(nvidia-smi | sed -n 's/.*CUDA Version: \([0-9]*\).*/\1/p')
  apt-get install -y "datacenter-gpu-manager-4-cuda${cuda_major}" || apt-get install -y datacenter-gpu-manager
fi
systemctl enable --now nvidia-dcgm 2>/dev/null || systemctl enable --now dcgm 2>/dev/null || true

echo "== Verify"
docker run --rm --gpus all nvcr.io/nvidia/cuda:12.4.1-base-ubuntu22.04 nvidia-smi -L
dcgmi discovery -l
