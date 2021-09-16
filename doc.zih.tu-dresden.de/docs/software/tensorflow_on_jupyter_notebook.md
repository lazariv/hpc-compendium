# Tensorflow on Jupyter Notebook

%RED%Note: This page is under construction<span
class="twiki-macro ENDCOLOR"></span>

Disclaimer: This page dedicates a specific question. For more general
questions please check the JupyterHub webpage.

The Jupyter Notebook is an open-source web application that allows you
to create documents that contain live code, equations, visualizations,
and narrative text. \<span style="font-size: 1em;">Jupyter notebook
allows working with TensorFlow on Taurus with GUI (graphic user
interface) and the opportunity to see intermediate results step by step
of your work. This can be useful for users who dont have huge experience
with HPC or Linux. \</span>

**Prerequisites:** To work with Tensorflow and jupyter notebook you need
\<a href="Login" target="\_blank">access\</a> for the Taurus system and
basic knowledge about Python, Slurm system and the Jupyter notebook.

\<span style="font-size: 1em;"> **This page aims** to introduce users on
how to start working with TensorFlow on the [HPCDA](../jobs_and_resources/hpcda.md) system - part
of the TU Dresden HPC system with a graphical interface.\</span>

## Get started with Jupyter notebook

Jupyter notebooks are a great way for interactive computing in your web
browser. Jupyter allows working with data cleaning and transformation,
numerical simulation, statistical modelling, data visualization and of
course with machine learning.

\<span style="font-size: 1em;">There are two general options on how to
work Jupyter notebooks using HPC. \</span>

-   \<span style="font-size: 1em;">There is \</span>**\<a
    href="JupyterHub" target="\_self">jupyterhub\</a>** on Taurus, where
    you can simply run your Jupyter notebook on HPC nodes. JupyterHub is
    available [here](https://taurus.hrsk.tu-dresden.de/jupyter)
-   For more specific cases you can run a manually created **remote
    jupyter server.** \<span style="font-size: 1em;"> You can find the
    manual server setup [here](deep_learning.md).

\<span style="font-size: 13px;">Keep in mind that with Jupyterhub you
can't work with some special instruments. However general data analytics
tools are available. Still and all, the simplest option for beginners is
using JupyterHub.\</span>

## Virtual environment

\<span style="font-size: 1em;">For working with TensorFlow and python
packages using virtual environments (kernels) is necessary.\</span>

Interactive code interpreters that are used by Jupyter Notebooks are
called kernels.\<br />Creating and using your kernel (environment) has
the benefit that you can install your preferred python packages and use
them in your notebooks.

A virtual environment is a cooperatively isolated runtime environment
that allows Python users and applications to install and upgrade Python
distribution packages without interfering with the behaviour of other
Python applications running on the same system. So the [Virtual
environment](https://docs.python.org/3/glossary.html#term-virtual-environment)
is a self-contained directory tree that contains a Python installation
for a particular version of Python, plus several additional packages. At
its core, the main purpose of Python virtual environments is to create
an isolated environment for Python projects. Python virtual environment is
the main method to work with Deep Learning software as TensorFlow on the
[HPCDA](../jobs_and_resources/hpcda.md) system.

### Conda and Virtualenv

There are two methods of how to work with virtual environments on
Taurus. **Vitualenv (venv)** is a
standard Python tool to create isolated Python environments. We
recommend using venv to work with Tensorflow and Pytorch on Taurus. It
has been integrated into the standard library under
the [venv](https://docs.python.org/3/library/venv.html).
However, if you have reasons (previously created environments etc) you
could easily use conda. The conda is the second way to use a virtual
environment on the Taurus.
[Conda](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html)
is an open-source package management system and environment management system
from the Anaconda.

**Note:** Keep in mind that you **can not** use conda for working with
the virtual environments previously created with Vitualenv tool and vice
versa!

This example shows how to start working with environments and prepare
environment (kernel) for working with Jupyter server

    srun -p ml --gres=gpu:1 -n 1 --pty --mem-per-cpu=8000 bash   #Job submission in ml nodes with 1 gpu on 1 node with 8000 mb.

    module load modenv/ml                    #example output: The following have been reloaded with a version change:  1) modenv/scs5 => modenv/ml

    mkdir python-virtual-environments        #create folder for your environments
    cd python-virtual-environments           #go to folder
    module load TensorFlow                   #load TensorFlow module. Example output: Module TensorFlow/1.10.0-PythonAnaconda-3.6 and 1 dependency loaded.
    which python                             #check which python are you using
    python3 -m venv --system-site-packages env               #create virtual environment "env" which inheriting with global site packages
    source env/bin/activate                                  #Activate virtual environment "env". Example output: (env) bash-4.2$
    module load TensorFlow                                   #load TensorFlow module in the virtual environment

The inscription (env) at the beginning of each line represents that now
you are in the virtual environment.

Now you can check the working capacity of the current environment.

    python                                                       #start python
    import tensorflow as tf
    print(tf.VERSION)                                            #example output: 1.14.0

### Install Ipykernel

Ipykernel is an interactive Python shell and a Jupyter kernel to work
with Python code in Jupyter notebooks. The IPython kernel is the Python
execution backend for Jupyter. The Jupyter Notebook
automatically ensures that the IPython kernel is available.

```
    (env) bash-4.2$ pip install ipykernel                        #example output: Collecting ipykernel
    ...
                                                                 #example output: Successfully installed ... ipykernel-5.1.0 ipython-7.5.0 ...

    (env) bash-4.2$ python -m ipykernel install --user --name env --display-name="env"

                                              #example output: Installed kernelspec my-kernel in .../.local/share/jupyter/kernels/env
    [install now additional packages for your notebooks]
```

Deactivate the virtual environment

    (env) bash-4.2$ deactivate

So now you have a virtual environment with included TensorFlow module.
You can use this workflow for your purposes particularly for the simple
running of your jupyter notebook with Tensorflow code.

## Examples and running the model

Below are brief explanations examples of Jupyter notebooks with
Tensorflow models which you can run on ml nodes of HPC-DA. Prepared
examples of TensorFlow models give you an understanding of how to work
with jupyterhub and tensorflow models. It can be useful and instructive
to start your acquaintance with Tensorflow and HPC-DA system from these
simple examples.

You can use a [remote Jupyter server](../access/jupyterhub.md). For simplicity, we
will recommend using Jupyterhub for our examples.

JupyterHub is available [here](https://taurus.hrsk.tu-dresden.de/jupyter)

Please check updates and details [JupyterHub](../access/jupyterhub.md). However,
the general pipeline can be briefly explained as follows.

After logging, you can start a new session and configure it. There are
simple and advanced forms to set up your session. On the simple form,
you have to choose the "IBM Power (ppc64le)" architecture. You can
select the required number of CPUs and GPUs. For the acquaintance with
the system through the examples below the recommended amount of CPUs and
1 GPU will be enough. With the advanced form, you can use the
configuration with 1 GPU and 7 CPUs. To access all your workspaces
use " / " in the workspace scope.

You need to download the file with a jupyter notebook that already
contains all you need for the start of the work. Please put the file
into your previously created virtual environment in your working
directory or use the kernel for your notebook.

Note: You could work with simple examples in your home directory but according to
[new storage concept](../data_lifecycle/overview.md) please use
[workspaces](../data_lifecycle/workspaces.md) for your study and work projects**.
For this reason, you have to use advanced options and put "/" in "Workspace scope" field.

To download the first example (from the list below) into your previously
created virtual environment you could use the following command:

```
    ws_list
    cd <name_of_your_workspace>                  #go to workspace

    wget https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/TensorFlowOnJupyterNotebook/Mnistmodel.zip
    unzip Example_TensorFlow_Automobileset.zip
```

Also, you could use kernels for all notebooks, not only for them which placed
in your virtual environment. See the [jupyterhub](../access/jupyterhub.md) page.

### Examples:

1\. Simple MNIST model. The MNIST database is a large database of
handwritten digits that is commonly used for \<a
href="<https://en.wikipedia.org/wiki/Training_set>" title="Training
set">t\</a>raining various image processing systems. This model
illustrates using TF-Keras API. \<a
href="<https://www.tensorflow.org/guide/keras>"
target="\_top">Keras\</a> is TensorFlow's high-level API. Tensorflow and
Keras allow us to import and download the MNIST dataset directly from
their API. Recommended parameters for running this model is 1 GPU and 7
cores (28 thread)

[doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/TensorFlowOnJupyterNotebook/Mnistmodel.zip]**todo**(Mnistmodel.zip)

### Running the model

\<span style="font-size: 1em;">Documents are organized with tabs and a
very versatile split-screen feature. On the left side of the screen, you
can open your file. Use 'File-Open from Path' to go to your workspace
(e.g. /scratch/ws/\<username-name_of_your_ws>). You could run each cell
separately step by step and analyze the result of each step. Default
command for running one cell Shift+Enter'. Also, you could run all cells
with the command 'run all cells' how presented on the picture
below\</span>

**todo** \<img alt="Screenshot_from_2019-09-03_15-20-16.png" height="250"
src="Screenshot_from_2019-09-03_15-20-16.png"
title="Screenshot_from_2019-09-03_15-20-16.png" width="436" />

#### Additional advanced models

1\. A simple regression model uses [Automobile
dataset](https://archive.ics.uci.edu/ml/datasets/Automobile). In a
regression problem, we aim to predict the output of a continuous value,
in this case, we try to predict fuel efficiency. This is the simple
model created to present how to work with a jupyter notebook for the
TensorFlow models. Recommended parameters for running this model is 1
GPU and 7 cores (28 thread)

[doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/TensorFlowOnJupyterNotebook/Example_TensorFlow_Automobileset.zip]**todo**(Example_TensorFlow_Automobileset.zip)

2\. The regression model uses the
[dataset](https://archive.ics.uci.edu/ml/datasets/Beijing+PM2.5+Data)
with meteorological data from the Beijing airport and the US embassy.
The data set contains almost 50 thousand on instances and therefore
needs more computational effort. Recommended parameters for running this
model is 1 GPU and 7 cores (28 threads)

[doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/TensorFlowOnJupyterNotebook/Example_TensorFlow_Meteo_airport.zip]**todo**(Example_TensorFlow_Meteo_airport.zip)

**Note**: All examples created only for study purposes. The main aim is
to introduce users of the HPC-DA system of TU-Dresden with TensorFlow
and Jupyter notebook. Examples do not pretend to completeness or
science's significance. Feel free to improve the models and use them for
your study.

-   [Mnistmodel.zip]**todo**(Mnistmodel.zip): Mnistmodel.zip
-   [Example_TensorFlow_Automobileset.zip]**todo**(Example_TensorFlow_Automobileset.zip):
    Example_TensorFlow_Automobileset.zip
-   [Example_TensorFlow_Meteo_airport.zip]**todo**(Example_TensorFlow_Meteo_airport.zip):
    Example_TensorFlow_Meteo_airport.zip
-   [Example_TensorFlow_3D_road_network.zip]**todo**(Example_TensorFlow_3D_road_network.zip):
    Example_TensorFlow_3D_road_network.zip
