# Environment and Software

A joyful and efficient usage of ZIH systems bases on a profound understanding of the working
environment, which comprises your personal *user environment* and the *software environment*.

## User Environment

All ZIH systems use global home directories to provide homogeneous user environments across all
systems. The default login shell is `bash`. Personal additions and modifications can be put into
so called dotfiles in your home directory, e.g., `~/.bashrc` or `~/.bash_profile`.

## Software Environment

There are different options to work with software on ZIH systems: [modules](#modules),
[Jupyter Notebook](#jupyternotebook) and [containers](#containers). Brief descriptions and related
links on these options are provided below.

!!! note
    There are two different software environments:

    * `scs5` environment for the x86 architecture based compute resources
    * and `ml` environment for the Machine Learning partition based on the Power9 architecture.

## Modules

Usage of software on ZIH systems, e.g., frameworks, compilers, loader and libraries, is
almost always managed by a **modules system**. Thus, it is crucial to be familiar with the
[modules concept and its commands](modules.md).  A module is a user interface that provides
utilities for the dynamic modification of a user's environment without manual modifications.

Modules are used to set up the environment when working on ZIH systems via batch system (e.g.,
`srun` or `sbatch`), and the [JupyterHub](../access/jupyterhub.md).

## Jupyter Notebook

The [Jupyter Notebook](https://jupyter.org/) is an open-source web application that allows creating
documents containing live code, equations, visualizations, and narrative text. There is a
[JupyterHub](../access/jupyterhub.md) service on ZIH systems, where you can simply run your Jupyter
notebook on compute nodes using [modules](#modules), preloaded or custom virtual environments.
Moreover, you can run a [manually created remote Jupyter server](../archive/install_jupyter.md)
for more specific cases.

## Containers

Some tasks require using containers. It can be done on ZIH Systems by [Singularity](containers.md).
