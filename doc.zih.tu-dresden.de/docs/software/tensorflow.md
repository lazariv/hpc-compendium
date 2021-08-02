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
[access](../access/login.md) for the Taurus system and basic knowledge about Python, SLURM system.

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

Keep in mind that using **srun** directly on the shell will be blocking
and launch an interactive job. Apart from short test runs, it is
recommended to launch your jobs into the background by using batch
jobs:\<span> **sbatch \[options\] \<job file>** \</span>. The example
will be presented later on the page.

As a Tensorflow example, we will use a \<a
href="<https://www.tensorflow.org/tutorials>" target="\_blank">simple
mnist model\</a>. Even though this example is in Python, the information
here will still apply to other tools.

The ml partition has very efficacious GPUs to offer. Do not assume that
more power means automatically faster computational speed. The GPU is
only one part of a typical machine learning application. Do not forget
that first the input data needs to be loaded and in most cases even
rescaled or augmented. If you do not specify that you want to use more
than the default one worker (=one CPU thread), then it is very likely
that your GPU computes faster, than it receives the input data. It is,
therefore, possible, that you will not be any faster, than on other GPU
partitions. \<span style="font-size: 1em;">You can solve this by using
multithreading when loading your input data. The \</span>\<a
href="<https://keras.io/models/sequential/#fit_generator>"
target="\_blank">fit_generator\</a>\<span style="font-size: 1em;">
method supports multiprocessing, just set \`use_multiprocessing\` to
\`True\`, \</span>\<a href="Slurm#Job_Submission"
target="\_blank">request more Threads\</a>\<span style="font-size:
1em;"> from SLURM and set the \`Workers\` amount accordingly.\</span>

The example below with a \<a
href="<https://www.tensorflow.org/tutorials>" target="\_blank">simple
mnist model\</a> of the python script illustrates using TF-Keras API
from TensorFlow. \<a href="<https://www.tensorflow.org/guide/keras>"
target="\_top">Keras\</a> is TensorFlows high-level API.

**You can read in detail how to work with Keras on Taurus \<a
href="Keras" target="\_blank">here\</a>.**

    import tensorflow as tf
    # Load and prepare the MNIST dataset. Convert the samples from integers to floating-point numbers:
    mnist = tf.keras.datasets.mnist

    (x_train, y_train),(x_test, y_test) = mnist.load_data()
    x_train, x_test = x_train / 255.0, x_test / 255.0

    # Build the tf.keras model by stacking layers. Select an optimizer and loss function used for training
    model = tf.keras.models.Sequential([
      tf.keras.layers.Flatten(input_shape=(28, 28)),
      tf.keras.layers.Dense(512, activation=tf.nn.relu),
      tf.keras.layers.Dropout(0.2),
      tf.keras.layers.Dense(10, activation=tf.nn.softmax)
    ])
    model.compile(optimizer='adam',
                  loss='sparse_categorical_crossentropy',
                  metrics=['accuracy'])

    # Train and evaluate model
    model.fit(x_train, y_train, epochs=5)
    model.evaluate(x_test, y_test)

The example can train an image classifier with \~98% accuracy based on
this dataset.

## Python virtual environment

A virtual environment is a cooperatively isolated runtime environment
that allows Python users and applications to install and update Python
distribution packages without interfering with the behaviour of other
Python applications running on the same system. At its core, the main
purpose of Python virtual environments is to create an isolated
environment for Python projects.

**Vitualenv**is a standard Python tool to create isolated Python
environments and part of the Python installation/module. We recommend
using virtualenv to work with Tensorflow and Pytorch on Taurus.\<br
/>However, if you have reasons (previously created environments etc) you
can also use conda which is the second way to use a virtual environment
on the Taurus. \<a
href="<https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html>"
target="\_blank">Conda\</a> is an open-source package management system
and environment management system. Note that using conda means that
working with other modules from taurus will be harder or impossible.
Hence it is highly recommended to use virtualenv.

## Running the sbatch script on ML modules (modenv/ml) and SCS5 modules (modenv/scs5)

Generally, for machine learning purposes the ml partition is used but
for some special issues, the other partitions can be useful also. The
following sbatch script can execute the above Python script both on ml
partition or gpu2 partition.\<br /> When not using the
TensorFlow-Anaconda modules you may need some additional modules that
are not included (e.g. when using the TensorFlow module from modenv/scs5
on gpu2).\<br />If you have a question about the sbatch script see the
article about \<a href="Slurm" target="\_blank">SLURM\</a>. Keep in mind
that you need to put the executable file (machine_learning_example.py)
with python code to the same folder as the bash script file
\<script_name>.sh (see below) or specify the path.

    #!/bin/bash
    #SBATCH --mem=8GB                         # specify the needed memory
    #SBATCH -p ml                             # specify ml partition or gpu2 partition
    #SBATCH --gres=gpu:1                      # use 1 GPU per node (i.e. use one GPU per task)
    #SBATCH --nodes=1                         # request 1 node
    #SBATCH --time=00:10:00                   # runs for 10 minutes
    #SBATCH -c 7                              # how many cores per task allocated
    #SBATCH -o HLR_<name_your_script>.out     # save output message under HLR_${SLURMJOBID}.out
    #SBATCH -e HLR_<name_your_script>.err     # save error messages under HLR_${SLURMJOBID}.err

    if [ "$SLURM_JOB_PARTITION" == "ml" ]; then
        module load modenv/ml
        module load TensorFlow/2.0.0-PythonAnaconda-3.7
    else
        module load modenv/scs5
        module load TensorFlow/2.0.0-fosscuda-2019b-Python-3.7.4
        module load Pillow/6.2.1-GCCcore-8.3.0               # Optional
        module load h5py/2.10.0-fosscuda-2019b-Python-3.7.4  # Optional
    fi

    python machine_learning_example.py

    ## when finished writing, submit with:  sbatch <script_name>

Output results and errors file can be seen in the same folder in the
corresponding files after the end of the job. Part of the example
output:

     1600/10000 [===>..........................] - ETA: 0s
     3168/10000 [========>.....................] - ETA: 0s
     4736/10000 [=============>................] - ETA: 0s
     6304/10000 [=================>............] - ETA: 0s
     7872/10000 [======================>.......] - ETA: 0s
     9440/10000 [===========================>..] - ETA: 0s
    10000/10000 [==============================] - 0s 38us/step

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
