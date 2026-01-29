# Predict contact rate between two age populations, given some model.

Predicts the expected contact rate over specified age breaks, given some
model of contact rate and population age structure. This function is
used internally in
[`predict_setting_contacts()`](https://idem-lab.github.io/conmat/reference/predict_setting_contacts.md),
which performs this prediction across all settings (home, work, school,
other), and optionally performs an adjustment for per capita household
size. You can use `predict_contacts()` by itself, just be aware you will
need to separately apply a per capita household size adjustment if
required. See details below on `adjust_household_contact_matrix` for
more information.

## Usage

``` r
predict_contacts(model, population, age_breaks = c(seq(0, 75, by = 5), Inf))
```

## Arguments

- model:

  A single fitted model of contact rate (e.g.,
  [`fit_single_contact_model()`](https://idem-lab.github.io/conmat/reference/fit_single_contact_model.md))

- population:

  a dataframe of age population information, with columns indicating
  some lower age limit, and population, (e.g.,
  [`get_polymod_population()`](https://idem-lab.github.io/conmat/reference/get_polymod_population.md))

- age_breaks:

  the ages to predict to. By default, the age breaks are 0-75 in 5 year
  groups.

## Value

A dataframe with three columns: `age_group_from`, `age_group_to`, and
`contacts`. The age groups are factors, broken up into 5 year bins
`[0,5)`, `[5,10)`. The `contact` column is the predicted number of
contacts from the specified age group to the other one.

## Details

The population data is used to determine age range to predict contact
rates, and removes ages with zero population, so we do not make
predictions for ages with zero populations. Contact rates are predicted
yearly between the age groups, using
[`predict_contacts_1y()`](https://idem-lab.github.io/conmat/reference/predict_contacts_1y.md),
then aggregates these predicted contacts using
[`aggregate_predicted_contacts()`](https://idem-lab.github.io/conmat/reference/aggregate_predicted_contacts.md),
which aggregates the predictions back to the same resolution as the
data, appropriately weighting the contact rate by the population.

Regarding the `adjust_household_contact_matrix` function, we use
Per-capita household size instead of mean household size. Per-capita
household size is different to mean household size, as the household
size averaged over people in the **population**, not over households, so
larger households get upweighted. It is calculated by taking a
distribution of the number of households of each size in a population,
multiplying the size by the household by the household count to get the
number of people with that size of household, and computing the
population-weighted average of household sizes. We use per-capita
household size as it is a more accurate reflection of the average number
of household members a person in the population can have contact with.

## Examples

``` r
# If we have a model of contact rate at home, and age population structure
# for an LGA, say, Fairfield, in NSW:

polymod_setting_models$home
#> 
#> Family: poisson 
#> Link function: log 
#> 
#> Formula:
#> contacts ~ s(gam_age_offdiag) + s(gam_age_offdiag_2) + s(gam_age_diag_prod) + 
#>     s(gam_age_diag_sum) + s(gam_age_pmax) + s(gam_age_pmin) + 
#>     school_probability + work_probability + offset(log_contactable_population)
#> 
#> Estimated degrees of freedom:
#> 7.73 1.00 5.28 3.10 8.36 5.68  total = 34.15 
#> 
#> fREML score: 14684.84     rank: 55/57

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
```
