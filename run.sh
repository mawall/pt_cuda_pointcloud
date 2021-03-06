#!/usr/bin/env bash

export NOTEBOOK_DIR=/home/marcus/Documents/notebooks/
export PROJECT_DIR=/home/marcus/Documents/projects/
export DATA_DIR=/home/marcus/Documents/data/

# The command passed to HOST_IP will find whatever source ip has a route to Google's public DNS server, aka the internet
# From: https://unix.stackexchange.com/questions/87468/is-there-an-easy-way-to-programmatically-extract-ip-address
docker run   \
    --privileged  \
    -it  \
    --rm  \
    --net=host \
    --gpus=all \
    -e HOST_IP="$(ip -o route get 8.8.8.8 | sed -e 's/^.* src \([^ ]*\) .*$/\1/')" \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v $NOTEBOOK_DIR:/notebooks/  \
    -v $PROJECT_DIR:/project/  \
    -v $DATA_DIR:/data/  \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -w /notebooks \
    --name ptpc \
    pt_cuda_pointcloud
