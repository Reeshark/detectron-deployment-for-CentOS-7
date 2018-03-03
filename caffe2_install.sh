#!/bin/bash
# a script for deploy caffe2 and detectron environment
# CUDA 9.1 required before installing
# writen by qzhu, 2018.2.15

WORKSPACE_FOLDER=`pwd`
echo -e "input sudo password"
read PASSWORD

$PASSWORD | sudo -S yum --enablerepo=extras install -y epel-release
$PASSWORD | sudo -S yum update -y
$PASSWORD | sudo -S yum install -y automake cmake3 gcc gcc-c++ git kernel-devel leveldb-devel \
    lmdb-devel libtool protobuf-devel python-devel python-pip snappy-devel

$PASSWORD | sudo -S pip install -U flask future graphviz hypothesis jupyter matplotlib numpy protobuf pydot python-nvd3 \
    pyyaml requests scikit-image scipy setuptools six tornado opencv-python Cython mock

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
    $PASSWORD | sudo -S rsync -av cuda /usr/local
fi

#download from github
if [ ! -d 'gflags' ]; then git clone https://github.com/gflags/gflags.git || rm -r gflags; fi
if [ ! -d 'glog' ]; then git clone https://github.com/google/glog || rm -r glog; fi
if [ ! -d 'caffe2' ]; then git clone --recursive https://github.com/caffe2/caffe2 || rm -r caffe2; fi
if [ ! -d 'cocoapi' ]; then git clone https://github.com/cocodataset/cocoapi.git || rm -r cocoapi; fi
if [ ! -d 'detectron' ]; then git clone https://github.com/facebookresearch/detectron || rm -r detectron; fi

cd gflags && \
mkdir build && cd build && \
cmake3 -DBUILD_SHARED_LIBS=ON -DCMAKE_CXX_FLAGS='-fPIC' .. && \
make -j 8 && $PASSWORD | sudo -S make install && cd $WORKSPACE_FOLDER

cd glog && \
mkdir build && cd build && \
cmake3 -DBUILD_SHARED_LIBS=ON -DCMAKE_CXX_FLAGS='-fPIC' .. && \
make -j 8 && $PASSWORD | sudo -S make install && cd $WORKSPACE_FOLDER

cd caffe2 && mkdir build
cd build && cmake ..
$PASSWORD | sudo -S make -j install
cd $WORKSPACE_FOLDER

cd cocoapi/PythonAPI
$PASSWORD | sudo -S make install
python2 setup.py install --user
cd $WORKSPACE_FOLDER

#install detectron
cd detectron/lib && make
cd $WORKSPACE_FOLDER

