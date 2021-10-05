# Modules

Usage of software on HPC systems is managed by a **modules system**.

!!! note "Module"

    A module is a user interface that provides utilities for the dynamic modification of a user's
    environment (e.g., `PATH`, `LD_LIBRARY_PATH` etc.) to access the compilers, loader, libraries,
    and utilities. With the help of modules, users can smoothly switch between different versions of
    installed software packages and libraries.

For all applications, tools, libraries etc. the correct environment can be easily set loading and/or
unloading modules.

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

Module files are ordered by their topic on our HPC systems. By default, with `module av` you will
see all available module files and topics. If you just wish to see the installed versions of a
certain module, you can use `module av softwarename` and it will display the available versions of
`softwarename` only.

## Lmod: An Alternative Module Implementation

Historically, the module command on our HPC systems has been provided by the rather dated
*Environment Modules* software which was first introduced in 1991. As of late 2016, we also offer
the new and improved [LMOD](https://www.tacc.utexas.edu/research-development/tacc-projects/lmod) as
an alternative. It has a handful of advantages over the old Modules implementation:

- all modulefiles are cached, which especially speeds up tab
  completion with bash
- sane version ordering (9.0 \< 10.0)
- advanced version requirement functions (atleast, between, latest)
- auto-swapping of modules (if a different version was already loaded)
- save/auto-restore of loaded module sets (module save)
- multiple language support
- properties, hooks, ...
- depends_on() function for automatic dependency resolution with
  reference counting

## Module environments

On Taurus, there exist different module environments, each containing a set of software modules.
They are activated via the meta module modenv which has different versions, one of which is loaded
by default. You can switch between them by simply loading the desired modenv-version, e.g.:

```
module load modenv/ml
```

| modenv/scs5    | SCS5 software                                   | default |
|                |                                                 |         |
| modenv/ml      | HPC-DA software (for use on the "ml" partition) |         |
| modenv/hiera   | WIP hierarchical module tree                    |         |
| modenv/classic | Manually built pre-SCS5 (AE4.0) software        | default |
|                |                                                 |         |

The old modules (pre-SCS5) are still available after loading the corresponding `modenv` version
(classic), however, due to changes in the libraries of the operating system, it is not guaranteed
that they still work under SCS5. Please don't use modenv/classic if you do not absolutely have to.
Most software is available under modenv/scs5, too, just be aware of the possibly different spelling
(case-sensitivity).

The command `module spider <modname>` allows searching for specific software in all modenv
environments. It will also display information on how to load a found module when giving a precise
module (with version) as the parameter.

## Per-architecture builds

Since we have a heterogeneous cluster, we do individual builds of some of the software for each
architecture present. This ensures that, no matter what partition the software runs on, a build
optimized for the host architecture is used automatically. This is achieved by having
'/sw/installed' symlinked to different directories on the compute nodes.

However, not every module will be available for each node type or partition. Especially when
introducing new hardware to the cluster, we do not want to rebuild all of the older module versions
and in some cases cannot fall-back to a more generic build either. That's why we provide the script:
`ml_arch_avail` that displays the availability of modules for the different node architectures.

```
ml_arch_avail CP2K

Example output:

#CP2K/6.1-foss-2019a: haswell, rome
#CP2K/5.1-intel-2018a: haswell
#CP2K/6.1-foss-2019a-spglib: haswell, rome
#CP2K/6.1-intel-2018a: haswell
#CP2K/6.1-intel-2018a-spglib: haswell
```

The command shows all modules that match on CP2K, and their respective availability. Note that this
will not work for meta-modules that do not have an installation directory (like some toolchain
modules).

## Project and User Private Modules

Private module files allow you to load your own installed software packages into your environment
and to handle different versions without getting into conflicts. Private modules can be setup for a
single user as well as all users of project group. The workflow and settings for user private module
files is described in the following. The [settings for project private
modules](#project-private-modules) differ only in details.

The command

```
module use <path_to_module_files>
```

adds directory by user choice to the list of module directories that are searched by the `module`
command. Within directory `../privatemodules` user can add directories for every software user wish
to install and add also in this directory a module file for every version user have installed.
Further information about modules can be found [here](http://modules.sourceforge.net/).

This is an example of work a private module file:

- create a directory in your home directory:

```
cd
mkdir privatemodules && cd privatemodules
mkdir testsoftware && cd testsoftware
```

- add the directory in the list of module directories:

```
module use $HOME/privatemodules
```

- create a file with the name `1.0` with a test software in the `testsoftware` directory (use e.g.
echo, emacs, etc):

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

- check the availability of the module with `ml av`, the output should look like this:

```
--------------------- /home/masterman/privatemodules ---------------------
   testsoftware/1.0
```

- load the test module with `module load testsoftware`, the output:

```
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

```
module use /projects/p_projectname/privatemodules
```

After that, the modules are available in your module environment and you can load the modules with
the `module load` command.

## Using Private Modules and Programs in the $HOME Directory

An automated backup system provides security for the HOME-directories on the cluster on a daily
basis. This is the reason why we urge users to store (large) temporary data (like checkpoint files)
on the /scratch -Filesystem or at local scratch disks.

**Please note**: We have set `ulimit -c 0` as a default to prevent users from filling the disk with
the dump of a crashed program. bash -users can use `ulimit -Sc unlimited` to enable the debugging
via analyzing the core file (limit coredumpsize unlimited for tcsh).
