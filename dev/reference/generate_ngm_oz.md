# Calculate next generation contact matrices from ABS data

This function calculates a next generation matrix (NGM) based on state
or LGA data from the Australian Bureau of Statistics (ABS). For full
details see
[`generate_ngm()`](https://idem-lab.github.io/conmat/dev/reference/generate_ngm.md).

## Usage

``` r
generate_ngm_oz(
  state_name = NULL,
  lga_name = NULL,
  age_breaks,
  R_target,
  setting_transmission_matrix = NULL
)
```

## Arguments

- state_name:

  target Australian state name in abbreviated form, such as "QLD",
  "NSW", or "TAS"

- lga_name:

  target Australian local government area (LGA) name, such as "Fairfield
  (C)". See
  [`abs_lga_lookup()`](https://idem-lab.github.io/conmat/dev/reference/abs_lga_lookup.md)
  for list of lga names.

- age_breaks:

  vector depicting age values with the highest age depicted as `Inf`.
  For example, c(seq(0, 85, by = 5), Inf)

- R_target:

  target reproduction number

- setting_transmission_matrix:

  default is NULL, which calculates the transmission matrix using
  `get_setting_transmission_matrices(age_breaks)`. You can provide your
  own transmission matrix, but its rows and columns must match the
  number of rows and columns, and must be a list of one matrix for each
  setting. See the output for
  `get_setting_transmission_matrices(age_breaks)` to get a sense of the
  structure. See
  [`get_setting_transmission_matrices()`](https://idem-lab.github.io/conmat/dev/reference/get_setting_transmission_matrices.md)
  for more detail.

## Examples

``` r
# don't run as both together takes a long time to run
# \donttest{
ngm_nsw <- generate_ngm_oz(
  state_name = "NSW",
  age_breaks = c(seq(0, 85, by = 5), Inf),
  R_target = 1.5
)
ngm_fairfield <- generate_ngm_oz(
  lga_name = "Fairfield (C)",
  age_breaks = c(seq(0, 85, by = 5), Inf),
  R_target = 1.5
)
# }
```
