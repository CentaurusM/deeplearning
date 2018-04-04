#!/bin/bash

# install cuda 9.0
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
apt-get update
apt-get install cuda-9-0 -y

# set enviroment for cuda
echo 'export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
' > env_cuda.rc
source env_cuda.rc

# install cudnn 7.0
wget https://nvidia.obs.myhwclouds.com/cudnn-9.0-linux-x64-v7.tgz
tar xvf cudnn-9.0-linux-x64-v7.tgz
cp ./cuda/include/cudnn.h /usr/local/cuda/include
cp ./cuda/include/cudnn.h /usr/local/cuda/include
cp ./cuda/lib64/libcudnn* /usr/local/cuda/lib64
chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

# install tensorflow-gpu 
apt install python-pip -y
pip install tensorflow-gpu==1.6.0 -i https://pypi.douban.com/simple

# tensorflow benchmark
apt install unzip -y
wget https://github.com/tensorflow/benchmarks/archive/tf_benchmark_stage.zip 
unzip tf_benchmark_stage.zip
cd ./benchmarks-tf_benchmark_stage/scripts/tf_cnn_enchmarks  
#python tf_cnn_benchmarks.py






