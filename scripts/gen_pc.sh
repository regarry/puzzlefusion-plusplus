#!/bin/bash

#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p general
#SBATCH --mem=32g
#SBATCH -t 01-00:00:00
#SBATCH --output=./logs/gen_pc_%j.out
#SBATCH --error=./logs/gen_pc_%j.out


# Record the start time
start_time=$(date +%s)
echo "Start time: $(date)"

module purge
module load anaconda
conda activate p38
echo "Active conda environment:"
conda info --envs | grep '*' | awk '{print $1}'

module load cuda/11.8
hostname
lscpu
top -b | head -n 20
nvidia-smi
nvcc --version

conda run -n p38 python generate_pc_data_sphere.py 

# Record the finish time
finish_time=$(date +%s)
echo "Finish time: $(date)"

# Calculate and print the elapsed time
elapsed_time=$((finish_time - start_time))
echo "Time elapsed: $(date -ud "@$elapsed_time" +'%H:%M:%S')"