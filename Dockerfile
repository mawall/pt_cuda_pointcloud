FROM mawall/py_pointcloud

# CUDA Version
ENV CUDA_MAJOR_VERSION=10.1
ENV CUDA_MAJOR_VERSION_HYP=10.1
ENV CUDA_MINOR_VERSION=10.1.243-1
ENV NVIDIA_REQUIRE_CUDA="cuda>=10.1"

# Nvidia drivers
# Not necessary to access GPUs, but only for X11 forwarding
RUN sudo apt-get purge nvidia-* && \
    sudo apt-get -y install ubuntu-drivers-common && sudo ubuntu-drivers autoinstall

# Nvidia CUDA
RUN curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | sudo apt-key add - && \
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID) && \
    curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list && \
    sudo apt-get update
RUN sudo apt-get -y install linux-headers-"$(uname -r)" && \
    sudo apt-get -y purge nvidia-cuda* && \
    sudo apt-get -y install nvidia-cuda-dev nvidia-cuda-doc nvidia-cuda-gdb nvidia-cuda-toolkit nvidia-container-runtime


ENV CUDA_HOME=/usr/local/cuda
ENV CUDA_PATH=/usr/local/cuda
ENV PATH=$CUDA_HOME/bin:$PATH
ENV LD_LIBRARY_PATH=$CUDA_HOME/lib64:$CUDA_HOME/extras/CUPTI/lib64:$LD_LIBRARY_PATH
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# Packages
RUN pip install --upgrade opencv-python \
                          tensorboard \
                          pyflann-py3
RUN conda install -y pillow \
                     pytorch \
                     torchvision \
                     cudatoolkit=10.1 \
                     pyntcloud \
                     pythreejs \
                  -c pytorch \
                  -c conda-forge

RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension install jupyter-threejs
