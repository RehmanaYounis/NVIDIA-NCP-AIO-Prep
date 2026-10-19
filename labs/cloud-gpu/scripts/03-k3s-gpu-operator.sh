#!/usr/bin/env bash
# Single-node k3s + NVIDIA GPU Operator using the host's preinstalled driver (like a DGX).
# The toolkit settings below are the k3s values from the GPU Operator docs; re-check them if the install fails.
set -euo pipefail
[ "$(id -u)" -eq 0 ] || { echo "Run as root (sudo)."; exit 1; }
if ! command -v k3s >/dev/null; then
  curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
fi
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
if ! command -v helm >/dev/null; then
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi
kubectl wait --for=condition=Ready node --all --timeout=180s

helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
helm repo update
helm upgrade --install gpu-operator nvidia/gpu-operator \
  --namespace gpu-operator --create-namespace \
  --set driver.enabled=false \
  --set toolkit.env[0].name=CONTAINERD_CONFIG \
  --set toolkit.env[0].value=/var/lib/rancher/k3s/agent/etc/containerd/config.toml \
  --set toolkit.env[1].name=CONTAINERD_SOCKET \
  --set toolkit.env[1].value=/run/k3s/containerd/containerd.sock \
  --wait --timeout 15m

kubectl get pods -n gpu-operator
kubectl describe node | grep -E 'nvidia.com/gpu' | head
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml  # add this to your shell"
