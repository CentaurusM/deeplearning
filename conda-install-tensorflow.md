## Install miniconda or Anaconda
Installing on Linux
1. Download the installer:
Miniconda installer for Linux.
Anaconda installer for Linux.

2. In your Terminal window, run:
* Miniconda:
```
bash Miniconda3-latest-Linux-x86_64.sh
```

* Anaconda:
``` 
bash Anaconda-latest-Linux-x86_64.sh
```

3. Follow the prompts on the installer screens.

If you are unsure about any setting, accept the defaults. You can change them later.

To make the changes take effect, close and then re-open your Terminal window.

Test your installation.


## Install tensorflow
```
conda install tensorflow
or
conda install tensorflow-gpu
or
conda create -n tensorflow_gpu_env tensorflow-gpu=1.10.0
```

## ref
- https://conda.io/docs/user-guide/install/linux.html
- https://conda.io/miniconda.html
- https://www.jiqizhixin.com/articles/2018-10-12-2
- https://docs.anaconda.com/_downloads/Anaconda-Starter-Guide-Cheat-Sheet.pdf
