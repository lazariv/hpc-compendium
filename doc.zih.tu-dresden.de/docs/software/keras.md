# Keras

This is an introduction on how to run a
Keras machine learning application on the new machine learning partition
of Taurus.

Keras is a high-level neural network API,
written in Python and capable of running on top of
[TensorFlow](https://github.com/tensorflow/tensorflow).
In this page, [Keras](https://www.tensorflow.org/guide/keras) will be
considered as a TensorFlow's high-level API for building and training
deep learning models. Keras includes support for TensorFlow-specific
functionality, such as [eager execution](https://www.tensorflow.org/guide/keras#eager_execution)
, [tf.data](https://www.tensorflow.org/api_docs/python/tf/data) pipelines
and [estimators](https://www.tensorflow.org/guide/estimator).

On the machine learning nodes (machine learning partition), you can use
the tools from [IBM Power AI](./power_ai.md). PowerAI is an enterprise
software distribution that combines popular open-source deep learning
frameworks, efficient AI development tools (Tensorflow, Caffe, etc).

In machine learning partition (modenv/ml) Keras is available as part of
the Tensorflow library at Taurus and also as a separate module named
"Keras". For using Keras in machine learning partition you have two
options:

- use Keras as part of the TensorFlow module;
- use Keras separately and use Tensorflow as an interface between
    Keras and GPUs.

**Prerequisites**: To work with Keras you, first of all, need
[access](../access/ssh_login.md) for the Taurus system, loaded
Tensorflow module on ml partition, activated Python virtual environment.
Basic knowledge about Python, SLURM system also required.

**Aim** of this page is to introduce users on how to start working with
Keras and TensorFlow on the [HPC-DA](../jobs_and_resources/hpcda.md)
system - part of the TU Dresden HPC system.

There are three main options on how to work with Keras and Tensorflow on
the HPC-DA: 1. Modules; 2. JupyterNotebook; 3. Containers. One of the
main ways is using the **TODO LINK MISSING** (Modules
system)(RuntimeEnvironment#Module_Environments) and Python virtual
environment. Please see the
[Python page](./python.md) for the HPC-DA
system.

The information about the Jupyter notebook and the **JupyterHub** could
be found [here](../access/jupyterhub.md). The use of
Containers is described [here](tensorflow_container_on_hpcda.md).

Keras contains numerous implementations of commonly used neural-network
building blocks such as layers,
[objectives](https://en.wikipedia.org/wiki/Objective_function),
[activation functions](https://en.wikipedia.org/wiki/Activation_function)
[optimizers](https://en.wikipedia.org/wiki/Mathematical_optimization),
and a host of tools
to make working with image and text data easier. Keras, for example, has
a library for preprocessing the image data.

The core data structure of Keras is a
**model**, a way to organize layers. The Keras functional API is the way
to go for defining as simple (sequential) as complex models, such as
multi-output models, directed acyclic graphs, or models with shared
layers.

## Getting started with Keras

This example shows how to install and start working with TensorFlow and
Keras (using the module system). To get started, import [tf.keras](https://www.tensorflow.org/api_docs/python/tf/keras)
as part of your TensorFlow program setup.
tf.keras is TensorFlow's implementation of the [Keras API
specification](https://keras.io/). This is a modified example that we
used for the [Tensorflow page](./tensorflow.md).

```bash
srun -p ml --gres=gpu:1 -n 1 --pty --mem-per-cpu=8000 bash

module load modenv/ml                           #example output: The following have been reloaded with a version change:  1) modenv/scs5 => modenv/ml

mkdir python-virtual-environments
cd python-virtual-environments
module load TensorFlow                          #example output: Module TensorFlow/1.10.0-PythonAnaconda-3.6 and 1 dependency loaded.
which python
python3 -m venv --system-site-packages env      #create virtual environment "env" which inheriting with global site packages
source env/bin/activate                         #example output: (env) bash-4.2$
module load TensorFlow
python
import tensorflow as tf
from tensorflow.keras import layers

print(tf.VERSION)                               #example output: 1.10.0
print(tf.keras.__version__)                     #example output: 2.1.6-tf
```

As was said the core data structure of Keras is a **model**, a way to
organize layers. In Keras, you assemble *layers* to build *models*. A
model is (usually) a graph of layers. For our example we use the most
common type of model is a stack of layers. The below [example](https://www.tensorflow.org/guide/keras#model_subclassing)
of using the advanced model with model
subclassing and custom layers illustrate using TF-Keras API.

```python
import tensorflow as tf
from tensorflow.keras import layers
import numpy as np

# Numpy arrays to train and evaluate a model
data = np.random.random((50000, 32))
labels = np.random.random((50000, 10))

# Create a custom layer by subclassing
class MyLayer(layers.Layer):

  def __init__(self, output_dim, **kwargs):
    self.output_dim = output_dim
    super(MyLayer, self).__init__(**kwargs)

# Create the weights of the layer
  def build(self, input_shape):
    shape = tf.TensorShape((input_shape[1], self.output_dim))
# Create a trainable weight variable for this layer
    self.kernel = self.add_weight(name='kernel',
                                  shape=shape,
                                  initializer='uniform',
                                  trainable=True)
    super(MyLayer, self).build(input_shape)
# Define the forward pass
  def call(self, inputs):
    return tf.matmul(inputs, self.kernel)

# Specify how to compute the output shape of the layer given the input shape.
  def compute_output_shape(self, input_shape):
    shape = tf.TensorShape(input_shape).as_list()
    shape[-1] = self.output_dim
    return tf.TensorShape(shape)

# Serializing the layer
  def get_config(self):
    base_config = super(MyLayer, self).get_config()
    base_config['output_dim'] = self.output_dim
    return base_config

  @classmethod
  def from_config(cls, config):
    return cls(**config)
# Create a model using your custom layer
model = tf.keras.Sequential([
    MyLayer(10),
    layers.Activation('softmax')])

# The compile step specifies the training configuration
model.compile(optimizer=tf.compat.v1.train.RMSPropOptimizer(0.001),
              loss='categorical_crossentropy',
              metrics=['accuracy'])

# Trains for 10 epochs(steps).
model.fit(data, labels, batch_size=32, epochs=10)
```

## Running the sbatch script on ML modules (modenv/ml)

Generally, for machine learning purposes ml partition is used but for
some special issues, SCS5 partition can be useful. The following sbatch
script will automatically execute the above Python script on ml
partition. If you have a question about the sbatch script see the
article about [SLURM](./../jobs_and_resources/binding_and_distribution_of_tasks.md).
Keep in mind that you need to put the executable file (Keras_example) with
python code to the same folder as bash script or specify the path.

```bash
#!/bin/bash
#SBATCH --mem=4GB                         # specify the needed memory
#SBATCH -p ml                             # specify ml partition
#SBATCH --gres=gpu:1                      # use 1 GPU per node (i.e. use one GPU per task)
#SBATCH --nodes=1                         # request 1 node
#SBATCH --time=00:05:00                   # runs for 5 minutes
#SBATCH -c 16                             # how many cores per task allocated
#SBATCH -o HLR_Keras_example.out          # save output message under HLR_${SLURMJOBID}.out
#SBATCH -e HLR_Keras_example.err          # save error messages under HLR_${SLURMJOBID}.err

module load modenv/ml
module load TensorFlow

python Keras_example.py

## when finished writing, submit with:  sbatch <script_name>
```

Output results and errors file you can see in the same folder in the
corresponding files after the end of the job. Part of the example
output:

```
......
Epoch 9/10
50000/50000 [==============================] - 2s 37us/sample - loss: 11.5159 - acc: 0.1000
Epoch 10/10
50000/50000 [==============================] - 2s 37us/sample - loss: 11.5159 - acc: 0.1020
```

## Tensorflow 2

[TensorFlow 2.0](https://blog.tensorflow.org/2019/09/tensorflow-20-is-now-available.html)
is a significant milestone for the
TensorFlow and the community. There are multiple important changes for
users.

Tere are a number of TensorFlow 2 modules for both ml and scs5
partitions in Taurus (2.0 (anaconda), 2.0 (python), 2.1 (python))
(11.04.20). Please check **TODO MISSING DOC**(the software modules list)(./SoftwareModulesList.md
for the information about available
modules.

<span style="color:red">**NOTE**</span>: Tensorflow 2 of the
current version is loading by default as a Tensorflow module.

TensorFlow 2.0 includes many API changes, such as reordering arguments,
renaming symbols, and changing default values for parameters. Thus in
some cases, it makes code written for the TensorFlow 1 not compatible
with TensorFlow 2. However, If you are using the high-level APIs
**(tf.keras)** there may be little or no action you need to take to make
your code fully TensorFlow 2.0 [compatible](https://www.tensorflow.org/guide/migrate).
It is still possible to run 1.X code,
unmodified ([except for contrib](https://github.com/tensorflow/community/blob/master/rfcs/20180907-contrib-sunset.md)
), in TensorFlow 2.0:

```python
import tensorflow.compat.v1 as tf
tf.disable_v2_behavior()                  #instead of "import tensorflow as tf"
```

To make the transition to TF 2.0 as seamless as possible, the TensorFlow
team has created the [tf_upgrade_v2](https://www.tensorflow.org/guide/upgrade)
utility to help transition legacy code to the new API.

## F.A.Q:
