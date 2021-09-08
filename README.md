
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
#>  8.47  8.99  8.72 26.91  total = 57.09 
#> 
#> fREML score: 21320.73
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
#> (0,5]    2.8387722 1.0291399 0.2766605 0.2582548 0.4673199 0.8607626 1.1324254
#> (5,10]   1.1027879 6.5918305 1.7022629 0.3180853 0.3058273 0.6160043 1.1550551
#> (10,15]  0.1925808 1.5161902 8.9568307 1.7614264 0.3427358 0.3689053 0.6796273
#> (15,20]  0.2067563 0.2656924 1.5870361 7.1302881 1.7126047 0.5498011 0.5734214
#> (20,25]  0.4103813 0.3408718 0.4150785 1.3349894 4.3899689 1.7343698 0.8973743
#> (25,30]  0.5434867 0.5460849 0.5628812 0.6367940 1.2441145 2.5412448 1.6622709
#> (30,35]  0.5969379 0.6551239 0.7026815 0.7595968 0.9665956 1.4998645 1.9802917
#> (35,40]  0.5780246 0.7693147 0.8118168 0.7780390 0.9165501 1.3669307 1.9184786
#> (40,45]  0.4301753 0.7026771 0.9267940 0.8774864 0.8022278 0.9809561 1.4866996
#> (45,50]  0.3243483 0.4741949 0.7897537 1.0080874 0.9815700 0.8934353 0.9696484
#> (50,55]  0.3294093 0.3437650 0.4947814 0.7851300 1.0982593 1.2033965 1.0735152
#> (55,60]  0.3385500 0.3545522 0.3600630 0.4502575 0.7097266 1.0920838 1.2608708
#> (60,65]  0.2417539 0.3611124 0.3664234 0.3309798 0.3830132 0.5793879 0.8553854
#> (65,70]  0.1473658 0.2515002 0.3323226 0.3307084 0.3241826 0.3787178 0.5041146
#> (70,75]  0.1478365 0.1639064 0.2014733 0.2475571 0.3010236 0.3662981 0.4440453
#> (75,Inf] 0.3245195 0.2804384 0.1991063 0.1883691 0.2050154 0.2181980 0.2673790
#>            (35,40]   (40,45]   (45,50]   (50,55]   (55,60]   (60,65]   (65,70]
#> (0,5]    0.9552600 0.6390436 0.4456603 0.3744931 0.3582693 0.3288140 0.2486246
#> (5,10]   1.3336289 0.9624858 0.5699823 0.3559197 0.2612384 0.2196554 0.1884797
#> (10,15]  1.0784071 1.0711483 0.7211896 0.4081841 0.2340800 0.1646249 0.1434159
#> (15,20]  0.8249342 1.0218337 0.9047085 0.5912142 0.3176323 0.1751825 0.1245482
#> (20,25]  0.8562710 0.9449718 0.9473909 0.7698155 0.4811831 0.2515074 0.1370806
#> (25,30]  1.1390654 1.0003106 0.9509885 0.8492645 0.6364532 0.3836608 0.1965379
#> (30,35]  1.6178609 1.1819454 0.9506992 0.8360281 0.7175589 0.5379405 0.3230852
#> (35,40]  1.9494570 1.5564974 1.0602469 0.7534618 0.6148783 0.5454211 0.4415471
#> (40,45]  1.9795761 1.9252104 1.3866023 0.8108277 0.4844507 0.3730961 0.3614958
#> (45,50]  1.2904495 1.7086806 1.7568914 1.1707384 0.5748772 0.2981193 0.2300626
#> (50,55]  0.9728859 1.1142105 1.4548587 1.5184069 0.9507324 0.4350471 0.2239421
#> (55,60]  1.0869700 0.9228473 1.0153581 1.2750815 1.2278089 0.7313072 0.3438039
#> (60,65]  0.9554479 0.8424986 0.7666870 0.8646785 1.0214677 0.9628341 0.5433552
#> (65,70]  0.6348106 0.6667910 0.6151115 0.5918359 0.6493292 0.7851859 0.8347522
#> (70,75]  0.5264638 0.5931428 0.5894058 0.5139512 0.4360879 0.4436669 0.6266410
#> (75,Inf] 0.3302775 0.3886436 0.4378567 0.4264760 0.3236279 0.2193879 0.1973210
#>             (70,75]  (75,Inf]
#> (0,5]    0.14704605 0.1049286
#> (5,10]   0.13709648 0.1095918
#> (10,15]  0.12541927 0.1306944
#> (15,20]  0.10906374 0.1631139
#> (20,25]  0.09532569 0.1597412
#> (25,30]  0.10280303 0.1450217
#> (30,35]  0.16132677 0.1690348
#> (35,40]  0.27435052 0.2580466
#> (40,45]  0.32374804 0.3951356
#> (45,50]  0.23800736 0.4648687
#> (50,55]  0.17226567 0.4199305
#> (55,60]  0.18431554 0.3440122
#> (60,65]  0.25442877 0.3050598
#> (65,70]  0.42224429 0.3387405
#> (70,75]  0.86342434 0.5711846
#> (75,Inf] 0.33164046 1.1493523
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
#> (0,5]    2.8387722 1.0291399 0.2766605 0.2582548 0.4673199 0.8607626 1.1324254
#> (5,10]   1.1027879 6.5918305 1.7022629 0.3180853 0.3058273 0.6160043 1.1550551
#> (10,15]  0.1925808 1.5161902 8.9568307 1.7614264 0.3427358 0.3689053 0.6796273
#> (15,20]  0.2067563 0.2656924 1.5870361 7.1302881 1.7126047 0.5498011 0.5734214
#> (20,25]  0.4103813 0.3408718 0.4150785 1.3349894 4.3899689 1.7343698 0.8973743
#> (25,30]  0.5434867 0.5460849 0.5628812 0.6367940 1.2441145 2.5412448 1.6622709
#> (30,35]  0.5969379 0.6551239 0.7026815 0.7595968 0.9665956 1.4998645 1.9802917
#> (35,40]  0.5780246 0.7693147 0.8118168 0.7780390 0.9165501 1.3669307 1.9184786
#> (40,45]  0.4301753 0.7026771 0.9267940 0.8774864 0.8022278 0.9809561 1.4866996
#> (45,50]  0.3243483 0.4741949 0.7897537 1.0080874 0.9815700 0.8934353 0.9696484
#> (50,55]  0.3294093 0.3437650 0.4947814 0.7851300 1.0982593 1.2033965 1.0735152
#> (55,60]  0.3385500 0.3545522 0.3600630 0.4502575 0.7097266 1.0920838 1.2608708
#> (60,65]  0.2417539 0.3611124 0.3664234 0.3309798 0.3830132 0.5793879 0.8553854
#> (65,70]  0.1473658 0.2515002 0.3323226 0.3307084 0.3241826 0.3787178 0.5041146
#> (70,75]  0.1478365 0.1639064 0.2014733 0.2475571 0.3010236 0.3662981 0.4440453
#> (75,Inf] 0.3245195 0.2804384 0.1991063 0.1883691 0.2050154 0.2181980 0.2673790
#>            (35,40]   (40,45]   (45,50]   (50,55]   (55,60]   (60,65]   (65,70]
#> (0,5]    0.9552600 0.6390436 0.4456603 0.3744931 0.3582693 0.3288140 0.2486246
#> (5,10]   1.3336289 0.9624858 0.5699823 0.3559197 0.2612384 0.2196554 0.1884797
#> (10,15]  1.0784071 1.0711483 0.7211896 0.4081841 0.2340800 0.1646249 0.1434159
#> (15,20]  0.8249342 1.0218337 0.9047085 0.5912142 0.3176323 0.1751825 0.1245482
#> (20,25]  0.8562710 0.9449718 0.9473909 0.7698155 0.4811831 0.2515074 0.1370806
#> (25,30]  1.1390654 1.0003106 0.9509885 0.8492645 0.6364532 0.3836608 0.1965379
#> (30,35]  1.6178609 1.1819454 0.9506992 0.8360281 0.7175589 0.5379405 0.3230852
#> (35,40]  1.9494570 1.5564974 1.0602469 0.7534618 0.6148783 0.5454211 0.4415471
#> (40,45]  1.9795761 1.9252104 1.3866023 0.8108277 0.4844507 0.3730961 0.3614958
#> (45,50]  1.2904495 1.7086806 1.7568914 1.1707384 0.5748772 0.2981193 0.2300626
#> (50,55]  0.9728859 1.1142105 1.4548587 1.5184069 0.9507324 0.4350471 0.2239421
#> (55,60]  1.0869700 0.9228473 1.0153581 1.2750815 1.2278089 0.7313072 0.3438039
#> (60,65]  0.9554479 0.8424986 0.7666870 0.8646785 1.0214677 0.9628341 0.5433552
#> (65,70]  0.6348106 0.6667910 0.6151115 0.5918359 0.6493292 0.7851859 0.8347522
#> (70,75]  0.5264638 0.5931428 0.5894058 0.5139512 0.4360879 0.4436669 0.6266410
#> (75,Inf] 0.3302775 0.3886436 0.4378567 0.4264760 0.3236279 0.2193879 0.1973210
#>             (70,75]  (75,Inf]
#> (0,5]    0.14704605 0.1049286
#> (5,10]   0.13709648 0.1095918
#> (10,15]  0.12541927 0.1306944
#> (15,20]  0.10906374 0.1631139
#> (20,25]  0.09532569 0.1597412
#> (25,30]  0.10280303 0.1450217
#> (30,35]  0.16132677 0.1690348
#> (35,40]  0.27435052 0.2580466
#> (40,45]  0.32374804 0.3951356
#> (45,50]  0.23800736 0.4648687
#> (50,55]  0.17226567 0.4199305
#> (55,60]  0.18431554 0.3440122
#> (60,65]  0.25442877 0.3050598
#> (65,70]  0.42224429 0.3387405
#> (70,75]  0.86342434 0.5711846
#> (75,Inf] 0.33164046 1.1493523

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
#>  7  2006 QLD   Aboriginal and Torres Strait Islander            4               37
#>  8  2006 QLD   Non-Indigenous                                   4              740
#>  9  2006 SA    Aboriginal and Torres Strait Islander            4               42
#> 10  2006 SA    Non-Indigenous                                   4             1023
#> # … with 4,184 more rows
```

### abs_education_state_2020

``` r
abs_education_state_2020
#> # A tibble: 808 × 6
#>     year state   age population population_interpolated  prop
#>    <dbl> <chr> <dbl>      <dbl>                   <dbl> <dbl>
#>  1  2020 ACT       0          0                   5569. 0    
#>  2  2020 ACT       1          0                   5702. 0    
#>  3  2020 ACT       2          0                   5781. 0    
#>  4  2020 ACT       3          0                   5814. 0    
#>  5  2020 ACT       4          0                   5809. 0    
#>  6  2020 ACT       5       4558                   5772. 0.790
#>  7  2020 ACT       6       6161                   5710. 1.08 
#>  8  2020 ACT       7       6163                   5623. 1.10 
#>  9  2020 ACT       8       5881                   5510. 1.07 
#> 10  2020 ACT       9       5921                   5370. 1.10 
#> # … with 798 more rows
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
