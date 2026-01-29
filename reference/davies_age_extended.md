# Susceptibility and clinical fraction parameters from Davies et al.

A dataset containing data from
<https://www.nature.com/articles/s41591-020-0962-9#code-availability>
When using this data, ensure that you cite the original authors at:

## Usage

``` r
davies_age_extended
```

## Format

A data frame of the probability of transmission from a case to a
contact. There are 101 rows and 4 variables.

- age:

  from 0 to 100

- clinical_fraction:

  Estimate of fraction with clinical symptoms, or the age-specific
  proportion of infections resulting in clinical symptoms inferred by
  applying a smoothing spline to the mean estimates from Davies et al.

- davies_original:

  Age specific parameters of the relative susceptibility to infection
  inferred from a smoothing-spline estimate of the mean relative
  susceptibility estimate from Davies et al.

- davies_updated:

  Re-estimated parameter of the susceptibility profile for under-16s
  that is estimated in a similar way but to the age-distribution of
  infections in England from the UK ONS prevalence survey rather than
  case counts which may undercount children

## Details

"Davies, N.G., Klepac, P., Liu, Y. et al. Age-dependent effects in the
transmission and control of COVID-19 epidemics. Nat Med 26, 1205–1211
(2020). https://doi.org/10.1038/s41591-020-0962-9"
