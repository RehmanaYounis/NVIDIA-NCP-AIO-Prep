# Lab 02: GPU containers and NGC images

**Status:** Not attempted
**Environment:** Ubuntu-Learning (WSL2) + Docker Desktop, RTX 4060. **Real.**

**Goal:** Run GPU workloads in containers, diagnose a container that can't see the GPU, and use NGC images correctly.

Image sizes: `nvcr.io/nvidia/cuda:12.4.1-base-ubuntu22.04` is small (about 100 MB). `nvcr.io/nvidia/pytorch:24.05-py3` is about 9 GB, so pull it only when you have space and time.

## Scenario 1: "The container has no GPU"

```bash
docker run --rm nvcr.io/nvidia/cuda:12.4.1-base-ubuntu22.04 nvidia-smi
```

**Predict, then run.** Explain the error. Fix the command so the container sees the GPU, without changing the image.

**Success check:** `nvidia-smi` inside the container shows your RTX 4060.

## Scenario 2: Select specific GPUs

Run the container so it receives **only GPU 0**, addressed by index and then by UUID. Find the UUID with `nvidia-smi -L`. Explain why the quoting matters for `--gpus '"device=0"'`.

## Scenario 3: A real CUDA workload

Run a short PyTorch matrix-multiply benchmark inside `nvcr.io/nvidia/pytorch:24.05-py3`:

```bash
docker run --rm --gpus all nvcr.io/nvidia/pytorch:24.05-py3 python -c "
import torch, time
a = torch.randn(8192, 8192, device='cuda', dtype=torch.float16); b = torch.randn_like(a)
torch.cuda.synchronize(); t = time.time()
for _ in range(50): c = a @ b
torch.cuda.synchronize(); dt = time.time() - t
print(f'{torch.cuda.get_device_name()}: {50 * 2 * 8192**3 / dt / 1e12:.1f} TFLOPS fp16')"
```

While it runs, watch `nvidia-smi dmon -s pucm` in a second terminal. Record TFLOPS, peak power, temperature, and any clock event reasons.

## Scenario 4: NGC account (optional)

1. Create a free NGC account and generate an **API key**.
2. Run `docker login nvcr.io`. What is the username? Where must the key never end up?
3. Explain why public images pulled in Scenario 1 without login, and when login becomes required.

## Evidence

For each scenario, record your prediction, the commands, sanitised output, the fix and your explanation. **Never commit your NGC API key.** Check `git diff` before every commit.
