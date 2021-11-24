# Alpha Centauri - Multi-GPU Sub-Cluster

The sub-cluster "Alpha Centauri" had been installed for AI-related computations (ScaDS.AI).
It has 34 nodes, each with:

* 8 x NVIDIA A100-SXM4 (40 GB RAM)
* 2 x AMD EPYC CPU 7352 (24 cores) @ 2.3 GHz with multi-threading enabled
* 1 TB RAM 3.5 TB `/tmp` local NVMe device
* Hostnames: `taurusi[8001-8034]`
* Slurm partition `alpha` for batch jobs and `alpha-interactive` for interactive jobs

!!! note

    The NVIDIA A100 GPUs may only be used with **CUDA 11** or later. Earlier versions do not
    recognize the new hardware properly. Make sure the software you are using is built with CUDA11.

## Usage

### Modules

The easiest way is using the [module system](../software/modules.md).
The software for the partition alpha is available in `modenv/hiera` module environment.

To check the available modules for `modenv/hiera`, use the command

```console
marie@alpha$ module spider <module_name>
```

For example, to check whether PyTorch is available in version 1.7.1:

```console
marie@alpha$ module spider PyTorch/1.7.1

-----------------------------------------------------------------------------------------------------------------------------------------
  PyTorch: PyTorch/1.7.1
-----------------------------------------------------------------------------------------------------------------------------------------
    Description:
      Tensors and Dynamic neural networks in Python with strong GPU acceleration. PyTorch is a deep learning framework that puts Python
      first.


    You will need to load all module(s) on any one of the lines below before the "PyTorch/1.7.1" module is available to load.

      modenv/hiera  GCC/10.2.0  CUDA/11.1.1  OpenMPI/4.0.5

[...]
```

The output of `module spider <module_name>` provides hints which dependencies should be loaded beforehand:

```console
marie@alpha$ module load modenv/hiera GCC/10.2.0 CUDA/11.1.1 OpenMPI/4.0.5
Module GCC/10.2.0, CUDA/11.1.1, OpenMPI/4.0.5 and 15 dependencies loaded.
marie@alpha$ module avail PyTorch
-------------------------------------- /sw/modules/hiera/all/MPI/GCC-CUDA/10.2.0-11.1.1/OpenMPI/4.0.5 ---------------------------------------
   PyTorch/1.7.1 (L)    PyTorch/1.9.0 (D)
marie@alpha$ module load PyTorch/1.7.1
Module PyTorch/1.7.1 and 39 dependencies loaded.
marie@alpha$ python -c "import torch; print(torch.__version__); print(torch.cuda.is_available())"
1.7.1
True
```

### Python Virtual Environments

[Virtual environments](../software/python_virtual_environments.md) allow users to install
additional python packages and create an isolated
runtime environment. We recommend using `virtualenv` for this purpose.

```console
marie@login$ srun --partition=alpha-interactive --nodes=1 --cpus-per-task=1 --gres=gpu:1 --time=01:00:00 --pty bash
marie@alpha$ mkdir python-environments                               # please use workspaces
marie@alpha$ module load modenv/hiera GCC/10.2.0 CUDA/11.1.1 OpenMPI/4.0.5 PyTorch
Module GCC/10.2.0, CUDA/11.1.1, OpenMPI/4.0.5, PyTorch/1.9.0 and 54 dependencies loaded.
marie@alpha$ which python
/sw/installed/Python/3.8.6-GCCcore-10.2.0/bin/python
marie@alpha$ pip list
[...]
marie@alpha$ virtualenv --system-site-packages python-environments/my-torch-env
created virtual environment CPython3.8.6.final.0-64 in 42960ms
  creator CPython3Posix(dest=~/python-environments/my-torch-env, clear=False, global=True)
  seeder FromAppData(download=False, pip=bundle, setuptools=bundle, wheel=bundle, via=copy, app_data_dir=~/.local/share/virtualenv)
    added seed packages: pip==21.1.3, setuptools==57.2.0, wheel==0.36.2
  activators BashActivator,CShellActivator,FishActivator,PowerShellActivator,PythonActivator,XonshActivator
marie@alpha$ source python-environments/my-torch-env/bin/activate
(my-torch-env) marie@alpha$ pip install torchvision
[...]
Installing collected packages: torchvision
Successfully installed torchvision-0.10.0
[...]
(my-torch-env) marie@alpha$ python -c "import torchvision; print(torchvision.__version__)"
0.10.0+cu102
(my-torch-env) marie@alpha$ deactivate
```

### JupyterHub

[JupyterHub](../access/jupyterhub.md) can be used to run Jupyter notebooks on Alpha Centauri
sub-cluster. As a starting configuration, a "GPU (NVIDIA Ampere A100)" preset can be used
in the advanced form. In order to use latest software, it is recommended to choose
`fosscuda-2020b` as a standard environment. Already installed modules from `modenv/hiera`
can be preloaded in "Preload modules (modules load):" field.

### Containers

Singularity containers enable users to have full control of their software environment.
For more information, see the [Singularity container details](../software/containers.md).

Nvidia
[NGC](https://developer.nvidia.com/blog/how-to-run-ngc-deep-learning-containers-with-singularity/)
containers can be used as an effective solution for machine learning related tasks. (Downloading
containers requires registration). Nvidia-prepared containers with software solutions for specific
scientific problems can simplify the deployment of deep learning workloads on HPC. NGC containers
have shown consistent performance compared to directly run code.
