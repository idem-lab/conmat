# Fit all-of-polymod model and extrapolate to a given population an age breaks

Uses
[`estimate_setting_contacts()`](https://idem-lab.github.io/conmat/dev/reference/estimate_setting_contacts.md)
to fit a contact model on the data from polymod and later extrapolate on
to a desired population. Note that this function is parallelisable with
`future`, and will be impacted by any `future` plans provided.

## Usage

``` r
extrapolate_polymod(
  population,
  age_breaks = c(seq(0, 75, by = 5), Inf),
  per_capita_household_size = NULL
)
```

## Arguments

- population:

  a `conmat_population` object, specifying the `age` and `population`
  characteristics. Or a data frame with `lower.age.limit` and
  `population` columns. See
  [`get_polymod_population()`](https://idem-lab.github.io/conmat/dev/reference/get_polymod_population.md)
  for an example of this data.

- age_breaks:

  vector depicting age values. Default value is
  `c(seq(0, 75, by = 5), Inf)`

- per_capita_household_size:

  Optional (defaults to NULL). When set, it adjusts the household
  contact matrix by some per capita household size. To set it, provide a
  single number, the per capita household size. More information is
  provided below in Details. See
  [`get_abs_per_capita_household_size()`](https://idem-lab.github.io/conmat/dev/reference/get_abs_per_capita_household_size.md)
  function for a helper for Australian data with a workflow on how to
  get this number.

## Value

Returns setting-specific and combined contact matrices for the desired
ages.

## Details

Also note that since this model uses the already fit
`polymod_setting_models` data, which has been fit using symmetrical
model terms, if you want to fit a model with asymmetric model terms, you
will need to go through the full process of building new models. You can
find this detail in last section of the vignette "example pipeline".

## Examples

``` r
# \donttest{
polymod_population <- get_polymod_population()
synthetic_settings_5y_polymod <- extrapolate_polymod(
  population = polymod_population
)
synthetic_settings_5y_polymod
#> 
#> ── Setting Prediction Matrices ─────────────────────────────────────────────────
#> 
#> A list of matrices containing the model predicted contact rate between ages in
#> each setting.
#> 
#> There are 16 age breaks, ranging 0-75+ years, with a regular 5 year interval
#> 
#> • home: a 16x16 <matrix>
#> • work: a 16x16 <matrix>
#> • school: a 16x16 <matrix>
#> • other: a 16x16 <matrix>
#> • all: a 16x16 <matrix>
#> ℹ Access each <matrix> with `x$name`
#> ℹ e.g., `x$home`
synthetic_settings_5y_fairfield <- extrapolate_polymod(
  population = abs_age_lga("Fairfield (C)")
)
synthetic_settings_5y_fairfield
#> 
#> ── Setting Prediction Matrices ─────────────────────────────────────────────────
#> 
#> A list of matrices containing the model predicted contact rate between ages in
#> each setting.
#> 
#> There are 16 age breaks, ranging 0-75+ years, with a regular 5 year interval
#> 
#> • home: a 16x16 <matrix>
#> • work: a 16x16 <matrix>
#> • school: a 16x16 <matrix>
#> • other: a 16x16 <matrix>
#> • all: a 16x16 <matrix>
#> ℹ Access each <matrix> with `x$name`
#> ℹ e.g., `x$home`
# }
```
