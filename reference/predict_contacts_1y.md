# Predict contact rate to a given population at full 1y resolution

Provides a predicted rate of contacts for contact ages. Take an already
fitted model of contact rate and predict the estimated contact rate, and
standard error, for all combinations of the provided ages in 1 year
increments. So if the minimum age is 5, and the maximum age is 10, it
will provide the estimated contact rate for all age combinations: 5 and
5, 5 and 6 ... 5 and 10, and so on. This function is used internally
within
[`predict_contacts()`](https://idem-lab.github.io/conmat/reference/predict_contacts.md),
and thus
[`predict_setting_contacts()`](https://idem-lab.github.io/conmat/reference/predict_setting_contacts.md)
as well, although it can be used by itself. See examples for more
details, and details for more information.

## Usage

``` r
predict_contacts_1y(model, population, age_min = 0, age_max = 100)
```

## Arguments

- model:

  A single fitted model of contact rate (e.g.,
  [`fit_single_contact_model()`](https://idem-lab.github.io/conmat/reference/fit_single_contact_model.md))

- population:

  a dataframe of age population information, with columns indicating
  some lower age limit, and population, (e.g.,
  [`get_polymod_population()`](https://idem-lab.github.io/conmat/reference/get_polymod_population.md))

- age_min:

  Age range minimum value. Default: 0

- age_max:

  Age range maximum value, Default: 100

## Value

Data frame with four columns: `age_from`, `age_to`, `contacts`, and
`se_contacts`. This contains the participant & contact ages from the
minimum and maximum ages provided along with the predicted rate of
contacts and standard error around the prediction.

## Details

Prediction features are added using
[`add_modelling_features()`](https://idem-lab.github.io/conmat/reference/add_modelling_features.md).
These features include the population distribution of contact ages,
fraction of population in each age group that attend school/work as well
as the offset according to the settings on all combinations of the
participant & contact ages.

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

# predict the contact rates in 1 year blocks to Fairfield data

fairfield_contacts_1 <- predict_contacts_1y(
  model = polymod_setting_models$home,
  population = fairfield,
  age_min = 0,
  age_max = 2
)
```
