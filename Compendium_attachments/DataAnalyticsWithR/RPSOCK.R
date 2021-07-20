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

# cluster setup

# get number of available nodes (should be the = "ntask")
mynodes = 8  
print(paste("The cluster of size", threads, "will be setup..."))

# initialize cluster
cl <- makeCluster(mynodes, type="PSOCK", outfile="")

# distribute required variables for the execution over the cluster
clusterExport(cl, list("mu","sigma"))  

list_of_averages <- parLapply(X=sample_sizes, fun=average, cl=cl)

# shut down the cluster
print(paste("Program finished"))
