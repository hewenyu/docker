#!/bin/bash
set -e

# Activate conda environment
source /opt/conda/etc/profile.d/conda.sh
conda activate cosyvoice

# Execute the command passed to the docker container
exec "$@" 