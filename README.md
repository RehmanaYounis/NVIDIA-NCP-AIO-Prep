# NVIDIA NCP-AIO Professional Certification Preparation

> Personal hands-on learning journal for the **NVIDIA-Certified Professional: AI Operations (NCP-AIO)** exam.

## Purpose

This public repository documents my preparation for professional AI infrastructure operations. I have already passed the associate-level NVIDIA AI Infrastructure and Operations certification; this repository focuses on **NCP-AIO**, not associate exam review.

My goal is to **understand, operate, monitor, troubleshoot, and optimize** AI infrastructure—not memorize answers. I will add only work I have genuinely studied, executed, and verified.

## How to use this repository

**For my daily study**

1. Open [ROADMAP.md](ROADMAP.md) and find the next unfinished study day.
2. Learn the concepts, including why components exist and how they interact.
3. Answer conceptual and exam-style questions before checking explanations.
4. Complete the guided lab, then attempt an independent task and a troubleshooting scenario when applicable.
5. Collect evidence: useful commands, sanitized outputs, configuration examples, and lessons learned.
6. Update [PROGRESS.md](PROGRESS.md) with what I actually completed, mistakes, quiz scores, and next steps.
7. Review `git status` and `git diff`, check for sensitive data, then commit and push a meaningful milestone.

**For visitors**: Start with the roadmap, read the progress log to see which tasks were actually performed, and explore module folders as they are added. Planned tasks are not claimed as accomplishments.

## Study method

`Learn → Understand → Answer questions → Guided lab → Independent lab → Troubleshoot → Verify → Exam scenarios → Document → Commit → Push`

A practical topic is **complete** only when I can explain it, demonstrate it or clearly label a simulation, diagnose a relevant problem, answer scenario questions, and record evidence. Weak topics return to the study queue.

## Learning environment

- Personal Windows WSL2 distribution: **Ubuntu-Learning**, Ubuntu 24.04 LTS
- Linux user: `rehmana`
- Repository path: `/home/rehmana/NVIDIA-NCP-AIO-Prep`
- Docker: Docker Desktop engine, connected to Ubuntu-Learning
- `kubectl`: installed; personal cluster not created yet
- `kind`: not installed yet; will be introduced only when its lab is reached
- GPU-related work: depends on available personal hardware; enterprise-only scenarios will be clearly labeled *simulated*

### Practice environments

| Environment | What it covers | Evidence label |
| --- | --- | --- |
| [simulator/](simulator/README.md): `aiolab` | A broken DGX H100 + BCM cluster to fix with real commands (BCM, Slurm, Kubernetes/GPU Operator, DCGM, MIG, InfiniBand, NGC), plus timed blueprint-weighted mock exams | *Simulated* |
| [labs/gpu-local/](labs/gpu-local/README.md) | The RTX 4060 Laptop GPU through WSL2: `nvidia-smi`, GPU containers, a Kubernetes GPU pod | Real |
| [labs/cloud-gpu/](labs/cloud-gpu/README.md) | A scripted ~3-hour session on a rented A100/H100: MIG, DCGM, Slurm GRES, GPU Operator | Real |

Problems are public. Solutions, explanations and exam answer keys live in a separate **private** repository, `NVIDIA-NCP-AIO-Prep-solutions`; clone it next to this one. The simulator finds it automatically, and lab solutions are at `labs/.../SOLUTION.md` inside it.

**Isolation rule:** Never use or copy files, credentials, kubeconfig, SSH keys, or projects from my separate work WSL distribution (`Ubuntu-20.04`). Do not change shared Windows/Docker settings without reviewing the impact.

## Learning roadmap

The high-level journey follows the professional exam skills:

1. Personal repository and prerequisite operational skills
2. Installation and deployment of AI infrastructure
3. Cluster administration and scheduling
4. AI workload management
5. Troubleshooting and optimization
6. Mixed practice, practical assessments, and mock exams

See [ROADMAP.md](ROADMAP.md) for the evolving day-by-day plan. Study-day numbers represent **sessions, not fixed calendar deadlines**.

## Progress

- **Current status:** Repository foundation — planned / in progress (update after verification)
- **Completed study days:** None recorded yet
- **Lab evidence and assessment scores:** See [PROGRESS.md](PROGRESS.md)

## Repository conventions

As I learn, I will add topic-specific folders only when useful (notes, scripts, YAML, labs, troubleshooting cases, and original practice questions). Each practical write-up should say what I attempted, commands used, what happened, how I verified it, and any limitations.

Meaningful Git commits may use prefixes like `docs:`, `lab:`, and `fix:`. Never commit passwords, tokens, private keys, `.env` secrets, personal kubeconfigs, sensitive logs, or company data. Sanitize command outputs before publishing.

## Official reference

- [NVIDIA NCP-AIO certification page](https://www.nvidia.com/en-us/learn/certification/ai-operations-professional/)

Official NVIDIA materials take priority if the exam blueprint changes. All notes and practice questions in this repository should be original summaries, not copied vendor content or exam dumps.

## Disclaimer

This is an independent personal learning repository and is not affiliated with or endorsed by NVIDIA.
