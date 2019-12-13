FROM mawall/py_pointcloud

# NVIDIA drivers and CUDA
RUN wget http://uk.download.nvidia.com/XFree86/Linux-x86_64/440.44/NVIDIA-Linux-x86_64-440.44.run && \
    chmod +x NVIDIA-Linux-x86_64-440.44.run && \
    ./NVIDIA-Linux-x86_64-440.44.run && \
    rm -rf NVIDIA-Linux-x86_64-440.44.run

RUN apt-get update --fix-missing && \
    apt-get install -y nvidia-cuda-toolkit

# Packages
RUN pip install --upgrade opencv-python
RUN conda install -y pillow
RUN conda install pytorch torchvision cudatoolkit=9.2 -c pytorch
