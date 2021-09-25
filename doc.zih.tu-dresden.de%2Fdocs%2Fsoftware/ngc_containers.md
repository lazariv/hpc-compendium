# Containers

Containers are executable units of software in which application code is packaged, along with its 
libraries and dependencies.
[Containerization](https://www.ibm.com/cloud/learn/containerization) encapsulating or packaging up
software code and all its dependencies to run uniformly and consistently on any infrastructure.

Containers are a widely adopted method of taming the complexity of deploying HPC and AI software. 
The entire software environment, from the deep learning framework itself, 
down to the math and communication libraries are necessary for performance, is packaged into 
a single bundle. Since workloads inside a container 
always use the same environment, the performance is reproducible and portable.

On Taurus [Singularity](https://sylabs.io/) used as a standard container solution.

[NGC](https://developer.nvidia.com/ai-hpc-containers), a registry of GPU-optimized software, 
has been enabling scientists and researchers by providing regularly updated 
and validated containers of HPC and AI applications.

NGC containers support Singularity.

NGC containers are GPU-optimized containers for deep learning, machine learning, visualization, 
and high-performance computing (HPC) applications:

- Built-in libraries and dependencies

- Faster training with Automatic Mixed Precision (AMP)

- Opportunity to scaling up from single-node to multi-node systems
- 
- Allowing you to develop on the cloud, on premises, or at the edge

- Highly versatile with support for various container runtimes such as Docker, Singularity, cri-o, etc

- Performance optimized
