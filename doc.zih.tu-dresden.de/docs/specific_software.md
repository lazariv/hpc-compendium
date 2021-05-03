# Use of Specific Software (packages, libraries, etc)

## Modular System

The modular concept is the easiest way to work with the software on Taurus. It allows to user to
switch between different versions of installed programs and provides utilities for the dynamic
modification of a user's environment. The information can be found [here](todo).

### Private project and user modules files

[Private project module files](todo) allow you to load your group-wide installed software into your
environment and to handle different versions. It allows creating your own software environment for
the project. You can create a list of modules that will be loaded for every member of the team. It
gives opportunity on unifying work of the team and defines the reproducibility of results. Private
modules can be loaded like other modules with module load.

[Private user module files](todo) allow you to load your own installed software into your
environment. It works in the same manner as to project modules but for your private use.

## Use of containers

[Containerization](todo) encapsulating or packaging up software code and all its dependencies to run
uniformly and consistently on any infrastructure. On Taurus [Singularity](todo) used as a standard
container solution. Singularity enables users to have full control of their environment. This means
that you don’t have to ask an HPC support to install anything for you - you can put it in a
Singularity container and run! As opposed to Docker (the most famous container solution),
Singularity is much more suited to being used in an HPC environment and more efficient in many
cases. Docker containers can easily be used in Singularity. Information about the use of Singularity
on Taurus can be found [here](todo).

In some cases using Singularity requires a Linux machine with root privileges (e.g. using the ml
partition), the same architecture and a compatible kernel. For many reasons, users on Taurus cannot
be granted root permissions. A solution is a Virtual Machine (VM) on the ml partition which allows
users to gain root permissions in an isolated environment. There are two main options on how to work
with VM on Taurus:

  1. [VM tools](todo). Automative algorithms for using virtual machines;
  1. [Manual method](todo). It required more operations but gives you more flexibility and reliability.

Additional Information: Examples of the definition for the Singularity container ([here](todo)) and
some hints ([here](todo)).

Useful links: [Containers](todo), [Custom EasyBuild Environment](todo), [Virtual machine on
Taurus](todo)
