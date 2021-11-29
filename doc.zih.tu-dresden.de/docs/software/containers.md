# Use of Containers

[Containerization](https://www.ibm.com/cloud/learn/containerization) encapsulating or packaging up
software code and all its dependencies to run uniformly and consistently on any infrastructure. On
ZIH systems [Singularity](https://sylabs.io/) is used as a standard container solution. Singularity
enables users to have full control of their environment. This means that you don’t have to ask the
HPC support to install anything for you - you can put it in a Singularity container and run! As
opposed to Docker (the most famous container solution), Singularity is much more suited to being
used in an HPC environment and more efficient in many cases. Docker containers can easily be used in
Singularity. Information about the use of Singularity on ZIH systems can be found on this page.

In some cases using Singularity requires a Linux machine with root privileges (e.g. using the
partition `ml`), the same architecture and a compatible kernel. For many reasons, users on ZIH
systems cannot be granted root permissions. A solution is a Virtual Machine (VM) on the partition
`ml` which allows users to gain root permissions in an isolated environment. There are two main
options on how to work with Virtual Machines on ZIH systems:

1. [VM tools](virtual_machines_tools.md): Automated algorithms for using virtual machines;
1. [Manual method](virtual_machines.md): It requires more operations but gives you more flexibility
   and reliability.

## Singularity

If you wish to containerize your workflow and/or applications, you can use Singularity containers on
ZIH systems. As opposed to Docker, this solution is much more suited to being used in an HPC
environment.

!!! note

    It is not possible for users to generate new custom containers on ZIH systems directly, because
    creating a new container requires root privileges.

However, new containers can be created on your local workstation and moved to ZIH systems for
execution. Follow the instructions for [locally installing Singularity](#local-installation) and
[container creation](#container-creation). Moreover, existing Docker container can easily be
converted, see [Import a docker container](#importing-a-docker-container).

If you are already familiar with Singularity, you might be more interested in our [singularity
recipes and hints](singularity_recipe_hints.md).

### Local Installation

The local installation of Singularity comprises two steps: Make `go` available and then follow the
instructions from the official documentation to install Singularity.

1. Check if `go` is installed by executing `go version`.  If it is **not**:

    ```console
    marie@local$ wget <https://storage.googleapis.com/golang/getgo/installer_linux> && chmod +x
    installer_linux && ./installer_linux && source $HOME/.bash_profile
    ```

1. Instructions to
   [install Singularity](https://github.com/sylabs/singularity/blob/master/INSTALL.md#clone-the-repo)
   from the official documentation:

    Clone the repository

    ```console
    marie@local$ mkdir -p ${GOPATH}/src/github.com/sylabs
    marie@local$ cd ${GOPATH}/src/github.com/sylabs
    marie@local$ git clone https://github.com/sylabs/singularity.git
    marie@local$ cd singularity
    ```

    Checkout the version you want (see the [GitHub releases page](https://github.com/sylabs/singularity/releases)
    for available releases), e.g.

    ```console
    marie@local$ git checkout v3.2.1
    ```

    Build and install

    ```console
    marie@local$ cd ${GOPATH}/src/github.com/sylabs/singularity
    marie@local$ ./mconfig && cd ./builddir && make
    marie@local$ sudo make install
    ```

### Container Creation

!!! note

    It is not possible for users to generate new custom containers on ZIH systems directly, because
    creating a new container requires root privileges.

There are two possibilities:

1. Create a new container on your local workstation (where you have the necessary privileges), and
   then copy the container file to ZIH systems for execution.
1. You can, however, import an existing container from, e.g., Docker.

Both methods are outlined in the following.

#### New Custom Container

You can create a new custom container on your workstation, if you have root rights.

!!! attention "Respect the micro-architectures"

    You cannot create containers for the partition `ml`, as it bases on Power9 micro-architecture
    which is different to the x86 architecture in common computers/laptops. For that you can use
    the [VM Tools](virtual_machines_tools.md).

Creating a container is done by writing a **definition file** and passing it to

```console
marie@local$ singularity build myContainer.sif <myDefinition.def>
```

A definition file contains a bootstrap
[header](https://sylabs.io/guides/3.2/user-guide/definition_files.html#header)
where you choose the base and
[sections](https://sylabs.io/guides/3.2/user-guide/definition_files.html#sections)
where you install your software.

The most common approach is to start from an existing docker image from DockerHub. For example, to
start from an [Ubuntu image](https://hub.docker.com/_/ubuntu) copy the following into a new file
called `ubuntu.def` (or any other filename of your choice)

```bash
Bootstrap: docker
From: ubuntu:trusty

%runscript
    echo "This is what happens when you run the container..."

%post
    apt-get install g++
```

Then you can call

```console
marie@local$ singularity build ubuntu.sif ubuntu.def
```

And it will install Ubuntu with g++ inside your container, according to your definition file.
More bootstrap options are available. The following example, for instance, bootstraps a basic CentOS
7 image.

```Bash
BootStrap: yum
OSVersion: 7
MirrorURL: http://mirror.centos.org/centos-%{OSVERSION}/%{OSVERSION}/os/$basearch/
Include: yum

%runscript
    echo "This is what happens when you run the container..."

%post
    echo "Hello from inside the container"
    yum -y install vim-minimal
```

More examples of definition files can be found at
https://github.com/singularityware/singularity/tree/master/examples.

#### Import a Docker Container

!!! hint

    As opposed to bootstrapping a container, importing from Docker does **not require root
    privileges** and therefore works on ZIH systems directly.

You can import an image directly from the Docker repository (Docker Hub):

```console
marie@local$ singularity build my-container.sif docker://ubuntu:latest
```

Creating a singularity container directly from a local docker image is possible but not
recommended. The steps are:

```console
# Start a docker registry
$ docker run -d -p 5000:5000 --restart=always --name registry registry:2

# Push local docker container to it
$ docker tag alpine localhost:5000/alpine
$ docker push localhost:5000/alpine

# Create def file for singularity like this...
$ cat example.def
Bootstrap: docker
Registry: <a href="http://localhost:5000" rel="nofollow" target="_blank">http://localhost:5000</a>
From: alpine

# Build singularity container
$ singularity build --nohttps alpine.sif example.def
```

#### Start from a Dockerfile

As Singularity definition files and Dockerfiles are very similar you can start creating a definition
file from an existing Dockerfile by "translating" each section.

There are tools to automate this. One of them is
[spython](https://github.com/singularityhub/singularity-cli) which can be installed with `pip`
(add `--user` if you don't want to install it system-wide):

```console
marie@local$ pip3 install -U spython
```

With this you can simply issue the following command to convert a Dockerfile in the current folder
into a singularity definition file:

```console
marie@local$ spython recipe Dockerfile myDefinition.def
```

Please **verify** your generated definition and adjust where required!

There are some notable changes between Singularity definitions and Dockerfiles:

1. Command chains in Dockerfiles (`apt-get update && apt-get install foo`) must be split into
   separate commands (`apt-get update; apt-get install foo`). Otherwise a failing command before the
   ampersand is considered "checked" and does not fail the build.
1. The environment variables section in Singularity is only set on execution of the final image, not
   during the build as with Docker. So `*ENV*` sections from Docker must be translated to an entry
   in the `%environment` section and **additionally** set in the `%runscript` section if the
   variable is used there.
1. `*VOLUME*` sections from Docker cannot be represented in Singularity containers. Use the runtime
   option \`-B\` to bind folders manually.
1. `CMD` and `ENTRYPOINT` from Docker do not have a direct representation in Singularity.
   The closest is to check if any arguments are given in the `%runscript` section and call the
   command from `ENTRYPOINT` with those, if none are given call `ENTRYPOINT` with the
   arguments of `CMD`:

  ```bash
  if [ $# -gt 0 ]; then
    <ENTRYPOINT> "$@"
  else
    <ENTRYPOINT> <CMD>
  fi
  ```

### Use the Containers

#### Enter a Shell in Your Container

A read-only shell can be entered as follows:

```console
marie@login$ singularity shell my-container.sif
```

!!! note

    In contrast to, for instance, Docker, this will mount various folders from the host system
    including $HOME. This may lead to problems with, e.g., Python that stores local packages in the
    home folder, which may not work inside the container. It also makes reproducibility harder. It
    is therefore recommended to use `--contain/-c` to not bind `$HOME` (and others like `/tmp`)
    automatically and instead set up your binds manually via `-B` parameter. Example:

    ```console
    marie@login$ singularity shell --contain -B /scratch,/my/folder-on-host:/folder-in-container my-container.sif
    ```

You can write into those folders by default. If this is not desired, add an `:ro` for read-only to
the bind specification (e.g. `-B /scratch:/scratch:ro\`).  Note that we already defined bind paths
for `/scratch`, `/projects` and `/sw` in our global `singularity.conf`, so you needn't use the `-B`
parameter for those.

If you wish to install additional packages, you have to use the `-w` parameter to
enter your container with it being writable. This, again, must be done on a system where you have
the necessary privileges, otherwise you can only edit files that your user has the permissions for.
E.g:

```console
marie@local$ singularity shell -w my-container.sif
Singularity.my-container.sif> yum install htop
```

The `-w` parameter should only be used to make permanent changes to your container, not for your
productive runs (it can only be used writable by one user at the same time). You should write your
output to the usual ZIH filesystems like `/scratch`. Launching applications in your container

#### Run a Command Inside the Container

While the `shell` command can be useful for tests and setup, you can also launch your applications
inside the container directly using "exec":

```console
marie@login$ singularity exec my-container.img /opt/myapplication/bin/run_myapp
```

This can be useful if you wish to create a wrapper script that transparently calls a containerized
application for you. E.g.:

```bash
#!/bin/bash

X=`which singularity 2>/dev/null`
if [ "z$X" = "z" ] ; then
  echo "Singularity not found. Is the module loaded?"
  exit 1
fi

singularity exec /scratch/p_myproject/my-container.sif /opt/myapplication/run_myapp "$@"
```

The better approach is to use `singularity run`, which executes whatever was set in the `%runscript`
section of the definition file with the arguments you pass to it. Example: Build the following
definition file into an image:

```bash
Bootstrap: docker
From: ubuntu:trusty

%post
  apt-get install -y g++
  echo '#include <iostream>' > main.cpp
  echo 'int main(int argc, char** argv){ std::cout << argc << " args for " << argv[0] << std::endl; }' >> main.cpp
  g++ main.cpp -o myCoolApp
  mv myCoolApp /usr/local/bin/myCoolApp

%runscript
  myCoolApp "$@
singularity build my-container.sif example.def
```

Then you can run your application via

```console
singularity run my-container.sif first_arg 2nd_arg
```

Alternatively you can execute the container directly which is equivalent:

```console
./my-container.sif first_arg 2nd_arg
```

With this you can even masquerade an application with a singularity container as if it was an actual
program by naming the container just like the binary:

```console
mv my-container.sif myCoolAp
```

### Use-Cases

One common use-case for containers is that you need an operating system with a newer
[glibc](https://www.gnu.org/software/libc/) version than what is available on ZIH systems. E.g., the
bullx Linux on ZIH systems used to be based on RHEL 6 having a rather dated glibc version 2.12, some
binary-distributed applications didn't work on that anymore. You can use one of our pre-made CentOS
7 container images (`/scratch/singularity/centos7.img`) to circumvent this problem. Example:

```console
marie@login$ singularity exec /scratch/singularity/centos7.img ldd --version
ldd (GNU libc) 2.17
```
