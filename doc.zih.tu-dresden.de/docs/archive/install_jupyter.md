# Jupyter Installation

!!! warning

    This page is outdated!

Jupyter notebooks allow to analyze data interactively using your web browser. One advantage of
Jupyter is, that code, documentation and visualization can be included in a single notebook, so that
it forms a unit. Jupyter notebooks can be used for many tasks, such as data cleaning and
transformation, numerical simulation, statistical modeling, data visualization and also machine
learning.

There are two general options on how to work with Jupyter notebooks on ZIH systems: remote Jupyter
server and JupyterHub.

These sections show how to set up and run a remote Jupyter server with GPUs within a Slurm job.
Furthermore, the following sections explain which modules and packages you need for that.

!!! note
    On ZIH systems, there is a [JupyterHub](../access/jupyterhub.md), where you do not need the
    manual server setup described below and can simply run your Jupyter notebook on HPC nodes. Keep
    in mind, that, with JupyterHub, you can't work with some special instruments. However, general
    data analytics tools are available.

The remote Jupyter server is able to offer more freedom with settings and approaches.

## Preparation phase (optional)

On ZIH system, start an interactive session for setting up the environment:

```console
marie@login$ srun --pty -n 1 --cpus-per-task=2 --time=2:00:00 --mem-per-cpu=2500 --x11=first bash -l -i
```

Create a new directory in your home, e.g. Jupyter

```console
marie@compute$ mkdir Jupyter
marie@compute$ cd Jupyter
```

There are two ways how to run Anaconda. The easiest way is to load the Anaconda module. The second
one is to download Anaconda in your home directory.

1. Load Anaconda module (recommended):

```console
marie@compute$ module load modenv/scs5
marie@compute$ module load Anaconda3
```

1. Download latest Anaconda release (see example below) and change the rights to make it an
executable script and run the installation script:

```console
marie@compute$ wget https://repo.continuum.io/archive/Anaconda3-2019.03-Linux-x86_64.sh
marie@compute$ chmod u+x Anaconda3-2019.03-Linux-x86_64.sh
marie@compute$ ./Anaconda3-2019.03-Linux-x86_64.sh
```

(during installation you have to confirm the license agreement)

Next step will install the anaconda environment into the home
directory (`/home/userxx/anaconda3`). Create a new anaconda environment with the name `jnb`.

```console
marie@compute$ conda create --name jnb
```

## Set environmental variables

In the shell, activate previously created python environment (you can
deactivate it also manually) and install Jupyter packages for this python environment:

```console
marie@compute$ source activate jnb
marie@compute$ conda install jupyter
```

If you need to adjust the configuration, you should create the template. Generate configuration
files for Jupyter notebook server:

```console
marie@compute$ jupyter notebook --generate-config
```

Find a path of the configuration file, usually in the home under `.jupyter` directory, e.g.
`/home//.jupyter/jupyter_notebook_config.py`

Set a password (choose easy one for testing), which is needed later on to log into the server
in browser session:

```console
marie@compute$ jupyter notebook password
Enter password:
Verify password:
```

You get a message like that:

```bash
[NotebookPasswordApp] Wrote *hashed password* to
/home/marie/.jupyter/jupyter_notebook_config.json
```

I order to create a certificate for secure connections, you can create a self-signed
certificate:

```console
marie@compute$ openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mykey.key -out mycert.pem
```

Fill in the form with decent values.

Possible entries for your Jupyter configuration (`.jupyter/jupyter_notebook*config.py*`).

```bash
c.NotebookApp.certfile = u'<path-to-cert>/mycert.pem'
c.NotebookApp.keyfile = u'<path-to-cert>/mykey.key'

# set ip to '*' otherwise server is bound to localhost only
c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False

# copy hashed password from the jupyter_notebook_config.json
c.NotebookApp.password = u'<your hashed password here>'
c.NotebookApp.port = 9999
c.NotebookApp.allow_remote_access = True
```

!!! note
    `<path-to-cert>` - path to key and certificate files, for example:
    (`/home/marie/mycert.pem`)

## Slurm job file to run the Jupyter server on ZIH system with GPU (1x K80) (also works on K20)

```bash
#!/bin/bash -l
#SBATCH --gres=gpu:1 # request GPU
#SBATCH --partition=gpu2 # use partition GPU 2
#SBATCH --output=notebook_output.txt
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=02:30:00
#SBATCH --mem=4000M
#SBATCH -J "jupyter-notebook" # job-name
#SBATCH -A p_marie

unset XDG_RUNTIME_DIR   # might be required when interactive instead of sbatch to avoid 'Permission denied error'
srun jupyter notebook
```

Start the script above (e.g. with the name `jnotebook`) with sbatch command:

```bash
sbatch jnotebook.slurm
```

If you have a question about sbatch script see the article about [Slurm](../jobs_and_resources/slurm.md).

Check by the command: `tail notebook_output.txt` the status and the **token** of the server. It
should look like this:

`https://(taurusi2092.taurus.hrsk.tu-dresden.de or 127.0.0.1):9999/`

You can see the **server node's hostname** by the command: `squeue --me`.

### Remote connect to the server

There are two options on how to connect to the server:

1. You can create an ssh tunnel if you have problems with the
solution above. Open the other terminal and configure ssh
tunnel: (look up connection values in the output file of Slurm job, e.g.) (recommended):

```bash
node=taurusi2092 #see the name of the node with squeue -u <your_login>
localport=8887 #local port on your computer
remoteport=9999 #pay attention on the value. It should be the same value as value in the notebook_output.txt
ssh -fNL ${localport}:${node}:${remoteport} <zih_user>@taurus.hrsk.tu-dresden.de #configure the ssh tunnel for connection to your remote server
pgrep -f "ssh -fNL ${localport}" #verify that tunnel is alive
```

2. On your client (local machine) you now can connect to the server.  You need to know the **node's
   hostname**, the **port** of the server and the **token** to login (see paragraph above).

You can connect directly if you know the IP address (just ping the node's hostname while logged on
ZIH system).

```bash
#command on remote terminal
marie@taurusi2092$ host taurusi2092
# copy IP address from output
# paste IP to your browser or call on local terminal e.g.:
marie@local$ firefox https://<IP>:<PORT>  # https important to use SSL cert
```

To login into the Jupyter notebook site, you have to enter the **token**.
(`https://localhost:8887`). Now you can create and execute notebooks on ZIH system with GPU support.

!!! important
    If you would like to use [JupyterHub](../access/jupyterhub.md) after using a remote manually
    configured Jupyter server (example above) you need to change the name of the configuration file
    (`/home//.jupyter/jupyter_notebook_config.py`) to any other.
