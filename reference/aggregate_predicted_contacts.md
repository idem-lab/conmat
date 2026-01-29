# Aggregate predicted contacts to specified age breaks

Aggregates contacts rate from, say, a 1 year level into provided age
breaks, weighting the contact rate by the specified age population. For
example, if you specify breaks as c(0, 5, 10, 15, Inf), it will return
age groups as 0-5, 5-10, 10-15, and 15+ (Inf). Used internally within
[`predict_contacts()`](https://idem-lab.github.io/conmat/reference/predict_contacts.md),
although can be used by users.

## Usage

``` r
aggregate_predicted_contacts(
  predicted_contacts_1y,
  population,
  age_breaks = c(seq(0, 75, by = 5), Inf)
)
```

## Arguments

- predicted_contacts_1y:

  contacts in 1 year breaks (could technically by in other year breaks).
  Data must contain columns, `age_from`, `age_to`, `contacts`, and
  `se_contacts`, which is the same output as
  [`predict_contacts_1y()`](https://idem-lab.github.io/conmat/reference/predict_contacts_1y.md) -
  see examples below.

- population:

  a `conmat_population` object, which has the `age` and `population`
  columns specified, or a dataframe with columns `lower.age.limit`, and
  `population`. See examples below.

- age_breaks:

  vector of ages. Default: c(seq(0, 75, by = 5), Inf)

## Value

data frame with columns, `age_group_from`, `age_group_to`, and
`contacts`, which is the aggregated model.

## Examples

``` r
fairfield <- abs_age_lga("Fairfield (C)")

fairfield
#> # A tibble: 18 × 4 (conmat_population)
#>  - age: lower.age.limit
#>  - population: population
#>    lga           lower.age.limit  year population
#>    <chr>                   <dbl> <dbl>      <dbl>
#>  1 Fairfield (C)               0  2020      12261
#>  2 Fairfield (C)               5  2020      13093
#>  3 Fairfield (C)              10  2020      13602
#>  4 Fairfield (C)              15  2020      14323
#>  5 Fairfield (C)              20  2020      15932
#>  6 Fairfield (C)              25  2020      16190
#>  7 Fairfield (C)              30  2020      14134
#>  8 Fairfield (C)              35  2020      13034
#>  9 Fairfield (C)              40  2020      12217
#> 10 Fairfield (C)              45  2020      13449
#> 11 Fairfield (C)              50  2020      13419
#> 12 Fairfield (C)              55  2020      13652
#> 13 Fairfield (C)              60  2020      12907
#> 14 Fairfield (C)              65  2020      10541
#> 15 Fairfield (C)              70  2020       8227
#> 16 Fairfield (C)              75  2020       5598
#> 17 Fairfield (C)              80  2020       4006
#> 18 Fairfield (C)              85  2020       4240

# We can predict the contact rate for Fairfield from the existing contact
# data, say, between the age groups of 0-15 in 5 year bins for school:

fairfield_contacts_1 <- predict_contacts_1y(
  model = polymod_setting_models$home,
  population = fairfield,
  age_min = 0,
  age_max = 15
)

fairfield_contacts_1
#> # A tibble: 256 × 4
#>    age_from age_to  contacts se_contacts
#>       <dbl>  <dbl> <dbl[1d]>   <dbl[1d]>
#>  1        0      0     0.417      0.0348
#>  2        0      1     0.436      0.0306
#>  3        0      2     0.439      0.0263
#>  4        0      3     0.428      0.0222
#>  5        0      4     0.404      0.0187
#>  6        0      5     0.374      0.0161
#>  7        0      6     0.339      0.0144
#>  8        0      7     0.305      0.0132
#>  9        0      8     0.272      0.0124
#> 10        0      9     0.244      0.0117
#> # ℹ 246 more rows

aggregated_fairfield <- aggregate_predicted_contacts(
  predicted_contacts_1y = fairfield_contacts_1,
  population = fairfield,
  age_breaks = c(0, 5, 10, 15, Inf)
)

aggregated_fairfield
#> # A tibble: 16 × 3
#>    age_group_from age_group_to contacts
#>    <fct>          <fct>           <dbl>
#>  1 [0,5)          [0,5)           2.59 
#>  2 [0,5)          [5,10)          2.29 
#>  3 [0,5)          [10,15)         1.22 
#>  4 [0,5)          [15,Inf)        0.175
#>  5 [5,10)         [0,5)           2.17 
#>  6 [5,10)         [5,10)          3.69 
#>  7 [5,10)         [10,15)         2.56 
#>  8 [5,10)         [15,Inf)        0.267
#>  9 [10,15)        [0,5)           1.09 
#> 10 [10,15)        [5,10)          2.43 
#> 11 [10,15)        [10,15)         4.24 
#> 12 [10,15)        [15,Inf)        0.651
#> 13 [15,Inf)       [0,5)           0.760
#> 14 [15,Inf)       [5,10)          1.23 
#> 15 [15,Inf)       [10,15)         3.14 
#> 16 [15,Inf)       [15,Inf)        0.910
```
