# Predict setting contacts

Predict contact rate for each setting. Note that this function is
parallelisable with `future`, and will be impacted by any `future` plans
provided.

## Usage

``` r
predict_setting_contacts(
  population,
  contact_model,
  age_breaks,
  per_capita_household_size = NULL,
  model_per_capita_household_size = get_polymod_per_capita_household_size()
)
```

## Arguments

- population:

  population

- contact_model:

  contact_model

- age_breaks:

  age_breaks

- per_capita_household_size:

  Optional (defaults to NULL). When set, it adjusts the household
  contact matrix by some per capita household size. To set it, provide a
  single number, the per capita household size. More information is
  provided below in Details. See
  [`get_abs_per_capita_household_size()`](https://idem-lab.github.io/conmat/reference/get_abs_per_capita_household_size.md)
  function for a helper for Australian data with a workflow on how to
  get this number.

- model_per_capita_household_size:

  modelled per capita household size. Default values for this are from
  [`get_polymod_per_capita_household_size()`](https://idem-lab.github.io/conmat/reference/get_polymod_per_capita_household_size.md),
  which ends up being 3.248971

## Value

List of setting matrices

## Details

We use Per-capita household size instead of mean household size.
Per-capita household size is different to mean household size, as the
household size averaged over **people** in the population, not over
households, so larger households get upweighted. It is calculated by
taking a distribution of the number of households of each size in a
population, multiplying the size by the household by the household count
to get the number of people with that size of household, and computing
the population-weighted average of household sizes. We use per-capita
household size as it is a more accurate reflection of the average number
of household members a person in the population can have contact with.

## Author

Nicholas Tierney

## Examples

``` r
# don't run as it takes too long to fit
# \donttest{
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

age_break_0_85_plus <- c(seq(0, 85, by = 5), Inf)

polymod_contact_data <- get_polymod_setting_data()
polymod_survey_data <- get_polymod_population()

setting_models <- fit_setting_contacts(
  contact_data_list = polymod_contact_data,
  population = polymod_survey_data
)
#> Warning: fitted rates numerically 0 occurred
#> Warning: fitted rates numerically 0 occurred

synthetic_settings_5y_fairfield <- predict_setting_contacts(
  population = fairfield,
  contact_model = setting_models,
  age_breaks = age_break_0_85_plus
)

fairfield_hh_size <- get_abs_per_capita_household_size(lga = "Fairfield (C)")
fairfield_hh_size
#> [1] 4.199372

synthetic_settings_5y_fairfield_hh <- predict_setting_contacts(
  population = fairfield,
  contact_model = setting_models,
  age_breaks = age_break_0_85_plus,
  per_capita_household_size = fairfield_hh_size
)
# }
```
