# Deep learning

**Prerequisites**: To work with Deep Learning tools you obviously need [Login](../access/ssh_login.md)
for the Taurus system and basic knowledge about Python, Slurm manager.

**Aim** of this page is to introduce users on how to start working with Deep learning software on
both the ml environment and the scs5 environment of the Taurus system.

## Deep Learning Software

### TensorFlow

[TensorFlow](https://www.tensorflow.org/guide/) is a free end-to-end open-source software library
for dataflow and differentiable programming across a range of tasks.

TensorFlow is available in both main partitions
[ml environment and scs5 environment](modules.md#module-environments)
under the module name "TensorFlow". However, for purposes of machine learning and deep learning, we
recommend using Ml partition [HPC-DA](../jobs_and_resources/hpcda.md). For example:

```Bash
module load TensorFlow
```

There are numerous different possibilities on how to work with [TensorFlow](tensorflow.md) on
Taurus. On this page, for all examples default, scs5 partition is used. Generally, the easiest way
is using the [modules system](modules.md)
and Python virtual environment (test case). However, in some cases, you may need directly installed
TensorFlow stable or night releases. For this purpose use the
[EasyBuild](custom_easy_build_environment.md), [Containers](tensorflow_container_on_hpcda.md) and see
[the example](https://www.tensorflow.org/install/pip). For examples of using TensorFlow for ml partition
with module system see [TensorFlow page for HPC-DA](tensorflow.md).

Note: If you are going used manually installed TensorFlow release we recommend use only stable
versions.

## Keras

[Keras](https://keras.io/) is a high-level neural network API, written in Python and capable of
running on top of [TensorFlow](https://github.com/tensorflow/tensorflow) Keras is available in both
environments [ml environment and scs5 environment](modules.md#module-environments) under the module
name "Keras".

On this page for all examples default scs5 partition used. There are numerous different
possibilities on how to work with [TensorFlow](tensorflow.md) and Keras
on Taurus. Generally, the easiest way is using the [module system](modules.md) and Python
virtual environment (test case) to see TensorFlow part above.
For examples of using Keras for ml partition with the module system see the
[Keras page for HPC-DA](keras.md).

It can either use TensorFlow as its backend. As mentioned in Keras documentation Keras capable of
running on Theano backend. However, due to the fact that Theano has been abandoned by the
developers, we don't recommend use Theano anymore. If you wish to use Theano backend you need to
install it manually. To use the TensorFlow backend, please don't forget to load the corresponding
TensorFlow module. TensorFlow should be loaded automatically as a dependency.

Test case: Keras with TensorFlow on MNIST data

Go to a directory on Taurus, get Keras for the examples and go to the examples:

```Bash
git clone https://github.com/fchollet/keras.git'>https://github.com/fchollet/keras.git
cd keras/examples/
```

If you do not specify Keras backend, then TensorFlow is used as a default

Job-file (schedule job with sbatch, check the status with 'squeue -u \<Username>'):

```Bash
#!/bin/bash
#SBATCH --gres=gpu:1                         # 1 - using one gpu, 2 - for using 2 gpus
#SBATCH --mem=8000
#SBATCH -p gpu2                              # select the type of nodes (options: haswell, smp, sandy, west, gpu, ml) K80 GPUs on Haswell node
#SBATCH --time=00:30:00
#SBATCH -o HLR_&lt;name_of_your_script&gt;.out     # save output under HLR_${SLURMJOBID}.out
#SBATCH -e HLR_&lt;name_of_your_script&gt;.err     # save error messages under HLR_${SLURMJOBID}.err

module purge                                 # purge if you already have modules loaded
module load modenv/scs5                      # load scs5 environment
module load Keras                            # load Keras module
module load TensorFlow                       # load TensorFlow module

# if you see 'broken pipe error's (might happen in interactive session after the second srun
command) uncomment line below
# module load h5py

python mnist_cnn.py
```

Keep in mind that you need to put the bash script to the same folder as an executable file or
specify the path.

Example output:

```Bash
x_train shape: (60000, 28, 28, 1) 60000 train samples 10000 test samples Train on 60000 samples,
validate on 10000 samples Epoch 1/12

128/60000 [..............................] - ETA: 12:08 - loss: 2.3064 - acc: 0.0781 256/60000
[..............................] - ETA: 7:04 - loss: 2.2613 - acc: 0.1523 384/60000
[..............................] - ETA: 5:22 - loss: 2.2195 - acc: 0.2005

...

60000/60000 [==============================] - 128s 2ms/step - loss: 0.0296 - acc: 0.9905 -
val_loss: 0.0268 - val_acc: 0.9911 Test loss: 0.02677746053306255 Test accuracy: 0.9911
```

## Datasets

There are many different datasets designed for research purposes. If you would like to download some
of them, first of all, keep in mind that many machine learning libraries have direct access to
public datasets without downloading it (for example
[TensorFlow Datasets](https://www.tensorflow.org/datasets).

If you still need to download some datasets, first of all, be careful with the size of the datasets
which you would like to download (some of them have a size of few Terabytes). Don't download what
you really not need to use! Use login nodes only for downloading small files (hundreds of the
megabytes). For downloading huge files use [DataMover](../data_transfer/datamover.md).
For example, you can use command `dtwget` (it is an analogue of the general wget
command). This command submits a job to the data transfer machines.  If you need to download or
allocate massive files (more than one terabyte) please contact the support before.

### The ImageNet dataset

The [ImageNet](http://www.image-net.org/) project is a large visual database designed for use in
visual object recognition software research. In order to save space in the file system by avoiding
to have multiple duplicates of this lying around, we have put a copy of the ImageNet database
(ILSVRC2012 and ILSVR2017) under `/scratch/imagenet` which you can use without having to download it
again. For the future, the ImageNet dataset will be available in `/warm_archive`. ILSVR2017 also
includes a dataset for recognition objects from a video. Please respect the corresponding
[Terms of Use](https://image-net.org/download.php).

## Jupyter Notebook

Jupyter notebooks are a great way for interactive computing in your web browser. Jupyter allows
working with data cleaning and transformation, numerical simulation, statistical modelling, data
visualization and of course with machine learning.

There are two general options on how to work Jupyter notebooks using HPC: remote Jupyter server and
JupyterHub.

These sections show how to run and set up a remote Jupyter server within a sbatch GPU job and which
modules and packages you need for that.

**Note:** On Taurus, there is a [JupyterHub](../access/jupyterhub.md), where you do not need the
manual server setup described below and can simply run your Jupyter notebook on HPC nodes. Keep in
mind, that, with JupyterHub, you can't work with some special instruments. However, general data
analytics tools are available.

The remote Jupyter server is able to offer more freedom with settings and approaches.

### Preparation phase (optional)

On Taurus, start an interactive session for setting up the
environment:

```Bash
srun --pty -n 1 --cpus-per-task=2 --time=2:00:00 --mem-per-cpu=2500 --x11=first bash -l -i
```

Create a new subdirectory in your home, e.g. Jupyter

```Bash
mkdir Jupyter cd Jupyter
```

There are two ways how to run Anaconda. The easiest way is to load the Anaconda module. The second
one is to download Anaconda in your home directory.

1. Load Anaconda module (recommended):

```Bash
module load modenv/scs5 module load Anaconda3
```

1. Download latest Anaconda release (see example below) and change the rights to make it an
executable script and run the installation script:

```Bash
wget https://repo.continuum.io/archive/Anaconda3-2019.03-Linux-x86_64.sh chmod 744
Anaconda3-2019.03-Linux-x86_64.sh ./Anaconda3-2019.03-Linux-x86_64.sh

(during installation you have to confirm the license agreement)
```

Next step will install the anaconda environment into the home
directory (/home/userxx/anaconda3). Create a new anaconda environment with the name "jnb".

```Bash
conda create --name jnb
```

### Set environmental variables on Taurus

In shell activate previously created python environment (you can
deactivate it also manually) and install Jupyter packages for this python environment:

```Bash
source activate jnb conda install jupyter
```

If you need to adjust the configuration, you should create the template. Generate config files for
Jupyter notebook server:

```Bash
jupyter notebook --generate-config
```

Find a path of the configuration file, usually in the home under `.jupyter` directory, e.g.
`/home//.jupyter/jupyter_notebook_config.py`

Set a password (choose easy one for testing), which is needed later on to log into the server
in browser session:

```Bash
jupyter notebook password Enter password: Verify password:
```

You get a message like that:

```Bash
[NotebookPasswordApp] Wrote *hashed password* to
/home/<zih_user>/.jupyter/jupyter_notebook_config.json
```

I order to create an SSL certificate for https connections, you can create a self-signed
certificate:

```Bash
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mykey.key -out mycert.pem
```

Fill in the form with decent values.

Possible entries for your Jupyter config (`.jupyter/jupyter_notebook*config.py*`). Uncomment below
lines:

```Bash
c.NotebookApp.certfile = u'<path-to-cert>/mycert.pem' c.NotebookApp.keyfile =
u'<path-to-cert>/mykey.key'

# set ip to '*' otherwise server is bound to localhost only c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False

# copy hashed password from the jupyter_notebook_config.json c.NotebookApp.password = u'<your
hashed password here>' c.NotebookApp.port = 9999 c.NotebookApp.allow_remote_access = True
```

Note: `<path-to-cert>` - path to key and certificate files, for example:
(`/home/\<username>/mycert.pem`)

### Slurm job file to run the Jupyter server on Taurus with GPU (1x K80) (also works on K20)

```Bash
#!/bin/bash -l #SBATCH --gres=gpu:1 # request GPU #SBATCH --partition=gpu2 # use GPU partition
SBATCH --output=notebook_output.txt #SBATCH --nodes=1 #SBATCH --ntasks=1 #SBATCH --time=02:30:00
SBATCH --mem=4000M #SBATCH -J "jupyter-notebook" # job-name #SBATCH -A <name_of_your_project>

unset XDG_RUNTIME_DIR   # might be required when interactive instead of sbatch to avoid
'Permission denied error' srun jupyter notebook
```

Start the script above (e.g. with the name jnotebook) with sbatch command:

```Bash
sbatch jnotebook.slurm
```

If you have a question about sbatch script see the article about [Slurm](../jobs_and_resources/slurm.md).

Check by the command: `tail notebook_output.txt` the status and the **token** of the server. It
should look like this:

```Bash
https://(taurusi2092.taurus.hrsk.tu-dresden.de or 127.0.0.1):9999/
```

You can see the **server node's hostname** by the command: `squeue -u <username>`.

Remote connect to the server

There are two options on how to connect to the server:

1. You can create an ssh tunnel if you have problems with the
solution above. Open the other terminal and configure ssh
tunnel: (look up connection values in the output file of Slurm job, e.g.) (recommended):

```Bash
node=taurusi2092                      #see the name of the node with squeue -u <your_login>
localport=8887                        #local port on your computer remoteport=9999
#pay attention on the value. It should be the same value as value in the notebook_output.txt ssh
-fNL ${localport}:${node}:${remoteport} <zih_user>@taurus.hrsk.tu-dresden.de         #configure
of the ssh tunnel for connection to your remote server pgrep -f "ssh -fNL ${localport}"
#verify that tunnel is alive
```

2. On your client (local machine) you now can connect to the server.  You need to know the **node's
   hostname**, the **port** of the server and the **token** to login (see paragraph above).

You can connect directly if you know the IP address (just ping the node's hostname while logged on
Taurus).

```Bash
#comand on remote terminal taurusi2092$> host taurusi2092 # copy IP address from output # paste
IP to your browser or call on local terminal e.g.  local$> firefox https://<IP>:<PORT>  # https
important to use SSL cert
```

To login into the Jupyter notebook site, you have to enter the **token**.
(`https://localhost:8887`). Now you can create and execute notebooks on Taurus with GPU support.

If you would like to use [JupyterHub](../access/jupyterhub.md) after using a remote manually configured
Jupyter server (example above) you need to change the name of the configuration file
(`/home//.jupyter/jupyter_notebook_config.py`) to any other.

### F.A.Q

**Q:** - I have an error to connect to the Jupyter server (e.g. "open failed: administratively
prohibited: open failed")

**A:** - Check the settings of your Jupyter config file. Is it all necessary lines uncommented, the
right path to cert and key files, right hashed password from .json file? Check is the used local
port [available](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers)
Check local settings e.g. (`/etc/ssh/sshd_config`, `/etc/hosts`).

**Q:** I have an error during the start of the interactive session (e.g.  PMI2_Init failed to
initialize. Return code: 1)

**A:** Probably you need to provide `--mpi=none` to avoid ompi errors ().
`srun --mpi=none --reservation \<...> -A \<...> -t 90 --mem=4000 --gres=gpu:1
--partition=gpu2-interactive --pty bash -l`
