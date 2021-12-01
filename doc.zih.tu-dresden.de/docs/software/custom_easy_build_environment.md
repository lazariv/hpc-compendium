# EasyBuild

Sometimes the [modules](modules.md) installed in the cluster are not enough for your purposes and
you need some other software or a different version of a software.

For most commonly used software, chances are high that there is already a *recipe* that EasyBuild
provides, which you can use. But what is EasyBuild?

[EasyBuild](https://easybuild.io/) is the software used to build and install
software on ZIH systems.

The aim of this page is to introduce users to working with EasyBuild and to utilizing it to create
modules.

## Prerequisites

1. [Shell access](../access/ssh_login.md) to ZIH systems
1. basic knowledge about:
   - [the ZIH system](../jobs_and_resources/hardware_overview.md)
   - [the module system](modules.md) on ZIH systems

EasyBuild uses a configuration file called recipe or "EasyConfig", which contains all the
information about how to obtain and build the software:

-   Name
-   Version
-   Toolchain (think: Compiler + some more)
-   Download URL
-   Build system (e.g. `configure && make` or `cmake && make`)
-   Config parameters
-   Tests to ensure a successful build

The build system part is implemented in so-called "EasyBlocks" and contains the common workflow.
Sometimes, those are specialized to encapsulate behavior specific to multiple/all versions of the
software. Everything is written in Python, which gives authors a great deal of flexibility.

## Set up a custom module environment and build your own modules

Installation of the new software (or version) does not require any specific credentials.

### Prerequisites

1. An existing EasyConfig
1. a place to put your modules.

### Step by step guide

**Step 1:** Create a [workspace](../data_lifecycle/workspaces.md#allocate-a-workspace) where you
install your modules. You need a place where your modules are placed. This needs to be done only
once:

```console
marie@login$ ws_allocate -F scratch EasyBuild 50
marie@login$ ws_list | grep 'directory.*EasyBuild'
     workspace directory  : /scratch/ws/1/marie-EasyBuild
```

**Step 2:** Allocate nodes. You can do this with interactive jobs (see the example below) and/or
put commands in a batch file and source it. The latter is recommended for non-interactive jobs,
using the command `sbatch` instead of `srun`. For the sake of illustration, we use an
interactive job as an example. Depending on the partitions that you want the module to be usable on
later, you need to select nodes with the same architecture. Thus, use nodes from partition ml for
building, if you want to use the module on nodes of that partition. In this example, we assume
that we want to use the module on nodes with x86 architecture and thus, we use Haswell nodes.

```console
marie@login$ srun --partition=haswell --nodes=1 --cpus-per-task=4 --time=08:00:00 --pty /bin/bash -l
```

!!! warning

    Using EasyBuild on the login nodes is not allowed.

**Step 3:** Specify the workspace. The rest of the guide is based on it. Please create an
environment variable called `WORKSPACE` with the path to your workspace:

```console
marie@compute$ export WORKSPACE=/scratch/ws/1/marie-EasyBuild    #see output of ws_list above
```

**Step 4:** Load the correct module environment  `modenv` according to your current or target
architecture:

=== "x86 (default, e. g. partition haswell)"
    ```console
    marie@compute$ module load modenv/scs5
    ```
=== "Power9 (partition ml)"
    ```console
    marie@ml$ module load modenv/ml
    ```

**Step 5:** Load module `EasyBuild`

```console
marie@compute$ module load EasyBuild
```

**Step 6:** Set up your environment:

```console
marie@compute$ export EASYBUILD_ALLOW_LOADED_MODULES=EasyBuild,modenv/scs5
marie@compute$ export EASYBUILD_DETECT_LOADED_MODULES=unload
marie@compute$ export EASYBUILD_BUILDPATH="/tmp/${USER}-EasyBuild${SLURM_JOB_ID:-}"
marie@compute$ export EASYBUILD_SOURCEPATH="${WORKSPACE}/sources"
marie@compute$ export EASYBUILD_INSTALLPATH="${WORKSPACE}/easybuild-$(basename $(readlink -f /sw/installed))"
marie@compute$ export EASYBUILD_INSTALLPATH_MODULES="${EASYBUILD_INSTALLPATH}/modules"
marie@compute$ module use "${EASYBUILD_INSTALLPATH_MODULES}/all"
marie@compute$ export LMOD_IGNORE_CACHE=1
```

**Step 7:** Now search for an existing EasyConfig:

```console
marie@compute$ eb --search TensorFlow
```

**Step 8:** Build the EasyConfig and its dependencies (option `-r`)

```console
marie@compute$ eb TensorFlow-1.8.0-fosscuda-2018a-Python-3.6.4.eb -r
```

This may take a long time. After this is done, you can load it just like any other module.

**Step 9:** To use your custom build modules you only need to rerun steps 3, 4, 5, 6 and execute
the usual:

```console
marie@compute$ module load TensorFlow-1.8.0-fosscuda-2018a-Python-3.6.4  #replace with the name of your module
```

The key is the `module use` command, which brings your modules into scope, so `module load` can find
them. The `LMOD_IGNORE_CACHE` line makes `LMod` pick up the custom modules instead of searching the
system cache.

## Troubleshooting

When building your EasyConfig fails, you can first check the log mentioned and scroll to the bottom
to see what went wrong.

It might also be helpful to inspect the build environment EasyBuild uses. For that you can run:

```console
marie@compute$ eb myEC.eb --dump-env-script`
```

This command creates a sourceable `.env`-file with `module load` and `export` commands that show
what EasyBuild does before running, e.g., the configuration step.

It might also be helpful to use

```console
marie@compute$ export LMOD_IGNORE_CACHE=0
```
