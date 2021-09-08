
<!-- README.md is generated from README.Rmd. Please edit that file -->

# conmat

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/njtierney/conmat/branch/master/graph/badge.svg)](https://codecov.io/gh/njtierney/conmat?branch=master)
[![R-CMD-check](https://github.com/njtierney/conmat/workflows/R-CMD-check/badge.svg)](https://github.com/njtierney/conmat/actions)
<!-- badges: end -->

The goal of conmat is to provide methods for producing contact matrices.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("njtierney/conmat")
```

## Example

``` r
library(conmat)
# build synthetic age-structured contact matrices with GAMs
# analysis of polymod data

# set age breaks
age_breaks_5y <- c(seq(0, 75, by = 5), Inf)
age_breaks_1y <- c(seq(0, 100, by = 1), Inf)

# fit a single overall contact model to polymod
m_all <- fit_single_contact_model(
  contact_data = get_polymod_contact_data("all"),
  population = get_polymod_population()
)

m_all
#> 
#> Family: poisson 
#> Link function: log 
#> 
#> Formula:
#> contacts ~ stats::offset(log(pop_age_to)) + s(age_to) + s(age_from) + 
#>     s(abs(age_from - age_to)) + s(abs(age_from - age_to), age_from) + 
#>     school_probability + work_probability
#> 
#> Estimated degrees of freedom:
#>  8.53  8.99  8.71 26.91  total = 57.14 
#> 
#> fREML score: 21570.15
```

``` r
# predict contacts at 1y and 5y resolutions for inspection
synthetic_all_5y <- predict_contacts(
  model = m_all, 
  population = get_polymod_population(),
  age_breaks = age_breaks_5y
) %>%
  predictions_to_matrix()

synthetic_all_5y
#>              (0,5]    (5,10]   (10,15]   (15,20]   (20,25]   (25,30]   (30,35]
#> (0,5]    2.8400017 1.0305551 0.2771485 0.2586028 0.4682234 0.8622457 1.1307316
#> (5,10]   1.1049150 6.5930048 1.7052086 0.3195251 0.3066997 0.6161558 1.1509901
#> (10,15]  0.1934966 1.5175429 8.9507856 1.7620614 0.3435061 0.3695499 0.6776167
#> (15,20]  0.2072856 0.2662766 1.5873190 7.1215999 1.7112340 0.5502392 0.5731694
#> (20,25]  0.4106011 0.3406150 0.4142480 1.3336175 4.4007555 1.7349729 0.8952530
#> (25,30]  0.5442477 0.5453194 0.5609802 0.6337094 1.2434185 2.5572372 1.6595262
#> (30,35]  0.5982771 0.6555846 0.7018351 0.7562980 0.9611144 1.4996345 1.9971372
#> (35,40]  0.5787506 0.7702701 0.8138874 0.7786628 0.9137200 1.3601930 1.9196323
#> (40,45]  0.4303399 0.7019076 0.9291836 0.8819765 0.8047492 0.9784541 1.4778175
#> (45,50]  0.3250665 0.4720926 0.7884972 1.0123399 0.9885040 0.8962693 0.9647952
#> (50,55]  0.3313535 0.3425054 0.4916445 0.7843867 1.1049916 1.2120966 1.0739637
#> (55,60]  0.3409113 0.3547422 0.3579512 0.4474676 0.7105624 1.1002061 1.2677977
#> (60,65]  0.2429733 0.3613740 0.3650872 0.3283990 0.3807830 0.5806635 0.8614147
#> (65,70]  0.1480291 0.2510481 0.3304551 0.3277160 0.3204505 0.3759066 0.5051290
#> (70,75]  0.1485989 0.1640390 0.2001622 0.2449400 0.2969237 0.3612944 0.4410055
#> (75,Inf] 0.3228251 0.2808426 0.2006601 0.1839990 0.1981417 0.2144704 0.2637568
#>            (35,40]   (40,45]   (45,50]   (50,55]   (55,60]   (60,65]   (65,70]
#> (0,5]    0.9507827 0.6370588 0.4472639 0.3772091 0.3603341 0.3285919 0.2473282
#> (5,10]   1.3259923 0.9599481 0.5739176 0.3618817 0.2661325 0.2205040 0.1856905
#> (10,15]  1.0706135 1.0641329 0.7224776 0.4146986 0.2411036 0.1685185 0.1429262
#> (15,20]  0.8214307 1.0153883 0.9019346 0.5950213 0.3250631 0.1808926 0.1268158
#> (20,25]  0.8537020 0.9416812 0.9450519 0.7706829 0.4866034 0.2568070 0.1400457
#> (25,30]  1.1308788 0.9943927 0.9483257 0.8492741 0.6399577 0.3867933 0.1980593
#> (30,35]  1.6129444 1.1703893 0.9441318 0.8344348 0.7206210 0.5399995 0.3223430
#> (35,40]  1.9703451 1.5542229 1.0512992 0.7492299 0.6166749 0.5478692 0.4401585
#> (40,45]  1.9794686 1.9451941 1.3865118 0.8051543 0.4836396 0.3742031 0.3611006
#> (45,50]  1.2791697 1.7048211 1.7708226 1.1698579 0.5723167 0.2970899 0.2290566
#> (50,55]  0.9647996 1.1026374 1.4515925 1.5301178 0.9530919 0.4325715 0.2212486
#> (55,60]  1.0839276 0.9132633 1.0057741 1.2762303 1.2457953 0.7344729 0.3395190
#> (60,65]  0.9590433 0.8382033 0.7576763 0.8567602 1.0281427 0.9804556 0.5436785
#> (65,70]  0.6401884 0.6705785 0.6122786 0.5839702 0.6439409 0.7891666 0.8464342
#> (70,75]  0.5298549 0.6032132 0.5982994 0.5147717 0.4322642 0.4388495 0.6251691
#> (75,Inf] 0.3278652 0.3918136 0.4478015 0.4369424 0.3286606 0.2187241 0.1936040
#>             (70,75]  (75,Inf]
#> (0,5]    0.14594039 0.1022311
#> (5,10]   0.13482777 0.1097128
#> (10,15]  0.12233332 0.1292273
#> (15,20]  0.10806307 0.1598418
#> (20,25]  0.09633395 0.1576916
#> (25,30]  0.10384229 0.1452318
#> (30,35]  0.16098681 0.1700390
#> (35,40]  0.27212732 0.2579629
#> (40,45]  0.32170684 0.3926875
#> (45,50]  0.23696402 0.4617110
#> (50,55]  0.17064588 0.4174007
#> (55,60]  0.18116418 0.3414115
#> (60,65]  0.25026245 0.3012546
#> (65,70]  0.42113690 0.3335910
#> (70,75]  0.86946503 0.5661322
#> (75,Inf] 0.32688638 1.1371280
```

``` r
set.seed(2021-09-08)
# predict contacts at 1y and 5y resolutions for inspection
synthetic_all_5y <- predict_contacts(
  model = m_all, 
  population = get_polymod_population(),
  age_breaks = age_breaks_5y
) %>%
  predictions_to_matrix()

synthetic_all_5y
#>              (0,5]    (5,10]   (10,15]   (15,20]   (20,25]   (25,30]   (30,35]
#> (0,5]    2.8400017 1.0305551 0.2771485 0.2586028 0.4682234 0.8622457 1.1307316
#> (5,10]   1.1049150 6.5930048 1.7052086 0.3195251 0.3066997 0.6161558 1.1509901
#> (10,15]  0.1934966 1.5175429 8.9507856 1.7620614 0.3435061 0.3695499 0.6776167
#> (15,20]  0.2072856 0.2662766 1.5873190 7.1215999 1.7112340 0.5502392 0.5731694
#> (20,25]  0.4106011 0.3406150 0.4142480 1.3336175 4.4007555 1.7349729 0.8952530
#> (25,30]  0.5442477 0.5453194 0.5609802 0.6337094 1.2434185 2.5572372 1.6595262
#> (30,35]  0.5982771 0.6555846 0.7018351 0.7562980 0.9611144 1.4996345 1.9971372
#> (35,40]  0.5787506 0.7702701 0.8138874 0.7786628 0.9137200 1.3601930 1.9196323
#> (40,45]  0.4303399 0.7019076 0.9291836 0.8819765 0.8047492 0.9784541 1.4778175
#> (45,50]  0.3250665 0.4720926 0.7884972 1.0123399 0.9885040 0.8962693 0.9647952
#> (50,55]  0.3313535 0.3425054 0.4916445 0.7843867 1.1049916 1.2120966 1.0739637
#> (55,60]  0.3409113 0.3547422 0.3579512 0.4474676 0.7105624 1.1002061 1.2677977
#> (60,65]  0.2429733 0.3613740 0.3650872 0.3283990 0.3807830 0.5806635 0.8614147
#> (65,70]  0.1480291 0.2510481 0.3304551 0.3277160 0.3204505 0.3759066 0.5051290
#> (70,75]  0.1485989 0.1640390 0.2001622 0.2449400 0.2969237 0.3612944 0.4410055
#> (75,Inf] 0.3228251 0.2808426 0.2006601 0.1839990 0.1981417 0.2144704 0.2637568
#>            (35,40]   (40,45]   (45,50]   (50,55]   (55,60]   (60,65]   (65,70]
#> (0,5]    0.9507827 0.6370588 0.4472639 0.3772091 0.3603341 0.3285919 0.2473282
#> (5,10]   1.3259923 0.9599481 0.5739176 0.3618817 0.2661325 0.2205040 0.1856905
#> (10,15]  1.0706135 1.0641329 0.7224776 0.4146986 0.2411036 0.1685185 0.1429262
#> (15,20]  0.8214307 1.0153883 0.9019346 0.5950213 0.3250631 0.1808926 0.1268158
#> (20,25]  0.8537020 0.9416812 0.9450519 0.7706829 0.4866034 0.2568070 0.1400457
#> (25,30]  1.1308788 0.9943927 0.9483257 0.8492741 0.6399577 0.3867933 0.1980593
#> (30,35]  1.6129444 1.1703893 0.9441318 0.8344348 0.7206210 0.5399995 0.3223430
#> (35,40]  1.9703451 1.5542229 1.0512992 0.7492299 0.6166749 0.5478692 0.4401585
#> (40,45]  1.9794686 1.9451941 1.3865118 0.8051543 0.4836396 0.3742031 0.3611006
#> (45,50]  1.2791697 1.7048211 1.7708226 1.1698579 0.5723167 0.2970899 0.2290566
#> (50,55]  0.9647996 1.1026374 1.4515925 1.5301178 0.9530919 0.4325715 0.2212486
#> (55,60]  1.0839276 0.9132633 1.0057741 1.2762303 1.2457953 0.7344729 0.3395190
#> (60,65]  0.9590433 0.8382033 0.7576763 0.8567602 1.0281427 0.9804556 0.5436785
#> (65,70]  0.6401884 0.6705785 0.6122786 0.5839702 0.6439409 0.7891666 0.8464342
#> (70,75]  0.5298549 0.6032132 0.5982994 0.5147717 0.4322642 0.4388495 0.6251691
#> (75,Inf] 0.3278652 0.3918136 0.4478015 0.4369424 0.3286606 0.2187241 0.1936040
#>             (70,75]  (75,Inf]
#> (0,5]    0.14594039 0.1022311
#> (5,10]   0.13482777 0.1097128
#> (10,15]  0.12233332 0.1292273
#> (15,20]  0.10806307 0.1598418
#> (20,25]  0.09633395 0.1576916
#> (25,30]  0.10384229 0.1452318
#> (30,35]  0.16098681 0.1700390
#> (35,40]  0.27212732 0.2579629
#> (40,45]  0.32170684 0.3926875
#> (45,50]  0.23696402 0.4617110
#> (50,55]  0.17064588 0.4174007
#> (55,60]  0.18116418 0.3414115
#> (60,65]  0.25026245 0.3012546
#> (65,70]  0.42113690 0.3335910
#> (70,75]  0.86946503 0.5661322
#> (75,Inf] 0.32688638 1.1371280

library(ggplot2)
plot_matrix(synthetic_all_5y) +
  ggtitle("synthetic all at once")
```

<img src="man/figures/README-matrix-plot-1.png" width="100%" />

## Data sources

This package provides data for use in calculating contact matrices.

These data are still being cleaned and processed, but their current
forms are shown below:

### abs_education_state

``` r
abs_education_state
#> # A tibble: 4,194 × 5
#>     year state aboriginal_and_torres_strait_islander_status   age n_full_and_part…
#>    <dbl> <chr> <chr>                                        <dbl>            <dbl>
#>  1  2006 ACT   Aboriginal and Torres Strait Islander            4                5
#>  2  2006 ACT   Non-Indigenous                                   4              109
#>  3  2006 NSW   Aboriginal and Torres Strait Islander            4              104
#>  4  2006 NSW   Non-Indigenous                                   4             1870
#>  5  2006 NT    Aboriginal and Torres Strait Islander            4              102
#>  6  2006 NT    Non-Indigenous                                   4               63
#>  7  2006 Qld   Aboriginal and Torres Strait Islander            4               37
#>  8  2006 Qld   Non-Indigenous                                   4              740
#>  9  2006 SA    Aboriginal and Torres Strait Islander            4               42
#> 10  2006 SA    Non-Indigenous                                   4             1023
#> # … with 4,184 more rows
```

### abs_education_state_2020

``` r
abs_education_state_2020
#> # A tibble: 4,317 × 13
#>     year state sex   grade       age   n_full_time n_part_time n_full_and_part_…
#>    <dbl> <chr> <chr> <chr>       <chr>       <dbl>       <dbl>             <dbl>
#>  1  2020 NSW   Male  Pre-Year 1… 4-             38           0                38
#>  2  2020 NSW   Male  Pre-Year 1… 5            2007           0              2007
#>  3  2020 NSW   Male  Pre-Year 1… 6            1044           0              1044
#>  4  2020 NSW   Male  Pre-Year 1… 7              13           0                13
#>  5  2020 NSW   Male  Year 1      5              32           0                32
#>  6  2020 NSW   Male  Year 1      6            1994           0              1994
#>  7  2020 NSW   Male  Year 1      7            1117           0              1117
#>  8  2020 NSW   Male  Year 1      8              10           0                10
#>  9  2020 NSW   Male  Year 2      6              19           0                19
#> 10  2020 NSW   Male  Year 2      7            2041           0              2041
#> # … with 4,307 more rows, and 5 more variables: affiliation_gov_non_gov <chr>,
#> #   affiliation_gov_cath_ind <chr>,
#> #   aboriginal_and_torres_strait_islander_status <chr>, school_level <chr>,
#> #   anr_school_level <chr>
```

### abs_employ_age_lga

``` r
abs_employ_age_lga
#> # A tibble: 67,560 × 10
#>     year state lga   lga_code labour_force_st… age   males females persons  diff
#>    <dbl> <chr> <chr>    <dbl> <chr>            <fct> <dbl>   <dbl>   <dbl> <dbl>
#>  1  2016 New … Albu…    10050 Employed, worke… 15-19   236     113     348    -1
#>  2  2016 New … Armi…    10130 Employed, worke… 15-19   105      58     160    -3
#>  3  2016 New … Ball…    10250 Employed, worke… 15-19   115      53     168     0
#>  4  2016 New … Balr…    10300 Employed, worke… 15-19    11       5      15    -1
#>  5  2016 New … Bath…    10470 Employed, worke… 15-19   167      75     242     0
#>  6  2016 New … Bega…    10550 Employed, worke… 15-19   139      66     206     1
#>  7  2016 New … Bell…    10600 Employed, worke… 15-19    41       4      49     4
#>  8  2016 New … Berr…    10650 Employed, worke… 15-19    39      14      56     3
#>  9  2016 New … Blac…    10750 Employed, worke… 15-19  1110     637    1745    -2
#> 10  2016 New … Blan…    10800 Employed, worke… 15-19    36      10      44    -2
#> # … with 67,550 more rows
```

### abs_household_lga

``` r
abs_household_lga
#> # A tibble: 4,986 × 6
#>     year state           lga_name household_compo… n_persons_usual… n_households
#>    <dbl> <chr>           <chr>    <chr>            <chr>                   <dbl>
#>  1  2016 New South Wales Albury … Total Households total                   19495
#>  2  2016 New South Wales Albury … Total Households 1                        6020
#>  3  2016 New South Wales Albury … Total Households 2                        6738
#>  4  2016 New South Wales Albury … Total Households 3                        2740
#>  5  2016 New South Wales Albury … Total Households 4                        2541
#>  6  2016 New South Wales Albury … Total Households 5                        1041
#>  7  2016 New South Wales Albury … Total Households 6                         311
#>  8  2016 New South Wales Albury … Total Households 7                          56
#>  9  2016 New South Wales Albury … Total Households 8+                         42
#> 10  2016 New South Wales Armidal… Total Households total                   10276
#> # … with 4,976 more rows
```

### abs_pop_age_lga_2016

``` r
abs_pop_age_lga_2016
#> # A tibble: 9,918 × 6
#>     year state           lga_code lga_name   age   population
#>    <dbl> <chr>              <dbl> <chr>      <chr>      <dbl>
#>  1  2016 New South Wales    10050 Albury (C) 0-4         3505
#>  2  2016 New South Wales    10050 Albury (C) 5-9         3279
#>  3  2016 New South Wales    10050 Albury (C) 10-14       3228
#>  4  2016 New South Wales    10050 Albury (C) 15-19       3381
#>  5  2016 New South Wales    10050 Albury (C) 20-24       3744
#>  6  2016 New South Wales    10050 Albury (C) 25-29       3485
#>  7  2016 New South Wales    10050 Albury (C) 30-34       3400
#>  8  2016 New South Wales    10050 Albury (C) 35-39       3143
#>  9  2016 New South Wales    10050 Albury (C) 40-44       3206
#> 10  2016 New South Wales    10050 Albury (C) 45-49       3330
#> # … with 9,908 more rows
```

### abs_pop_age_lga_2020

``` r
abs_pop_age_lga_2020
#> # A tibble: 9,900 × 6
#>     year state           lga_code lga_name   age   population
#>    <dbl> <chr>              <dbl> <chr>      <chr>      <dbl>
#>  1  2020 New South Wales    10050 Albury (C) 0-4         3764
#>  2  2020 New South Wales    10050 Albury (C) 5-9         3614
#>  3  2020 New South Wales    10050 Albury (C) 10-14       3369
#>  4  2020 New South Wales    10050 Albury (C) 15-19       3334
#>  5  2020 New South Wales    10050 Albury (C) 20-24       3603
#>  6  2020 New South Wales    10050 Albury (C) 25-29       3736
#>  7  2020 New South Wales    10050 Albury (C) 30-34       3443
#>  8  2020 New South Wales    10050 Albury (C) 35-39       3371
#>  9  2020 New South Wales    10050 Albury (C) 40-44       3187
#> 10  2020 New South Wales    10050 Albury (C) 45-49       3449
#> # … with 9,890 more rows
```

### abs_state_age

``` r
abs_state_age
#> # A tibble: 168 × 3
#>    age_group state                        population
#>    <chr>     <chr>                             <dbl>
#>  1 0–4       New South Wales                  495060
#>  2 0–4       Victoria                         401992
#>  3 0–4       Queensland                       314592
#>  4 0–4       South Australia                   98400
#>  5 0–4       Western Australia                171531
#>  6 0–4       Tasmania                          29258
#>  7 0–4       Northern Territory                17766
#>  8 0–4       Australian Capital Territory      27846
#>  9 5–9       New South Wales                  512687
#> 10 5–9       Victoria                         416633
#> # … with 158 more rows
```

## Code of Conduct

Please note that the conmat project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
