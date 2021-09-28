#create small dataset
name <- c("1", "2", "3", "4", "5")
age <- c(6, 7, 4, 5, 6)
growth <- c(100, 107, 85, 93, 99)
weight <- c(20, 23, 16, 19, 20)
children <- data.frame(name, age, growth, weight)

#The kmeans function is now wrapped in a custom parallel function 
#that takes the number of starting positions (nstart) as its sole parameter
parallel.function <- function(i) {kmeans( children, centers=4, nstart=i )}

#Each of the four invocations of lapply winds up calling kmeans, 
#but each call to kmeans only does 25 starts instead of the full 100
results <- lapply( c(25, 25, 25, 25), FUN=parallel.function )


#for the k-means result with the absolute lowest value for results$tot.withinss use the which.min() function alue. 
#for thw which.min() for the input vecor) use tot.withinss.sapply returns a vector comprised of each tot.withinss value from the list of k-means objects
temp.vector <- sapply( results, function(result) { result$tot.withinss } )

#to get the index of temp.vector that contains the minimum value
result <- results[[which.min(temp.vector)]]

print(result)
