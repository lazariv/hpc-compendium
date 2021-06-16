## Machine Learning

On the machine learning nodes, you can use the tools from [IBM Power
AI](PowerAI).

### Interactive Session Examples

#### Tensorflow-Test

    tauruslogin6 :~> srun -p ml --gres=gpu:1 -n 1 --pty --mem-per-cpu=10000 bash
    srun: job 4374195 queued and waiting for resources
    srun: job 4374195 has been allocated resources
    taurusml22 :~> ANACONDA2_INSTALL_PATH='/opt/anaconda2'
    taurusml22 :~> ANACONDA3_INSTALL_PATH='/opt/anaconda3'
    taurusml22 :~> export PATH=$ANACONDA3_INSTALL_PATH/bin:$PATH
    taurusml22 :~> source /opt/DL/tensorflow/bin/tensorflow-activate
    taurusml22 :~> tensorflow-test
    Basic test of tensorflow - A Hello World!!!...

    #or:
    taurusml22 :~> module load TensorFlow/1.10.0-PythonAnaconda-3.6

Or to use the whole node: `--gres=gpu:6 --exclusive --pty`

##### In Singularity container:

    rotscher@tauruslogin6:~&gt; srun -p ml --gres=gpu:6 --pty bash
    [rotscher@taurusml22 ~]$ singularity shell --nv /scratch/singularity/powerai-1.5.3-all-ubuntu16.04-py3.img
    Singularity powerai-1.5.3-all-ubuntu16.04-py3.img:~&gt; export PATH=/opt/anaconda3/bin:$PATH
    Singularity powerai-1.5.3-all-ubuntu16.04-py3.img:~&gt; . /opt/DL/tensorflow/bin/tensorflow-activate
    Singularity powerai-1.5.3-all-ubuntu16.04-py3.img:~&gt; tensorflow-test

### Additional libraries

The following NVIDIA libraries are available on all nodes:

|       |                                       |
|-------|---------------------------------------|
| NCCL  | /usr/local/cuda/targets/ppc64le-linux |
| cuDNN | /usr/local/cuda/targets/ppc64le-linux |

Note: For optimal NCCL performance it is recommended to set the
**NCCL_MIN_NRINGS** environment variable during execution. You can try
different values but 4 should be a pretty good starting point.

    export NCCL_MIN_NRINGS=4

\<span style="color: #222222; font-size: 1.385em;">HPC\</span>

The following HPC related software is installed on all nodes:

|                  |                        |
|------------------|------------------------|
| IBM Spectrum MPI | /opt/ibm/spectrum_mpi/ |
| PGI compiler     | /opt/pgi/              |
| IBM XLC Compiler | /opt/ibm/xlC/          |
| IBM XLF Compiler | /opt/ibm/xlf/          |
| IBM ESSL         | /opt/ibmmath/essl/     |
| IBM PESSL        | /opt/ibmmath/pessl/    |
