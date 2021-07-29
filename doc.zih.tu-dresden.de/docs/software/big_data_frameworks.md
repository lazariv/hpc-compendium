# Big Data Frameworks: Apache Spark, Apache Flink, Apache Hadoop

!!! note

    This page is under construction

[Apache Spark](https://spark.apache.org/), [Apache Flink](https://flink.apache.org/)
and [Apache Hadoop](https://hadoop.apache.org/) are frameworks for processing and integrating
Big Data. These frameworks are also offered as software [modules](modules.md) on Taurus
for both ml and scs5 partitions. You could check module availability with the command:

```bash
ml av Spark
```

**Aim** of this page is to introduce users on how to start working with
the frameworks on Taurus in general as well as on the [HPC-DA](../jobs_and_resources/hpcda.md) system.

**Prerequisites:** To work with the frameworks, you need [access](../access/login.md) to the Taurus
system and basic knowledge about data analysis and [Slurm](../jobs_and_resources/slurm.md).

The usage of big data frameworks is
different from other modules due to their master-worker approach. That
means, before an application can be started, one has to do additional
steps. In the following, we assume that a Spark application should be
started.

The steps are:

1. Load the Spark software module

2. Configure the Spark cluster

3. Start a Spark cluster

4. Start the Spark application

## Interactive jobs with Apache Spark with the default configuration

The Spark module is available for both **scs5** and **ml** partitions.
Thus, it could be used for different CPU architectures: Haswell, Power9
(ml partition) etc.

Let us assume that 2 nodes should be used for the computation. Use a
`srun` command similar to the following to start an interactive session
using the Haswell partition:

```bash
srun --partition=haswell -N2 --mem=60g --exclusive --time=01:00:00 --pty bash -l                     #Job submission to haswell nodes with an allocation of 2 nodes with 60 GB main memory exclusively for 1 hour
```

The command for different resource allocation on the **ml** partition is
similar:

```bash
srun -p ml -N 1 -n 1 -c 2 --gres=gpu:1 --time=01:00:00 --pty --mem-per-cpu=10000 bash    #job submission to ml nodes with an allocation of 1 node, 1 task per node, 2 CPUs per task, 1 gpu per node, with 10000 MB for 1 hour.
```

Once you have the shell, load Spark using the following command:

```bash
ml Spark
```

Before the application can be started, the Spark cluster needs to be set
up. To do this, configure Spark first using configuration template at
`$SPARK_HOME/conf`:

```bash
source framework-configure.sh spark $SPARK_HOME/conf
```

This places the configuration in a directory called
`cluster-conf-<JOB_ID>` in your home directory, where `<JOB_ID>` stands
for the job id of the SLURM job. After that, you can start Spark in the
usual way:

```bash
start-all.sh
```

The Spark processes should now be set up and you can start your
application, e. g.:

```bash
spark-submit --class org.apache.spark.examples.SparkPi $SPARK_HOME/examples/jars/spark-examples_2.11-2.4.4.jar 1000
```

!!! warning

    Please do not delete the directory `cluster-conf-<JOB_ID>` while the job is still
    running. This may lead to errors.

## Batch jobs

Using `srun` directly on the shell blocks the shell and launches an
interactive job. Apart from short test runs, it is **recommended to
launch your jobs in the background using batch jobs**. For that, you can
conveniently put the parameters directly into the job file which you can
submit using `sbatch [options] <job file>`.

Please use a [batch job](../jobs_and_resources/slurm.md) similar to the one attached:
[example-spark.sbatch](misc/example-spark.sbatch).

## Apache Spark with Jupyter Notebook

There are two general options on how to work with Jupyter notebooks on
Taurus:<br />There is [jupyterhub](../access/jupyterhub.md), where you can simply
run your Jupyter notebook on HPC nodes (the preferable way). Also, you
can run a remote jupyter server manually within a sbatch GPU job and
with the modules and packages you need. You can find the manual server
setup [here](deep_learning.md).

### Preparation

If you want to run Spark in Jupyter notebooks, you have to prepare it first. This is comparable
to the [description for custom environments](../access/jupyterhub.md#conda-environment).
You start with an allocation:

```bash
srun --pty -n 1 -c 2 --mem-per-cpu 2583 -t 01:00:00 bash -l
```

When a node is allocated, install the required package with Anaconda:

```bash
module load Anaconda3
cd
mkdir user-kernel
conda create --prefix $HOME/user-kernel/haswell-py3.6-spark python=3.6      #Example output: Collecting package metadata:done Solving environment: done [...]

conda activate $HOME/user-kernel/haswell-py3.6-spark
conda install ipykernel                                            #Example output: Collecting package metadata: done Solving environment: done[...]

python -m ipykernel install --user --name haswell-py3.6-spark --display-name="haswell-py3.6-spark"   #Example output: Installed kernelspec haswell-py3.6-spark in [...]

conda install -c conda-forge findspark
conda install pyspark
conda install keras

conda deactivate
```

You are now ready to spawn a notebook with Spark.

### Spawning a notebook

Assuming that you have prepared everything as described above, you can go to
[https://taurus.hrsk.tu-dresden.de/jupyter](https://taurus.hrsk.tu-dresden.de/jupyter).
In the tab "Advanced", go
to the field "Preload modules" and select one of the Spark modules.
When your jupyter instance is started, check whether the kernel that
you created in the preparation phase (see above) is shown in the top
right corner of the notebook. If it is not already selected, select the
kernel haswell-py3.6-spark. Then, you can set up Spark. Since the setup
in the notebook requires more steps than in an interactive session, we
have created an example notebook that you can use as a starting point
for convenience: [SparkExample.ipynb](misc/SparkExample.ipynb)

!!! note

    You could work with simple examples in your home directory but according to the
    [storage concept](../data_lifecycle/hpc_storage_concept2019.md)
    **please use [workspaces](../data_lifecycle/workspaces.md) for
    your study and work projects**. For this reason, you have to use
    advanced options of Jupyterhub and put "/" in "Workspace scope" field.

## Interactive jobs using a custom configuration

The script `framework-configure.sh` is used to derive a configuration from
a template. It takes 2 parameters:

-   The framework to set up (Spark, Flink, Hadoop)
-   A configuration template

Thus, you can modify the configuration by replacing the default
configuration template with a customized one. This way, your custom
configuration template is reusable for different jobs. You can start
with a copy of the default configuration ahead of your interactive
session:

```bash
cp -r $SPARK_HOME/conf my-config-template
```

After you have changed `my-config-template`, you can use your new template
in an interactive job with:

```bash
source framework-configure.sh spark my-config-template 
```

## Interactive jobs with Spark and Hadoop Distributed File System (HDFS)

If you want to use Spark and HDFS together (or in general more than one
framework), a scheme similar to the following can be used:

```bash
ml Hadoop
ml Spark
source framework-configure.sh hadoop $HADOOP_ROOT_DIR/etc/hadoop
source framework-configure.sh spark $SPARK_HOME/conf
start-dfs.sh
start-all.sh
```

Note: It is recommended to use ssh keys to avoid entering the password
every time to log in to nodes. For the details, please check the
[external documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/s2-ssh-configuration-keypairs).

## FAQ

Q: Command `source framework-configure.sh hadoop
$HADOOP_ROOT_DIR/etc/hadoop` gives the output:
`bash: framework-configure.sh: No such file or directory`. How can this be resolved?

A: Please try to re-submit or re-run the job and if that doesn't help
re-login to Taurus.

Q: There are a lot of errors and warnings during the set up of the
session

A: Please check the work capability on a simple example. The source of
warnings could be ssh etc, and it could be not affecting the frameworks

!!! help

    If you have questions or need advice, please see
    [https://www.scads.ai/services](https://www.scads.ai/services) or contact the HPC support.
