# PyTorch

[PyTorch](https://pytorch.org/){:target="_blank"} is an open-source machine learning framework.
It is an optimized tensor library for deep learning using GPUs and CPUs.
PyTorch is a machine learning tool developed by Facebooks AI division to process large-scale
object detection, segmentation, classification, etc.
PyTorch provides a core data structure, the tensor, a multi-dimensional array that shares many
similarities with Numpy arrays.

Please check the software modules list via

```console
marie@login$ module spider pytorch
```

to find out, which PyTorch modules are available on your partition.

We recommend using partitions alpha and/or ml when working with machine learning workflows
and the PyTorch library.
You can find detailed hardware specification in our
[hardware documentation](../jobs_and_resources/hardware_overview.md).

## PyTorch Console

On the partition `alpha`, load the module environment:

```console
marie@login$ srun -p alpha --gres=gpu:1 -n 1 -c 7 --pty --mem-per-cpu=800 bash #Job submission on alpha nodes with 1 gpu on 1 node with 800 Mb per CPU
marie@alpha$ module load modenv/hiera  GCC/10.2.0  CUDA/11.1.1 OpenMPI/4.0.5 PyTorch/1.9.0
Die folgenden Module wurden in einer anderen Version erneut geladen:
  1) modenv/scs5 => modenv/hiera

Module GCC/10.2.0, CUDA/11.1.1, OpenMPI/4.0.5, PyTorch/1.9.0 and 54 dependencies loaded.
```

??? hint "Torchvision on partition `alpha`"
    On the partition `alpha`, the module torchvision is not yet available within the module
    system. (19.08.2021)
    Torchvision can be made available by using a virtual environment:

    ```console
    marie@alpha$ virtualenv --system-site-packages python-environments/torchvision_env
    marie@alpha$ source python-environments/torchvision_env/bin/activate
    marie@alpha$ pip install torchvision --no-deps
    ```

    Using the **--no-deps** option for "pip install" is necessary here as otherwise the PyTorch
    version might be replaced and you will run into trouble with the cuda drivers.

On the partition `ml`:

```console
marie@login$ srun -p ml --gres=gpu:1 -n 1 -c 7 --pty --mem-per-cpu=800 bash    #Job submission in ml nodes with 1 gpu on 1 node with 800 Mb per CPU
```

After calling

```console
marie@login$ module spider pytorch
```

we know that we can load PyTorch (including torchvision) with

```console
marie@ml$ module load modenv/ml torchvision/0.7.0-fosscuda-2019b-Python-3.7.4-PyTorch-1.6.0
Module torchvision/0.7.0-fosscuda-2019b-Python-3.7.4-PyTorch-1.6.0 and 55 dependencies loaded.
```

Now, we check that we can access PyTorch:

```console
marie@{ml,alpha}$ python -c "import torch; print(torch.__version__)"
```

The following example shows how to create a python virtual environment and import PyTorch.

```console
marie@ml$ mkdir python-environments    #create folder
marie@ml$ which python    #check which python are you using
/sw/installed/Python/3.7.4-GCCcore-8.3.0/bin/python
marie@ml$ virtualenv --system-site-packages python-environments/env    #create virtual environment "env" which inheriting with global site packages
[...]
marie@ml$ source python-environments/env/bin/activate    #activate virtual environment "env". Example output: (env) bash-4.2$
marie@ml$ python -c "import torch; print(torch.__version__)"
```

## PyTorch in JupyterHub

In addition to using interactive and batch jobs, it is possible to work with PyTorch using JupyterHub.
The production and test environments of JupyterHub contain Python kernels, that come with a PyTorch support.

![PyTorch module in JupyterHub](misc/Pytorch_jupyter_module.png)
{: align="center"}

## Distributed PyTorch

For details on how to run PyTorch with multiple GPUs and/or multiple nodes, see
[distributed training](distributed_training.md).
