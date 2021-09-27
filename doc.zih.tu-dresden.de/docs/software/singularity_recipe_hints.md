# Singularity Recipes and Hints

## Example Definitions

### Basic Example

A usual workflow to create Singularity Definition consists of the following steps:

* Start from base image
* Install dependencies
    * Package manager
    * Other sources
* Build and install own binaries
* Provide entry points and metadata

An example doing all this:

```bash
Bootstrap: docker
From: alpine

%post
  . /.singularity.d/env/10-docker*.sh

  apk add g++ gcc make wget cmake

  wget https://github.com/fmtlib/fmt/archive/5.3.0.tar.gz
  tar -xf 5.3.0.tar.gz
  mkdir build && cd build
  cmake ../fmt-5.3.0 -DFMT_TEST=OFF
  make -j$(nproc) install
  cd ..
  rm -r fmt-5.3.0*

  cat hello.cpp
#include &lt;fmt/format.h&gt;

int main(int argc, char** argv){
  if(argc == 1) fmt::print("No arguments passed!\n");
  else fmt::print("Hello {}!\n", argv[1]);
}
EOF

  g++ hello.cpp -o hello -lfmt
  mv hello /usr/bin/hello

%runscript
  hello "$@"

%labels
  Author Alexander Grund
  Version 1.0.0

%help
  Display a greeting using the fmt library

  Usage:
    ./hello
```

### CUDA + CuDNN + OpenMPI

* Chosen CUDA version depends on installed driver of host
* OpenMPI needs PMI for Slurm integration
* OpenMPI needs CUDA for GPU copy-support
* OpenMPI needs `ibverbs` library for Infiniband
* `openmpi-mca-params.conf` required to avoid warnings on fork (OK on ZIH systems)
* Environment variables `SLURM_VERSION` and `OPENMPI_VERSION` can be set to  choose different
  version when building the container

```bash
Bootstrap: docker
From: nvidia/cuda-ppc64le:10.1-cudnn7-devel-ubuntu18.04

%labels
    Author ZIH
    Requires CUDA driver 418.39+.

%post
    . /.singularity.d/env/10-docker*.sh

    apt-get update
    apt-get install -y cuda-compat-10.1
    apt-get install -y libibverbs-dev ibverbs-utils
    # Install basic development tools
    apt-get install -y gcc g++ make wget python
    apt-get autoremove; apt-get clean

    cd /tmp

    : ${SLURM_VERSION:=17-02-11-1}
    wget https://github.com/SchedMD/slurm/archive/slurm-${SLURM_VERSION}.tar.gz
    tar -xf slurm-${SLURM_VERSION}.tar.gz
        cd slurm-slurm-${SLURM_VERSION}
        ./configure --prefix=/usr/ --sysconfdir=/etc/slurm --localstatedir=/var --disable-debug
        make -C contribs/pmi2 -j$(nproc) install
    cd ..
    rm -rf slurm-*

    : ${OPENMPI_VERSION:=3.1.4}
    wget https://download.open-mpi.org/release/open-mpi/v${OPENMPI_VERSION%.*}/openmpi-${OPENMPI_VERSION}.tar.gz
    tar -xf openmpi-${OPENMPI_VERSION}.tar.gz
    cd openmpi-${OPENMPI_VERSION}/
    ./configure --prefix=/usr/ --with-pmi --with-verbs --with-cuda
    make -j$(nproc) install
    echo "mpi_warn_on_fork = 0" >> /usr/etc/openmpi-mca-params.conf
    echo "btl_openib_warn_default_gid_prefix = 0" >> /usr/etc/openmpi-mca-params.conf
    cd ..
    rm -rf openmpi-*
```

## Hints

### GUI (X11) Applications

Running GUI applications inside a singularity container is possible out of the box. Check the
following definition:

```Bash
Bootstrap: docker
From: centos:7

%post
yum install -y xeyes
```

This image may be run with

```console
singularity exec xeyes.sif xeyes.
```

This works because all the magic is done by Singularity already like setting `$DISPLAY` to the outside
display and mounting `$HOME` so `$HOME/.Xauthority` (X11 authentication cookie) is found. When you are
using `--contain` or `--no-home` you have to set that cookie yourself or mount/copy it inside
the container. Similar for `--cleanenv` you have to set `$DISPLAY`, e.g., via

```console
export SINGULARITY_DISPLAY=$DISPLAY
```

When you run a container as root (via `sudo`) you may need to allow root for your local display
port: `xhost +local:root\`

### Hardware Acceleration

If you want hardware acceleration, you **may** need [VirtualGL](https://virtualgl.org). An example
definition file is as follows:

```Bash
Bootstrap: docker
From: centos:7

%post
yum install -y glx-utils # for glxgears example app

yum install -y curl
VIRTUALGL_VERSION=2.6.2 # Replace by required (e.g. latest) version

curl -sSL https://downloads.sourceforge.net/project/virtualgl/"${VIRTUALGL_VERSION}"/VirtualGL-"${VIRTUALGL_VERSION}".x86_64.rpm -o VirtualGL-"${VIRTUALGL_VERSION}".x86_64.rpm
yum install -y VirtualGL*.rpm
/opt/VirtualGL/bin/vglserver_config -config +s +f -t
rm VirtualGL-*.rpm

# Install video drivers AFTER VirtualGL to avoid them being overwritten
yum install -y mesa-dri-drivers # for e.g. intel integrated GPU drivers. Replace by your driver
```

You can now run the application with `vglrun`:

```console
singularity exec vgl.sif vglrun glxgears
```

!!! warning

    Using VirtualGL may not be required at all and could even decrease the performance.

To check install, e.g., `glxgears` as above and your graphics driver (or use the VirtualGL image
from above) and disable `vsync`:

```console
vblank_mode=0 singularity exec vgl.sif glxgears
```

Compare the FPS output with the `glxgears` prefixed by `vglrun` (see above) to see which produces more
FPS (or runs at all).

**NVIDIA GPUs** need the `--nv` parameter for the Singularity command:

``console
singularity exec --nv vgl.sif glxgears
```
