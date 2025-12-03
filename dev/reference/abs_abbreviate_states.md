# Abbreviate Australian State Names

Given a full name (Title Case) of an Australian State or Territory,
produces the abbreviated state name.

## Usage

``` r
abs_abbreviate_states(state_names)
```

## Arguments

- state_names:

  vector of state names in long form

## Value

shortened state names

## See also

[`abs_unabbreviate_states()`](https://idem-lab.github.io/conmat/dev/reference/abs_unabbreviate_states.md)

## Examples

``` r
abs_abbreviate_states("Victoria")
#> [1] "VIC"
abs_abbreviate_states(c("Victoria", "Queensland"))
#> [1] "VIC" "QLD"
```
