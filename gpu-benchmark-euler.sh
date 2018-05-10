#!/bin/bash

GPU_NUM=1

if [ $GPU_NUM -eq 1 ]; then
 UPDATE=''
else
 UPDATE='--variable_update=replicated'
fi

# prepare
cd ~

# install epel
EPEL_FILE="/root/epel-release-latest-7.noarch.rpm"
if [ ! -f "$EPEL_FILE" ]; then
wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
fi
rpm -ivh epel-release-latest-7.noarch.rpm
yum repolist

# install some package
LIBVDPAU_FILE="/root/libvdpau-1.1.1-3.el7.x86_64.rpm"
if [ ! -f "$LIBVDPAU_FILE" ]; then
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/libvdpau-1.1.1-3.el7.x86_64.rpm
fi
rpm -i libvdpau-1.1.1-3.el7.x86_64.rpm

# install nvidia driver
NVIDIA_DRIVER="/root/nvidia-diag-driver-local-repo-rhel7-384.125-1.0-1.x86_64.rpm"
if [ ! -f "$NVIDIA_DRIVER" ]; then
wget http://us.download.nvidia.com/tesla/384.125/nvidia-diag-driver-local-repo-rhel7-384.125-1.0-1.x86_64.rpm
fi
rpm -i nvidia-diag-driver-local-repo-rhel7-384.125-1.0-1.x86_64.rpm
yum clean all
yum install cuda-drivers -y

# install cuda 
CUDA_FILE="/root/cuda-repo-rhel7-9-0-local-9.0.176-1.x86_64.rpm"
if [ ! -f "$CUDA_FILE" ]; then
wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda-repo-rhel7-9-0-local-9.0.176-1.x86_64-rpm
mv cuda-repo-rhel7-9-0-local-9.0.176-1.x86_64-rpm cuda-repo-rhel7-9-0-local-9.0.176-1.x86_64.rpm
fi 
rpm -i cuda-repo-rhel7-9-0-local-9.0.176-1.x86_64.rpm
yum clean all
yum install cuda -y

# set enviroment for cuda 
echo 'export PATH=/usr/local/cuda/bin${PATH:+:${PATH}} 
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} 
' > ~/env_cuda.rc 
source ~/env_cuda.rc 

# install cudnn 9.0 
CUDNN_FILE="/root/cudnn-9.0-linux-x64-v7.tgz"
if [ ! -f "$CUDNN_FILE" ]; then
wget https://nvidia.obs.myhwclouds.com/cudnn-9.0-linux-x64-v7.tgz 
fi
tar xvf cudnn-9.0-linux-x64-v7.tgz 
cp ./cuda/include/cudnn.h /usr/local/cuda/include 
cp ./cuda/lib64/libcudnn* /usr/local/cuda/lib64 
chmod a+r /usr/local/cuda/include/cudnn.h  /usr/local/cuda/lib64/libcudnn*

# install pip
yum install python-pip -y

# install tensorflow-gpu
pip install tensorflow-gpu==1.6.0 -i https://pypi.douban.com/simple
BENCHMARK_FILE="/root/tf_benchmark_stage.zip"
if [ ! -f "$BENCHMARK_FILE" ]; then
wget https://github.com/tensorflow/benchmarks/archive/tf_benchmark_stage.zip 
fi
unzip -o tf_benchmark_stage.zip

# tensorflow benchmark
echo "tensorflow benchmarks start"
cd ~/benchmarks-tf_benchmark_stage/scripts/tf_cnn_benchmarks
touch ~/result
echo "vgg16" > ~/result
python tf_cnn_benchmarks.py  --model vgg16  --batch_size=64 --num_gpus=$GPU_NUM $UPDATE | grep "total images/sec" >> ~/result
echo "alexnet" >> ~/result
python tf_cnn_benchmarks.py --num_gpus=$GPU_NUM --batch_size=512 --model=alexnet $UPDATE | grep "total images/sec" >> ~/result
echo "resnet152" >> ~/result
python tf_cnn_benchmarks.py --num_gpus=$GPU_NUM --batch_size=64 --model=resnet152 $UPDATE | grep "total images/sec" >> ~/result
echo "inception3" >> ~/result
python tf_cnn_benchmarks.py  --model inception3  --batch_size=64 --num_gpus=$GPU_NUM $UPDATE | grep "total images/sec" >> ~/result
echo "googlenet" >> ~/result
python tf_cnn_benchmarks.py  --model googlenet  --batch_size=64 --num_gpus=$GPU_NUM $UPDATE | grep "total images/sec" >> ~/result
echo "tensorflow benchmarks end"

# bandwidth test
BANDWIDTH_PATH='/usr/local/cuda/samples/1_Utilities/bandwidthTest'
cd $BANDWIDTH_PATH
make
./bandwidthTest >> ~/result

# P2P
P2P_PATH='/usr/local/cuda/samples/0_Simple/simpleP2P'
cd $P2P_PATH
make
./simpleP2P >> ~/result 

# P2P bandwidth
P2P_BANDWIDTH='/usr/local/cuda/samples/1_Utilities/p2pBandwidthLatencyTest'
cd $P2P_BANDWIDTH
make
./p2pBandwidthLatencyTest >> ~/result

# DISK 
yum install fio -y
touch ~/disk_result
echo "" > ~/disk_result
echo "###############init disk##################" >> ~/disk_result
echo "init disk" 
fio -ioengine=libaio -group_reporting -direct=1 -rw=write -bs=128k -iodepth=32 -size=100G  -name=/dev/nvme0n1 > ~/disk_result
echo "###############write disk#################" >> ~/disk_result
echo "write disk" 
fio -ioengine=libaio -group_reporting -direct=1 -rw=randwrite -bs=4k -iodepth=128 -runtime=100 -time_based -name=/dev/nvme0n1 >> ~/disk_result
echo "###############read disk##################" >> ~/disk_result
echo "read disk"
fio -ioengine=libaio -group_reporting -direct=1 -rw=randread -bs=4k -iodepth=128 -runtime=100 -time_based  -name=/dev/nvme0n1 >> ~/disk_result



