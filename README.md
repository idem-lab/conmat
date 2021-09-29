
<!-- README.md is generated from README.Rmd. Please edit that file -->

# conmat

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/njtierney/conmat/branch/master/graph/badge.svg)](https://codecov.io/gh/njtierney/conmat?branch=master)
[![R-CMD-check](https://github.com/njtierney/conmat/workflows/R-CMD-check/badge.svg)](https://github.com/njtierney/conmat/actions)
<!-- badges: end -->

The goal of conmat is to provide methods for producing contact matrices.

## Installation

You can install the development version with:

``` r
install.packages("conmat", repos = "https://njtierney.r-universe.dev")
```

Or alternatively you can use `remotes` (although I recommend using the
above code)

``` r
# install.packages("remotes")
remotes::install_github("njtierney/conmat")
```

## Example

We can extract out the ABS age population data using `abs_age_lga` like
so:

``` r
library(conmat)
fairfield_age_pop <- abs_age_lga("Fairfield (C)")
fairfield_age_pop
#> # A tibble: 18 × 4
#>    lga           lower.age.limit  year population
#>    <chr>                   <dbl> <dbl>      <dbl>
#>  1 Fairfield (C)               0  2020      12261
#>  2 Fairfield (C)               5  2020      13093
#>  3 Fairfield (C)              10  2020      13602
#>  4 Fairfield (C)              15  2020      14323
#>  5 Fairfield (C)              20  2020      15932
#>  6 Fairfield (C)              25  2020      16190
#>  7 Fairfield (C)              30  2020      14134
#>  8 Fairfield (C)              35  2020      13034
#>  9 Fairfield (C)              40  2020      12217
#> 10 Fairfield (C)              45  2020      13449
#> 11 Fairfield (C)              50  2020      13419
#> 12 Fairfield (C)              55  2020      13652
#> 13 Fairfield (C)              60  2020      12907
#> 14 Fairfield (C)              65  2020      10541
#> 15 Fairfield (C)              70  2020       8227
#> 16 Fairfield (C)              75  2020       5598
#> 17 Fairfield (C)              80  2020       4006
#> 18 Fairfield (C)              85  2020       4240
```

Note that you need to use the exact LGA name - you can look up LGA names
in the data set `abs_lga_lookup`:

``` r
abs_lga_lookup
#> # A tibble: 545 × 3
#>    state lga_code lga                  
#>    <chr>    <dbl> <chr>                
#>  1 NSW      10050 Albury (C)           
#>  2 NSW      10180 Armidale Regional (A)
#>  3 NSW      10250 Ballina (A)          
#>  4 NSW      10300 Balranald (A)        
#>  5 NSW      10470 Bathurst Regional (A)
#>  6 NSW      10500 Bayside (A)          
#>  7 NSW      10550 Bega Valley (A)      
#>  8 NSW      10600 Bellingen (A)        
#>  9 NSW      10650 Berrigan (A)         
#> 10 NSW      10750 Blacktown (C)        
#> # … with 535 more rows
```

First we want to fit the model to the polymod data

``` r
set.seed(2021-09-24)
polymod_contact_data <- get_polymod_setting_data()
polymod_survey_data <- get_polymod_population()

setting_models <- fit_setting_contacts(
  contact_data_list = polymod_contact_data,
  population = polymod_survey_data
  )
```

Then we take this model and extrapolate to the fairfield data:

``` r
set.seed(2021-09-24)
synthetic_settings_5y_fairfield <- predict_setting_contacts(
  population = fairfield_age_pop,
  contact_model = setting_models,
  age_breaks = c(seq(0, 85, by = 5), Inf)
  )
```

``` r
# this code is erroring for the moment - something to do with rendering a large plot I think.
plot_setting_matrices(
  synthetic_settings_5y_fairfield,
  title = "Setting-specific synthetic contact matrices (fairfield 2020 projected)"
)
```

<img src="man/figures/README-fairfield-synth-5-plot-1.png" width="100%" />

``` r
set.seed(2021-09-24)
plot_matrix(synthetic_settings_5y_fairfield$home)
```

<img src="man/figures/README-plot-matrix-differents-1.png" width="100%" />

``` r
plot_matrix(synthetic_settings_5y_fairfield$work)
```

<img src="man/figures/README-plot-matrix-differents-2.png" width="100%" />

``` r
plot_matrix(synthetic_settings_5y_fairfield$school)
```

<img src="man/figures/README-plot-matrix-differents-3.png" width="100%" />

``` r
plot_matrix(synthetic_settings_5y_fairfield$other)
```

<img src="man/figures/README-plot-matrix-differents-4.png" width="100%" />

``` r
plot_matrix(synthetic_settings_5y_fairfield$all)
```

<img src="man/figures/README-plot-matrix-differents-5.png" width="100%" />

``` r
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
#> contacts ~ offset(log(pop_age_to)) + s(age_to) + s(age_from) + 
#>     s(abs(age_from - age_to)) + s(abs(age_from - age_to), age_from) + 
#>     school_probability + work_probability
#> 
#> Estimated degrees of freedom:
#>  8.67  8.99  8.68 26.91  total = 56.26 
#> 
#> fREML score: 22074.32
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
#>              [0,5)    [5,10)   [10,15)   [15,20)   [20,25)   [25,30)   [30,35)
#> [0,5)    2.2891737 0.9949687 0.2691132 0.2394117 0.4182412 0.7758830 1.0625373
#> [5,10)   0.9250158 5.9172474 1.6408940 0.3277472 0.2994007 0.5994652 1.1394165
#> [10,15)  0.1564236 1.4495157 8.6842279 1.7818410 0.3210659 0.3458876 0.6575636
#> [15,20)  0.1498034 0.2494135 1.6221258 7.7674864 1.6814767 0.4917967 0.5195025
#> [20,25)  0.3066034 0.2999524 0.3748132 1.3630679 4.9011663 1.7411600 0.8233086
#> [25,30)  0.4338632 0.5084420 0.5179072 0.5844292 1.2379027 2.7802984 1.6666857
#> [30,35)  0.4724034 0.6177384 0.6769786 0.7191672 0.8828595 1.4130443 2.0243651
#> [35,40)  0.4665727 0.7230177 0.7890517 0.7671371 0.8858053 1.2882586 1.8463474
#> [40,45)  0.3553404 0.6695318 0.9056751 0.8685303 0.7951551 0.9707911 1.4902907
#> [45,50)  0.2656129 0.4586718 0.7774093 0.9920817 0.9505373 0.8618402 0.9657264
#> [50,55)  0.2652696 0.3335625 0.4928810 0.7889709 1.0839066 1.1610205 1.0378091
#> [55,60)  0.2779783 0.3444442 0.3600289 0.4598311 0.7295451 1.1144280 1.2853488
#> [60,65)  0.2038195 0.3563334 0.3697974 0.3351314 0.3902712 0.6015204 0.9153784
#> [65,70)  0.1186364 0.2517017 0.3452473 0.3367333 0.3169853 0.3660394 0.5048739
#> [70,75)  0.1095165 0.1646628 0.2192171 0.2668296 0.3052080 0.3498869 0.4182720
#> [75,Inf) 0.2547570 0.2872322 0.2215026 0.1995964 0.2129546 0.2283466 0.2732799
#>            [35,40)   [40,45)   [45,50)   [50,55)   [55,60)   [60,65)   [65,70)
#> [0,5)    0.9493580 0.6519831 0.4556524 0.3867690 0.3724571 0.3435719 0.2757343
#> [5,10)   1.3675059 1.0083798 0.6044589 0.3922269 0.2915877 0.2394097 0.2107546
#> [10,15)  1.0913430 1.1090114 0.7530522 0.4433578 0.2602545 0.1778190 0.1544232
#> [15,20)  0.7947386 1.0283718 0.9226043 0.6221873 0.3410001 0.1850457 0.1336665
#> [20,25)  0.8055499 0.9242376 0.9518948 0.8024749 0.5101751 0.2631519 0.1482032
#> [25,30)  1.1071329 0.9817657 0.9472848 0.8778943 0.6672166 0.3948120 0.2087426
#> [30,35)  1.6236300 1.1736590 0.9576277 0.8745315 0.7542811 0.5484007 0.3355116
#> [35,40)  1.9568005 1.5709759 1.0801767 0.8051132 0.6709106 0.5785565 0.4687143
#> [40,45)  2.0138131 1.9411765 1.4120118 0.8682299 0.5396522 0.4115969 0.4011043
#> [45,50)  1.3375906 1.7651199 1.7811647 1.2241008 0.6206899 0.3198197 0.2524756
#> [50,55)  0.9711036 1.1306380 1.4758079 1.5786365 1.0054753 0.4498633 0.2354822
#> [55,60)  1.1132429 0.9341166 1.0190510 1.3232209 1.2972753 0.7627647 0.3639279
#> [60,65)  1.0417119 0.8990143 0.7911803 0.9062217 1.0812876 0.9943012 0.5826591
#> [65,70)  0.6669633 0.7071213 0.6420229 0.6265520 0.6927873 0.8141661 0.8601807
#> [70,75)  0.5098696 0.5861997 0.5892296 0.5352969 0.4683113 0.4718484 0.6575502
#> [75,Inf) 0.3364058 0.3946486 0.4475374 0.4600678 0.3668111 0.2486042 0.2217512
#>            [70,75)  [75,Inf)
#> [0,5)    0.1668769 0.1292756
#> [5,10)   0.1549106 0.1525056
#> [10,15)  0.1325375 0.1595105
#> [15,20)  0.1153000 0.1787327
#> [20,25)  0.1028265 0.1788953
#> [25,30)  0.1100376 0.1632014
#> [30,35)  0.1670185 0.1825263
#> [35,40)  0.2842698 0.2727809
#> [40,45)  0.3487355 0.4266697
#> [45,50)  0.2588026 0.5250746
#> [50,55)  0.1811590 0.4930047
#> [55,60)  0.1921257 0.4106243
#> [60,65)  0.2718940 0.3589770
#> [65,70)  0.4402282 0.3840373
#> [70,75)  0.8585981 0.6174334
#> [75,Inf) 0.3443620 1.2402697
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
#>              [0,5)    [5,10)   [10,15)   [15,20)   [20,25)   [25,30)   [30,35)
#> [0,5)    2.2891737 0.9949687 0.2691132 0.2394117 0.4182412 0.7758830 1.0625373
#> [5,10)   0.9250158 5.9172474 1.6408940 0.3277472 0.2994007 0.5994652 1.1394165
#> [10,15)  0.1564236 1.4495157 8.6842279 1.7818410 0.3210659 0.3458876 0.6575636
#> [15,20)  0.1498034 0.2494135 1.6221258 7.7674864 1.6814767 0.4917967 0.5195025
#> [20,25)  0.3066034 0.2999524 0.3748132 1.3630679 4.9011663 1.7411600 0.8233086
#> [25,30)  0.4338632 0.5084420 0.5179072 0.5844292 1.2379027 2.7802984 1.6666857
#> [30,35)  0.4724034 0.6177384 0.6769786 0.7191672 0.8828595 1.4130443 2.0243651
#> [35,40)  0.4665727 0.7230177 0.7890517 0.7671371 0.8858053 1.2882586 1.8463474
#> [40,45)  0.3553404 0.6695318 0.9056751 0.8685303 0.7951551 0.9707911 1.4902907
#> [45,50)  0.2656129 0.4586718 0.7774093 0.9920817 0.9505373 0.8618402 0.9657264
#> [50,55)  0.2652696 0.3335625 0.4928810 0.7889709 1.0839066 1.1610205 1.0378091
#> [55,60)  0.2779783 0.3444442 0.3600289 0.4598311 0.7295451 1.1144280 1.2853488
#> [60,65)  0.2038195 0.3563334 0.3697974 0.3351314 0.3902712 0.6015204 0.9153784
#> [65,70)  0.1186364 0.2517017 0.3452473 0.3367333 0.3169853 0.3660394 0.5048739
#> [70,75)  0.1095165 0.1646628 0.2192171 0.2668296 0.3052080 0.3498869 0.4182720
#> [75,Inf) 0.2547570 0.2872322 0.2215026 0.1995964 0.2129546 0.2283466 0.2732799
#>            [35,40)   [40,45)   [45,50)   [50,55)   [55,60)   [60,65)   [65,70)
#> [0,5)    0.9493580 0.6519831 0.4556524 0.3867690 0.3724571 0.3435719 0.2757343
#> [5,10)   1.3675059 1.0083798 0.6044589 0.3922269 0.2915877 0.2394097 0.2107546
#> [10,15)  1.0913430 1.1090114 0.7530522 0.4433578 0.2602545 0.1778190 0.1544232
#> [15,20)  0.7947386 1.0283718 0.9226043 0.6221873 0.3410001 0.1850457 0.1336665
#> [20,25)  0.8055499 0.9242376 0.9518948 0.8024749 0.5101751 0.2631519 0.1482032
#> [25,30)  1.1071329 0.9817657 0.9472848 0.8778943 0.6672166 0.3948120 0.2087426
#> [30,35)  1.6236300 1.1736590 0.9576277 0.8745315 0.7542811 0.5484007 0.3355116
#> [35,40)  1.9568005 1.5709759 1.0801767 0.8051132 0.6709106 0.5785565 0.4687143
#> [40,45)  2.0138131 1.9411765 1.4120118 0.8682299 0.5396522 0.4115969 0.4011043
#> [45,50)  1.3375906 1.7651199 1.7811647 1.2241008 0.6206899 0.3198197 0.2524756
#> [50,55)  0.9711036 1.1306380 1.4758079 1.5786365 1.0054753 0.4498633 0.2354822
#> [55,60)  1.1132429 0.9341166 1.0190510 1.3232209 1.2972753 0.7627647 0.3639279
#> [60,65)  1.0417119 0.8990143 0.7911803 0.9062217 1.0812876 0.9943012 0.5826591
#> [65,70)  0.6669633 0.7071213 0.6420229 0.6265520 0.6927873 0.8141661 0.8601807
#> [70,75)  0.5098696 0.5861997 0.5892296 0.5352969 0.4683113 0.4718484 0.6575502
#> [75,Inf) 0.3364058 0.3946486 0.4475374 0.4600678 0.3668111 0.2486042 0.2217512
#>            [70,75)  [75,Inf)
#> [0,5)    0.1668769 0.1292756
#> [5,10)   0.1549106 0.1525056
#> [10,15)  0.1325375 0.1595105
#> [15,20)  0.1153000 0.1787327
#> [20,25)  0.1028265 0.1788953
#> [25,30)  0.1100376 0.1632014
#> [30,35)  0.1670185 0.1825263
#> [35,40)  0.2842698 0.2727809
#> [40,45)  0.3487355 0.4266697
#> [45,50)  0.2588026 0.5250746
#> [50,55)  0.1811590 0.4930047
#> [55,60)  0.1921257 0.4106243
#> [60,65)  0.2718940 0.3589770
#> [65,70)  0.4402282 0.3840373
#> [70,75)  0.8585981 0.6174334
#> [75,Inf) 0.3443620 1.2402697

library(ggplot2)
plot_matrix(synthetic_all_5y) +
  ggtitle("synthetic all at once")
```

<img src="man/figures/README-matrix-plot-1.png" width="100%" />

## Speeding up computation with `future`

`conmat` now supports parallelisation, which is useful in a couple of
contexts with the model fitting, here is an example:

``` r
library(future)
plan(multisession, workers = 4)
```

We set the future plan, saying multisession, with 4 workers.

Then we run the code as normal:

``` r
polymod_setting_data <- get_polymod_setting_data()
polymod_population <- get_polymod_population()

contact_model <- fit_setting_contacts(
  contact_data_list = polymod_setting_data,
  population = polymod_population
)

contact_model_pred <- predict_setting_contacts(
  population = polymod_population,
  contact_model = contact_model,
  age_breaks = c(seq(0, 75, by = 5), Inf)
)
```

Notably this is about 3 times faster than without using that plan.

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
#> # A tibble: 5,600 × 8
#>     year state lga    age_group total_employed total_unemployed total_labour_fo…
#>    <dbl> <chr> <chr>  <fct>              <dbl>            <dbl>            <dbl>
#>  1  2016 NSW   Albur… 15-19               1527              300             1830
#>  2  2016 NSW   Armid… 15-19                838              217             1055
#>  3  2016 NSW   Balli… 15-19               1064              185             1255
#>  4  2016 NSW   Balra… 15-19                 41                9               46
#>  5  2016 NSW   Bathu… 15-19               1103              241             1341
#>  6  2016 NSW   Bega … 15-19                801               97              897
#>  7  2016 NSW   Belli… 15-19                241               42              281
#>  8  2016 NSW   Berri… 15-19                168               16              181
#>  9  2016 NSW   Black… 15-19               7534             2136             9670
#> 10  2016 NSW   Bland… 15-19                124               14              140
#> # … with 5,590 more rows, and 1 more variable: total <dbl>
```

### abs_household_lga

``` r
abs_household_lga
#> # A tibble: 4,968 × 5
#>     year state lga                   n_persons_usually_resident n_households
#>    <dbl> <chr> <chr>                 <chr>                             <dbl>
#>  1  2016 NSW   Albury (C)            total                             19495
#>  2  2016 NSW   Albury (C)            1                                  6020
#>  3  2016 NSW   Albury (C)            2                                  6738
#>  4  2016 NSW   Albury (C)            3                                  2740
#>  5  2016 NSW   Albury (C)            4                                  2541
#>  6  2016 NSW   Albury (C)            5                                  1041
#>  7  2016 NSW   Albury (C)            6                                   311
#>  8  2016 NSW   Albury (C)            7                                    56
#>  9  2016 NSW   Albury (C)            8+                                   42
#> 10  2016 NSW   Armidale Regional (A) total                             10276
#> # … with 4,958 more rows
```

### abs_pop_age_lga_2016

``` r
abs_pop_age_lga_2016
#> # A tibble: 9,792 × 5
#>     year state lga                age_group population
#>    <dbl> <chr> <chr>              <fct>          <dbl>
#>  1  2016 ACT   Unincorporated ACT 0-4            28054
#>  2  2016 ACT   Unincorporated ACT 5-9            25767
#>  3  2016 ACT   Unincorporated ACT 10-14          22170
#>  4  2016 ACT   Unincorporated ACT 15-19          24906
#>  5  2016 ACT   Unincorporated ACT 20-24          32615
#>  6  2016 ACT   Unincorporated ACT 25-29          34243
#>  7  2016 ACT   Unincorporated ACT 30-34          34574
#>  8  2016 ACT   Unincorporated ACT 35-39          30340
#>  9  2016 ACT   Unincorporated ACT 40-44          28387
#> 10  2016 ACT   Unincorporated ACT 45-49          26431
#> # … with 9,782 more rows
```

### abs_pop_age_lga_2020

``` r
abs_pop_age_lga_2020
#> # A tibble: 9,774 × 5
#>     year state lga                age_group population
#>    <dbl> <chr> <chr>              <fct>          <dbl>
#>  1  2020 ACT   Unincorporated ACT 0-4            27861
#>  2  2020 ACT   Unincorporated ACT 5-9            28871
#>  3  2020 ACT   Unincorporated ACT 10-14          26015
#>  4  2020 ACT   Unincorporated ACT 15-19          23867
#>  5  2020 ACT   Unincorporated ACT 20-24          32626
#>  6  2020 ACT   Unincorporated ACT 25-29          33992
#>  7  2020 ACT   Unincorporated ACT 30-34          35734
#>  8  2020 ACT   Unincorporated ACT 35-39          35354
#>  9  2020 ACT   Unincorporated ACT 40-44          30155
#> 10  2020 ACT   Unincorporated ACT 45-49          29103
#> # … with 9,764 more rows
```

### abs_state_age

``` r
abs_state_age
#> # A tibble: 168 × 3
#>    state age_group population
#>    <chr> <fct>          <dbl>
#>  1 NSW   0-4           495060
#>  2 VIC   0-4           401992
#>  3 QLD   0-4           314592
#>  4 SA    0-4            98400
#>  5 WA    0-4           171531
#>  6 TAS   0-4            29258
#>  7 NT    0-4            17766
#>  8 ACT   0-4            27846
#>  9 NSW   5-9           512687
#> 10 VIC   5-9           416633
#> # … with 158 more rows
```

## Code of Conduct

Please note that the conmat project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
