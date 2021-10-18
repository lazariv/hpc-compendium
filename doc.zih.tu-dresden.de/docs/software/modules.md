# Modules

Usage of software on HPC systems is managed by a **modules system**.

!!! note "Module"

    A module is a user interface that provides utilities for the dynamic modification of a user's
    environment (e.g., `PATH`, `LD_LIBRARY_PATH` etc.) to access the compilers, loader, libraries,
    and utilities. With the help of modules, users can smoothly switch between different versions of
    installed software packages and libraries.

For all applications, tools, libraries etc. the correct environment can be easily set by
calling "module load" or "module unload".

## Module Commands

| Command                       | Description                                                      |
|:------------------------------|:-----------------------------------------------------------------|
| `module help`                 | show all module options                                          |
| `module list`                 | list all user-installed modules                                  |
| `module purge`                | remove all user-installed modules                                |
| `module avail`                | list all available modules                                       |
| `module spider`               | search for modules across all environments, can take a parameter |
| `module load <modname>`       | load module `modname`                                            |
| `module unload <modname>`     | unloads module `modname`                                         |
| `module switch <mod1> <mod2>` | unload module `mod1` ; load module `mod2`                        |

Module files are ordered by their topic on our HPC systems. By default, with `module avail` you will
see all topics and their available module files. If you just wish to see the installed versions of a
certain module, you can use `module avail softwarename` and it will display the available versions of
`softwarename` only.

## Module Environments

On the ZIH systems, there exist different module environments, each containing a set of software modules.
They are activated via the meta module `modenv` which has different versions, one of which is loaded
by default. You can switch between them by simply loading the desired modenv-version, e.g.:

```console
marie@compute$ module load modenv/ml
```

### modenv/scs5 (default)

* SCS5 software
* usually optimized for Intel processors (Partitions: `haswell`, `broadwell`, `gpu2`, `julia`)

### modenv/ml

* data analytics software (for use on the partition ml)
* necessary to run most software on the partition ml
(The instruction set [Power ISA](https://en.wikipedia.org/wiki/Power_ISA#Power_ISA_v.3.0)
is different from the usual x86 instruction set.
Thus the 'machine code' of other modenvs breaks).

### modenv/hiera

* uses a hierarchical module load scheme
* optimized software for AMD processors (Partitions: romeo, alpha)

### modenv/classic

* deprecated, old software. Is not being curated.
* may break due to library inconsistencies with the operating system.
* please don't use software from that modenv

### Searching for Software

The command `module spider <modname>` allows searching for specific software in all modenv
environments. It will also display information on how to load a found module when giving a precise
module (with version) as the parameter.

## Per-architecture Builds

Since we have a heterogeneous cluster, we do individual builds of some of the software for each
architecture present. This ensures that, no matter what partition the software runs on, a build
optimized for the host architecture is used automatically.
For that purpose we have created symbolic links on the compute nodes,
at the system path '/sw/installed'.

However, not every module will be available for each node type or partition. Especially when
introducing new hardware to the cluster, we do not want to rebuild all of the older module versions
and in some cases cannot fall-back to a more generic build either. That's why we provide the script:
`ml_arch_avail` that displays the availability of modules for the different node architectures.

### Example Invocation of ml_arch_avail

```console
marie@compute$ ml_ar:qLch_avail CP2K

Example output:

#CP2K/6.1-foss-2019a: haswell, rome
#CP2K/5.1-intel-2018a: haswell
#CP2K/6.1-foss-2019a-spglib: haswell, rome
#CP2K/6.1-intel-2018a: haswell
#CP2K/6.1-intel-2018a-spglib: haswell
```

The command shows all modules that match on CP2K, and their respective availability. Note that this
will not work for meta-modules that do not have an installation directory (like some tool chain modules).

## Project and User Private Modules

Private module files allow you to load your own installed software packages into your environment
and to handle different versions without getting into conflicts. Private modules can be setup for a
single user as well as all users of project group. The workflow and settings for user private module
files is described in the following. The [settings for project private
modules](#project-private-modules) differ only in details.

In order to use your own module files please use the command
`module use <path_to_module_files>`. It will add the path to the list of module directories
that are searched by lmod (i.e. the `module` command). You may use a directory `privatemodules`
within your home or project directory to setup your own module files.

Please see the [Environment Modules open source project's web page](http://modules.sourceforge.net/)
for further information on writing module files.

### 1. Create Directories

```console
marie@compute$ cd $HOME
marie@compute$ mkdir --verbose --parents privatemodules/testsoftware
marie@compute$ cd privatemodules/testsoftware
```

(create a directory in your home directory)

### 2. Notify lmod

```console
marie@compute$ module use $HOME/privatemodules
```

(add the directory in the list of module directories)

### 3. Create Modulefile

Create a file with the name `1.0` with a
test software in the `testsoftware` directory you created earlier
(using your favorite editor) and paste the following text into it:

```
#%Module######################################################################
##
##     testsoftware modulefile
##
proc ModulesHelp { } {
        puts stderr "Loads testsoftware"
}

set version 1.0
set arch    x86_64
set path    /home/<user>/opt/testsoftware/$version/$arch/

prepend-path PATH            $path/bin
prepend-path LD_LIBRARY_PATH $path/lib

if [ module-info mode load ] {
        puts stderr "Load testsoftware version $version"
}
```

### 4. Check lmod

Check the availability of the module with `ml av`, the output should look like this:

```
--------------------- /home/masterman/privatemodules ---------------------
   testsoftware/1.0
```

### 5. Load Module

Load the test module with `module load testsoftware`, the output should look like this:

```console
Load testsoftware version 1.0
Module testsoftware/1.0 loaded.
```

### Project Private Modules

Private module files allow you to load project- or group-wide installed software into your
environment and to handle different versions without getting into conflicts.

The module files have to be stored in your global projects directory
`/projects/p_projectname/privatemodules`. An example of a module file can be found in the section
above. To use a project-wide module file you have to add the path to the module file to the module
environment with the command

```console
marie@compute$ module use /projects/p_projectname/privatemodules
```

After that, the modules are available in your module environment and you can load the modules with
the `module load` command.

## Using Private Modules and Programs in the $HOME Directory

An automated backup system provides security for the HOME-directories on the cluster on a daily
basis. This is the reason why we urge users to store (large) temporary data (like checkpoint files)
on the /scratch filesystem or at local scratch disks.

**Please note**: We have set `ulimit -c 0` as a default to prevent users from filling the disk with
the dump of crashed programs. `bash` users can use `ulimit -Sc unlimited` to enable the debugging
via analyzing the core file.
