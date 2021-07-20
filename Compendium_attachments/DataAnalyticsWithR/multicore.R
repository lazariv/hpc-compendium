library(parallel)

# here some function that needs to be executed in parallel
average <- function(size){
  norm_vector <- rnorm(n=size, mean=mu, sd=sigma)
  return(mean(norm_vector))
}

# variable initialization
mu <- 1.0
sigma <- 1.0
vector_length <- 10^7
n_repeat <- 100
sample_sizes <- rep(vector_length, times=n_repeat)


# shared-memory version
threads <- as.integer(Sys.getenv("SLURM_CPUS_ON_NODE"))  
# here the name of the variable depends on the correct sbatch configuration
# unfortunately the built-in function gets the total number of physical cores without looking on SLURM configuration

list_of_averages <- mclapply(X=sample_sizes, FUN=average, mc.cores=threads)  # apply function "average" 100 times
