# EasyBuild

Sometimes the [Software Modules List] todo add sw list modules installed in the cluster are not
enough for your purposes and you need some other software or a different version of a software.

For most commonly used software, chances are high that there is already a *recipe* that EasyBuild
provides, which you can use. But what is Easybuild?

[EasyBuild](https://easybuilders.github.io/easybuild/) is the software used to build and install
software on, and create modules for ZIH systems.

\<span style="font-size: 1em;">The aim of this page is to introduce
users to working with EasyBuild and to utilizing it to create
modules**.**\</span>

**Prerequisites:** \<a href="Login" target="\_blank">access\</a> to the
Taurus system and basic knowledge about Linux, \<a href="SystemTaurus"
target="\_blank" title="SystemTaurus">Taurus\</a> and the \<a
href="RuntimeEnvironment" target="\_blank"
title="RuntimeEnvironment">modules system \</a>on Taurus.

\<span style="font-size: 1em;">EasyBuild uses a configuration file
called recipe or "EasyConfig", which contains all the information about
how to obtain and build the software:\</span>

-   Name
-   Version
-   Toolchain (think: Compiler + some more)
-   Download URL
-   Buildsystem (e.g. configure && make or cmake && make)
-   Config parameters
-   Tests to ensure a successful build

The "Buildsystem" part is implemented in so-called "EasyBlocks" and
contains the common workflow. Sometimes those are specialized to
encapsulate behaviour specific to multiple/all versions of the software.
\<span style="font-size: 1em;">Everything is written in Python, which
gives authors a great deal of flexibility.\</span>

## Set up a custom module environment and build your own modules

Installation of the new software (or version) does not require any
specific credentials.

\<br />Prerequisites: 1 An existing EasyConfig 1 a place to put your
modules. \<span style="font-size: 1em;">Step by step guide:\</span>

1\. Create a \<a href="WorkSpaces" target="\_blank">workspace\</a> where
you'll install your modules. You need a place where your modules will be
placed. This needs to be done only once :

    ws_allocate -F scratch EasyBuild 50                 #

2\. Allocate nodes. You can do this with interactive jobs (see the
example below) and/or put commands in a batch file and source it. The
latter is recommended for non-interactive jobs, using the command sbatch
in place of srun. For the sake of illustration, we use an interactive
job as an example. The node parameters depend, to some extent, on the
architecture you want to use. ML nodes for the Power9 and others for the
x86. We will use Haswell nodes.

    srun -p haswell -N 1 -c 4 --time=08:00:00 --pty /bin/bash

\*Using EasyBuild on the login nodes is not allowed\*

3\. Load EasyBuild module.

    module load EasyBuild

\<br />4. Specify Workspace. The rest of the guide is based on it.
Please create an environment variable called \`WORKSPACE\` with the
location of your Workspace:

    WORKSPACE=<location_of_your_workspace>         # For example: WORKSPACE=/scratch/ws/anpo879a-EasyBuild

5\. Load the correct modenv according to your current or target
architecture: \`ml modenv/scs5\` for x86 (default) or \`modenv/ml\` for
Power9 (ml partition). Load EasyBuild module

    ml modenv/scs5
    module load EasyBuild

6\. Set up your environment:

    export EASYBUILD_ALLOW_LOADED_MODULES=EasyBuild,modenv/scs5
    export EASYBUILD_DETECT_LOADED_MODULES=unload
    export EASYBUILD_BUILDPATH="/tmp/${USER}-EasyBuild${SLURM_JOB_ID:-}"
    export EASYBUILD_SOURCEPATH="${WORKSPACE}/sources"
    export EASYBUILD_INSTALLPATH="${WORKSPACE}/easybuild-$(basename $(readlink -f /sw/installed))"
    export EASYBUILD_INSTALLPATH_MODULES="${EASYBUILD_INSTALLPATH}/modules"
    module use "${EASYBUILD_INSTALLPATH_MODULES}/all"
    export LMOD_IGNORE_CACHE=1

7\. \<span style="font-size: 13px;">Now search for an existing
EasyConfig: \</span>

    eb --search TensorFlow

\<span style="font-size: 13px;">8. Build the EasyConfig and its
dependencies\</span>

    eb TensorFlow-1.8.0-fosscuda-2018a-Python-3.6.4.eb -r

\<span style="font-size: 13px;">After this is done (may take A LONG
time), you can load it just like any other module.\</span>

9\. To use your custom build modules you only need to rerun step 4, 5, 6
and execute the usual:

    module load <name_of_your_module>            # For example module load TensorFlow-1.8.0-fosscuda-2018a-Python-3.6.4

The key is the \`module use\` command which brings your modules into
scope so \`module load\` can find them and the LMOD_IGNORE_CACHE line
which makes LMod pick up the custom modules instead of searching the
system cache.

## Troubleshooting

When building your EasyConfig fails, you can first check the log
mentioned and scroll to the bottom to see what went wrong.

It might also be helpful to inspect the build environment EB uses. For
that you can run \`eb myEC.eb --dump-env-script\` which creates a
sourceable .env file with \`module load\` and \`export\` commands that
show what EB does before running, e.g., the configure step.

It might also be helpful to use '\<span style="font-size: 1em;">export
LMOD_IGNORE_CACHE=0'\</span>
