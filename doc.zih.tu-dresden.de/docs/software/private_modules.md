# Project and User Private Modules

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

## 1. Create Directories

```console
marie@compute$ cd $HOME
marie@compute$ mkdir --verbose --parents privatemodules/testsoftware
marie@compute$ cd privatemodules/testsoftware
```

(create a directory in your home directory)

## 2. Notify lmod

```console
marie@compute$ module use $HOME/privatemodules
```

(add the directory in the list of module directories)

## 3. Create Modulefile

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

## 4. Check lmod

Check the availability of the module with `ml av`, the output should look like this:

```
--------------------- /home/masterman/privatemodules ---------------------
   testsoftware/1.0
```

## 5. Load Module

Load the test module with `module load testsoftware`, the output should look like this:

```console
Load testsoftware version 1.0
Module testsoftware/1.0 loaded.
```

## Project Private Modules

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
