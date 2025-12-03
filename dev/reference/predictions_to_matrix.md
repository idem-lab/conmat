# Convert dataframe of predicted contacts into matrix

Helper function to convert predictions of contact rates in data frames
to matrix format with the survey participant age groups as columns and
contact age groups as rows.

## Usage

``` r
predictions_to_matrix(contact_predictions, ...)
```

## Arguments

- contact_predictions:

  data frame with columns `age_group_from`, `age_group_to`, and
  `contacts`.

- ...:

  extra arguments

## Value

Square matrix with the unique age groups from `age_group_from/to` in the
rows and columns and `contacts` as the values.

## Examples

``` r
fairfield <- abs_age_lga("Fairfield (C)")

# We can convert the predictions into a matrix

fairfield_school_contacts <- predict_contacts(
  model = polymod_setting_models$school,
  population = fairfield,
  age_breaks = c(0, 5, 10, 15, Inf)
)

fairfield_school_contacts
#> # A tibble: 16 × 3
#>    age_group_from age_group_to contacts
#>    <fct>          <fct>           <dbl>
#>  1 [0,5)          [0,5)          1.29  
#>  2 [0,5)          [5,10)         0.360 
#>  3 [0,5)          [10,15)        0.0398
#>  4 [0,5)          [15,Inf)       0.646 
#>  5 [5,10)         [0,5)          0.342 
#>  6 [5,10)         [5,10)         4.28  
#>  7 [5,10)         [10,15)        0.407 
#>  8 [5,10)         [15,Inf)       1.22  
#>  9 [10,15)        [0,5)          0.0358
#> 10 [10,15)        [5,10)         0.389 
#> 11 [10,15)        [10,15)        6.89  
#> 12 [10,15)        [15,Inf)       1.78  
#> 13 [15,Inf)       [0,5)          0.0460
#> 14 [15,Inf)       [5,10)         0.0916
#> 15 [15,Inf)       [10,15)        0.142 
#> 16 [15,Inf)       [15,Inf)       1.03  

# convert them back to a matrix
predictions_to_matrix(fairfield_school_contacts)
#>               [0,5)    [5,10)    [10,15)   [15,Inf)
#> [0,5)    1.29282238 0.3420768 0.03576273 0.04598657
#> [5,10)   0.35984494 4.2783940 0.38874296 0.09155252
#> [10,15)  0.03981607 0.4065530 6.89007154 0.14173611
#> [15,Inf) 0.64590388 1.2160564 1.78393541 1.03380519
```
