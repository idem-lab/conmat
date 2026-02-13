# Format POLYMOD data and filter contacts to certain settings

Provides contact and participant POLYMOD data from selected countries.
It impute missing contact ages via one of three methods:

1.  imputing contact ages from a random uniform distribution from the
    range of ages. 2) using the average of the ages, 3) removal of those
    participants. The contact settings are then classified as "home",
    "school", "work" and "others", where "others" include locations such
    as leisure, transport or other places. The participants with missing
    contact ages or settings are removed, and the number of contacts per
    participant and contact age from ages 0-100 are obtained for various
    countries and settings.

## Usage

``` r
get_polymod_contact_data(
  setting = c("all", "home", "work", "school", "other"),
  countries = c("Belgium", "Finland", "Germany", "Italy", "Luxembourg", "Netherlands",
    "Poland", "United Kingdom"),
  ages = 0:100,
  contact_age_imputation = c("sample", "mean", "remove_participant")
)
```

## Arguments

- setting:

  Which setting to extract data from. Default is all settings. Options
  are: "all", "home", "work", "school", and "other".

- countries:

  countries to extract data from. Default is all countries from this
  list: "Belgium", "Finland", "Germany", "Italy", "Luxembourg",
  "Netherlands", "Poland", and "United Kingdom".

- ages:

  Which ages to return. Default is ages 0 to 100.

- contact_age_imputation:

  How to handle age when it is missing. Choose one of three methods: 1)
  "sample", which imputes contact ages from a random uniform
  distribution from the range of ages. 2) "mean", use the average of the
  ages, 3) "remove_participant" removal of those participants. Default
  is "sample".

## Value

A data.frame with columns: "setting" (all, work, home, etc. as specified
in "setting" argument); "age_from" - the age of the participant;
"age_to" - the age of the person the participant had contact with;
"contacts" the number of contacts that person had; "participants" the
number of participants in that row.

## Examples

``` r
get_polymod_contact_data()
#> # A tibble: 8,787 × 5
#>    setting age_from age_to contacts participants
#>    <chr>      <int>  <dbl>    <int>        <int>
#>  1 all            0      0       31           92
#>  2 all            0      1       15           92
#>  3 all            0      2       24           92
#>  4 all            0      3       21           92
#>  5 all            0      4       14           92
#>  6 all            0      5       13           92
#>  7 all            0      6       12           92
#>  8 all            0      7       11           92
#>  9 all            0      8        7           92
#> 10 all            0      9        8           92
#> # ℹ 8,777 more rows
get_polymod_contact_data(
  setting = "home",
  countries = c("Belgium", "Italy"),
  ages = 0:50,
  contact_age_imputation = "mean"
)
#> # A tibble: 5,988 × 5
#>    setting age_from age_to contacts participants
#>    <chr>      <int>  <dbl>    <int>        <int>
#>  1 home           0      0        0           11
#>  2 home           0      1        2           11
#>  3 home           0      2        0           11
#>  4 home           0      3        4           11
#>  5 home           0      4        1           11
#>  6 home           0      5        1           11
#>  7 home           0      6        0           11
#>  8 home           0      7        2           11
#>  9 home           0      8        1           11
#> 10 home           0      9        0           11
#> # ℹ 5,978 more rows
```
