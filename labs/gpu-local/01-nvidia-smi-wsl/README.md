# Lab 01: nvidia-smi on a real GPU (WSL2)

**Status:** Not attempted
**Environment:** Ubuntu-Learning (WSL2), RTX 4060 Laptop GPU. **Real.**

**Goal:** Read and query GPU state fluently, and recognise when a feature isn't supported (as opposed to broken).

## Tasks

1. Run `nvidia-smi`. Identify the driver version, the CUDA version, the driver model (WDDM), memory used/total, P-state, and power usage/cap. Explain what "CUDA Version" in the header actually means.
2. Write one `--query-gpu` command that prints, as CSV without units: index, name, temperature, utilisation, memory used, memory total, power draw, and SM clock.
3. Run `nvidia-smi dmon -s pucm -c 10` while the GPU is idle. Then run it again while something loads the GPU, such as a video or the container from Lab 02. Record what changes.
4. Run `nvidia-smi -q -d PERFORMANCE` and list which clock event (throttle) reasons are active at idle. Explain why "Idle" being active is normal.
5. Try each of these and record the exact output. **Predict first:**
   - `nvidia-smi -pm 1`
   - `nvidia-smi -i 0 -mig 1`
   - `nvidia-smi -q -d ECC`
   - `nvidia-smi -pl 60` (if it is refused, do not force it)
6. For each command in task 5, decide: is the feature *broken*, *unsupported on this GPU/driver model*, or *a permissions issue*? Which line of output proves it?

## Success checks

- Your query command from task 2 prints exactly one CSV line per GPU.
- You can explain the difference between "Not Supported", "N/A" and an error in `nvidia-smi` output.
- You can name the simulator lab that practises each feature that failed in task 5 (`aiolab list`).

## Evidence to record in PROGRESS.md

Your commands and sanitised outputs, your predictions vs actual results, and which features are unsupported on WSL/GeForce.
