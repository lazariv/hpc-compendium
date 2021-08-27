# TensorFlow

TensorFlow is a free end-to-end open-source software library for dataflow and differentiable
programming across many tasks. It is a symbolic math library, used primarily for machine learning
applications. It has a comprehensive, flexible ecosystem of tools, libraries and community
resources.

Please check the software modules list via

```console
marie@compute$ module spider TensorFlow
```

to find out, which TensorFlow modules are available on your partition.

On ZIH systems, TensorFlow 2 is the default module version. For compatibility hints between TF2 and
TF1, see the corresponding [section](#compatibility-tf2-and-tf1) below.

We recommend using **Alpha** and/or **ML** partitions when working with machine learning workflows
and the TensorFlow library. You can find detailed hardware specification
[here](../jobs_and_resources/hardware_taurus.md).

## TensorFlow Console

On the **Alpha** partition load the module environment:

```console
marie@login$ srun -p alpha --gres=gpu:1 -n 1 -c 7 --pty --mem-per-cpu=8000 bash   #Job submission on alpha nodes with 1 gpu on 1 node with 8000 Mb per CPU
marie@alpha$ module load modenv/scs5
```

On the **ML** partition load the module environment:

```console
marie@login$ srun -p ml --gres=gpu:1 -n 1 -c 7 --pty --mem-per-cpu=8000 bash    #Job submission in ml nodes with 1 gpu on 1 node with 8000 Mb per CPU
marie@ml$ module load modenv/ml    #example output: The following have been reloaded with a version change:  1) modenv/scs5 => modenv/ml
```

This example shows how to install and start working with TensorFlow (with using modules system)

```console
marie@ml$ module load TensorFlow  
Module TensorFlow/1.10.0-PythonAnaconda-3.6 and 1 dependency loaded.
```

Now we check that we can access TensorFlow. One example is tensorflow-test:

```console
marie@ml$ tensorflow-test    
Basic test of tensorflow - A Hello World!!!...
```

??? example
    Following example shows how to create python virtual environment and import TensorFlow.

    ```console
    marie@ml$ mkdir python-environments    #create folder 
    marie@ml$ which python    #check which python are you using
    /sw/installed/Python/3.7.4-GCCcore-8.3.0/bin/python
    marie@ml$ virtualenv --system-site-packages python-environments/env    #create virtual environment "env" which inheriting with global site packages
    [...]
    marie@ml$ source python-environments/env/bin/activate    #activate virtual environment "env". Example output: (env) bash-4.2$
    marie@ml$ python -c "import tensorflow as tf; print(tf.__version__)"
    ```

## TensorFlow in JupyterHub

In addition to using interactive and batch jobs, it is possible to work with TensorFlow using
JupyterHub. The production and test environments of JupyterHub contain Python and R kernels, that
both come with a TensorFlow support. However, you can specify the TensorFlow version when spawning
the notebook by pre-loading a specific TensorFlow module:

![TensorFlow module in JupyterHub](misc/tensorflow_jupyter_module.png)
{: align="center"}

??? hint
    You can also define your own Jupyter kernel for more specific tasks. Please read there
    documentation about JupyterHub, Jupyter kernels and virtual environments
    [here](../../access/jupyterhub/#creating-and-using-your-own-environment).

## TensorFlow in Containers

Another option to use TensorFlow are containers. In the HPC domain, the
[Singularity](https://singularity.hpcng.org/) container system is a widely used tool. In the
following example, we use the tensorflow-test in a Singularity container:

```console
marie@login$ srun -p ml --gres=gpu:1 -n 1 -c 7 --pty --mem-per-cpu=8000 bash    
marie@ml$ singularity shell --nv /scratch/singularity/powerai-1.5.3-all-ubuntu16.04-py3.img
marie@ml$ export PATH=/opt/anaconda3/bin:$PATH                                               
marie@ml$ source activate /opt/anaconda3    #activate conda environment
marie@ml$ . /opt/DL/tensorflow/bin/tensorflow-activate
marie@ml$ tensorflow-test
Basic test of tensorflow - A Hello World!!!...
```

## TensorFlow with Python or R

For further information on TensorFlow in combination with Python see
[here](data_analytics_with_python.md), for R see [here](data_analytics_with_r.md).

## Distributed TensorFlow

For details on how to run TensorFlow with multiple GPUs and/or multiple nodes, see
[distributed training](distributed_training.md).

## Compatibility TF2 and TF1

TensorFlow 2.0 includes many API changes, such as reordering arguments, renaming symbols, and
changing default values for parameters. Thus in some cases, it makes code written for the TensorFlow
1 not compatible with TensorFlow 2. However, If you are using the high-level APIs (tf.keras) there
may be little or no action you need to take to make your code fully [TensorFlow
2.0](https://www.tensorflow.org/guide/migrate) compatible. It is still possible to run 1.X code,
unmodified (except for contrib), in TensorFlow 2.0:

```python
import tensorflow.compat.v1 as tf
tf.disable_v2_behavior()    #instead of "import tensorflow as tf"
```

To make the transition to TF 2.0 as seamless as possible, the TensorFlow team has created the
tf_upgrade_v2 utility to help transition legacy code to the new API.

## Keras

[Keras](https://keras.io) is a high-level neural network API, written in Python and capable
of running on top of TensorFlow. Please check the software modules list via

```console
marie@compute$ module spider Keras
```

to find out, which Keras modules are available on your partition. TensorFlow should be automatically
loaded as a dependency. After loading the module, you can use Keras as usual.
