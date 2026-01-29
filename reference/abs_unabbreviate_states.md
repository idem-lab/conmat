# Un-abbreviate Australian state names

Un-abbreviate Australian state names

## Usage

``` r
abs_unabbreviate_states(state_names)
```

## Arguments

- state_names:

  vector of state names in short form

## Value

Longer state names

## See also

[`abs_abbreviate_states()`](https://idem-lab.github.io/conmat/reference/abs_abbreviate_states.md)

## Examples

``` r
abs_unabbreviate_states("VIC")
#> [1] "Victoria"
abs_unabbreviate_states(c("VIC", "QLD"))
#> [1] "Victoria"   "Queensland"
```
