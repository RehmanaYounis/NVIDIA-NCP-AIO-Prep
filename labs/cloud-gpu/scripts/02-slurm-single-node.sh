#!/usr/bin/env bash
# Single-node Slurm with GPU GRES (controller + compute on this machine). For practice only.
set -euo pipefail
[ "$(id -u)" -eq 0 ] || { echo "Run as root (sudo)."; exit 1; }
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y slurm-wlm munge

HOST=$(hostname -s)
NGPU=$(nvidia-smi -L | grep -c '^GPU')
CPUS=$(nproc)
MEM=$(( $(awk '/MemTotal/ {print $2}' /proc/meminfo) / 1024 - 4096 ))
LAST=$((NGPU - 1))

mkdir -p /etc/slurm /var/spool/slurmctld /var/spool/slurmd /var/log/slurm
chown slurm: /var/spool/slurmctld /var/log/slurm 2>/dev/null || true

cat > /etc/slurm/slurm.conf <<CONF
ClusterName=practice
SlurmctldHost=${HOST}
AuthType=auth/munge
SelectType=select/cons_tres
SelectTypeParameters=CR_Core_Memory
GresTypes=gpu
ProctrackType=proctrack/cgroup
TaskPlugin=task/affinity,task/cgroup
SlurmctldLogFile=/var/log/slurm/slurmctld.log
SlurmdLogFile=/var/log/slurm/slurmd.log
StateSaveLocation=/var/spool/slurmctld
SlurmdSpoolDir=/var/spool/slurmd
ReturnToService=2
NodeName=${HOST} CPUs=${CPUS} RealMemory=${MEM} Gres=gpu:${NGPU} State=UNKNOWN
PartitionName=gpu Nodes=${HOST} Default=YES MaxTime=INFINITE State=UP
CONF

if [ "$NGPU" -gt 1 ]; then FILES="/dev/nvidia[0-${LAST}]"; else FILES="/dev/nvidia0"; fi
echo "Name=gpu File=${FILES}" > /etc/slurm/gres.conf
cat > /etc/slurm/cgroup.conf <<CONF
ConstrainCores=yes
ConstrainDevices=yes
ConstrainRAMSpace=yes
CONF

systemctl enable --now munge
systemctl restart slurmctld slurmd
sleep 3
sinfo -N -l
srun --gres=gpu:1 nvidia-smi -L
