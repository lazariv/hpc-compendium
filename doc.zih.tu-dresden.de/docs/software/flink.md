# Apache Flink

[Apache Flink](https://flink.apache.org/) is a framework for processing and integrating Big Data.
It offers a similar API as [Apache Spark](big_data_frameworks_spark.md), but is more appropriate
for data stream processing. You can check module versions and availability with the command:

```console
marie@login$ module avail Flink
```

**Prerequisites:** To work with the frameworks, you need [access](../access/ssh_login.md) to ZIH
systems and basic knowledge about data analysis and the batch system
[Slurm](../jobs_and_resources/slurm.md).

The usage of Big Data frameworks is different from other modules due to their master-worker
approach. That means, before an application can be started, one has to do additional steps.

The steps are:

1. Load the Flink software module
1. Configure the Flink cluster
1. Start a Flink cluster
1. Start the Flink application

Apache Flink can be used in [interactive](#interactive-jobs) and [batch](#batch-jobs) jobs as
described below.

## Interactive Jobs

### Default Configuration

Let us assume that two nodes should be used for the computation. Use a `srun` command similar to
the following to start an interactive session using the partition haswell. The following code
snippet shows a job submission to haswell nodes with an allocation of two nodes with 60 GB main
memory exclusively for one hour:

```console
marie@login$ srun --partition=haswell --nodes=2 --mem=60g --exclusive --time=01:00:00 --pty bash -l
```

Once you have the shell, load Flink using the command

```console
marie@compute$ module load Flink
```

Before the application can be started, the Flink cluster needs to be set up. To do this, configure
Flink first using configuration template at `$FLINK_ROOT_DIR/conf`:

```console
marie@compute$ source framework-configure.sh flink $FLINK_ROOT_DIR/conf
```

This places the configuration in a directory called `cluster-conf-<JOB_ID>` in your `home`
directory, where `<JOB_ID>` stands for the id of the Slurm job. After that, you can start Flink in
the usual way:

```console
marie@compute$ start-cluster.sh
```

The Flink processes should now be set up and you can start your application, e. g.:

```console
marie@compute$ flink run $FLINK_ROOT_DIR/examples/batch/KMeans.jar
```

!!! warning

    Do not delete the directory `cluster-conf-<JOB_ID>` while the job is still
    running. This leads to errors.

### Custom Configuration

The script `framework-configure.sh` is used to derive a configuration from a template. It takes two
parameters:

- The framework to set up (Spark, Flink, Hadoop)
- A configuration template

Thus, you can modify the configuration by replacing the default configuration template with a
customized one. This way, your custom configuration template is reusable for different jobs. You
can start with a copy of the default configuration ahead of your interactive session:

```console
marie@login$ cp -r $FLINK_ROOT_DIR/conf my-config-template
```

After you have changed `my-config-template`, you can use your new template in an interactive job
with:

```console
marie@compute$ source framework-configure.sh flink my-config-template
```

### Using Hadoop Distributed Filesystem (HDFS)

If you want to use Flink and HDFS together (or in general more than one framework), a scheme
similar to the following can be used:

```console
marie@compute$ module load Hadoop
marie@compute$ module load Flink
marie@compute$ source framework-configure.sh hadoop $HADOOP_ROOT_DIR/etc/hadoop
marie@compute$ source framework-configure.sh flink $FLINK_ROOT_DIR/conf
marie@compute$ start-dfs.sh
marie@compute$ start-cluster.sh
```

## Batch Jobs

Using `srun` directly on the shell blocks the shell and launches an interactive job. Apart from
short test runs, it is **recommended to launch your jobs in the background using batch jobs**. For
that, you can conveniently put the parameters directly into the job file and submit it via
`sbatch [options] <job file>`.

Please use a [batch job](../jobs_and_resources/slurm.md) with a configuration, similar to the
example below:

??? example "flink.sbatch"
    ```bash
    #!/bin/bash -l
    #SBATCH --time=00:05:00
    #SBATCH --partition=haswell
    #SBATCH --nodes=2
    #SBATCH --exclusive
    #SBATCH --mem=60G
    #SBATCH --job-name="example-flink"

    ml Flink/1.12.3-Java-1.8.0_161-OpenJDK-Python-3.7.4-GCCcore-8.3.0

    function myExitHandler () {
        stop-cluster.sh
    }

    #configuration
    . framework-configure.sh flink $FLINK_ROOT_DIR/conf

    #register cleanup hook in case something goes wrong
    trap myExitHandler EXIT

    #start the cluster
    start-cluster.sh

    #run your application
    flink run $FLINK_ROOT_DIR/examples/batch/KMeans.jar

    #stop the cluster
    stop-cluster.sh

    exit 0
    ```

!!! note

    You could work with simple examples in your home directory, but, according to the
    [storage concept](../data_lifecycle/overview.md), **please use
    [workspaces](../data_lifecycle/workspaces.md) for your study and work projects**. For this
    reason, you have to use advanced options of Jupyterhub and put "/" in "Workspace scope" field.

## FAQ

Q: Command `source framework-configure.sh hadoop
$HADOOP_ROOT_DIR/etc/hadoop` gives the output:
`bash: framework-configure.sh: No such file or directory`. How can this be resolved?

A: Please try to re-submit or re-run the job and if that doesn't help
re-login to the ZIH system.

Q: There are a lot of errors and warnings during the set up of the
session

A: Please check the work capability on a simple example as shown in this documentation.

!!! help

    If you have questions or need advice, please use the contact form on
    [https://scads.ai/contact/](https://scads.ai/contact/) or contact the HPC support.
