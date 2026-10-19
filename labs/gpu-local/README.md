# Local GPU labs (RTX 4060 Laptop, WSL2)

These labs use **real hardware**: your laptop GPU, through WSL2 and Docker Desktop. They cover the parts of the exam that a consumer GPU can genuinely exercise. Everything a laptop GPU cannot do (MIG, NVLink/NVSwitch, InfiniBand, BCM, multi-node Slurm, DCGM diagnostics) is practised in the [simulator](../../simulator/README.md) or the [cloud GPU session](../cloud-gpu/README.md).

| Lab | Exam skills | Real or simulated |
| --- | --- | --- |
| [01 nvidia-smi on WSL2](01-nvidia-smi-wsl/README.md) | Read GPU state; query fields; recognise unsupported features | Real |
| [02 GPU containers](02-gpu-containers/README.md) | NVIDIA Container Toolkit, `--gpus`, NGC images, a failing container | Real |
| [03 Kubernetes GPU pod](03-k8s-gpu-pod/README.md) | Device plugin, `nvidia.com/gpu` requests, a Pending pod | Real (minikube) |

Each lab folder has a `README.md` with the problem. The matching `SOLUTION.md` (answers, edge cases, traps) is in the private solutions repository, at the same path. Attempt the lab before you open it.

## What your GPU can and cannot do

| Feature | RTX 4060 Laptop on WSL2 | Why it matters for NCP-AIO |
| --- | --- | --- |
| `nvidia-smi` queries, `dmon`, `-q -d` | Yes | Reading GPU state is in every troubleshooting domain |
| GPU containers (`docker --gpus`) | Yes, via Docker Desktop | Container Toolkit and NGC workflow |
| Kubernetes GPU scheduling | Yes, single node | Device plugin, resource requests |
| Persistence mode, `-pl`, `-r`, ECC | Mostly no (WDDM driver and laptop limits) | Practise in the simulator |
| MIG | No (data-centre GPUs only) | Simulator, then a cloud A100/H100 |
| DCGM diagnostics | No (not supported on WSL/GeForce) | Simulator, then cloud |
| NVLink, InfiniBand, BCM, multi-node Slurm | No | Simulator |

## One-time prerequisites

Run these in **Ubuntu-Learning** (your personal WSL distribution, never the work one):

```bash
nvidia-smi                 # comes from the Windows driver; do NOT install a Linux NVIDIA driver inside WSL
docker version             # Docker Desktop with WSL integration enabled for Ubuntu-Learning
docker info | grep -i runtime
```

Do not install `nvidia-driver-*` packages inside WSL. The Windows driver provides `libcuda` to WSL through `/usr/lib/wsl/lib`. Installing a Linux driver breaks it. This WSL quirk doesn't apply to a DGX.
