#!/bin/bash

GPU_NUM=4
# prepare
cd ~

# install epel
wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -ivh epel-release-latest-7.noarch.rpm
yum repolist

# install some package
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/libvdpau-1.1.1-3.el7.x86_64.rpm
rpm -i libvdpau-1.1.1-3.el7.x86_64.rpm

# install nvidia driver
wget http://us.download.nvidia.com/tesla/384.125/nvidia-diag-driver-local-repo-rhel7-384.125-1.0-1.x86_64.rpm
rpm -i nvidia-diag-driver-local-repo-rhel7-384.125-1.0-1.x86_64.rpm
yum clean all
yum install cuda-drivers -y

# install cuda 
wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda-repo-rhel7-9-0-local-9.0.176-1.x86_64-rpm
mv cuda-repo-rhel7-9-0-local-9.0.176-1.x86_64-rpm cuda-repo-rhel7-9-0-local-9.0.176-1.x86_64.rpm
rpm -i cuda-repo-rhel7-9-0-local-9.0.176-1.x86_64.rpm
yum clean all
yum install cuda -y

# set enviroment for cuda 
echo 'export PATH=/usr/local/cuda/bin${PATH:+:${PATH}} 
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} 
' > env_cuda.rc 
source env_cuda.rc 

# install cudnn 9.0 
wget https://nvidia.obs.myhwclouds.com/cudnn-9.0-linux-x64-v7.tgz 
tar xvf cudnn-9.0-linux-x64-v7.tgz 
cp ./cuda/include/cudnn.h /usr/local/cuda/include 
cp ./cuda/lib64/libcudnn* /usr/local/cuda/lib64 
chmod a+r /usr/local/cuda/include/cudnn.h  /usr/local/cuda/lib64/libcudnn*

# install pip
yum install python-pip -y

# install tensorflow-gpu
pip install tensorflow-gpu==1.6.0 -i https://pypi.douban.com/simple
wget https://github.com/tensorflow/benchmarks/archive/tf_benchmark_stage.zip 
unzip tf_benchmark_stage.zip

# tensorflow benchmark
echo "tensorflow benchmarks start"
cd ~/benchmarks-tf_benchmark_stage/scripts/tf_cnn_benchmarks
touch ~/result
echo "vgg16" > ~/result
python tf_cnn_benchmarks.py  --model vgg16  --batch_size=64 --num_gpus=$GPU_NUM --variable_update=replicated | grep "total images/sec" >> ~/result
echo "alexnet" >> ~/result
python tf_cnn_benchmarks.py --num_gpus=$GPU_NUM --batch_size=512 --model=alexnet --variable_update=replicated | grep "total images/sec" >> ~/result
echo "resnet152" >> ~/result
python tf_cnn_benchmarks.py --num_gpus=$GPU_NUM --batch_size=64 --model=resnet152 --variable_update=replicated | grep "total images/sec" >> ~/result
echo "inception3" >> ~/result
python tf_cnn_benchmarks.py  --model inception3  --batch_size=64 --num_gpus=$GPU_NUM --variable_update=replicated | grep "total images/sec" >> ~/result
echo "googlenet" >> ~/result
python tf_cnn_benchmarks.py  --model googlenet  --batch_size=64 --num_gpus=$GPU_NUM --variable_update=replicated | grep "total images/sec" >> ~/result
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

# DISK 
yum install fio
touch ~/disk_result
echo "" > ~/disk_result
echo "###############init disk##################" >> ~/disk_result
echo "init disk" 
fio -ioengine=libaio -group_reporting -direct=1 -rw=write -bs=128k -iodepth=32 -size=100G  -name=/dev/nvme0n1 > ~/disk_result
echo "###############write disk#################" >> ~/disk_result
echo "write disk" 
fio -ioengine=libaio -group_reporting -direct=1 -rw=randwrite -bs=4k -iodepth=128 -runtime=10 -time_based -name=/dev/nvme0n1 >> ~/disk_result
echo "###############read disk##################" >> ~/disk_result
echo "read disk"
fio -ioengine=libaio -group_reporting -direct=1 -rw=randread -bs=4k -iodepth=128 -runtime=10 -time_based  -name=/dev/nvme0n1 >> ~/disk_result




