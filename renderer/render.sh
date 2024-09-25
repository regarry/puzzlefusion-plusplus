#!/bin/bash

#SBATCH -N 1
#SBATCH -n 1
#SBATCH -p volta-gpu
#SBATCH --mem=32g
#SBATCH -t 12:00:00
#SBATCH --qos=gpu_access
#SBATCH --gres=gpu:1

# Record the start time
start_time=$(date +%s)
echo "Start time: $(date)"

module purge
module load anaconda
conda activate blender
echo "Active conda environment:"
conda info --envs | grep '*' | awk '{print $1}'

module load cuda/11.8
hostname
lscpu
#free -h
#df -h
top -b | head -n 20
nvidia-smi
nvcc --version

cd /work/users/r/e/regarry/puzzlefusion-plusplus/
conda run -n blender python -u renderer/render_results.py experiment_name=everyday_epoch2000_bs64 inference_dir=results  renderer.output_path=results renderer.mesh_path=./renderer/

# Record the finish time
finish_time=$(date +%s)
echo "Finish time: $(date)"

# Calculate and print the elapsed time
elapsed_time=$((finish_time - start_time))
echo "Time elapsed: $(date -ud "@$elapsed_time" +'%H:%M:%S')"