# Introduction

IOTrack is a small tool developed at ZIH that tracks the I/O requests of
all processes and dumps a statistic per process at the end of the
program run.

# How it works

On taurus load the module via

    module load iotrack

Then, instead of running your normal command, put "iotrack" in front of
it. So,

    python xyz.py arg1 arg2

changes to:

    iotrack python xyz.py arg1 arg2

# Technical Details

The functionality is implemented in a library that is preloaded via
LD_PRELOAD. Thus, this will not work for static binaries.

-- Main.MichaelKluge - 2013-07-16
