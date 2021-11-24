# Python Virtual Environments

Virtual environments allow users to install additional Python packages and create an isolated
run-time environment. We recommend using `virtualenv` for this purpose. In your virtual environment,
you can use packages from the [modules list](modules.md) or if you didn't find what you need you can
install required packages with the command: `pip install`. With the command `pip freeze`, you can
see a list of all installed packages and their versions.

There are two methods of how to work with virtual environments on ZIH systems:

1. **virtualenv** is a standard Python tool to create isolated Python environments.
   It is the preferred interface for
   managing installations and virtual environments on ZIH system and part of the Python modules.

2. **conda** is an alternative method for managing installations and
virtual environments on ZIH system. conda is an open-source package
management system and environment management system from Anaconda. The
conda manager is included in all versions of Anaconda and Miniconda.

!!! warning

    Keep in mind that you **cannot** use virtualenv for working
    with the virtual environments previously created with conda tool and
    vice versa! Prefer virtualenv whenever possible.

## Python Virtual Environment

This example shows how to start working with **virtualenv** and Python virtual environment (using
the module system).

!!! hint

    We recommend to use [workspaces](../data_lifecycle/workspaces.md) for your virtual
    environments.

At first, we check available Python modules and load the preferred version:

```console
marie@compute$ module avail Python    #Check the available modules with Python
[...]
marie@compute$ module load Python    #Load default Python
Module Python/3.7 2-GCCcore-8.2.0 with 10 dependencies loaded
marie@compute$ which python    #Check which python are you using
/sw/installed/Python/3.7.2-GCCcore-8.2.0/bin/python
```

Then create the virtual environment and activate it.

```console
marie@compute$ ws_allocate -F scratch python_virtual_environment 1
Info: creating workspace.
/scratch/ws/1/python_virtual_environment
[...]
marie@compute$ virtualenv --system-site-packages /scratch/ws/1/python_virtual_environment/env  #Create virtual environment
[...]
marie@compute$ source /scratch/ws/1/python_virtual_environment/env/bin/activate    #Activate virtual environment. Example output: (envtest) bash-4.2$
```

Now you can work in this isolated environment, without interfering with other tasks running on the
system. Note that the inscription (env) at the beginning of each line represents that you are in
the virtual environment. You can deactivate the environment as follows:

```console
(env) marie@compute$ deactivate    #Leave the virtual environment
```

## Conda Virtual Environment

This example shows how to start working with **conda** and virtual environment (with using module
system). At first, we use an interactive job and create a directory for the conda virtual
environment:

```console
marie@compute$ ws_allocate -F scratch conda_virtual_environment 1
Info: creating workspace.
/scratch/ws/1/conda_virtual_environment
[...]
```

Then, we load Anaconda, create an environment in our directory and activate the environment:

```console
marie@compute$ module load Anaconda3    #load Anaconda module
marie@compute$ conda create --prefix /scratch/ws/1/conda_virtual_environment/conda-env python=3.6    #create virtual environment with Python version 3.6
marie@compute$ conda activate /scratch/ws/1/conda_virtual_environment/conda-env    #activate conda-env virtual environment
```

Now you can work in this isolated environment, without interfering with other tasks running on the
system. Note that the inscription (conda-env) at the beginning of each line represents that you
are in the virtual environment. You can deactivate the conda environment as follows:

```console
(conda-env) marie@compute$ conda deactivate    #Leave the virtual environment
```

??? example

    This is an example on partition Alpha. The example creates a virtual environment, and installs
    the package `torchvision` with pip.
    ```console
    marie@login$ srun --partition=alpha-interactive -N=1 --gres=gpu:1 --time=01:00:00 --pty bash
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
