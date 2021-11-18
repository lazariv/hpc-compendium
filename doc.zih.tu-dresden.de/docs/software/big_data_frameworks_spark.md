# Big Data Frameworks: Apache Spark

[Apache Spark](https://spark.apache.org/), [Apache Flink](https://flink.apache.org/)
and [Apache Hadoop](https://hadoop.apache.org/) are frameworks for processing and integrating
Big Data. These frameworks are also offered as software [modules](modules.md) in both `ml` and
`scs5` software environments. You can check module versions and availability with the command

=== "Spark"
    ```console
    marie@login$ module avail Spark
    ```
=== "Flink"
    ```console
    marie@login$ module avail Flink
    ```

**Prerequisites:** To work with the frameworks, you need [access](../access/ssh_login.md) to ZIH
systems and basic knowledge about data analysis and the batch system
[Slurm](../jobs_and_resources/slurm.md).

The usage of Big Data frameworks is different from other modules due to their master-worker
approach. That means, before an application can be started, one has to do additional steps.
In the following, we assume that a Spark application should be started and give alternative
commands for Flink where applicable.

The steps are:

1. Load the Spark software module
1. Configure the Spark cluster
1. Start a Spark cluster
1. Start the Spark application

Apache Spark can be used in [interactive](#interactive-jobs) and [batch](#batch-jobs) jobs as well
as via [Jupyter notebooks](#jupyter-notebook). All three ways are outlined in the following.
The usage of Flink with Jupyter notebooks is currently under examination.

## Interactive Jobs

### Default Configuration

The Spark module is available in both `scs5` and `ml` environments.
Thus, Spark can be executed using different CPU architectures, e.g., Haswell and Power9.

Let us assume that two nodes should be used for the computation. Use a `srun` command similar to
the following to start an interactive session using the partition haswell. The following code
snippet shows a job submission to haswell nodes with an allocation of two nodes with 60000 MB main
memory exclusively for one hour:

```console
marie@login$ srun --partition=haswell --nodes=2 --mem=60000M --exclusive --time=01:00:00 --pty bash -l
```

Once you have the shell, load desired Big Data framework using the command

=== "Spark"
    ```console
    marie@compute$ module load Spark
    ```
=== "Flink"
    ```console
    marie@compute$ module load Flink
    ```

Before the application can be started, the Spark cluster needs to be set up. To do this, configure
Spark first using configuration template at `$SPARK_HOME/conf`:

=== "Spark"
    ```console
    marie@compute$ source framework-configure.sh spark $SPARK_HOME/conf
    ```
=== "Flink"
    ```console
    marie@compute$ source framework-configure.sh flink $FLINK_ROOT_DIR/conf
    ```

This places the configuration in a directory called `cluster-conf-<JOB_ID>` in your `home`
directory, where `<JOB_ID>` stands for the id of the Slurm job. After that, you can start Spark in
the usual way:

=== "Spark"
    ```console
    marie@compute$ start-all.sh
    ```
=== "Flink"
    ```console
    marie@compute$ start-cluster.sh
    ```

The Spark processes should now be set up and you can start your application, e. g.:

=== "Spark"
    ```console
    marie@compute$ spark-submit --class org.apache.spark.examples.SparkPi \
    $SPARK_HOME/examples/jars/spark-examples_2.12-3.0.1.jar 1000
    ```
=== "Flink"
    ```console
    marie@compute$ flink run $FLINK_ROOT_DIR/examples/batch/KMeans.jar
    ```

!!! warning

    Do not delete the directory `cluster-conf-<JOB_ID>` while the job is still
    running. This leads to errors.

### Custom Configuration

The script `framework-configure.sh` is used to derive a configuration from a template. It takes two
parameters:

- The framework to set up (parameter `spark` for Spark, `flink` for Flink, and `hadoop` for Hadoop)
- A configuration template

Thus, you can modify the configuration by replacing the default configuration template with a
customized one. This way, your custom configuration template is reusable for different jobs. You
can start with a copy of the default configuration ahead of your interactive session:

=== "Spark"
    ```console
    marie@login$ cp -r $SPARK_HOME/conf my-config-template
    ```
=== "Flink"
    ```console
    marie@login$ cp -r $FLINK_ROOT_DIR/conf my-config-template
    ```

After you have changed `my-config-template`, you can use your new template in an interactive job
with:

=== "Spark"
    ```console
    marie@compute$ source framework-configure.sh spark my-config-template
    ```
=== "Flink"
    ```console
    marie@compute$ source framework-configure.sh flink my-config-template
    ```

### Using Hadoop Distributed Filesystem (HDFS)

If you want to use Spark and HDFS together (or in general more than one framework), a scheme
similar to the following can be used:

=== "Spark"
    ```console
    marie@compute$ module load Hadoop
    marie@compute$ module load Spark
    marie@compute$ source framework-configure.sh hadoop $HADOOP_ROOT_DIR/etc/hadoop
    marie@compute$ source framework-configure.sh spark $SPARK_HOME/conf
    marie@compute$ start-dfs.sh
    marie@compute$ start-all.sh
    ```
=== "Flink"
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

??? example "example-starting-script.sbatch"
    === "Spark"
        ```bash
        #!/bin/bash -l
        #SBATCH --time=01:00:00
        #SBATCH --partition=haswell
        #SBATCH --nodes=2
        #SBATCH --exclusive
        #SBATCH --mem=60000M
        #SBATCH --job-name="example-spark"

        ml Spark/3.0.1-Hadoop-2.7-Java-1.8-Python-3.7.4-GCCcore-8.3.0

        function myExitHandler () {
            stop-all.sh
        }

        #configuration
        . framework-configure.sh spark $SPARK_HOME/conf

        #register cleanup hook in case something goes wrong
        trap myExitHandler EXIT

        start-all.sh

        spark-submit --class org.apache.spark.examples.SparkPi $SPARK_HOME/examples/jars/spark-examples_2.12-3.0.1.jar 1000

        stop-all.sh

        exit 0
        ```
    === "Flink"
        ```bash
        #!/bin/bash -l
        #SBATCH --time=01:00:00
        #SBATCH --partition=haswell
        #SBATCH --nodes=2
        #SBATCH --exclusive
        #SBATCH --mem=60000M
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

## Jupyter Notebook

You can run Jupyter notebooks with Spark on the ZIH systems in a similar way as described on the
[JupyterHub](../access/jupyterhub.md) page. Interaction of Flink with JupyterHub is currently
under examination and will be posted here upon availability.

### Preparation

If you want to run Spark in Jupyter notebooks, you have to prepare it first. This is comparable
to [normal Python virtual environments](../software/python_virtual_environments.md#python-virtual-environment).
You start with an allocation:

```console
marie@login$ srun --pty --ntasks=1 --cpus-per-task=2 --mem-per-cpu=2500 --time=01:00:00 bash -l
```

When a node is allocated, install the required packages:

```console
marie@compute$ cd $HOME
marie@compute$ mkdir jupyter-kernel
marie@compute$ module load Python
marie@compute$ virtualenv --system-site-packages jupyter-kernel/env  #Create virtual environment
[...]
marie@compute$ source jupyter-kernel/env/bin/activate    #Activate virtual environment.
(env) marie@compute$ pip install ipykernel
[...]
(env) marie@compute$ python -m ipykernel install --user --name haswell-py3.7-spark --display-name="haswell-py3.7-spark"
Installed kernelspec haswell-py3.7-spark in [...]

(env) marie@compute$ pip install findspark
(env) marie@compute$ deactivate
```

You are now ready to spawn a notebook with Spark.

### Spawning a Notebook

Assuming that you have prepared everything as described above, you can go to
[https://taurus.hrsk.tu-dresden.de/jupyter](https://taurus.hrsk.tu-dresden.de/jupyter).
In the tab "Advanced", go to the field "Preload modules" and select one of the Spark modules. When
your Jupyter instance is started, check whether the kernel that you created in the preparation
phase (see above) is shown in the top right corner of the notebook. If it is not already selected,
select the kernel `haswell-py3.7-spark`. Then, you can set up Spark. Since the setup in the
notebook requires more steps than in an interactive session, we have created an example notebook
that you can use as a starting point for convenience: [SparkExample.ipynb](misc/SparkExample.ipynb)

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
