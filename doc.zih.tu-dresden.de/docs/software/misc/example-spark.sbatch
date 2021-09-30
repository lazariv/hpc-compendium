#!/bin/bash
#SBATCH --time=00:03:00
#SBATCH --partition=haswell
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --mem=50G
#SBATCH -J "example-spark"

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
