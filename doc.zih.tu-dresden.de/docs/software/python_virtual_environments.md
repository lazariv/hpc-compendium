# Python Virtual Environments

## TODO

Link to this page from other DA/ML topics.

## copied from alpha_centauri.md

??? comment
    copied from `alpha_centauri.md`. Please remove there if this article is finished

Virtual environments allow users to install additional python packages and create an isolated
run-time environment. We recommend using `virtualenv` for this purpose.

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

## copied from python.md

??? comment
    clear up the following. Maybe leave only conda stuff...

There are two methods of how to work with virtual environments on
Taurus:

1. **virtualenv** is a standard Python tool to create isolated Python environments.
   It is the preferred interface for
   managing installations and virtual environments on Taurus and part of the Python modules.

2. **conda** is an alternative method for managing installations and
virtual environments on Taurus. conda is an open-source package
management system and environment management system from Anaconda. The
conda manager is included in all versions of Anaconda and Miniconda.

**Note:** Keep in mind that you **cannot** use virtualenv for working
with the virtual environments previously created with conda tool and
vice versa! Prefer virtualenv whenever possible.

This example shows how to start working
with **virtualenv** and Python virtual environment (using the module system)

```Bash
srun -p ml -N 1 -n 1 -c 7 --mem-per-cpu=5772 --gres=gpu:1 --time=04:00:00 --pty bash   #Job submission in ml nodes with 1 gpu on 1 node.

mkdir python-environments        # Optional: Create folder. Please use Workspaces!

module load modenv/ml            # Changing the environment. Example output: The following have been reloaded with a version change: 1 modenv/scs5 => modenv/ml
ml av Python                     #Check the available modules with Python
module load Python               #Load default Python. Example output: Module Python/3.7 4-GCCcore-8.3.0 with 7 dependencies loaded
which python                                                   #Check which python are you using
virtualenv --system-site-packages python-environments/envtest  #Create virtual environment
source python-environments/envtest/bin/activate                #Activate virtual environment. Example output: (envtest) bash-4.2$
python                                                         #Start python

from time import gmtime, strftime
print(strftime("%Y-%m-%d %H:%M:%S", gmtime()))                 #Example output: 2019-11-18 13:54:16
deactivate                                                     #Leave the virtual environment
```

The [virtualenv](https://virtualenv.pypa.io/en/latest/) Python module (Python 3) provides support
for creating virtual environments with their own site-directories, optionally isolated from system
site directories. Each virtual environment has its own Python binary (which matches the version of
the binary that was used to create this environment) and can have its own independent set of
installed Python packages in its site directories. This allows you to manage separate package
installations for different projects. It essentially allows us to create a virtual isolated Python
installation and install packages into that virtual installation. When you switch projects, you can
simply create a new virtual environment and not have to worry about breaking the packages installed
in other environments.

In your virtual environment, you can use packages from the (Complete List of
Modules) or if you didn't find what you need you can install required packages
with the command: `pip install`. With the command `pip freeze`, you can see a list of all installed
packages and their versions.

This example shows how to start working with **conda** and virtual
environment (with using module system)

```Bash
srun -p ml -N 1 -n 1 -c 7 --mem-per-cpu=5772 --gres=gpu:1 --time=04:00:00 --pty bash  # Job submission in ml nodes with 1 gpu on 1 node.

module load modenv/ml
mkdir conda-virtual-environments            #create a folder
cd conda-virtual-environments               #go to folder
which python                                #check which python are you using
module load PythonAnaconda/3.6              #load Anaconda module
which python                                #check which python are you using now

conda create -n conda-testenv python=3.6        #create virtual environment with the name conda-testenv and Python version 3.6
conda activate conda-testenv                    #activate conda-testenv virtual environment

conda deactivate                                #Leave the virtual environment
```

You can control where a conda environment
lives by providing a path to a target directory when creating the
environment. For example, the following command will create a new
environment in a workspace located in `scratch`

```Bash
conda create --prefix /scratch/ws/<name_of_your_workspace>/conda-virtual-environment/<name_of_your_environment>
```

Please pay attention,
using srun directly on the shell will lead to blocking and launch an
interactive job. Apart from short test runs, it is **recommended to
launch your jobs into the background by using Slurm**. For that, you can conveniently put
the parameters directly into the job file which you can submit using
`sbatch [options] <job file>.`
