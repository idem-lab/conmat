new_population <- function(data, age, population){
  
  age <- data[[substitute(age)]]
  population <- data[[substitute(population)]]
  
  stopifnot(is.data.frame(data))
  stopifnot(is.numeric(age))
  stopifnot(is.numeric(population))
  
  structure(
    data, 
    class = c("population", class(data)),
    age = age,
    population = population
  )
            
}

validate_population <- function(x){
  
}

population <- function(x){
  
}