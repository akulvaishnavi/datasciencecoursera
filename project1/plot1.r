# Function to create a special "matrix" object that can cache its inverse
makeCacheMatrix <- function(x = matrix()) {
  inv <- NULL
  set <- function(y) {
    x <<- y
    inv <<- NULL
  }
  get <- function() x
  setInverse <- function(inverse) inv <<- inverse
  getInverse <- function() inv
  list(set = set, get = get, setInverse = setInverse, getInverse = getInverse)
}

# Function to compute the inverse of a matrix and cache the result
cacheSolve <- function(x, ...) {
  inv <- x$getInverse()
  
  # If the inverse is already calculated, return it
  if (!is.null(inv)) {
    message("Getting cached data")
    return(inv)
  }
  
  # If the inverse is not cached, calculate it and cache the result
  data <- x$get()
  inv <- solve(data, ...)
  x$setInverse(inv)
  inv
}

# Example usage:
# Create a cache matrix
myMatrix <- makeCacheMatrix(matrix(c(1, 2, 3, 4), nrow = 2))

# Compute and cache the inverse
cacheSolve(myMatrix)
