# Data Analytics

On the ZIH system, there are many possibilities for working with tools from the field of data
analytics. The boundaries between data analytics and machine learning are fluid.
Therefore, it may be worthwhile to search for a specific issue within the data analytics and
machine learning sections.

The following tools are available in the ZIH system, among others:

1. [Python](data_analytics_with_python.md)
1. [R](data_analytics_with_r.md)
1. [Rstudio](data_analytics_with_rstudio.md)
1. [Big Data framework Spark](big_data_frameworks_spark.md)
1. [TensorFlow](tensorflow.md)
1. [Pytorch](pytorch.md)
1. [MATLAB and Mathematica](mathematics.md)

Other software not listed here can be searched with

```bash
module spider <software_name>
```

Additional software or special versions of individual modules can be installed individually by
each user. If possible, the use of virtual environments is recommended (e.g. for Python).
Likewise software can be used within [containers](containers.md).

For the transfer of larger amounts of data into and within the system, the
[export nodes and data mover](../data_transfer/overview.md) should be used.
The data storage takes place in the [work spaces](../data_lifecycle/workspaces.md).
Software modules or virtual environments can also be installed in workspaces to enable
collaborative work even within larger groups. General recommendations for setting up workflows
can be found in the [experiments](../data_lifecycle/experiments.md) section.
