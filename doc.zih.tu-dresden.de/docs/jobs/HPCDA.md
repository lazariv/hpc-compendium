# HPC for Data Analytics

With the HPC-DA system, the TU Dresden provides infrastructure for High-Performance Computing and
Data Analytics (HPC-DA) for German researchers for computing projects with focus in one of the
following areas:

- machine learning scenarios for large systems
- evaluation of various hardware settings for large machine learning
  problems, including accelerator and compute node configuration and
  memory technologies
- processing of large amounts of data on highly parallel machine
  learning infrastructure.

Currently we offer 25 Mio core hours compute time per year for external computing projects.
Computing projects have a duration of up to one year with the possibility of extensions, thus
enabling projects to continue seamlessly. Applications for regular projects on HPC-DA can be
submitted at any time via the
[online web-based submission](https://tu-dresden.de/zih/hochleistungsrechnen/zugang/hpc-da)
and review system. The reviews of the applications are carried out by experts in their respective
scientific fields. Applications are evaluated only according to their scientific excellence.

ZIH provides a portfolio of preinstalled applications and offers support for software
installation/configuration of project-specific applications. In particular, we provide consulting
services for all our users, and advise researchers on using the resources in an efficient way.

\<img align="right" alt="HPC-DA Overview"
src="%ATTACHURL%/bandwidth.png" title="bandwidth.png" width="250" />

## Access

- Application for access using this 
  [Online Web Form](https://tu-dresden.de/zih/hochleistungsrechnen/zugang/hpc-da)

## Hardware Overview

- [Nodes for machine learning (Power9)](../use_of_hardware/Power9.md)
- [NVMe Storage](../use_of_hardware/NvmeStorage.md) (2 PB)
- [Warm archive](../data_management/WarmArchive.md) (10 PB)
- HPC nodes (x86) for DA (island 6)
- Compute nodes with high memory bandwidth:
  [AMD Rome Nodes](../use_of_hardware/RomeNodes.md) (island 7)

Additional hardware:

- [Multi-GPU-Cluster](../use_of_hardware/AlphaCentauri.md) for projects of SCADS.AI

## File Systems and Object Storage

- Lustre
- BeeGFS
- Quobyte
- S3

## HOWTOS

- [Get started with HPC-DA](../software/GetStartedWithHPCDA.md)
- [IBM Power AI](../software/PowerAI.md)
- [Work with Singularity Containers on Power9]**todo** Cloud
- [TensorFlow on HPC-DA (native)](../software/TensorFlow.md)
- [Tensorflow on Jupyter notebook](../software/TensorFlowOnJupyterNotebook.md)
- Create and run your own TensorFlow container for HPC-DA (Power9) (todo: no link at all in old compendium)
- [TensorFlow on x86](../software/DeepLearning.md)
- [PyTorch on HPC-DA (Power9)](../software/PyTorch.md)
- [Python on HPC-DA (Power9)](../software/Python.md)
- [JupyterHub](../software/JupyterHub.md)
- [R on HPC-DA (Power9)](../software/DataAnalyticsWithR.md)
- [Big Data frameworks: Apache Spark, Apache Flink, Apache Hadoop]
   **todo** BigDataFrameworks:ApacheSparkApacheFlinkApacheHadoop 
