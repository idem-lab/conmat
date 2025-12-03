# Get polymod setting data

`get_polymod_setting_data()` acts as an extension of
[`get_polymod_contact_data()`](https://idem-lab.github.io/conmat/dev/reference/get_polymod_contact_data.md),
and extracts the setting wise contact data on the desired country, as a
list.

## Usage

``` r
get_polymod_setting_data(
  countries = c("Belgium", "Finland", "Germany", "Italy", "Luxembourg", "Netherlands",
    "Poland", "United Kingdom")
)
```

## Arguments

- countries:

  countries to extract data from

## Value

A list of data frames, of the polymod data. One list per setting:
"home", "work", "school", and "other".

## Examples

``` r
get_polymod_setting_data()
#> 
#> ── Setting Data ────────────────────────────────────────────────────────────────
#> 
#> A list of <data.frame>s containing the number of contacts between ages in each
#> setting.
#> 
#> There are 86 age breaks, ranging 0-90 years, with an irregular year interval,
#> (on average, 1.05 years)
#> 
#> • home: a 8,787x5 <data.frame>
#> • work: a 8,787x5 <data.frame>
#> • school: a 8,787x5 <data.frame>
#> • other: a 8,787x5 <data.frame>
#> ℹ Access each <data.frame> with `x$name`
#> ℹ e.g., `x$home`
get_polymod_setting_data("Belgium")
#> 
#> ── Setting Data ────────────────────────────────────────────────────────────────
#> 
#> A list of <data.frame>s containing the number of contacts between ages in each
#> setting.
#> 
#> There are 81 age breaks, ranging 0-84 years, with an irregular year interval,
#> (on average, 1.04 years)
#> 
#> • home: a 8,282x5 <data.frame>
#> • work: a 8,282x5 <data.frame>
#> • school: a 8,282x5 <data.frame>
#> • other: a 8,282x5 <data.frame>
#> ℹ Access each <data.frame> with `x$name`
#> ℹ e.g., `x$home`
```
