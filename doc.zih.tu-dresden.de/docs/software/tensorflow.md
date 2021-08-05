# TensorFlow

## Introduction

This is an introduction of how to start working with TensorFlow and run
machine learning applications on the [HPC-DA](../jobs_and_resources/hpcda.md) system of Taurus.

\<span style="font-size: 1em;">On the machine learning nodes (machine
learning partition), you can use the tools from [IBM PowerAI](power_ai.md) or the other
modules. PowerAI is an enterprise software distribution that combines popular open-source
deep learning frameworks, efficient AI development tools (Tensorflow, Caffe, etc). For
this page and examples was used [PowerAI version 1.5.4](https://www.ibm.com/support/knowledgecenter/en/SS5SF7_1.5.4/navigation/pai_software_pkgs.html)

[TensorFlow](https://www.tensorflow.org/guide/) is a free end-to-end open-source
software library for dataflow and differentiable programming across many
tasks. It is a symbolic math library, used primarily for machine
learning applications. It has a comprehensive, flexible ecosystem of tools, libraries and
community resources. It is available on taurus along with other common machine
learning packages like Pillow, SciPY, Numpy.

**Prerequisites:** To work with Tensorflow on Taurus, you obviously need
[access](../access/ssh_login.md) for the Taurus system and basic knowledge about Python, SLURM system.

**Aim** of this page is to introduce users on how to start working with
TensorFlow on the \<a href="HPCDA" target="\_self">HPC-DA\</a> system -
part of the TU Dresden HPC system.

There are three main options on how to work with Tensorflow on the
HPC-DA: **1.** **Modules,** **2.** **JupyterNotebook, 3. Containers**. The best option is
to use [module system](../software/runtime_environment.md#Module_Environments) and
Python virtual environment. Please see the next chapters and the [Python page](python.md) for the
HPC-DA system.

The information about the Jupyter notebook and the **JupyterHub** could
be found [here](../access/jupyterhub.md). The use of
Containers is described [here](tensorflow_container_on_hpcda.md).

On Taurus, there exist different module environments, each containing a set
of software modules. The default is *modenv/scs5* which is already loaded,
however for the HPC-DA system using the "ml" partition you need to use *modenv/ml*.
To find out which partition are you using use: `ml list`.
You can change the module environment with the command:

    module load modenv/ml

The machine learning partition is based on the PowerPC Architecture (ppc64le)
(Power9 processors), which means that the software built for x86_64 will not
work on this partition, so you most likely can't use your already locally
installed packages on Taurus. Also, users need to use the modules which are
specially made for the ml partition (from modenv/ml) and not for the rest
of Taurus (e.g. from modenv/scs5).

Each node on the ml partition has 6x Tesla V-100 GPUs, with 176 parallel threads
on 44 cores per node (Simultaneous multithreading (SMT) enabled) and 256GB RAM.
The specification could be found [here](../jobs_and_resources/power9.md).

%RED%Note:<span class="twiki-macro ENDCOLOR"></span> Users should not
reserve more than 28 threads per each GPU device so that other users on
the same node still have enough CPUs for their computations left.

## Get started with Tensorflow

This example shows how to install and start working with TensorFlow
(with using modules system) and the python virtual environment. Please,
check the next chapter for the details about the virtual environment.

    srun -p ml --gres=gpu:1 -n 1 -c 7 --pty --mem-per-cpu=8000 bash   #Job submission in ml nodes with 1 gpu on 1 node with 8000 mb.

    module load modenv/ml                    #example output: The following have been reloaded with a version change:  1) modenv/scs5 => modenv/ml

    mkdir python-environments                #create folder
    module load TensorFlow                   #load TensorFlow module. Example output: Module TensorFlow/1.10.0-PythonAnaconda-3.6 and 1 dependency loaded.
    which python                             #check which python are you using
    virtualenvv --system-site-packages python-environments/env   #create virtual environment "env" which inheriting with global site packages
    source python-environments/env/bin/activate                  #Activate virtual environment "env". Example output: (env) bash-4.2$
    python                                                       #start python
    import tensorflow as tf
    print(tf.VERSION)                                            #example output: 1.10.0

On the machine learning nodes, you can use the tools from [IBM Power
AI](power_ai.md).

## Interactive Session Examples

### Tensorflow-Test

    tauruslogin6 :~> srun -p ml --gres=gpu:1 -n 1 --pty --mem-per-cpu=10000 bash
    srun: job 4374195 queued and waiting for resources
    srun: job 4374195 has been allocated resources
    taurusml22 :~> ANACONDA2_INSTALL_PATH='/opt/anaconda2'
    taurusml22 :~> ANACONDA3_INSTALL_PATH='/opt/anaconda3'
    taurusml22 :~> export PATH=$ANACONDA3_INSTALL_PATH/bin:$PATH
    taurusml22 :~> source /opt/DL/tensorflow/bin/tensorflow-activate
    taurusml22 :~> tensorflow-test
    Basic test of tensorflow - A Hello World!!!...

    #or:
    taurusml22 :~> module load TensorFlow/1.10.0-PythonAnaconda-3.6

Or to use the whole node: `--gres=gpu:6 --exclusive --pty`

### In Singularity container:

    rotscher@tauruslogin6:~&gt; srun -p ml --gres=gpu:6 --pty bash
    [rotscher@taurusml22 ~]$ singularity shell --nv /scratch/singularity/powerai-1.5.3-all-ubuntu16.04-py3.img
    Singularity powerai-1.5.3-all-ubuntu16.04-py3.img:~&gt; export PATH=/opt/anaconda3/bin:$PATH
    Singularity powerai-1.5.3-all-ubuntu16.04-py3.img:~&gt; . /opt/DL/tensorflow/bin/tensorflow-activate
    Singularity powerai-1.5.3-all-ubuntu16.04-py3.img:~&gt; tensorflow-test

## Additional libraries

The following NVIDIA libraries are available on all nodes:

|       |                                       |
|-------|---------------------------------------|
| NCCL  | /usr/local/cuda/targets/ppc64le-linux |
| cuDNN | /usr/local/cuda/targets/ppc64le-linux |

Note: For optimal NCCL performance it is recommended to set the
**NCCL_MIN_NRINGS** environment variable during execution. You can try
different values but 4 should be a pretty good starting point.

    export NCCL_MIN_NRINGS=4

\<span style="color: #222222; font-size: 1.385em;">HPC\</span>

The following HPC related software is installed on all nodes:

|                  |                        |
|------------------|------------------------|
| IBM Spectrum MPI | /opt/ibm/spectrum_mpi/ |
| PGI compiler     | /opt/pgi/              |
| IBM XLC Compiler | /opt/ibm/xlC/          |
| IBM XLF Compiler | /opt/ibm/xlf/          |
| IBM ESSL         | /opt/ibmmath/essl/     |
| IBM PESSL        | /opt/ibmmath/pessl/    |

## TensorFlow 2

[TensorFlow
2.0](https://blog.tensorflow.org/2019/09/tensorflow-20-is-now-available.html)
is a significant milestone for TensorFlow and the community. There are
multiple important changes for users. TensorFlow 2.0 removes redundant
APIs, makes APIs more consistent (Unified RNNs, Unified Optimizers), and
better integrates with the Python runtime with Eager execution. Also,
TensorFlow 2.0 offers many performance improvements on GPUs.

There are a number of TensorFlow 2 modules for both ml and scs5 modenvs
on Taurus. Please check\<a href="SoftwareModulesList" target="\_blank">
the software modules list\</a> for the information about available
modules or use

    module spider TensorFlow

%RED%Note:<span class="twiki-macro ENDCOLOR"></span> Tensorflow 2 will
be loaded by default when loading the Tensorflow module without
specifying the version.

\<span style="font-size: 1em;">TensorFlow 2.0 includes many API changes,
such as reordering arguments, renaming symbols, and changing default
values for parameters. Thus in some cases, it makes code written for the
TensorFlow 1 not compatible with TensorFlow 2. However, If you are using
the high-level APIs (tf.keras) there may be little or no action you need
to take to make your code fully TensorFlow 2.0 \<a
href="<https://www.tensorflow.org/guide/migrate>"
target="\_blank">compatible\</a>. It is still possible to run 1.X code,
unmodified ( [except for
contrib](https://github.com/tensorflow/community/blob/master/rfcs/20180907-contrib-sunset.md)),
in TensorFlow 2.0:\</span>

    import tensorflow.compat.v1 as tf
    tf.disable_v2_behavior()                                  #instead of "import tensorflow as tf"

To make the transition to TF 2.0 as seamless as possible, the TensorFlow
team has created the
[`tf_upgrade_v2`](https://www.tensorflow.org/guide/upgrade) utility to
help transition legacy code to the new API.

## FAQ:

Q: Which module environment should I use? modenv/ml, modenv/scs5,
modenv/hiera

A: On the ml partition use modenv/ml, on rome and gpu3 use modenv/hiera,
else stay with the default of modenv/scs5.

Q: How to change the module environment and know more about modules?

A: [Modules](../software/runtime_environment.md#Modules)
