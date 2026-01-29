# Establish new BGM setting data

Establish new BGM setting data

## Usage

``` r
new_ngm_setting_matrix(list_matrix, raw_eigenvalue, scaling, age_breaks)
```

## Arguments

- list_matrix:

  list of matrices

- raw_eigenvalue:

  the raw eigenvalue

- scaling:

  scaling factor

- age_breaks:

  vector of age breaks

## Value

object with additional (primary) class "ngm_setting_matrix", and
attributes for "age_breaks", "scaling", and "raw_eigenvalue".
