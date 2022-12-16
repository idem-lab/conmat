new_population <- function(data, age, population){
  
  quo_age <- rlang::enquo(age)
  quo_population <- rlang::enquo(population)
  
  label_age <- rlang::as_label(quo_age)
  label_population <- rlang::as_label(quo_population)
  
  age <- data[[label_age]]
  population <- data[[label_population]]
  
  structure(
    data, 
    class = c("population", class(data)),
    age = age,
    age_quo = quo_age,
    population = population,
    population_quo = quo_population
  )
  
}

pull_age <- function(x){
  attr(x, "age")
}

pull_population <- function(x){
  attr(x, "population")
}

validate_population <- function(x){
  if (!is.data.frame(x)){
    msg <- cli::format_error(
      c("x must be a {.cls data.frame}",
        "x is {.cls {class(x)}")
    )
    rlang::abort(msg)
  }
  
  age <- pull_age(x)
  population <- pull_population(x)
  
  if (!is.numeric(age)){
    msg <- cli::format_error(
      c("age must be of class {.cls numeric}",
        "but age is of class {.cls {class(x)}}")
    )
    rlang::abort(msg)
  }
  
  if (!is.numeric(population)){
    msg <- cli::format_error(
      c("population must be of class {.cls numeric}",
        "but population is of class {.cls {class(x)}}")
    )
    rlang::abort(msg)
  }
  
}

population <- function(data, age, population){
  population <- new_population(data, age, population)
  validate_population(population)
  population
}

# perth <- abs_age_lga("Perth (C)")
# perth_pop <- new_population(
#   data = perth,
#   age = lower.age.limit,
#   population = population
# )
# validate_population(perth_pop)
