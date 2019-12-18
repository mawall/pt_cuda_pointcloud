FROM mawall/py_pointcloud

# Packages
RUN pip install --upgrade opencv-python
RUN conda install -y pillow
RUN conda install pytorch torchvision cudatoolkit=10.1 -c pytorch
