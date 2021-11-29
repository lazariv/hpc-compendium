# Visualization

## ParaView

[ParaView](https://paraview.org) is an open-source, multi-platform data analysis and visualization
application. The ParaView package comprises different tools which are designed to meet interactive,
batch and in-situ workflows.

ParaView is available on ZIH systems from the [modules system](modules.md#modules-environment). The
following command lists the available versions

```console
marie@login$ module avail ParaView

   ParaView/5.4.1-foss-2018b-mpi  (D)    ParaView/5.5.2-intel-2018a-mpi                ParaView/5.7.0-osmesa
   ParaView/5.4.1-intel-2018a-mpi        ParaView/5.6.2-foss-2019b-Python-3.7.4-mpi    ParaView/5.7.0
[...]
```

## Batch Mode - PvBatch

ParaView can run in batch mode, i.e., without opening the ParaView GUI, executing a Python script.
This way, common visualization tasks can be automated. There are two Python interfaces: *PvPython*
and *PvBatch*. The interface *PvBatch* only accepts commands from input scripts, and it will run in
parallel, if it was built using MPI.

!!! note

    ParaView is shipped with a prebuild MPI library and **pvbatch has to be
    invoked using this very mpiexec** command. Make sure to not use `srun`
    or `mpiexec` from another MPI module, e.g., check what `mpiexec` is in
    the path:

    ```console
    marie@login$ module load ParaView/5.7.0-osmesa
    marie@login$ which mpiexec
    /sw/installed/ParaView/5.7.0-osmesa/bin/mpiexec
    ```

The resources for the MPI processes have to be allocated via the
[batch system](../jobs_and_resources/slurm.md) option `-c NUM` (not `-n`, as it would be usually for
MPI processes). It might be valuable in terms of runtime to bind/pin the MPI processes to hardware.
A convenient option is `-bind-to core`. All other options can be obtained by

```console
marie@login$ mpiexec -bind-to -help`
```

or from
[mpich wiki](https://wiki.mpich.org/mpich/index.php/Using_the_Hydra_Process_Manager#Process-core_Binding%7Cwiki.mpich.org).

In the following, we provide two examples on how to use `pvbatch` from within a job file and an
interactive allocation.

??? example "Example job file"

    ```Bash
    #!/bin/bash

    #SBATCH -N 1
    #SBATCH -c 12
    #SBATCH --time=01:00:00

    # Make sure to only use ParaView
    module purge
    module load ParaView/5.7.0-osmesa

    pvbatch --mpi --force-offscreen-rendering pvbatch-script.py
    ```

??? example "Example of interactive allocation using `salloc`"

    ```console
    marie@login$ salloc -N 1 -c 16 --time=01:00:00 bash
    salloc: Pending job allocation 336202
    salloc: job 336202 queued and waiting for resources
    salloc: job 336202 has been allocated resources
    salloc: Granted job allocation 336202
    salloc: Waiting for resource configuration
    salloc: Nodes taurusi6605 are ready for job

    # Make sure to only use ParaView
    marie@compute$ module purge
    marie@compute$ module load ParaView/5.7.0-osmesa

    # Go to working directory, e.g., workspace
    marie@compute$ cd /path/to/workspace

    # Execute pvbatch using 16 MPI processes in parallel on allocated resources
    marie@compute$ pvbatch --mpi --force-offscreen-rendering pvbatch-script.py
    ```

### Using GPUs

ParaView Pvbatch can render offscreen through the Native Platform Interface (EGL) on the graphics
cards (GPUs) specified by the device index. For that, make sure to use the modules indexed with
*-egl*, e.g., `ParaView/5.9.0-RC1-egl-mpi-Python-3.8`, and pass the option
`--egl-device-index=$CUDA_VISIBLE_DEVICES`.

??? example "Example job file"

    ```Bash
    #!/bin/bash

    #SBATCH -N 1
    #SBATCH -c 12
    #SBATCH --gres=gpu:2
    #SBATCH --partition=gpu2
    #SBATCH --time=01:00:00

    # Make sure to only use ParaView
    module purge
    module load ParaView/5.9.0-RC1-egl-mpi-Python-3.8

    mpiexec -n $SLURM_CPUS_PER_TASK -bind-to core pvbatch --mpi --egl-device-index=$CUDA_VISIBLE_DEVICES --force-offscreen-rendering pvbatch-script.py
    #or
    pvbatch --mpi --egl-device-index=$CUDA_VISIBLE_DEVICES --force-offscreen-rendering pvbatch-script.py
    ```

## Interactive Mode

There are three different ways of using ParaView interactively on ZIH systems:

- GUI via NICE DCV on a GPU node
- Client-/Server mode with MPI-parallel off-screen-rendering
- GUI via X forwarding

### Using the GUI via NICE DCV on a GPU Node

This option provides hardware accelerated OpenGL and might provide the best performance and smooth
handling. First, you need to open a DCV session, so please follow the instructions under
[virtual desktops](virtual_desktops.md). Start a terminal (right-click on desktop -> Terminal) in your
virtual desktop session, then load the ParaView module as usual and start the GUI:

```console
marie@dcv module load ParaView/5.7.0
paraview
```

Since your DCV session already runs inside a job, which has been scheduled to a compute node, no
`srun command` is necessary here.

#### Using Client-/Server Mode with MPI-parallel Offscreen-Rendering

ParaView has a built-in client-server architecture, where you run the GUI locally on your desktop
and connect to a ParaView server instance (so-called pvserver) on a cluster. The pvserver performs
the computationally intensive rendering. Note that **your client must be of the same version as the
server**.

The pvserver can be run in parallel using MPI, but it will only do CPU rendering via MESA. For this,
you need to load the `osmesa`-suffixed version of the ParaView modules, which supports
offscreen-rendering. Then, start the `pvserver` via `srun` in parallel using multiple MPI
processes.

??? example "Example"

    ```console
    marie@login$ module ParaView/5.7.0-osmesa
    marie@login$ srun -N1 -n8 --mem-per-cpu=2500 -p interactive --pty pvserver --force-offscreen-rendering
    srun: job 2744818 queued and waiting for resources
    srun: job 2744818 has been allocated resources
    Waiting for client...
    Connection URL: cs://taurusi6612.taurus.hrsk.tu-dresden.de:11111
    Accepting connection(s): taurusi6612.taurus.hrsk.tu-dresden.de:11111
    ```

If the default port 11111 is already in use, an alternative port can be specified via `-sp=port`.
*Once the resources are allocated, the pvserver is started in parallel and connection information
are outputed.*

This contains the node name which your job and server runs on. However, since the node names of the
cluster are not present in the public domain name system (only cluster-internally), you cannot just
use this line as-is for connection with your client. **You first have to resolve** the name to an IP
address on ZIH systems: Suffix the node name with `-mn` to get the management network (ethernet)
address, and pass it to a lookup-tool like `host` in another SSH session:

```console
marie@login$ host taurusi6605-mn
taurusi6605-mn.taurus.hrsk.tu-dresden.de has address 172.24.140.229
```

The SSH tunnel has to be created from the user's localhost. The following example will create a
forward SSH tunnel to localhost on port 22222 (or what ever port is preferred):

```console
marie@local$ ssh -L 22222:172.24.140.229:11111 <zihlogin>@taurus.hrsk.tu-dresden.de
```

The final step is to start ParaView locally on your own machine and add the connection

- File -> Connect...
- Add Server
    - Name: localhost tunnel
    - Server Type: Client / Server
    - Host: localhost
    - Port: 22222
- Configure
    - Startup Type: Manual
    - -> Save
- -> Connect

A successful connection is displayed by a *client connected* message displayed on the `pvserver`
process terminal, and within ParaView's Pipeline Browser (instead of it saying builtin). You now are
connected to the pvserver running on a compute node at ZIH systems and can open files from its
filesystems.

#### Caveats

Connecting to the compute nodes will only work when you are **inside the TUD campus network**,
because otherwise, the private networks 172.24.\* will not be routed. That's why you either need to
use [VPN](https://tu-dresden.de/zih/dienste/service-katalog/arbeitsumgebung/zugang_datennetz/vpn),
or, when coming via the ZIH login gateway (`login1.zih.tu-dresden.de`), use an SSH tunnel. For the
example IP address from above, this could look like the following:

```console
marie@local$ ssh -f -N -L11111:172.24.140.229:11111 <zihlogin>@login1.zih.tu-dresden.de
```

This command opens the port 11111 locally and tunnels it via `login1` to the `pvserver` running on
the compute node. Note that you then must instruct your local ParaView client to connect to host
`localhost` instead. The recommendation, though, is to use VPN, which makes this extra step
unnecessary.

#### Using the GUI via X-Forwarding

(not recommended)

Even the developers, KitWare, say that X-forwarding is not supported at all by ParaView, as it
requires OpenGL extensions that are not supported by X forwarding. It might still be usable for very
small examples, but the user experience will not be good. Also, you have to make sure your
X-forwarding connection provides OpenGL rendering support. Furthermore, especially in newer versions
of ParaView, you might have to set the environment variable `MESA_GL_VERSION_OVERRIDE=3.2` to fool
it into thinking your provided GL rendering version is higher than what it actually is.

??? example

    ```console
    # 1st, connect to ZIH systems using X forwarding (-X).
    # It is a good idea to also enable compression for such connections (-C):
    marie@local$ ssh -XC taurus.hrsk.tu-dresden.de

    # 2nd, load the ParaView module and override the GL version (if necessary):
    marie@login$ module Paraview/5.7.0
    marie@login$ export MESA_GL_VERSION_OVERRIDE=3.2

    # 3rd, start the ParaView GUI inside an interactive job. Don't forget the --x11 parameter for X forwarding:
    marie@login$ srun -n1 -c1 -p interactive --mem-per-cpu=2500 --pty --x11=first paraview
    ```
