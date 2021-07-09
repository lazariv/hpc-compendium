# Container on HPC-DA (TensorFlow, PyTorch)

<span class="twiki-macro RED"></span> **Note: This page is under
construction** <span class="twiki-macro ENDCOLOR"></span>

\<span style="font-size: 1em;">A container is a standard unit of
software that packages up code and all its dependencies so the
application runs quickly and reliably from one computing environment to
another.\</span>

**Prerequisites:** To work with Tensorflow, you need \<a href="Login"
target="\_blank">access\</a> for the Taurus system and basic knowledge
about containers, Linux systems.

**Aim** of this page is to introduce users on how to use Machine
Learning Frameworks such as TensorFlow or PyTorch on the \<a
href="HPCDA" target="\_self">HPC-DA\</a> system - part of the TU Dresden
HPC system.

Using a container is one of the options to use Machine learning
workflows on Taurus. Using containers gives you more flexibility working
with modules and software but at the same time required more effort.

\<span style="font-size: 1em;">On Taurus \</span>\<a
href="<https://sylabs.io/>" target="\_blank">Singularity\</a>\<span
style="font-size: 1em;"> used as a standard container solution.
Singularity enables users to have full control of their environment.
Singularity containers can be used to package entire scientific
workflows, software and libraries, and even data. This means that
\</span>**you dont have to ask an HPC support to install anything for
you - you can put it in a Singularity container and run!**\<span
style="font-size: 1em;">As opposed to Docker (the most famous container
solution), Singularity is much more suited to being used in an HPC
environment and more efficient in many cases. Docker containers also can
easily be used in Singularity.\</span>

Future information is relevant for the HPC-DA system (ML partition)
based on Power9 architecture.

In some cases using Singularity requires a Linux machine with root
privileges, the same architecture and a compatible kernel. For many
reasons, users on Taurus cannot be granted root permissions. A solution
is a Virtual Machine (VM) on the ml partition which allows users to gain
root permissions in an isolated environment. There are two main options
on how to work with VM on Taurus:

1\. [VM tools](vm_tools.md). Automative algorithms for using virtual
machines;

2\. [Manual method](cloud.md). It required more operations but gives you
more flexibility and reliability.

Short algorithm to run the virtual machine manually:

    srun -p ml -N 1 -c 4 --hint=nomultithread --cloud=kvm --pty /bin/bash<br />cat ~/.cloud_$SLURM_JOB_ID                                                          #Example output: ssh root@192.168.0.1<br />ssh root@192.168.0.1                                                                #Copy and paste output from the previous command     <br />./mount_host_data.sh 

with VMtools:

VMtools contains two main programs:
**\<span>buildSingularityImage\</span>** and
**\<span>startInVM.\</span>**

Main options on how to create a container on ML nodes:

1\. Create a container from the definition

1.1 Create a Singularity definition from the Dockerfile.

\<span style="font-size: 1em;">2. Importing container from the \</span>
[DockerHub](https://hub.docker.com/search?q=ppc64le&type=image&page=1)\<span
style="font-size: 1em;"> or \</span>
[SingularityHub](https://singularity-hub.org/)

Two main sources for the Tensorflow containers for the Power9
architecture:

<https://hub.docker.com/r/ibmcom/tensorflow-ppc64le>

<https://hub.docker.com/r/ibmcom/powerai>

Pytorch:

<https://hub.docker.com/r/ibmcom/powerai>

-- Main.AndreiPolitov - 2020-01-03
