# Use of Containers

[Containerization]**todo link** encapsulating or packaging up software code and all its dependencies
to run uniformly and consistently on any infrastructure. On Taurus [Singularity]**todo link** used
as a standard container solution. Singularity enables users to have full control of their
environment. This means that you don’t have to ask an HPC support to install anything for you - you
can put it in a Singularity container and run! As opposed to Docker (the most famous container
solution), Singularity is much more suited to being used in an HPC environment and more efficient in
many cases. Docker containers can easily be used in Singularity. Information about the use of
Singularity on Taurus can be found [here]**todo link**.

In some cases using Singularity requires a Linux machine with root privileges (e.g. using the ml
partition), the same architecture and a compatible kernel. For many reasons, users on Taurus cannot
be granted root permissions. A solution is a Virtual Machine (VM) on the ml partition which allows
users to gain root permissions in an isolated environment. There are two main options on how to work
with VM on Taurus:

  1. [VM tools]**todo link**. Automative algorithms for using virtual machines;
  1. [Manual method]**todo link**. It required more operations but gives you more flexibility and reliability.

Additional Information: Examples of the definition for the Singularity container ([here]**todo
link**) and some hints ([here]**todo link**).

Useful links: [Containers]**todo link**, [Custom EasyBuild Environment]**todo link**, [Virtual
machine on Taurus]**todo link**
