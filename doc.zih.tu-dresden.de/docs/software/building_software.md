# Building Software

While it is possible to do short compilations on the login nodes, it is generally considered good
practice to use a job for that, especially when using many parallel make processes. Since 2016,
the `/projects` filesystem is mounted read-only on all compute
nodes in order to prevent users from doing large I/O there (which is what the `/scratch` is for).
In consequence, you cannot compile in `/projects` within a job. If you wish to install
software for your project group anyway, you can use a build directory in the `/scratch` filesystem
instead.

Every sane build system should allow you to keep your source code tree and your build directory
separate, some even demand them to be different directories. Plus, you can set your installation
prefix (the target directory) back to your `/projects` folder and do the "make install" step on the
login nodes.

For instance, when using CMake and keeping your source in `/projects`, you could do the following:

```console
# save path to your source directory:
marie@login$ export SRCDIR=/projects/p_marie/mysource

# create a build directory in /scratch:
marie@login$ mkdir /scratch/p_marie/mysoftware_build

# change to build directory within /scratch:
marie@login$ cd /scratch/p_marie/mysoftware_build

# create Makefiles:
marie@login$ cmake -DCMAKE_INSTALL_PREFIX=/projects/p_marie/mysoftware $SRCDIR

# build in a job:
marie@login$ srun --mem-per-cpu=1500 --cpus-per-task=12 --pty make -j 12

# do the install step on the login node again:
marie@login$ make install
```

As a bonus, your compilation should also be faster in the parallel `/scratch` filesystem than it
would be in the comparatively slow NFS-based `/projects` filesystem.
