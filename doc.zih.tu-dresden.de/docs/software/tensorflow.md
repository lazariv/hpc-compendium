# TensorFlow

TensorFlow is a free end-to-end open-source software library for dataflow and differentiable
programming across many tasks. It is a symbolic math library, used primarily for machine learning
applications. It has a comprehensive, flexible ecosystem of tools, libraries and community
resources.

Please check the software modules list via

    module spider TensorFlow

to find out, which TensorFlow modules are available on your partition.

On ZIH systems, TensorFlow 2 is the default module version. For compatibility hints between TF2 and
TF1, see the corresponding [section](#compatibility-tf2-and-tf1) below.

We recommend using **Alpha** and/or **ML** partitions when working with machine learning workflows
and the TensorFlow library. You can find detailed hardware specification
[here](../jobs_and_resources/hardware_taurus.md).

## TensorFlow Console

On the **Alpha** partition load the module environment:

```console
marie@login$ srun -p alpha --gres=gpu:1 -n 1 -c 7 --pty --mem-per-cpu=8000 bash   #Job submission on alpha nodes with 1 gpu on 1 node with 8000 mb.
marie@romeo$ module load modenv/scs5
```

On the **ML** partition load the module environment:

```console
marie@login$ srun -p ml --gres=gpu:1 -n 1 -c 7 --pty --mem-per-cpu=8000 bash    #Job submission in ml nodes with 1 gpu on 1 node with 8000 mb.
marie@ml$ module load modenv/ml    #example output: The following have been reloaded with a version change:  1) modenv/scs5 => modenv/ml
```

This example shows how to install and start working with TensorFlow (with using modules system)

```console
marie@ml$ module load TensorFlow    #load TensorFlow module. example output: Module TensorFlow/1.10.0-PythonAnaconda-3.6 and 1 dependency loaded.
```

Now we check that we can access TensorFlow. One example is tensorflow-test:

```console
marie@ml$ tensorflow-test    #example output: Basic test of tensorflow - A Hello World!!!...
```

As another example we use a python virtual environment and import TensorFlow.

```console
marie@ml$ mkdir python-environments    #create folder 
marie@ml$ which python    #check which python are you using
marie@ml$ virtualenvv --system-site-packages python-environments/env    #create virtual environment "env" which inheriting with global site packages
marie@ml$ source python-environments/env/bin/activate    #activate virtual environment "env". Example output: (env) bash-4.2$
marie@ml$ python    #start python
>>> import tensorflow as tf
>>> print(tf.VERSION)    #example output: 1.10.0
```

## TensorFlow in JupyterHub

In addition to using interactive and batch jobs, it is possible to work with TensorFlow using
JupyterHub. The production and test environments of JupyterHub contain Python and R kernels, that
both come with a TensorFlow support.

![TensorFlow module in JupyterHub](misc/tensorflow_jupyter_module.png)
{: align="center"}

## TensorFlow in Containers

Another option to use TensorFlow are containers. In the HPC domain, the
[Singularity](https://singularity.hpcng.org/) container system is a widely used tool. In the
following example, we use the tensorflow-test in a Singularity container:

```console
marie@login$ srun -p ml --gres=gpu:1 -n 1 -c 7 --pty --mem-per-cpu=8000 bash    #Job submission in ml nodes with 1 gpu on 1 node with 8000 mb.
marie@ml$ singularity shell --nv /scratch/singularity/powerai-1.5.3-all-ubuntu16.04-py3.img
marie@ml$ export PATH=/opt/anaconda3/bin:$PATH                                               
marie@ml$ source activate /opt/anaconda3    #activate conda environment
marie@ml$ . /opt/DL/tensorflow/bin/tensorflow-activate
marie@ml$ tensorflow-test    #example output: Basic test of tensorflow - A Hello World!!!...
```

## TensorFlow with Python or R

For further information on TensorFlow in combination with Python see
[here](data_analytics_with_python.md), for R see [here](data_analytics_with_r.md).

## Compatibility TF2 and TF1

TensorFlow 2.0 includes many API changes, such as reordering arguments, renaming symbols, and
changing default values for parameters. Thus in some cases, it makes code written for the TensorFlow
1 not compatible with TensorFlow 2. However, If you are using the high-level APIs (tf.keras) there
may be little or no action you need to take to make your code fully [TensorFlow
2.0](https://www.tensorflow.org/guide/migrate) compatible. It is still possible to run 1.X code,
unmodified (except for contrib), in TensorFlow 2.0:

```Python
import tensorflow.compat.v1 as tf
tf.disable_v2_behavior()    #instead of "import tensorflow as tf"
```

To make the transition to TF 2.0 as seamless as possible, the TensorFlow team has created the
tf_upgrade_v2 utility to help transition legacy code to the new API.

## Additional libraries

The following NVIDIA libraries are available on all nodes:

|       |                                       |
|-------|---------------------------------------|
| NCCL  | /usr/local/cuda/targets/ppc64le-linux |
| cuDNN | /usr/local/cuda/targets/ppc64le-linux |

Note: For optimal NCCL performance it is recommended to set the
**NCCL_MIN_NRINGS** environment variable during execution. You can try
different values but 4 should be a pretty good starting point.

```console
export NCCL_MIN_NRINGS=4
```
