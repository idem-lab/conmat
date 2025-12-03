# Return an interpolating function for populations in 1y age increments

This function returns an interpolating function to get populations in 1y
age increments from chunkier distributions produced by
[`socialmixr::wpp_age()`](https://epiforecasts.io/socialmixr/reference/wpp_age.html).

## Usage

``` r
get_age_population_function(data, ...)

# S3 method for class 'conmat_population'
get_age_population_function(data = population, ...)

# S3 method for class 'data.frame'
get_age_population_function(
  data = population,
  age_col = lower.age.limit,
  pop_col = population,
  ...
)
```

## Arguments

- data:

  dataset containing information on population of a given age/age group

- ...:

  extra arguments

- age_col:

  bare variable name for the column with age information

- pop_col:

  bare variable name for the column with population information

## Value

An interpolating function to get populations in 1y age increments

## Details

The function first prepares the data to fit a smoothing spline to the
data for ages below the maximum age. It arranges the data by the lower
limit of the age group to obtain the bin width/differences of the lower
age limits. The mid point of the bin width is later added to the ages
and the population is scaled as per the bin widths. The maximum age is
later obtained and the populations for different above and below are
filtered out along with the sum of populations with and without maximum
age. A cubic smoothing spline is then fitted to the data for ages below
the maximum with predictor variable as the ages with the mid point of
the bins added to it where as the response variable is the log-scaled
population. Using the smoothing spline fit, the predicted population of
ages 0 to 200 is obtained and the predicted population is adjusted
further using a ratio of the sum of the population across all ages from
the data and predicted population. The ratio is based on whether the
ages are under the maximum age as the total population across all ages
differs for ages above and below the maximum age. The maximum age
population is adjusted further to drop off smoothly, based on the
weights. The final population is then linearly extrapolated over years
past the upper bound from the data. For ages above the maximum age from
data, the population is calculated as a weighted population of the
maximum age that depends on the years past the upper bound. Older ages
would have lower weights, therefore lower population.

## Examples

``` r
polymod_pop <- get_polymod_population()

polymod_pop
#> # A tibble: 21 × 2 (conmat_population)
#>  - age: lower.age.limit
#>  - population: population
#>    lower.age.limit population
#>              <int>      <dbl>
#>  1               0   1898966.
#>  2               5   2017632.
#>  3              10   2192410.
#>  4              15   2369985.
#>  5              20   2467873.
#>  6              25   2484327.
#>  7              30   2649826.
#>  8              35   3043704.
#>  9              40   3117812.
#> 10              45   2879510.
#> # ℹ 11 more rows

# But these ages and populations are binned every 5 years. So we can now
# provide a specified age and get the estimated population for that 1 year
# age group. First we create the new function like so

age_pop_function <- get_age_population_function(
  data = polymod_pop
)
# Then we pass it a year to get the estimated population for a particular age
age_pop_function(4)
#> [1] 385331.6

# Or a vector of years, to get the estimated population for a particular age
# range
age_pop_function(1:4)
#> [1] 369379.0 374617.8 379931.3 385331.6

# Notice that we get a _pretty similar_ number of 0-4 if we sum it up, as
# the first row of the table:
head(polymod_pop, 1)
#> # A tibble: 1 × 2 (conmat_population)
#>  - age: lower.age.limit
#>  - population: population
#>   lower.age.limit population
#>             <int>      <dbl>
#> 1               0   1898966.
sum(age_pop_function(age = 0:4))
#> [1] 1873473

# Usage in dplyr
library(dplyr)
example_df <- slice_head(abs_education_state, n = 5)
example_df %>%
  mutate(population_est = age_pop_function(age))
#> # A tibble: 5 × 6
#>    year state aboriginal_and_torres_…¹   age n_full_and_part_time population_est
#>   <dbl> <chr> <chr>                    <dbl>                <dbl>          <dbl>
#> 1  2006 ACT   Aboriginal and Torres S…     4                    5        385332.
#> 2  2006 ACT   Non-Indigenous               4                  109        385332.
#> 3  2006 NSW   Aboriginal and Torres S…     4                  104        385332.
#> 4  2006 NSW   Non-Indigenous               4                 1870        385332.
#> 5  2006 NT    Aboriginal and Torres S…     4                  102        385332.
#> # ℹ abbreviated name: ¹​aboriginal_and_torres_strait_islander_status
```
