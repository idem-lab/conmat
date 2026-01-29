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
get_polymod_contact_data(setting = "home")
#> # A tibble: 8,787 × 5
#>    setting age_from age_to contacts participants
#>    <chr>      <int>  <dbl>    <int>        <int>
#>  1 home           0      0       10           92
#>  2 home           0      1        7           92
#>  3 home           0      2       11           92
#>  4 home           0      3       15           92
#>  5 home           0      4       11           92
#>  6 home           0      5        6           92
#>  7 home           0      6        9           92
#>  8 home           0      7        9           92
#>  9 home           0      8        6           92
#> 10 home           0      9        6           92
#> # ℹ 8,777 more rows
get_polymod_contact_data(countries = "Belgium")
#> # A tibble: 8,282 × 5
#>    setting age_from age_to contacts participants
#>    <chr>      <int>  <dbl>    <int>        <int>
#>  1 all            0      0        8            5
#>  2 all            0      1        5            5
#>  3 all            0      2        5            5
#>  4 all            0      3        1            5
#>  5 all            0      4        1            5
#>  6 all            0      5        1            5
#>  7 all            0      6        0            5
#>  8 all            0      7        3            5
#>  9 all            0      8        0            5
#> 10 all            0      9        0            5
#> # ℹ 8,272 more rows
get_polymod_contact_data(countries = c("Belgium", "Italy"))
#> # A tibble: 8,383 × 5
#>    setting age_from age_to contacts participants
#>    <chr>      <int>  <dbl>    <int>        <int>
#>  1 all            0      0        9           11
#>  2 all            0      1        5           11
#>  3 all            0      2        4           11
#>  4 all            0      3        6           11
#>  5 all            0      4        2           11
#>  6 all            0      5        1           11
#>  7 all            0      6        0           11
#>  8 all            0      7        4           11
#>  9 all            0      8        1           11
#> 10 all            0      9        0           11
#> # ℹ 8,373 more rows
get_polymod_contact_data(ages = 0:50)
#> # A tibble: 7,183 × 5
#>    setting age_from age_to contacts participants
#>    <chr>      <int>  <dbl>    <int>        <int>
#>  1 all            0      0       31           92
#>  2 all            0      1       13           92
#>  3 all            0      2       24           92
#>  4 all            0      3       23           92
#>  5 all            0      4       15           92
#>  6 all            0      5       12           92
#>  7 all            0      6       12           92
#>  8 all            0      7       11           92
#>  9 all            0      8        7           92
#> 10 all            0      9        8           92
#> # ℹ 7,173 more rows
get_polymod_contact_data(contact_age_imputation = "sample")
#> # A tibble: 8,787 × 5
#>    setting age_from age_to contacts participants
#>    <chr>      <int>  <dbl>    <int>        <int>
#>  1 all            0      0       31           92
#>  2 all            0      1       11           92
#>  3 all            0      2       27           92
#>  4 all            0      3       23           92
#>  5 all            0      4       14           92
#>  6 all            0      5       12           92
#>  7 all            0      6       12           92
#>  8 all            0      7       11           92
#>  9 all            0      8        7           92
#> 10 all            0      9        8           92
#> # ℹ 8,777 more rows
get_polymod_contact_data(contact_age_imputation = "mean")
#> # A tibble: 8,787 × 5
#>    setting age_from age_to contacts participants
#>    <chr>      <int>  <dbl>    <int>        <int>
#>  1 all            0      0       31           93
#>  2 all            0      1       11           93
#>  3 all            0      2       27           93
#>  4 all            0      3       23           93
#>  5 all            0      4       16           93
#>  6 all            0      5       12           93
#>  7 all            0      6       11           93
#>  8 all            0      7       12           93
#>  9 all            0      8        7           93
#> 10 all            0      9        8           93
#> # ℹ 8,777 more rows
get_polymod_contact_data(contact_age_imputation = "remove_participant")
#> # A tibble: 8,686 × 5
#>    setting age_from age_to contacts participants
#>    <chr>      <int>  <dbl>    <int>        <int>
#>  1 all            0      0        1           36
#>  2 all            0      1        6           36
#>  3 all            0      2        3           36
#>  4 all            0      3        8           36
#>  5 all            0      4        4           36
#>  6 all            0      5        2           36
#>  7 all            0      6        5           36
#>  8 all            0      7        3           36
#>  9 all            0      8        3           36
#> 10 all            0      9        7           36
#> # ℹ 8,676 more rows
```
