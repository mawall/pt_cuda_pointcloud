FROM mawall/py_pointcloud

# CUDA Version
ENV CUDA_MAJOR_VERSION=10.1
ENV CUDA_MAJOR_VERSION_HYP=10.1
ENV CUDA_MINOR_VERSION=10.1.243-1
ENV NVIDIA_REQUIRE_CUDA="cuda>=10.1"

# CUDA Install
RUN wget -nv -P /root/manual http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub && \
    echo "47217c49dcb9e47a8728b354450f694c9898cd4a126173044a69b1e9ac0fba96  /root/manual/7fa2af80.pub" | sha256sum -c --strict - && \
    apt-key add /root/manual/7fa2af80.pub && \
    wget -nv -P /root/manual http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_${CUDA_MINOR_VERSION}_amd64.deb && \
    dpkg -i /root/manual/cuda-repo-ubuntu1604_${CUDA_MINOR_VERSION}_amd64.deb && \
    echo 'deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /' > /etc/apt/sources.list.d/nvidia-ml.list && \
    rm -rf /root/manual && \
    apt-get update  && apt-get install --no-install-recommends -y cuda-toolkit-${CUDA_MAJOR_VERSION_HYP} \
                                                                  libcudnn7 \
                                                                  libcudnn7-dev && \
    ls /usr/local/cuda-${CUDA_MAJOR_VERSION}/targets/x86_64-linux/lib/stubs/* | xargs -I{} ln -s {} /usr/lib/x86_64-linux-gnu/ && \
    ln -s libcuda.so /usr/lib/x86_64-linux-gnu/libcuda.so.1 && \
    ln -s libnvidia-ml.so /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 && \
    # Remove Stubs - to solve this issue: https://discuss.ropensci.org/t/using-the-gpu-backend-in-h2o-xgboost-in-a-rocker-based-docker-container/1561/2
    rm -r -f  /usr/local/cuda/lib64/stubs

ENV CUDA_HOME=/usr/local/cuda
ENV CUDA_PATH=/usr/local/cuda
ENV PATH=$CUDA_HOME/bin:$PATH
ENV LD_LIBRARY_PATH=$CUDA_HOME/lib64:$CUDA_HOME/extras/CUPTI/lib64:$LD_LIBRARY_PATH
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# Packages
RUN pip install --upgrade opencv-python
RUN conda install -y pillow \
                     pytorch \
                     torchvision \
                     cudatoolkit=10.1 \
                  -c pytorch
