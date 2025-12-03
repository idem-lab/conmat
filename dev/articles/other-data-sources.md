# Using other data sources

``` r
library(conmat)
```

The primary goal of the conmat package is to be able to get a contact
matrix for a given age population. It was initially written for work
done in Australia, and so the initial focus was on cleaning and
extracting data from the Australian Bureau of Statistics.

This vignette focusses on using other data sources with conmat.

We can use some other functions from `socialmixr` to extract similar
estimates for different populations in different countries.

We could extract some data from Italy using the
[`socialmixr`](https://epiforecasts.io/socialmixr/) R package

``` r
library(socialmixr)

italy_2005 <- wpp_age("Italy", "2005")

head(italy_2005)
#>   country lower.age.limit year population
#> 1   Italy               0 2005    2758749
#> 2   Italy               5 2005    2712790
#> 3   Italy              10 2005    2815246
#> 4   Italy              15 2005    2917476
#> 5   Italy              20 2005    3168918
#> 6   Italy              25 2005    3786584
```

We can then convert this data into a `conmat_population` object and use
it in `extrapolate_polymod`

``` r
italy_2005_pop <- as_conmat_population(
  data = italy_2005,
  age = lower.age.limit,
  population = population
)
```

``` r
age_breaks_0_80_plus <- c(seq(0, 80, by = 5), Inf)
italy_contact <- extrapolate_polymod(
  population = italy_2005_pop,
  age_breaks = age_breaks_0_80_plus
)

italy_contact
#> 
#> ── Setting Prediction Matrices ─────────────────────────────────────────────────
#> A list of matrices containing the model predicted contact rate between ages in
#> each setting.
#> There are 17 age breaks, ranging 0-80+ years, with a regular 5 year interval
#> • home: a 17x17 <matrix>
#> • work: a 17x17 <matrix>
#> • school: a 17x17 <matrix>
#> • other: a 17x17 <matrix>
#> • all: a 17x17 <matrix>
#> ℹ Access each <matrix> with `x$name`
#> ℹ e.g., `x$home`
```

## Creating a next generation matrix (NGM)

To create a next generation matrix, you can use either a conmat
population object, or setting prediction matrices, like so:

``` r
# using a conmat population object
italy_2005_ngm <- generate_ngm(
  italy_2005_pop,
  age_breaks = age_breaks_0_80_plus,
  R_target = 1.5
)

italy_2005_ngm
#> 
#> ── NGM Setting Matrices ────────────────────────────────────────────────────────
#> A list of matrices, each <matrix> containing the number of newly infected
#> individuals for a specified age group.
#> There are 17 age breaks, ranging 0-80+ years, with a regular 5 year interval
#> • home: a 17x17 <matrix>
#> • school: a 17x17 <matrix>
#> • work: a 17x17 <matrix>
#> • other: a 17x17 <matrix>
#> • all: a 17x17 <matrix>
#> ℹ Access each <matrix> with `x$name`
#> ℹ e.g., `x$home`

# using a setting prediction matrix
italy_2005_ngm_polymod <- generate_ngm(
  italy_contact,
  age_breaks = age_breaks_0_80_plus,
  R_target = 1.5
)

italy_2005_ngm_polymod
#> 
#> ── NGM Setting Matrices ────────────────────────────────────────────────────────
#> A list of matrices, each <matrix> containing the number of newly infected
#> individuals for a specified age group.
#> There are 17 age breaks, ranging 0-80+ years, with a regular 5 year interval
#> • home: a 17x17 <matrix>
#> • school: a 17x17 <matrix>
#> • work: a 17x17 <matrix>
#> • other: a 17x17 <matrix>
#> • all: a 17x17 <matrix>
#> ℹ Access each <matrix> with `x$name`
#> ℹ e.g., `x$home`

# these are the same
identical(italy_2005_ngm, italy_2005_ngm_polymod)
#> [1] TRUE
```

## Applying vaccination to an NGM

We can then take a next generation matrix and apply vaccination data,
such as the provided `vaccination_effect_example_data` dataset.

``` r
vaccination_effect_example_data
#> # A tibble: 17 × 4
#>    age_band coverage acquisition transmission
#>    <chr>       <dbl>       <dbl>        <dbl>
#>  1 0-4         0           0            0    
#>  2 5-11        0.782       0.583        0.254
#>  3 12-15       0.997       0.631        0.295
#>  4 16-19       0.965       0.786        0.469
#>  5 20-24       0.861       0.774        0.453
#>  6 25-29       0.997       0.778        0.458
#>  7 30-34       0.998       0.803        0.493
#>  8 35-39       0.998       0.829        0.533
#>  9 40-44       0.999       0.841        0.551
#> 10 45-49       0.993       0.847        0.562
#> 11 50-54       0.999       0.857        0.579
#> 12 55-59       0.996       0.864        0.591
#> 13 60-64       0.998       0.858        0.581
#> 14 65-69       0.999       0.864        0.591
#> 15 70-74       0.999       0.867        0.597
#> 16 75-79       0.999       0.866        0.595
#> 17 80+         0.999       0.844        0.556

ngm_italy_vacc <- apply_vaccination(
  ngm = italy_2005_ngm,
  data = vaccination_effect_example_data,
  coverage_col = coverage,
  acquisition_col = acquisition,
  transmission_col = transmission
)

ngm_italy_vacc
#> 
#> ── Vaccination Setting Matrices ────────────────────────────────────────────────
#> A list of matrices, each <matrix> containing the adjusted number of newly
#> infected individuals for age groups. These numbers have been adjusted based on
#> proposed vaccination rates in age groups
#> There are 17 age breaks, ranging 0-80+ years, with a regular 5 year interval
#> • home: a 17x17 <matrix>
#> • school: a 17x17 <matrix>
#> • work: a 17x17 <matrix>
#> • other: a 17x17 <matrix>
#> • all: a 17x17 <matrix>
#> ℹ Access each <matrix> with `x$name`
#> ℹ e.g., `x$home`
```
