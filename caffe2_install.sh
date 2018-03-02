#!/bin/bash
# a script for deploy caffe2 and detectron environment
# CUDA and CUDNN required before installing
# writen by qzhu, 2018.2.15
# version 1.01
set -e
sudo ls
WORKSPACE_FOLDER=`pwd`
echo $WORKSPACE_FOLDER

#install cmake 3.10.2

if [ ! -f "cmake-3.10.2-Linux-x86_64.tar.gz" ]; then
    wget https://cmake.org/files/v3.10/cmake-3.10.2-Linux-x86_64.tar.gz
fi
tar -zxf cmake-3.10.2-Linux-x86_64.tar.gz
export PATH=`pwd`/cmake-3.10.2-Linux-x86_64/bin:$PATH
echo $PATH
cmake --version

#install cudnn

if [ ! -f "/usr/local/cuda/include/cudnn.h" ]; then
    wget http://developer.download.nvidia.com/compute/redist/cudnn/v7.0.5/cudnn-9.1-linux-x64-v7.tgz
    tar -zxf cudnn-9.1-linux-x64-v7.tgz
    sudo rsync -av cuda /usr/local/
fi

#install caffe2

sudo yum --enablerepo=extras install -y epel-release
sudo yum update -y
sudo yum install -y automake cmake3 gcc gcc-c++ git kernel-devel leveldb-devel lmdb-devel libtool protobuf-devel python-devel python-pip snappy-devel
git clone https://github.com/gflags/gflags.git && \
    cd gflags && \
    mkdir build && cd build && \
    cmake3 -DBUILD_SHARED_LIBS=ON -DCMAKE_CXX_FLAGS='-fPIC' .. && \
    make -j 8 && sudo make install && cd ../.. && \
    git clone https://github.com/google/glog && \
    cd glog && \
    mkdir build && cd build && \
    cmake3 -DBUILD_SHARED_LIBS=ON -DCMAKE_CXX_FLAGS='-fPIC' .. && \
    make -j 8 && sudo make install && cd ../..
sudo pip install -U \
    flask \
    future \
    graphviz \
    hypothesis \
    jupyter \
    matplotlib \
    numpy \
    protobuf \
    pydot \
    python-nvd3 \
    pyyaml \
    requests \
    scikit-image \
    scipy \
    setuptools \
    six \
    tornado

git clone --recursive https://github.com/caffe2/caffe2
cd caffe2 && mkdir build
cd build && cmake ..
sudo make -j install
cd $WORKSPACE_FOLDER

sudo pip install -U numpy pyyaml matplotlib opencv-python setuptools Cython mock scipy
git clone https://github.com/cocodataset/cocoapi.git
cd cocoapi/PythonAPI
sudo make install
python2 setup.py install --user
cd $WORKSPACE_FOLDER

#install detectron

git clone https://github.com/facebookresearch/detectron
cd detectron/lib && make

