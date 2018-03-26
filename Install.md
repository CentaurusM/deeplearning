# Install DeepLearning things 

## Install NVIDIA Driver
### Download proper driver
http://www.nvidia.com/Download/index.aspx?lang=cn

``` 
# eg. TESLA DRIVER FOR LINUX X64 384.81 for cuda 9.0 

wget http://us.download.nvidia.com/tesla/384.81/NVIDIA-Linux-x86_64-384.81.run
```

## Install CUDA

### Environment Setup
```
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```

### Check CUDA
```
cd /usr/local/cuda/samples/1_Utilities/deviceQuery
make
./deviceQuery   # Should print "Result = PASS"
```




## Install cuDNN
http://developer2.download.nvidia.com/compute/machine-learning/cudnn/secure/v7.0.4/prod/Doc/cuDNN-Installation-Guide.pdf?wPiewup07TxDeMsxqM5cGxaclh3i3O8mACtgJpJ6yTYiOmYf3HWv_XcndAHsstVcbCeCN47i4X65F0rowwjRiNffNdzMVq4r9Fur2gViV2ea1TYm1-5zsqS4dnJl-tn4CvEdqc6HF54JmwIlLRjR0-j38Xp6qfxjpXYExnzsCEVAaKS_b5Q4_1Nh-EncdYM4jA

## Install tensorRT
http://docs.nvidia.com/deeplearning/sdk/tensorrt-install-guide/index.html

## Install TensorFlow
https://www.tensorflow.org/install/install_linux



## TensorFlow benchmark
https://github.com/tobigithub/tensorflow-deep-learning/wiki/tf-benchmarks


## Install face-recognition

Depends on Dlib
> Dlib is a modern C++ toolkit containing machine learning algorithms and tools for creating complex software in C++ to solve real world problems. It is used in both industry and academia in a wide range of domains including robotics, embedded devices, mobile phones, and large high performance computing environments. Dlib's open source licensing allows you to use it in any application, free of charge.


```
apt-get install cmake
apt-get install libboost-all-dev
pip install face_recognition -i https://pypi.douban.com/simple
```


pip install opencv-python



## Deploy Tensorflow with Tensorflow Serving via docker  
### Install Docker CE

```
curl -fsSL https://get.docker.com/ | sh
service docker start

```

### Using Tensorflow Serving via Docker
```
git clone https://github.com/tensorflow/serving.git
docker build --pull -t $USER/tensorflow-serving-devel -f ./serving/tensorflow_serving/tools/docker/Dockerfile.devel .
docker run -it $USER/tensorflow-serving-devel

git clone --recurse-submodules https://github.com/tensorflow/serving
cd serving/tensorflow
./configure
cd ..
bazel test tensorflow_serving/...

```


### tf-benchmark
```
apt install python-pip
pip install virtualenv 
virtualenv --system-site-package tensorflow-env
source tensorflow-env/bin/activate
pip install   -i https://pypi.tuna.tsinghua.edu.cn/simple/   https://mirrors.tuna.tsinghua.edu.cn/tensorflow/linux/gpu/tensorflow-0.11.0-cp27-none-linux_x86_64.whll
cd lib/python2.7/site-packages/tensorflow/models/
cd ~/tensorflow-env/lib/python2.7/site-packages/tensorflow/models/image/alexnet/
```




