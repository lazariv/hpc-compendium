# Big Data Frameworks: Apache Spark

!!! note

    This page is under construction

[Apache Spark](https://spark.apache.org/), [Apache Flink](https://flink.apache.org/)
and [Apache Hadoop](https://hadoop.apache.org/) are frameworks for processing and integrating
Big Data. These frameworks are also offered as software [modules](modules.md) on both `ml` and
`scs5` partition. You can check module versions and availability with the command

```console
marie@login$ module av Spark
```

The **aim** of this page is to introduce users on how to start working with
these frameworks on ZIH systems.

**Prerequisites:** To work with the frameworks, you need [access](../access/ssh_login.md) to ZIH
systems and basic knowledge about data analysis and the batch system
[Slurm](../jobs_and_resources/slurm.md).

The usage of Big Data frameworks is
different from other modules due to their master-worker approach. That
means, before an application can be started, one has to do additional steps.
In the following, we assume that a Spark application should be
started.

The steps are:

1. Load the Spark software module
1. Configure the Spark cluster
1. Start a Spark cluster
1. Start the Spark application

Apache Spark can be used in [interactive](#interactive-jobs) and [batch](#batch-jobs) jobs as well
as via [Jupyter notebook](#jupyter-notebook). All three ways are outlined in the following.

!!! note

    It is recommended to use ssh keys to avoid entering the password
    every time to log in to nodes. For the details, please check the
    [external documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/s2-ssh-configuration-keypairs).

## Interactive Jobs

### Default Configuration

The Spark module is available for both `scs5` and `ml` partitions.
Thus, Spark can be executed using different CPU architectures, e.g., Haswell and Power9.

Let us assume that two nodes should be used for the computation. Use a
`srun` command similar to the following to start an interactive session
using the Haswell partition. The following code snippet shows a job submission
to Haswell nodes with an allocation of two nodes with 60 GB main memory
exclusively for one hour:

```console
marie@login$ srun --partition=haswell -N 2 --mem=60g --exclusive --time=01:00:00 --pty bash -l
```

The command for different resource allocation on the `ml` partition is
similar, e. g. for a job submission to `ml` nodes with an allocation of one
node, one task per node, two CPUs per task, one GPU per node, with 10000 MB for one hour:

```console
marie@login$ srun --partition=ml -N 1 -n 1 -c 2 --gres=gpu:1 --mem-per-cpu=10000 --time=01:00:00 --pty bash
```

Once you have the shell, load Spark using the command

```console
marie@compute$ module load Spark
```

Before the application can be started, the Spark cluster needs to be set
up. To do this, configure Spark first using configuration template at
`$SPARK_HOME/conf`:

```console
marie@compute$ source framework-configure.sh spark $SPARK_HOME/conf
```

This places the configuration in a directory called
`cluster-conf-<JOB_ID>` in your `home` directory, where `<JOB_ID>` stands
for the id of the Slurm job. After that, you can start Spark in the
usual way:

```console
marie@compute$ start-all.sh
```

The Spark processes should now be set up and you can start your
application, e. g.:

```console
marie@compute$ spark-submit --class org.apache.spark.examples.SparkPi $SPARK_HOME/examples/jars/spark-examples_2.11-2.4.4.jar 1000
```

!!! warning

    Do not delete the directory `cluster-conf-<JOB_ID>` while the job is still
    running. This leads to errors.

### Custom Configuration

The script `framework-configure.sh` is used to derive a configuration from
a template. It takes two parameters:

- The framework to set up (Spark, Flink, Hadoop)
- A configuration template

Thus, you can modify the configuration by replacing the default
configuration template with a customized one. This way, your custom
configuration template is reusable for different jobs. You can start
with a copy of the default configuration ahead of your interactive
session:

```console
marie@login$ cp -r $SPARK_HOME/conf my-config-template
```

After you have changed `my-config-template`, you can use your new template
in an interactive job with:

```console
marie@compute$ source framework-configure.sh spark my-config-template
```

### Using Hadoop Distributed File System (HDFS)

If you want to use Spark and HDFS together (or in general more than one
framework), a scheme similar to the following can be used:

```console
marie@compute$ module load Hadoop
marie@compute$ module load Spark
marie@compute$ source framework-configure.sh hadoop $HADOOP_ROOT_DIR/etc/hadoop
marie@compute$ source framework-configure.sh spark $SPARK_HOME/conf
marie@compute$ start-dfs.sh
marie@compute$ start-all.sh
```

## Batch Jobs

Using `srun` directly on the shell blocks the shell and launches an
interactive job. Apart from short test runs, it is **recommended to
launch your jobs in the background using batch jobs**. For that, you can
conveniently put the parameters directly into the job file and submit it via
`sbatch [options] <job file>`.

Please use a [batch job](../jobs_and_resources/slurm.md) similar to
[example-spark.sbatch](misc/example-spark.sbatch).

## Jupyter Notebook

There are two general options on how to work with Jupyter notebooks:
There is [JupyterHub](../access/jupyterhub.md), where you can simply
run your Jupyter notebook on HPC nodes (the preferable way).

### Preparation

If you want to run Spark in Jupyter notebooks, you have to prepare it first. This is comparable
to the [description for custom environments](../access/jupyterhub.md#conda-environment).
You start with an allocation:

```console
marie@login$ srun --pty -n 1 -c 2 --mem-per-cpu=2500 -t 01:00:00 bash -l
```

When a node is allocated, install the required package with Anaconda:

```console
marie@compute$ module load Anaconda3
marie@compute$ cd
marie@compute$ mkdir user-kernel
marie@compute$ conda create --prefix $HOME/user-kernel/haswell-py3.6-spark python=3.6
Collecting package metadata: done
Solving environment: done [...]

marie@compute$ conda activate $HOME/user-kernel/haswell-py3.6-spark
marie@compute$ conda install ipykernel
Collecting package metadata: done
Solving environment: done [...]

marie@compute$ python -m ipykernel install --user --name haswell-py3.6-spark --display-name="haswell-py3.6-spark"
Installed kernelspec haswell-py3.6-spark in [...]

marie@compute$ conda install -c conda-forge findspark
marie@compute$ conda install pyspark

marie@compute$ conda deactivate
```

You are now ready to spawn a notebook with Spark.

### Spawning a Notebook

Assuming that you have prepared everything as described above, you can go to
[https://taurus.hrsk.tu-dresden.de/jupyter](https://taurus.hrsk.tu-dresden.de/jupyter).
In the tab "Advanced", go
to the field `Preload modules` and select one of the Spark modules.
When your Jupyter instance is started, check whether the kernel that
you created in the preparation phase (see above) is shown in the top
right corner of the notebook. If it is not already selected, select the
kernel `haswell-py3.6-spark`. Then, you can set up Spark. Since the setup
in the notebook requires more steps than in an interactive session, we
have created an example notebook that you can use as a starting point
for convenience: [Spark-Example](misc/SparkExample.ipynb)

!!! note

    You could work with simple examples in your home directory but according to the
    [storage concept](../data_lifecycle/hpc_storage_concept2019.md)
    **please use [workspaces](../data_lifecycle/workspaces.md) for
    your study and work projects**. For this reason, you have to use
    advanced options of Jupyterhub and put "/" in "Workspace scope" field.

## FAQ

Q: Command `source framework-configure.sh hadoop
$HADOOP_ROOT_DIR/etc/hadoop` gives the output:
`bash: framework-configure.sh: No such file or directory`. How can this be resolved?

A: Please try to re-submit or re-run the job and if that doesn't help
re-login to the ZIH system.

Q: There are a lot of errors and warnings during the set up of the
session

A: Please check the work capability on a simple example. The source of
warnings could be ssh etc, and it could be not affecting the frameworks

!!! help

    If you have questions or need advice, please see
    [https://www.scads.de/transfer-2/beratung-und-support-en/](https://www.scads.de/transfer-2/beratung-und-support-en/) or contact the HPC support.
