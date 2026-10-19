# Lab 03: A GPU pod on a personal Kubernetes cluster

**Status:** Not attempted
**Environment:** Ubuntu-Learning (WSL2) + Docker Desktop, RTX 4060. **Real.** Uses **minikube** with GPU support.

**Goal:** See the device plugin turn a GPU into the schedulable resource `nvidia.com/gpu`, then diagnose a GPU pod stuck in Pending.

> GPU passthrough into minikube under WSL2 depends on your Docker Desktop and minikube versions. If step 1 fails after a reasonable attempt, record it as **Blocked (environment)** and do the simulator labs `wkl-k8s-pod-pending-gpu` and `ins-gpu-operator-preinstalled-driver` instead. Don't change shared Windows/Docker settings to force it.

## Setup

```bash
# install minikube (https://minikube.sigs.k8s.io/docs/start/), then:
minikube start --driver=docker --container-runtime=docker --gpus=all
kubectl get nodes
kubectl describe node minikube | grep -A8 -i capacity
```

**Question:** Before the device plugin runs, is `nvidia.com/gpu` in the node's capacity? Which component adds it?

## Scenario 1: Run a GPU pod

Write `gpu-pod.yaml`: a Pod named `cuda-check` that runs `nvidia-smi -L` from `nvcr.io/nvidia/cuda:12.4.1-base-ubuntu22.04`, requests **1** GPU, and has `restartPolicy: Never`. Apply it and read its logs.

**Success check:** `kubectl logs cuda-check` shows your GPU.

## Scenario 2: The pod that never starts

Change the request to **2** GPUs, give the pod a new name, and apply it.

- Which status does it show?
- Which command shows *why*? Copy the exact event message.
- Explain the message format `0/1 nodes are available: ...`.

Fix it without deleting the device plugin.

## Scenario 3: Requests vs limits

Try giving the pod `requests: nvidia.com/gpu: 1` but no `limits`. What happens and why? What about fractional values like `0.5`?

## Cleanup

```bash
kubectl delete pod --all
minikube stop      # or: minikube delete
```
