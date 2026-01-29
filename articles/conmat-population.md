# Conmat Population Data

``` r
library(conmat)
```

The main goal of conmat is to estimate contact rates between age groups.
This means we require data describing the age population distribution.
Effectively this is data that has a column describing age, and a column
describing population, like this:

``` r
library(tibble)

dat_age <- tibble(
  age = seq(0, 25, by = 5),
  population = seq(1410, 1350, by = -12)
)

dat_age
#> # A tibble: 6 × 2
#>     age population
#>   <dbl>      <dbl>
#> 1     0       1410
#> 2     5       1398
#> 3    10       1386
#> 4    15       1374
#> 5    20       1362
#> 6    25       1350
```

We use this kind of data frequently in conmat, and it means that your
code might sometimes have lots of repetition like this:

``` r
calculation(
  data,
  age_col = age,
  population_col = population
)

estimation(
  data,
  age_col = age,
  population_col = population
)
```

The issue with repeating arguments is that it is unnecessary and
sometimes leads to forgetting to include them, or including them
erroneously. The code could instead look like this:

``` r
calculation(data)
estimation(data)
```

We can achieve this by creating a special object that is a dataframe
that knows which columns represent age, and population. This is a
`conmat_population` object.

We can create one with `as_conmat_population`:

``` r
dat_age_pop <- as_conmat_population(
  data = dat_age,
  age = age,
  population = population
)

dat_age_pop
#> # A tibble: 6 × 2 (conmat_population)
#>  - age: age
#>  - population: population
#>     age population
#>   <dbl>      <dbl>
#> 1     0       1410
#> 2     5       1398
#> 3    10       1386
#> 4    15       1374
#> 5    20       1362
#> 6    25       1350
```

You can see when we print this out to the console that this class is
noted in parentheses (`conmat_population`), and the columns are noted.

## Accessing age and population information

If you want to access the age and population information, there are 2
main functions:

- [`age()`](https://idem-lab.github.io/conmat/reference/accessors.md)
- [`population()`](https://idem-lab.github.io/conmat/reference/accessors.md)

These return symbols, which can be used in programming.

``` r
age(dat_age_pop)
#> age
population(dat_age_pop)
#> population
```

alternatively there are functions that return character information:

- [`age_label()`](https://idem-lab.github.io/conmat/reference/accessors.md)
- [`population_label()`](https://idem-lab.github.io/conmat/reference/accessors.md)

``` r
age_label(dat_age_pop)
#> [1] "age"
population_label(dat_age_pop)
#> [1] "population"
```

## Brief example of using accessor functions

You could use this to extract out the values from the data and then
summarise it, for example:

``` r
pop_var <- age_label(dat_age_pop)

dat_age_pop[[pop_var]]
#> [1]  0  5 10 15 20 25
mean(dat_age_pop[[pop_var]])
#> [1] 12.5
sd(dat_age_pop[[pop_var]])
#> [1] 9.354143

age_var <- population_label(dat_age_pop)

dat_age_pop[[age_var]]
#> [1] 1410 1398 1386 1374 1362 1350
mean(dat_age_pop[[age_var]])
#> [1] 1380
sd(dat_age_pop[[age_var]])
#> [1] 22.44994
```

You could then wrap this in a function if you like:

``` r
summary_pop <- function(data) {
  dat_age_pop[[pop_var]]
  mean_pop <- mean(dat_age_pop[[pop_var]])
  sd_pop <- sd(dat_age_pop[[pop_var]])

  age_var <- population_label(dat_age_pop)

  dat_age_pop[[age_var]]
  mean_age <- mean(dat_age_pop[[age_var]])
  sd_age <- sd(dat_age_pop[[age_var]])

  return(
    tibble(
      mean_pop,
      sd_pop,
      mean_age,
      sd_age
    )
  )
}

summary_pop(dat_age_pop)
#> # A tibble: 1 × 4
#>   mean_pop sd_pop mean_age sd_age
#>      <dbl>  <dbl>    <dbl>  <dbl>
#> 1     12.5   9.35     1380   22.4
```

However if you would like to program with these variables, for example
write a function that uses functions like `mutate` and `arrange`, from
`dplyr`, you would need to get the symbols and then evaluate them with
`!!`, like so:

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
my_age_summary <- function(data) {
  age_col <- age(data)
  data %>%
    summarise(
      mean_age = mean(!!age_col)
    )
}

my_age_summary(dat_age_pop)
#> # A tibble: 1 × 1
#>   mean_age
#>      <dbl>
#> 1     12.5
```

And for a slightly more complex use case

``` r
my_age_pop_summary <- function(data) {
  age_col <- age(data)
  pop_col <- population(data)

  data %>%
    summarise(
      across(c(!!age_col, !!pop_col),
        c(mean = mean, sd = sd),
        .names = "{.fn}_{.col}"
      )
    )
}

my_age_pop_summary(dat_age_pop)
#> # A tibble: 1 × 4
#>   mean_age sd_age mean_population sd_population
#>      <dbl>  <dbl>           <dbl>         <dbl>
#> 1     12.5   9.35            1380          22.4
```

## An example use from the package

Internally within conmat we do some modelling work that requires us to
know the midpoint of the ages, and a couple of other bits - here’s an
example of how we write that code now:

``` r
add_modelling_info <- function(data) {
  age_col <- age(data)
  age_var <- age_label(data)
  pop_col <- population(data)

  diffs <- diff(data[[age_var]])
  bin_widths <- c(diffs, diffs[length(diffs)])

  data %>%
    dplyr::arrange(
      !!age_col
    ) %>%
    dplyr::mutate(
      # model based on bin midpoint
      bin_width = bin_widths,
      midpoint = !!age_col + bin_width / 2,
      # scaling down the population appropriately
      log_pop = log(!!pop_col / bin_width)
    )
}

add_modelling_info(dat_age_pop)
#> # A tibble: 6 × 5 (conmat_population)
#>  - age: age
#>  - population: population
#>     age population bin_width midpoint log_pop
#>   <dbl>      <dbl>     <dbl>    <dbl>   <dbl>
#> 1     0       1410         5      2.5    5.64
#> 2     5       1398         5      7.5    5.63
#> 3    10       1386         5     12.5    5.62
#> 4    15       1374         5     17.5    5.62
#> 5    20       1362         5     22.5    5.61
#> 6    25       1350         5     27.5    5.60
```

## Using these as S3 methods in an R package

If you want to use `conmat_population` within your R package, then
please get in touch with the maintainer. We currently do not export the
underlying internal functions, but this can easily be changed.

## Conclusion

That’s how we can use the conmat population information! Please go ahead
and use and enjoy!
