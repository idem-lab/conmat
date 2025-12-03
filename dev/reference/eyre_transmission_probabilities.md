# Transmission probabilities of COVID19 from Eyre et al.

A dataset containing data digitised from "The impact of SARS-CoV-2
vaccination on Alpha & Delta variant transmission", by David W Eyre,
Donald Taylor, Mark Purver, David Chapman, Tom Fowler, Koen B Pouwels, A
Sarah Walker, Tim EA Peto
([doi:10.1101/2021.09.28.21264260](https://doi.org/10.1101/2021.09.28.21264260)
. The figures were taken from
<https://www.medrxiv.org/content/10.1101/2021.09.28.21264260v1.full-text>,
and the code to digitise these figures is in `data-raw` under
"read_eyre_transmission_probabilities.R". When using this data, ensure
that you cite the original authors at 'Eyre, D. W., Taylor, D., Purver,
M., Chapman, D., Fowler, T., Pouwels, K. B., Walker, A. S., & Peto, T.
E. (2021). The impact of SARS-CoV-2 vaccination on Alpha & Delta variant
transmission (Preprint). Infectious Diseases (except HIV/AIDS).
https://doi.org/10.1101/2021.09.28.21264260'

## Usage

``` r
eyre_transmission_probabilities
```

## Format

A data frame of the probability of transmission from a case to a
contact. There are 40,804 rows and 6 variables.

- setting:

  "household", "household_visitor", "work_education", or
  "events_activities"

- case_age:

  from 0 to 100

- contact_age:

  from ages 0 to 100

- case_age_5y:

  If case is between ages 0-4, in 5 year bins up to 100

- contact_age_5y:

  If contact is between ages 0-4, in 5 year bins up to 100

- probability:

  probability of transmission. Value is 0 - 1

## Examples

``` r
eyre_transmission_probabilities
#> # A tibble: 40,804 × 6
#>    setting   case_age contact_age case_age_5y contact_age_5y probability
#>    <chr>        <int>       <int> <chr>       <chr>                <dbl>
#>  1 household        0           0 0-4         0-4                  0.195
#>  2 household        0           1 0-4         0-4                  0.195
#>  3 household        0           2 0-4         0-4                  0.195
#>  4 household        0           3 0-4         0-4                  0.195
#>  5 household        0           4 0-4         0-4                  0.195
#>  6 household        0           5 0-4         5-9                  0.196
#>  7 household        0           6 0-4         5-9                  0.198
#>  8 household        0           7 0-4         5-9                  0.198
#>  9 household        0           8 0-4         5-9                  0.199
#> 10 household        0           9 0-4         5-9                  0.201
#> # ℹ 40,794 more rows
if (interactive()) {

# plot this
library(ggplot2)
library(stringr)
library(dplyr)
plot_eyre_transmission_probabilities <- eyre_transmission_probabilities %>%
  group_by(
    setting,
    case_age_5y,
    contact_age_5y
  ) %>%
  summarise(
    across(
      probability,
      mean
    ),
    .groups = "drop"
  ) %>%
  rename(
    case_age = case_age_5y,
    contact_age = contact_age_5y
  ) %>%
  mutate(
    across(
      ends_with("age"),
      ~ factor(.x,
        levels = str_sort(
          unique(.x),
          numeric = TRUE
        )
      )
    )
  )

  plot_eyre_transmission_probabilities

  ggplot(
    plot_eyre_transmission_probabilities,
    aes(
      x = case_age,
      y = contact_age,
      fill = probability
    )
  ) +
  facet_wrap(~setting) +
  geom_tile() +
  scale_fill_viridis_c() +
  coord_fixed() +
  theme_minimal() +
  theme(
    axis.text = element_text(angle = 45, hjust = 1)
  )
}
```
