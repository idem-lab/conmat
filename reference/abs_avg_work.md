# ABS work data for 2016

An internal dataset containing Australian Bureau of Statistics work data
for each age in 2016. The data is averaged across each state to provide
an overall average, and is used to provide estimated work populations
for model fitting in
[`add_school_work_participation()`](https://idem-lab.github.io/conmat/reference/add_school_work_participation.md),
which is used in
[`fit_single_contact_model()`](https://idem-lab.github.io/conmat/reference/fit_single_contact_model.md).
The data is summarised from `data_abs_state_work`, see
[`?data_abs_state_work`](https://idem-lab.github.io/conmat/reference/data_abs_state_work.md)
for more details.

## Usage

``` r
abs_avg_work
```

## Format

A data frame with 116 rows and 2 variables:

- age:

  0 to 115

- work_fraction:

  fraction of population working.

## Source

Census of Population and Housing, 2016, TableBuilder
