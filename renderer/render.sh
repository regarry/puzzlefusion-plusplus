#!/bin/bash

#SBATCH -N 1
#SBATCH -n 1
#SBATCH -p volta-gpu
#SBATCH --mem=32g
#SBATCH -t 72:00:00
#SBATCH --qos=gpu_access
#SBATCH --gres=gpu:1
#SBATCH --mail-type=BEGIN,END,FAIL # Send email on job begin, end, and fail
#SBATCH --mail-user=rgarry@unc.edu
#SBATCH --output=/work/users/r/e/regarry/puzzlefusion-plusplus/renderer/logs/render-%j.out
#SBATCH --error=/work/users/r/e/regarry/puzzlefusion-plusplus/renderer/logs/render-%j.out

# Record the start time
start_time=$(date +%s)
echo "Start time: $(date)"

module purge
module load anaconda
module load ffmpeg # to render movies
conda activate blender
echo "Active conda environment:"
conda info --envs | grep '*' | awk '{print $1}'

hostname
lscpu
#free -h
#df -h
top -b | head -n 20


cd /work/users/r/e/regarry/puzzlefusion-plusplus/
pwd
conda run -n blender \
    python renderer/render_results.py \
    experiment_name=everyday_epoch2000_bs64 \
    inference_dir=results \
    renderer.output_path=results \
    renderer.mesh_path=../breaking-bad-dataset/data/


# Record the finish time
finish_time=$(date +%s)
echo "Finish time: $(date)"

# Calculate and print the elapsed time
elapsed_time=$((finish_time - start_time))
echo "Time elapsed: $(date -ud "@$elapsed_time" +'%H:%M:%S')"