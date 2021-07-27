#!/bin/bash
#SBATCH --time=00:03:00
#SBATCH --partition=haswell
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --mem=60G
#SBATCH -J "example-spark"

ml Spark

function myExitHandler () {
	stop-all.sh
}

#configuration
. framework-configure.sh spark $SPARK_HOME/conf

#register cleanup hook in case something goes wrong
trap myExitHandler EXIT

start-all.sh

spark-submit --class org.apache.spark.examples.SparkPi $SPARK_HOME/examples/jars/spark-examples_2.11-2.4.4.jar 1000

stop-all.sh

exit 0
