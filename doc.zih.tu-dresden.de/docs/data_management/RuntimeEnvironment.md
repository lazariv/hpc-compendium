# Runtime Environment

Make sure you know how to work with a Linux system. Documentations and tutorials can be easily
found on the internet or in your library.

## Modules

To allow the user to switch between different versions of installed programs and libraries we use a
*module concept*. A module is a user interface that provides utilities for the dynamic modification
of a user's environment, i.e., users do not have to manually modify their environment variables (
`PATH` , `LD_LIBRARY_PATH`, ...) to access the compilers, loader, libraries, and utilities.

For all applications, tools, libraries etc. the correct environment can be easily set by e.g.
`module load Mathematica`. If several versions are installed they can be chosen like `module load
MATLAB/2019b`. A list of all modules shows `module avail`. Other important commands are:

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

### Lmod: An Alternative Module Implementation

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

### Module Environments

On Taurus, there exist different module environments, each containing a set of software modules.
They are activated via the meta module **modenv** which has different versions, one of which is
loaded by default. You can switch between them by simply loading the desired modenv-version, e.g.:

```Bash
module load modenv/ml
```

|              |                                                                        |         |
|--------------|------------------------------------------------------------------------|---------|
| modenv/scs5  | SCS5 software                                                          | default |
| modenv/ml    | HPC-DA software (for use on the "ml" partition)                        |         |
| modenv/hiera | Hierarchical module tree (for use on the "romeo" and "gpu3" partition) |         |

The old modules (pre-SCS5) are still available after loading **modenv**/**classic**, however, due to
changes in the libraries of the operating system, it is not guaranteed that they still work under
SCS5.  Please don't use modenv/classic if you do not absolutely have to. Most software is available
under modenv/scs5, too, just be aware of the possibly different spelling (case-sensitivity).

You can use `module spider \<modname>` to search for a specific
software in all modenv environments. It will also display information on
how to load a found module when giving a precise module (with version)
as the parameter.

Also see the information under [SCS5 software](../software/SCS5Software.md).

### Per-Architecture Builds

Since we have a heterogenous cluster, we do individual builds of some of the software for each
architecture present. This ensures that, no matter what partition the software runs on, a build
optimized for the host architecture is used automatically. This is achieved by having
`/sw/installed` symlinked to different directories on the compute nodes.

However, not every module will be available for each node type or partition. Especially when
introducing new hardware to the cluster, we do not want to rebuild all of the older module versions
and in some cases cannot fall-back to a more generic build either. That's why we provide the script:
`ml_arch_avail` that displays the availability of modules for the different node architectures.

E.g.:

```Bash
$ ml_arch_avail CP2K
CP2K/6.1-foss-2019a: haswell, rome
CP2K/5.1-intel-2018a: sandy, haswell
CP2K/6.1-foss-2019a-spglib: haswell, rome
CP2K/6.1-intel-2018a: sandy, haswell
CP2K/6.1-intel-2018a-spglib: haswell
```

shows all modules that match on CP2K, and their respective availability.  Note that this will not
work for meta-modules that do not have an installation directory (like some toolchain modules).

### Private User Module Files

Private module files allow you to load your own installed software into your environment and to
handle different versions without getting into conflicts.

You only have to call `module use <path to your module files>`, which adds your directory to the
list of module directories that are searched by the `module` command. Within the privatemodules
directory you can add directories for each software you wish to install and add - also in this
directory - a module file for each version you have installed. Further information about modules can
be found at <https://lmod.readthedocs.io> .

**todo** quite old

This is an example of a private module file:

```Bash
dolescha@venus:~/module use $HOME/privatemodules

dolescha@venus:~/privatemodules&gt; ls
null  testsoftware

dolescha@venus:~/privatemodules/testsoftware&gt; ls
1.0

dolescha@venus:~&gt; module av
------------------------------- /work/home0/dolescha/privatemodules ---------------------------
null             testsoftware/1.0

dolescha@venus:~&gt; module load testsoftware
Load testsoftware version 1.0

dolescha@venus:~/privatemodules/testsoftware&gt; cat 1.0 
#%Module######################################################################
##
##     testsoftware modulefile
##
proc ModulesHelp { } {
        puts stderr "Loads testsoftware"
}

set version 1.0
set arch    x86_64
set path    /home/&lt;user&gt;/opt/testsoftware/$version/$arch/

prepend-path PATH            $path/bin
prepend-path LD_LIBRARY_PATH $path/lib

if [ module-info mode load ] {
        puts stderr "Load testsoftware version $version"
}
```

### Private Project Module Files

Private module files allow you to load your group-wide installed software into your environment and
to handle different versions without getting into conflicts.

The module files have to be stored in your global projects directory, e.g.
`/projects/p_projectname/privatemodules`. An example for a module file can be found in the section
above.

To use a project-wide module file you have to add the path to the module file to the module
environment with following command `module use /projects/p_projectname/privatemodules`.

After that, the modules are available in your module environment and you
can load the modules with `module load` .

## Misc

An automated [backup](FileSystems.md#backup-and-snapshots-of-the-file-system)
system provides security for the HOME-directories on `Taurus` and `Venus` on a daily basis. This is
the reason why we urge our users to store (large) temporary data (like checkpoint files) on the
/scratch -Filesystem or at local scratch disks.

`Please note`: We have set `ulimit -c 0` as a default to prevent you from filling the disk with the
dump of a crashed program. `bash` -users can use `ulimit -Sc unlimited` to enable the debugging via
analyzing the core file (limit coredumpsize unlimited for tcsh).
