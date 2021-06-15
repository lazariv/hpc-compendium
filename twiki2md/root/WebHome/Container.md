# Singularity



If you wish to containerize your workflow/applications, you can use
Singularity containers on Taurus. As opposed to Docker, this solution is
much more suited to being used in an HPC environment. Existing Docker
containers can easily be converted.

Website: \<a href="<https://www.sylabs.io>"
target="\_blank"><https://www.sylabs.io>\</a>\<br />Docu: \<a
href="<https://www.sylabs.io/docs/>"
target="\_blank"><https://www.sylabs.io/docs/>\</a>

ZIH wiki sites:

-   [Example Definitions](SingularityExampleDefinitions)
-   [Building Singularity images on Taurus](VMTools)
-   [Hints on Advanced usage](SingularityRecipeHints)

It is available on Taurus without loading any module.

## Local installation

One advantage of containers is that you can create one on a local
machine (e.g. your laptop) and move it to the HPC system to execute it
there. This requires a local installation of singularity. The easiest
way to do so is: 1 Check if go is installed by executing \`go version\`.
If it is **not**: \<verbatim>wget
<https://storage.googleapis.com/golang/getgo/installer_linux> && chmod
+x installer_linux && ./installer_linux && source
$HOME/.bash_profile\</verbatim> 1 Follow the instructions to [install
Singularity](https://github.com/sylabs/singularity/blob/master/INSTALL.md#clone-the-repo)\<br
/>\<br /> Clone the repo\<br /> \<pre>mkdir -p
${GOPATH}/src/github.com/sylabs && cd ${GOPATH}/src/github.com/sylabs &&
git clone <https://github.com/sylabs/singularity.git> && cd
singularity\</pre> Checkout the version you want (see the \<a
href="<https://github.com/sylabs/singularity/releases>"
target="\_blank">Github Releases page\</a> for available releases),
e.g.\<br /> \<pre>git checkout v3.2.1\</pre> Build and install\<br />
\<pre>cd ${GOPATH}/src/github.com/sylabs/singularity && ./mconfig && cd
./builddir && make && sudo make install\</pre>

## 

## Container creation

Since creating a new container requires access to system-level tools and
thus root privileges, it is not possible for users to generate new
custom containers on Taurus directly. You can, however, import an
existing container from, e.g., Docker.

In case you wish to create a new container, you can do so on your own
local machine where you have the necessary privileges and then simply
copy your container file to Taurus and use it there.\<br />This does not
work on our **ml** partition, as it uses Power9 as its architecture
which is different to the x86 architecture in common
computers/laptops.** For that you can use the [VM Tools](VMTools).**

### Creating a container

Creating a container is done by writing a definition file and passing it
to

    singularity build myContainer.sif myDefinition.def

NOTE: This must be done on a machine (or \<a href="Cloud"
target="\_blank">VM\</a>) with root rights.

A definition file contains a bootstrap \<a
href="<https://sylabs.io/guides/3.2/user-guide/definition_files.html#header>"
target="\_blank">header\</a> where you choose the base and \<a
href="<https://sylabs.io/guides/3.2/user-guide/definition_files.html#sections>"
target="\_blank">sections\</a> where you install your software.

The most common approach is to start from an existing docker image from
DockerHub. For example, to start from an \<a
href="<https://hub.docker.com/_/ubuntu>" target="\_blank">ubuntu
image\</a> copy the following into a new file called ubuntu.def (or any
other filename of your choosing)

    Bootstrap: docker<br />From: ubuntu:trusty<br /><br />%runscript<br />   echo "This is what happens when you run the container..."<br /><br />%post<br />    apt-get install g++

Then you can call:

    singularity build ubuntu.sif ubuntu.def

And it will install Ubuntu with g++ inside your container, according to
your definition file.

More bootstrap options are available. The following example, for
instance, bootstraps a basic CentOS 7 image.

    BootStrap: yum
    OSVersion: 7
    MirrorURL: http://mirror.centos.org/centos-%{OSVERSION}/%{OSVERSION}/os/$basearch/
    Include: yum

    %runscript
        echo "This is what happens when you run the container..."

    %post
        echo "Hello from inside the container"
        yum -y install vim-minimal

More examples of definition files can be found at
<https://github.com/singularityware/singularity/tree/master/examples>

### Importing a docker container

You can import an image directly from the Docker repository (Docker
Hub):

    singularity build my-container.sif docker://ubuntu:latest

As opposed to bootstrapping a container, importing from Docker does
**not require root privileges** and therefore works on Taurus directly.

Creating a singularity container directly from a local docker image is
possible but not recommended. Steps:

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

### Starting from a Dockerfile

As singularity definition files and Dockerfiles are very similar you can
start creating a definition file from an existing Dockerfile by
"translating" each section.

There are tools to automate this. One of them is \<a
href="<https://github.com/singularityhub/singularity-cli>"
target="\_blank">spython\</a> which can be installed with \`pip\` (add
\`--user\` if you don't want to install it system-wide):

`pip3 install -U spython`

With this you can simply issue the following command to convert a
Dockerfile in the current folder into a singularity definition file:

`spython recipe Dockerfile myDefinition.def<br />`

Now please **verify** your generated defintion and adjust where
required!

There are some notable changes between singularity definitions and
Dockerfiles: 1 Command chains in Dockerfiles (\`apt-get update &&
apt-get install foo\`) must be split into separate commands (\`apt-get
update; apt-get install foo). Otherwise a failing command before the
ampersand is considered "checked" and does not fail the build. 1 The
environment variables section in Singularity is only set on execution of
the final image, not during the build as with Docker. So \`*ENV*\`
sections from Docker must be translated to an entry in the
*%environment* section and **additionally** set in the *%runscript*
section if the variable is used there. 1 \`*VOLUME*\` sections from
Docker cannot be represented in Singularity containers. Use the runtime
option \`-B\` to bind folders manually. 1 *\`CMD\`* and *\`ENTRYPOINT\`*
from Docker do not have a direct representation in Singularity. The
closest is to check if any arguments are given in the *%runscript*
section and call the command from \`*ENTRYPOINT*\` with those, if none
are given call \`*ENTRYPOINT*\` with the arguments of \`*CMD*\`:
\<verbatim>if \[ $# -gt 0 \]; then \<ENTRYPOINT> "$@" else \<ENTRYPOINT>
\<CMD> fi\</verbatim>

## Using the containers

### Entering a shell in your container

A read-only shell can be entered as follows:

    singularity shell my-container.sif

**IMPORTANT:** In contrast to, for instance, Docker, this will mount
various folders from the host system including $HOME. This may lead to
problems with, e.g., Python that stores local packages in the home
folder, which may not work inside the container. It also makes
reproducibility harder. It is therefore recommended to use
\`--contain/-c\` to not bind $HOME (and others like /tmp) automatically
and instead set up your binds manually via \`-B\` parameter. Example:

    singularity shell --contain -B /scratch,/my/folder-on-host:/folder-in-container my-container.sif

You can write into those folders by default. If this is not desired, add
an \`:ro\` for read-only to the bind specification (e.g. \`-B
/scratch:/scratch:ro\`).\<br />Note that we already defined bind paths
for /scratch, /projects and /sw in our global singularity.conf, so you
needn't use the -B parameter for those.

If you wish, for instance, to install additional packages, you have to
use the `-w` parameter to enter your container with it being writable.
This, again, must be done on a system where you have the necessary
privileges, otherwise you can only edit files that your user has the
permissions for. E.g:

    singularity shell -w my-container.sif
    Singularity.my-container.sif> yum install htop

The -w parameter should only be used to make permanent changes to your
container, not for your productive runs (it can only be used writeable
by one user at the same time). You should write your output to the usual
Taurus file systems like /scratch.Launching applications in your
container

### Running a command inside the container

While the "shell" command can be useful for tests and setup, you can
also launch your applications inside the container directly using
"exec":

    singularity exec my-container.img /opt/myapplication/bin/run_myapp

This can be useful if you wish to create a wrapper script that
transparently calls a containerized application for you. E.g.:

    #!/bin/bash

    X=`which singularity 2>/dev/null`
    if [ "z$X" = "z" ] ; then
            echo "Singularity not found. Is the module loaded?"
            exit 1
    fi

    singularity exec /scratch/p_myproject/my-container.sif /opt/myapplication/run_myapp "$@"
    The better approach for that however is to use `singularity run` for that, which executes whatever was set in the _%runscript_ section of the definition file with the arguments you pass to it.
    Example:
    Build the following definition file into an image:
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

Then you can run your application via

    singularity run my-container.sif first_arg 2nd_arg

Alternatively you can execute the container directly which is
equivalent:

    ./my-container.sif first_arg 2nd_arg

With this you can even masquerade an application with a singularity
container as if it was an actual program by naming the container just
like the binary:

    mv my-container.sif myCoolAp

### Use-cases

One common use-case for containers is that you need an operating system
with a newer GLIBC version than what is available on Taurus. E.g., the
bullx Linux on Taurus used to be based on RHEL6 having a rather dated
GLIBC version 2.12, some binary-distributed applications didn't work on
that anymore. You can use one of our pre-made CentOS 7 container images
(`/scratch/singularity/centos7.img`) to circumvent this problem.
Example:

    $ singularity exec /scratch/singularity/centos7.img ldd --version
    ldd (GNU libc) 2.17
