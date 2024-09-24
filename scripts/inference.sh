#!/bin/bash

#SBATCH -N 1
#SBATCH -n 1
#SBATCH -p l40-gpu
#SBATCH --mem=32g
#SBATCH -t 01-00:00:00
#SBATCH --qos=gpu_access
#SBATCH --gres=gpu:1

module purge
module load anaconda
conda activate p38
echo "Active conda environment:"
conda info --envs | grep '*' | awk '{print $1}'

module load cuda/11.8
hostname
lscpu
free -h
df -h
top
nvidia-smi
nvcc --version


cd /work/users/r/e/regarry/puzzlefusion-plusplus
conda run -n p38 python test.py \
    experiment_name=everyday_epoch2000_bs64 \
    denoiser.data.val_batch_size=1 \
    denoiser.data.data_val_dir=./data/pc_data/everyday/val/ \
    denoiser.data.matching_data_path=./data/matching_data/ \
    denoiser.ckpt_path=output/denoiser/everyday_epoch2000_bs64/training/last.ckpt \
    verifier.ckpt_path=output/verifier/everyday_epoch100_bs64/training/last.ckpt \
    inference_dir=results \
    verifier.max_iters=6 \
