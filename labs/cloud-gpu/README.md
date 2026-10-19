# Cloud GPU session: real MIG, DCGM, Slurm and GPU Operator

**Status:** Not attempted
**Environment:** One rented data-centre GPU VM, for a few hours. **Real.**

Do this **after** you've passed the matching simulator labs. You pay by the hour, so the simulator is where you learn and this session is where you confirm. Everything here is scripted so no paid time goes on setup.

## 1. Choose the right kind of instance

| Requirement | Why |
| --- | --- |
| **MIG-capable GPU:** A100, A30, H100 or H200 (1 GPU is enough; 2+ lets you see NVLink/topology) | MIG, ECC and row remapping, DCGM diagnostics |
| **A full VM or bare metal with root**, not a "container/pod" GPU rental | MIG mode, GPU reset and DCGM need host-level root. Container-based rentals block them |
| **Ubuntu 22.04** with the NVIDIA data-centre driver preinstalled (most GPU images have it) | Matches DGX OS 6 |
| At least 100 GB disk | NGC containers are large |

Before you start, check current per-hour prices on two or three providers. **Set a billing alert**, and when you finish, **terminate** the instance (stopping it can still bill for storage or the reserved GPU). Budget for about 3 hours.

## 2. Session plan (about 3 hours)

| Time | Script / task | Exam domain | Simulator lab to do first |
| --- | --- | --- | --- |
| 0:00 | `sudo bash scripts/00-preflight.sh` | — | — |
| 0:05 | `sudo bash scripts/01-install-tools.sh` (Container Toolkit, Docker, DCGM) | Installation & Deployment | `ins-ngc-registry-auth` |
| 0:20 | **Lab A: MIG** (below) | Administration | `adm-mig-h100-1g` |
| 0:50 | **Lab B: DCGM health and diagnostics** | Troubleshooting & Optimization | `tsh-dcgm-diag-failure` |
| 1:15 | `sudo bash scripts/02-slurm-single-node.sh`, then **Lab C** | Installation / Workload | `ins-slurm-gres-config`, `wkl-slurm-pending-reasons` |
| 1:50 | `sudo bash scripts/03-k3s-gpu-operator.sh`, then **Lab D** | Installation / Administration | `ins-gpu-operator-preinstalled-driver`, `adm-k8s-mig-mixed-strategy` |
| 2:40 | Copy your evidence off the machine, then **terminate** | — | — |

## Lab A: MIG for real

1. `nvidia-smi -i 0 -mig 1`. Is a reset or reboot required on your GPU model? Record the output.
2. List the profiles (`nvidia-smi mig -lgip`) and compare them with the simulator's H100 table.
3. Create one `3g` and two `2g` instances, or the closest your GPU allows, with compute instances. Run `nvidia-smi -L`.
4. Run a CUDA container on **one** MIG device by UUID: `docker run --rm --gpus '"device=MIG-<uuid>"' nvcr.io/nvidia/cuda:12.4.1-base-ubuntu22.04 nvidia-smi -L`.
5. Try to create one more instance than fits, and record the error.
6. Tear everything down in the correct order, then disable MIG.

## Lab B: DCGM

1. `dcgmi discovery -l`, then create a group with all GPUs: `dcgmi group -c allgpus --default`.
2. `dcgmi health -g <id> -s a`, then `dcgmi health -g <id> -c`.
3. `dcgmi diag -r 1`, then `dcgmi diag -r 2`. Time each level. Why would you avoid `-r 3` on a node that is running jobs?
4. `dcgmi dmon -e 150,155,203,252 -c 5`. Look up what each field ID is.

## Lab C: Slurm with GRES

1. After the script runs: `sinfo -N -l`, then `scontrol show node $(hostname) | grep -i gres`.
2. `srun --gres=gpu:1 nvidia-smi -L`. Then ask for more GPUs than exist, and read the reason in `squeue`.
3. Break `gres.conf` on purpose (wrong count), restart `slurmd`, and observe the node state. Fix it and resume the node.
4. Optional: install pyxis and enroot, then `srun --container-image=nvcr.io#nvidia/cuda:12.4.1-base-ubuntu22.04 nvidia-smi -L`.

## Lab D: GPU Operator

1. After the script: `kubectl get pods -n gpu-operator`. Which pods exist, and why is there **no** driver pod?
2. Run the GPU pod from [Lab 03](../gpu-local/03-k8s-gpu-pod/README.md).
3. MIG through the operator (MIG GPUs only): `helm upgrade` with `mig.strategy=mixed`, then `kubectl label node <node> nvidia.com/mig.config=all-1g.10gb --overwrite` (use a profile your GPU supports; check the mig-parted config map). Watch the `nvidia.com/mig.config.state` label, then schedule a pod requesting `nvidia.com/mig-1g.10gb: 1`.

## Evidence

Copy the outputs you want to keep into this folder **before terminating**, sanitised: no IPs, keys or account IDs. Record them in PROGRESS.md as **real** evidence.

The scripts follow the current public NVIDIA install docs. Package names and chart values change, so if a step fails, check the linked doc and record what you changed.
