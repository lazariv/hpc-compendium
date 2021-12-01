# Data Analytics

On ZIH systems, there are many possibilities for working with tools from the field of data
analytics. The boundaries between data analytics and machine learning are fluid.
Therefore, it may be worthwhile to search for a specific issue within the data analytics and
machine learning sections.

The following tools are available on ZIH systems, among others:

* [Python](data_analytics_with_python.md)
* [R](data_analytics_with_r.md)
* [RStudio](data_analytics_with_rstudio.md)
* [Big Data framework Spark](big_data_frameworks.md)
* [MATLAB and Mathematica](mathematics.md)

Detailed information about frameworks for machine learning, such as [TensorFlow](tensorflow.md)
and [PyTorch](pytorch.md), can be found in the [machine learning](machine_learning.md) subsection.

Other software, not listed here, can be searched with

```console
marie@compute$ module spider <software_name>
```

Refer to the section covering [modules](modules.md) for further information on the modules system.
Additional software or special versions of [individual modules](custom_easy_build_environment.md)
can be installed individually by each user. If possible, the use of
[virtual environments](python_virtual_environments.md) is
recommended (e.g. for Python). Likewise, software can be used within [containers](containers.md).

For the transfer of larger amounts of data into and within the system, the
[export nodes and datamover](../data_transfer/overview.md) should be used.
Data is stored in the [workspaces](../data_lifecycle/workspaces.md).
Software modules or virtual environments can also be installed in workspaces to enable
collaborative work even within larger groups. General recommendations for setting up workflows
can be found in the [experiments](../data_lifecycle/experiments.md) section.
