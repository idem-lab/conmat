# Apply vaccination effects to next generation contact matrices

Applies the effect of vaccination on the next generation of infections,
to understand and describe the reduction of acquisition and transmission
in each age group.

## Usage

``` r
apply_vaccination(ngm, data, coverage_col, acquisition_col, transmission_col)
```

## Arguments

- ngm:

  next generation matrices. See
  [`generate_ngm()`](https://idem-lab.github.io/conmat/reference/generate_ngm.md)
  for creating next generation matrices of a state or a local government
  area for specific age groups

- data:

  data frame with location specific information on vaccine coverage,
  efficacy of acquisition/susceptibility and efficacy of
  transmission/infectiousness for the ordered age groups from lowest to
  highest of the next generation matrix

- coverage_col:

  bare variable name for the column with information on vaccine coverage
  by age groups

- acquisition_col:

  bare variable name for the column with information on efficacy of
  acquisition

- transmission_col:

  bare variable name for the column with information on efficacy of
  transmission

## Value

list of contact matrices, one for each setting with reduction in
transmission matching the next generation matrices

## Details

Vaccination improves a person's immunity from a disease. When a sizeable
section of the population receives vaccinations or when vaccine coverage
is sufficient enough, the likelihood that the unvaccinated population
will contract the disease is decreased. This helps to slow infectious
disease spread as well as lessen its severity. For this reason, it is
important to understand how much of a reduction in probability of
acquisition (the likelihood that an individual will contract the
disease), and probability of transmission (the likelihood that an
individual will spread the disease after contracting it), has occurred
as an the effect of vaccination, in other words the effect of
vaccination on the next generation of infections.

`apply_vaccination` returns the percentage reduction in acquisition and
transmission in each age group. It does this by taking the outer product
of these reductions in acquisition and transmission by age group,
creating a transmission reduction matrix. The next generation matrices
with the vaccination effects applied are then produced using the
obtained transmission reduction matrix and the next generation matrices
passed to the function as an argument.

## Examples

``` r
# examples take 20 second to run so skipping
# \donttest{
# example data frame with vaccine coverage, acquisition and transmission
# efficacy of different age groups
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

# Generate next generation matrices

perth <- abs_age_lga("Perth (C)")
perth_hh <- get_abs_per_capita_household_size(lga = "Perth (C)")

age_breaks_0_80 <- c(seq(0, 80, by = 5), Inf)

# refit the model - note that the default if age_breaks isn't specified is
# 0 to 75
perth_contact_0_80 <- extrapolate_polymod(
  perth,
  per_capita_household_size = perth_hh,
  age_breaks = age_breaks_0_80
)

perth_ngm_0_80 <- generate_ngm(perth_contact_0_80,
  age_breaks = age_breaks_0_80,
  per_capita_household_size = perth_hh,
  R_target = 1.5
)

# In the old way we used to be able to pass age_breaks_0_80 along
generate_ngm_oz(
  lga_name = "Perth (C)",
  age_breaks = age_breaks_0_80,
  R_target = 1.5
)
#> 
#> ── NGM Setting Matrices ────────────────────────────────────────────────────────
#> 
#> A list of matrices, each <matrix> containing the number of newly infected
#> individuals for a specified age group.
#> 
#> There are 17 age breaks, ranging 0-80+ years, with a regular 5 year interval
#> 
#> • home: a 17x17 <matrix>
#> • school: a 17x17 <matrix>
#> • work: a 17x17 <matrix>
#> • other: a 17x17 <matrix>
#> • all: a 17x17 <matrix>
#> ℹ Access each <matrix> with `x$name`
#> ℹ e.g., `x$home`


# another way to do this using the previous method for generating NGMs
# The number of age breaks must match the vaccination effect data
ngm_nsw <- generate_ngm_oz(
  state_name = "NSW",
  age_breaks = c(seq(0, 80, by = 5), Inf),
  R_target = 1.5
)

# Apply vaccination effect to next generation matrices
ngm_nsw_vacc <- apply_vaccination(
  ngm = ngm_nsw,
  data = vaccination_effect_example_data,
  coverage_col = coverage,
  acquisition_col = acquisition,
  transmission_col = transmission
)
# }
```
