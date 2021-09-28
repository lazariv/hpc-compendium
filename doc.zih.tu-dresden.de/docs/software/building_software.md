# Building Software

While it is possible to do short compilations on the login nodes, it is
generally considered good practice to use a job for that, especially
when using many parallel make processes. Note that starting on December
6th 2016, the /projects file system will be mounted read-only on all
compute nodes in order to prevent users from doing large I/O there
(which is what the /scratch is for). In consequence, you cannot compile
in /projects within a job anymore. If you wish to install software for
your project group anyway, you can use a build directory in the /scratch
file system instead:

Every sane build system should allow you to keep your source code tree
and your build directory separate, some even demand them to be different
directories. Plus, you can set your installation prefix (the target
directory) back to your /projects folder and do the "make install" step
on the login nodes.

For instance, when using CMake and keeping your source in /projects, you
could do the following:

    # save path to your source directory:
    export SRCDIR=/projects/p_myproject/mysource

    # create a build directory in /scratch:
    mkdir /scratch/p_myproject/mysoftware_build

    # change to build directory within /scratch:
    cd /scratch/p_myproject/mysoftware_build

    # create Makefiles:
    cmake -DCMAKE_INSTALL_PREFIX=/projects/p_myproject/mysoftware $SRCDIR

    # build in a job:
    srun --mem-per-cpu=1500 -c 12 --pty make -j 12

    # do the install step on the login node again:
    make install

As a bonus, your compilation should also be faster in the parallel
/scratch file system than it would be in the comparatively slow
NFS-based /projects file system.
