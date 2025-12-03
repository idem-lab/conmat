# Example Pipeline

``` r
library(conmat)
```

This vignette outlines a basic workflow of:

- Create a new synthetic matrix by extrapolating from POLYMOD data to a
  new age distribution
- Generating a Next Generation Matrix
- Applying Vaccination Rates
- Comparing R0 before and post vaccination rates

### Create a new synthetic matrix from all POLYMOD data

We can create a synthetic matrix from all POLYMOD data by using the
`extrapolate_polymod` function. First, let’s extract an age distribution
from the ABS data.

``` r
fairfield <- abs_age_lga("Fairfield (C)")
fairfield
#> # A tibble: 18 × 4 (conmat_population)
#>  - age: lower.age.limit
#>  - population: population
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

Note that this is a `conmat_population` object, which is just a data
frame that knows which columns represent the `age` and `population`
information.

We then extrapolate this to home, work, school, other and all settings,
using the full POLYMOD data. This gives us a setting prediction matrix.

``` r
age_breaks_0_80_plus <- c(seq(0, 80, by = 5), Inf)
synthetic_fairfield_5y <- extrapolate_polymod(
  population = fairfield,
  age_breaks = age_breaks_0_80_plus
)
synthetic_fairfield_5y
#> 
#> ── Setting Prediction Matrices ─────────────────────────────────────────────────
#> A list of matrices containing the model predicted contact rate between ages in
#> each setting.
#> There are 17 age breaks, ranging 0-80+ years, with a regular 5 year interval
#> • home: a 17x17 <matrix>
#> • work: a 17x17 <matrix>
#> • school: a 17x17 <matrix>
#> • other: a 17x17 <matrix>
#> • all: a 17x17 <matrix>
#> ℹ Access each <matrix> with `x$name`
#> ℹ e.g., `x$home`
synthetic_fairfield_5y$home
#>               [0,5)     [5,10)    [10,15)    [15,20)    [20,25)    [25,30)
#> [0,5)    0.51116928 0.42843881 0.21585439 0.14575078 0.20804049 0.39474004
#> [5,10)   0.45304596 0.72903087 0.48059476 0.17553142 0.11992143 0.20802548
#> [10,15)  0.24031930 0.50600328 0.83745364 0.42378365 0.15017474 0.11284139
#> [15,20)  0.17314453 0.19719654 0.45218311 0.74757194 0.39215673 0.15016421
#> [20,25)  0.26561664 0.14479406 0.17221722 0.42147245 0.67105468 0.36286014
#> [25,30)  0.50851893 0.25343058 0.13056795 0.16284127 0.36612365 0.57814044
#> [30,35)  0.64035274 0.51192053 0.23296189 0.12433667 0.14474182 0.31635997
#> [35,40)  0.44198782 0.61980984 0.44854042 0.21171392 0.10837101 0.12344056
#> [40,45)  0.22694283 0.40107641 0.51012087 0.38890693 0.17634346 0.08866227
#> [45,50)  0.15569421 0.20593862 0.32978546 0.44979200 0.32631726 0.14766411
#> [50,55)  0.16831103 0.14234815 0.17049124 0.29358224 0.37592680 0.27723916
#> [55,60)  0.19803329 0.14826334 0.11374889 0.14317432 0.23015310 0.30435221
#> [60,65)  0.17188942 0.15609054 0.10538765 0.08115178 0.09699324 0.16556335
#> [65,70)  0.10404341 0.11985571 0.09708617 0.06183362 0.04569274 0.05988774
#> [70,75)  0.05509216 0.06899319 0.06987432 0.05170148 0.03279967 0.02770485
#> [75,80)  0.03021745 0.03632963 0.03924862 0.03579325 0.02737094 0.02048952
#> [80,Inf) 0.02444781 0.03096856 0.03145695 0.02961577 0.02948605 0.02963137
#>             [30,35)    [35,40)    [40,45)    [45,50)    [50,55)    [55,60)
#> [0,5)    0.53951801 0.40993868 0.21939914 0.14580955 0.15196587 0.17758044
#> [5,10)   0.45608173 0.60788373 0.41001432 0.20394110 0.13590604 0.14058668
#> [10,15)  0.21852409 0.46316735 0.54905935 0.34385296 0.17138125 0.11356169
#> [15,20)  0.12444681 0.23326839 0.44664453 0.50040670 0.31489166 0.15251760
#> [20,25)  0.15569983 0.12833028 0.21766331 0.39017637 0.43335538 0.26350034
#> [25,30)  0.34337141 0.14748994 0.11042140 0.17814941 0.32246606 0.35158420
#> [30,35)  0.51293108 0.30307120 0.11962218 0.08683850 0.14502352 0.26224032
#> [35,40)  0.27531048 0.44431455 0.24797571 0.09675552 0.07426100 0.12480961
#> [40,45)  0.10425093 0.23790265 0.38824970 0.22158551 0.09216404 0.07041480
#> [45,50)  0.07812418 0.09582324 0.22874220 0.39953949 0.24365176 0.09945106
#> [50,55)  0.13532923 0.07628442 0.09868394 0.25272579 0.47105350 0.27891893
#> [55,60)  0.24639347 0.12909211 0.07591462 0.10386422 0.28083714 0.52047792
#> [60,65)  0.24464209 0.21084479 0.11130621 0.06701367 0.09693256 0.27064254
#> [65,70)  0.11665646 0.18206295 0.15328724 0.07979013 0.05051372 0.07853857
#> [70,75)  0.04178828 0.08435478 0.12621400 0.10424589 0.05770463 0.04009816
#> [75,80)  0.01980164 0.02999711 0.05718474 0.08526931 0.07661143 0.04679801
#> [80,Inf) 0.02697191 0.02379486 0.02858113 0.05158357 0.09126298 0.11005685
#>             [60,65)    [65,70)    [70,75)    [75,80)   [80,Inf)
#> [0,5)    0.16391101 0.11722764 0.08073189 0.06210064 0.04092676
#> [5,10)   0.15739431 0.14279982 0.10690918 0.07895009 0.05482036
#> [10,15)  0.11188618 0.12178691 0.11399891 0.08980290 0.05862890
#> [15,20)  0.09192951 0.08276335 0.09000284 0.08738509 0.05889633
#> [20,25)  0.11808857 0.06573097 0.06136662 0.07181835 0.06302190
#> [25,30)  0.20338511 0.08692594 0.05230065 0.05424578 0.06390208
#> [30,35)  0.27688760 0.15600467 0.07268139 0.04830063 0.05359107
#> [35,40)  0.21677703 0.22117114 0.13327738 0.06646746 0.04294789
#> [40,45)  0.10978929 0.17865000 0.19131297 0.12156260 0.04949124
#> [45,50)  0.06823527 0.09599556 0.16311759 0.18711883 0.09220729
#> [50,55)  0.10237530 0.06303640 0.09365534 0.17438067 0.16921099
#> [55,60)  0.28780485 0.09868281 0.06552738 0.10725281 0.20546010
#> [60,65)  0.50089590 0.27168013 0.10044015 0.07186713 0.14735934
#> [65,70)  0.22993304 0.43218966 0.24423050 0.09260139 0.07544333
#> [70,75)  0.06535984 0.18778462 0.34274067 0.18785267 0.05583272
#> [75,80)  0.03334656 0.05076854 0.13394746 0.22911365 0.08313095
#> [80,Inf) 0.08394006 0.05077722 0.04887387 0.10205485 0.16070716
```

By full POLYMOD data, we mean these data:

``` r
polymod_setting <- get_polymod_setting_data()

polymod_population <- get_polymod_population()

polymod_setting
#> 
#> ── Setting Data ────────────────────────────────────────────────────────────────
#> A list of <data.frame>s containing the number of contacts between ages in each
#> setting.
#> There are 86 age breaks, ranging 0-90 years, with an irregular year interval,
#> (on average, 1.05 years)
#> • home: a 8,787x5 <data.frame>
#> • work: a 8,787x5 <data.frame>
#> • school: a 8,787x5 <data.frame>
#> • other: a 8,787x5 <data.frame>
#> ℹ Access each <data.frame> with `x$name`
#> ℹ e.g., `x$home`
polymod_setting$home
#> # A tibble: 8,787 × 5
#>    setting age_from age_to contacts participants
#>    <chr>      <int>  <dbl>    <int>        <int>
#>  1 home           0      0       10           92
#>  2 home           0      1        7           92
#>  3 home           0      2       12           92
#>  4 home           0      3       14           92
#>  5 home           0      4       12           92
#>  6 home           0      5        6           92
#>  7 home           0      6        8           92
#>  8 home           0      7        9           92
#>  9 home           0      8        6           92
#> 10 home           0      9        6           92
#> # ℹ 8,777 more rows
polymod_population
#> # A tibble: 21 × 2 (conmat_population)
#>  - age: lower.age.limit
#>  - population: population
#>    lower.age.limit population
#>              <int>      <dbl>
#>  1               0   1898966.
#>  2               5   2017632.
#>  3              10   2192410.
#>  4              15   2369985.
#>  5              20   2467873.
#>  6              25   2484327.
#>  7              30   2649826.
#>  8              35   3043704.
#>  9              40   3117812.
#> 10              45   2879510.
#> # ℹ 11 more rows
```

The
[`extrapolate_polymod()`](https://idem-lab.github.io/conmat/dev/reference/extrapolate_polymod.md)
function does the following:

- Uses an already fit model (`polymod_setting_models`) of the contact
  rate to the full POLYMOD data above
- Predicts it to the provided fairfield population data

It also has options to predict to specified age brackets, defaulting to
5 year age groups up to 75, then 75 and older.

This object, `synthetic_fairfield_5y`, contains a matrix of predictions
for each of the settings, home, work, school, other, and all settings,
which is summarised when you print the object to the console:

``` r
synthetic_fairfield_5y
#> 
#> ── Setting Prediction Matrices ─────────────────────────────────────────────────
#> A list of matrices containing the model predicted contact rate between ages in
#> each setting.
#> There are 17 age breaks, ranging 0-80+ years, with a regular 5 year interval
#> • home: a 17x17 <matrix>
#> • work: a 17x17 <matrix>
#> • school: a 17x17 <matrix>
#> • other: a 17x17 <matrix>
#> • all: a 17x17 <matrix>
#> ℹ Access each <matrix> with `x$name`
#> ℹ e.g., `x$home`
```

You can see more detail by using `str` if you like:

``` r
str(synthetic_fairfield_5y)
#> List of 5
#>  $ home  : 'conmat_age_matrix' num [1:17, 1:17] 0.511 0.453 0.24 0.173 0.266 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>   ..- attr(*, "age_breaks")= num [1:18] 0 5 10 15 20 25 30 35 40 45 ...
#>  $ work  : 'conmat_age_matrix' num [1:17, 1:17] 0.00275 0.00304 0.00325 0.00543 0.01286 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>   ..- attr(*, "age_breaks")= num [1:18] 0 5 10 15 20 25 30 35 40 45 ...
#>  $ school: 'conmat_age_matrix' num [1:17, 1:17] 1.2928 0.3598 0.0398 0.0231 0.0462 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>   ..- attr(*, "age_breaks")= num [1:18] 0 5 10 15 20 25 30 35 40 45 ...
#>  $ other : 'conmat_age_matrix' num [1:17, 1:17] 0.755 0.441 0.163 0.101 0.138 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>   ..- attr(*, "age_breaks")= num [1:18] 0 5 10 15 20 25 30 35 40 45 ...
#>  $ all   : 'conmat_age_matrix' num [1:17, 1:17] 2.562 1.257 0.446 0.302 0.463 ...
#>   ..- attr(*, "age_breaks")= num [1:18] 0 5 10 15 20 25 30 35 40 45 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>  - attr(*, "age_breaks")= num [1:18] 0 5 10 15 20 25 30 35 40 45 ...
#>  - attr(*, "class")= chr [1:2] "conmat_setting_prediction_matrix" "list"
```

### Generating a Next Generation Matrix

Once infected, a person can transmit an infectious disease to another,
creating generations of infected individuals. We can define a matrix
describing the number of newly infected individuals in given categories,
such as age, for consecutive generations. This matrix is called a “next
generation matrix” (NGM).

We can generate an NGM using the population data

``` r
fairfield_ngm_age_data <- generate_ngm(
  fairfield,
  age_breaks = age_breaks_0_80_plus,
  R_target = 1.5
)
```

Or if you’ve already got the fitted settings contact matrices, then you
can pass that to `generate_ngm` instead:

``` r
fairfield_ngm <- generate_ngm(
  synthetic_fairfield_5y,
  age_breaks = age_breaks_0_80_plus,
  R_target = 1.5
)
```

However, note in these cases the age breaks specified in `generate_ngm`
must be the same as the age breaks specified in the synthetic contact
matrix, otherwise it will error as it is trying to multiple incompatible
matrices.

You can also specify your own transmission matrix, like so:

``` r
# using our own transmission matrix
new_transmission_matrix <- get_setting_transmission_matrices(
  age_breaks = age_breaks_0_80_plus,
  # is normally 0.5
  asymptomatic_relative_infectiousness = 0.75
)

new_transmission_matrix
#> 
#> ── Transmission Probability Matrices ───────────────────────────────────────────
#> A list of matrices, each <matrix> containing the relative probability of
#> individuals in a given age group infecting an individual in another age group,
#> for that setting.
#> There are 17 age breaks, ranging 0-80+ years, with a regular 5 year interval
#> • home: a 17x17 <matrix>
#> • school: a 17x17 <matrix>
#> • work: a 17x17 <matrix>
#> • other: a 17x17 <matrix>
#> ℹ Access each <matrix> with `x$name`
#> ℹ e.g., `x$home`

fairfield_ngm_0_80_new_tmat <- generate_ngm(
  synthetic_fairfield_5y,
  age_breaks = age_breaks_0_80_plus,
  R_target = 1.5,
  setting_transmission_matrix = new_transmission_matrix
)
```

We can also generate an NGM for Australian specific data like so, which
refits and extrapolates the data based on the Australian state or LGA
provided.

``` r
ngm_fairfield <- generate_ngm_oz(
  lga_name = "Fairfield (C)",
  age_breaks = age_breaks_0_80_plus,
  R_target = 1.5
)
```

The output of this is a matrix for each of the settings, where each
value is the number of newly infected individuals

``` r
ngm_fairfield$home
#>                [0,5)      [5,10)     [10,15)     [15,20)     [20,25)
#> [0,5)    0.046314740 0.038000588 0.018554473 0.012467735 0.018222884
#> [5,10)   0.050115197 0.078932569 0.050417895 0.018324651 0.012821480
#> [10,15)  0.031336501 0.064570120 0.103523674 0.052129547 0.018922039
#> [15,20)  0.027542727 0.030690925 0.068152012 0.112113004 0.060256465
#> [20,25)  0.061132336 0.032581977 0.037491538 0.091285310 0.149020510
#> [25,30)  0.140741617 0.068539857 0.034136125 0.042351315 0.097686918
#> [30,35)  0.187856647 0.146717338 0.064524277 0.034256451 0.040920662
#> [35,40)  0.128628369 0.176226264 0.123251595 0.057869289 0.030395055
#> [40,45)  0.063329140 0.109362898 0.134459486 0.101973228 0.047437233
#> [45,50)  0.042679586 0.055165708 0.085403752 0.115873740 0.086239113
#> [50,55)  0.046823395 0.038695709 0.044801780 0.076744298 0.100817085
#> [55,60)  0.056960616 0.041665459 0.030895567 0.038683524 0.063804046
#> [60,65)  0.051251509 0.045464912 0.029662550 0.022720388 0.027867273
#> [65,70)  0.030213185 0.034004013 0.026620293 0.016865090 0.012787875
#> [70,75)  0.014583938 0.017849527 0.017479293 0.012866126 0.008372440
#> [75,80)  0.007486146 0.008798037 0.009193027 0.008340506 0.006540742
#> [80,Inf) 0.005900909 0.007307291 0.007179693 0.006724746 0.006865664
#>              [25,30)     [30,35)     [35,40)     [40,45)    [45,50)    [50,55)
#> [0,5)    0.035457134 0.049732738 0.038687004 0.021283125 0.01453563 0.01568386
#> [5,10)   0.022811586 0.051333956 0.070059421 0.048583537 0.02483903 0.01714154
#> [10,15)  0.014585277 0.028996893 0.062943637 0.076731141 0.04940399 0.02550721
#> [15,20)  0.023675892 0.020149239 0.038691373 0.076209094 0.08781281 0.05726781
#> [20,25)  0.082750904 0.036494967 0.030840029 0.053863691 0.09940762 0.11458703
#> [25,30)  0.158513659 0.096830701 0.042672128 0.032924820 0.05473771 0.10295475
#> [30,35)  0.091931981 0.153349481 0.092986422 0.037837592 0.02831490 0.04916118
#> [35,40)  0.035585082 0.081649442 0.135224475 0.077801710 0.03129129 0.02496647
#> [40,45)  0.024509732 0.029642280 0.069403239 0.116734611 0.06865672 0.02967513
#> [45,50)  0.040100220 0.021819969 0.027457078 0.067545342 0.12156730 0.07702884
#> [50,55)  0.076404597 0.038360331 0.022185510 0.029578806 0.07806007 0.15119171
#> [55,60)  0.086717135 0.072219179 0.038826894 0.023536541 0.03319080 0.09328434
#> [60,65)  0.048897586 0.074341217 0.065758047 0.035792138 0.02221627 0.03341384
#> [65,70)  0.017226819 0.034521650 0.055288395 0.047987467 0.02574735 0.01694465
#> [70,75)  0.007265847 0.011269811 0.023335860 0.035975672 0.03061153 0.01760145
#> [75,80)  0.005029379 0.004996934 0.007762944 0.015243371 0.02340868 0.02183711
#> [80,Inf) 0.007086404 0.006630796 0.005998508 0.007420714 0.01379147 0.02533043
#>             [55,60)    [60,65)    [65,70)     [70,75)     [75,80)    [80,Inf)
#> [0,5)    0.01905681 0.01844857 0.01361685 0.009568568 0.007430323 0.004911830
#> [5,10)   0.01844370 0.02166604 0.02029276 0.015504940 0.011560033 0.008051674
#> [10,15)  0.01758643 0.01818899 0.02044541 0.019535778 0.015538764 0.010176308
#> [15,20)  0.02887748 0.01828522 0.01700874 0.018887562 0.018519350 0.012521395
#> [20,25)  0.07266254 0.03428803 0.01975208 0.018851580 0.022292362 0.019627521
#> [25,30)  0.11724204 0.07156126 0.03170181 0.019519864 0.020467664 0.024196106
#> [30,35)  0.09290802 0.10359858 0.06054267 0.028879654 0.019407009 0.021610306
#> [35,40)  0.04385037 0.08042239 0.08509839 0.052500407 0.026475038 0.017168284
#> [40,45)  0.02368227 0.03896507 0.06572539 0.072033861 0.046274136 0.018905984
#> [45,50)  0.03283546 0.02376781 0.03465479 0.060258331 0.069879716 0.034555884
#> [50,55)  0.09350832 0.03621631 0.02311535 0.035147422 0.066160726 0.064426032
#> [55,60)  0.18064547 0.10545785 0.03749632 0.025488179 0.042181676 0.081094757
#> [60,65)  0.09752337 0.19066851 0.10728943 0.040617949 0.029390797 0.060482876
#> [65,70)  0.02753114 0.08510704 0.16590361 0.095981229 0.036797730 0.030087109
#> [70,75)  0.01276934 0.02194835 0.06533309 0.121994047 0.067585898 0.020157357
#> [75,80)  0.01391857 0.01045042 0.01647454 0.044451075 0.076838791 0.027975046
#> [80,Inf) 0.03186734 0.02560338 0.01603421 0.015780675 0.033299318 0.052614559
str(ngm_fairfield)
#> List of 5
#>  $ home  : 'conmat_age_matrix' num [1:17, 1:17] 0.0463 0.0501 0.0313 0.0275 0.0611 ...
#>   ..- attr(*, "age_breaks")= num [1:18] 0 5 10 15 20 25 30 35 40 45 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>  $ school: 'conmat_age_matrix' num [1:17, 1:17] 0.031428 0.010615 0.001376 0.000965 0.002728 ...
#>   ..- attr(*, "age_breaks")= num [1:18] 0 5 10 15 20 25 30 35 40 45 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>  $ work  : 'conmat_age_matrix' num [1:17, 1:17] 6.68e-05 8.97e-05 1.12e-04 2.27e-04 7.59e-04 ...
#>   ..- attr(*, "age_breaks")= num [1:18] 0 5 10 15 20 25 30 35 40 45 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>  $ other : 'conmat_age_matrix' num [1:17, 1:17] 0.01835 0.01301 0.00562 0.00421 0.00816 ...
#>   ..- attr(*, "age_breaks")= num [1:18] 0 5 10 15 20 25 30 35 40 45 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>  $ all   : 'conmat_age_matrix' num [1:17, 1:17] 0.0962 0.0738 0.0384 0.0329 0.0728 ...
#>   ..- attr(*, "age_breaks")= num [1:18] 0 5 10 15 20 25 30 35 40 45 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>   .. ..$ : chr [1:17] "[0,5)" "[5,10)" "[10,15)" "[15,20)" ...
#>  - attr(*, "raw_eigenvalue")= num 3.23
#>  - attr(*, "scaling")= num 0.464
#>  - attr(*, "age_breaks")= num [1:18] 0 5 10 15 20 25 30 35 40 45 ...
#>  - attr(*, "class")= chr [1:2] "ngm_setting_matrix" "list"
```

### Applying Vaccination Rates

It is important to understand the effect of vaccination on the next
generation of infections. We can use
[`apply_vaccination()`](https://idem-lab.github.io/conmat/dev/reference/apply_vaccination.md)
to return the percentage reduction in acquisition and transmission in
each age group.

It takes two key arguments:

1.  The next generation matrix
2.  The vaccination effect data

The vaccination effect could look like the following:

``` r
vaccination_effect_example_data
#> # A tibble: 17 × 4
#>    age_band coverage acquisition transmission
#>    <chr>       <dbl>       <dbl>        <dbl>
#>  1 0-4         0           0            0    
#>  2 5-11        0.782       0.583        0.254
#>  3 12-15       0.997       0.631        0.295
#>  4 16-19       0.965       0.786        0.469
#>  5 20-24       0.861       0.774        0.453
#>  6 25-29       0.997       0.778        0.458
#>  7 30-34       0.998       0.803        0.493
#>  8 35-39       0.998       0.829        0.533
#>  9 40-44       0.999       0.841        0.551
#> 10 45-49       0.993       0.847        0.562
#> 11 50-54       0.999       0.857        0.579
#> 12 55-59       0.996       0.864        0.591
#> 13 60-64       0.998       0.858        0.581
#> 14 65-69       0.999       0.864        0.591
#> 15 70-74       0.999       0.867        0.597
#> 16 75-79       0.999       0.866        0.595
#> 17 80+         0.999       0.844        0.556
```

Each row contains information, for each age band:

- Coverage % vaccinated
- Acquisition - probability of acquiring COVID
- Transmission - the probability of transmission

Then you need to specify the columns in the vaccination effect data
frame related to coverage, acquisition, and transmission.

``` r
# Apply vaccination effect to next generation matrices
ngm_nsw_vacc <- apply_vaccination(
  ngm = ngm_fairfield,
  data = vaccination_effect_example_data,
  coverage_col = coverage,
  acquisition_col = acquisition,
  transmission_col = transmission
)

ngm_nsw_vacc
#> 
#> ── Vaccination Setting Matrices ────────────────────────────────────────────────
#> A list of matrices, each <matrix> containing the adjusted number of newly
#> infected individuals for age groups. These numbers have been adjusted based on
#> proposed vaccination rates in age groups
#> There are 17 age breaks, ranging 0-80+ years, with a regular 5 year interval
#> • home: a 17x17 <matrix>
#> • school: a 17x17 <matrix>
#> • work: a 17x17 <matrix>
#> • other: a 17x17 <matrix>
#> • all: a 17x17 <matrix>
#> ℹ Access each <matrix> with `x$name`
#> ℹ e.g., `x$home`
```

## Fitting a new model with asymmetric terms

In the examples so far we have focussed on using `extrapolate_polymod`
to fit the contact model - this is very useful because it doesn’t
involve many lines of code to fit:

``` r
fairfield <- abs_age_lga("Fairfield (C)")
age_breaks_0_80_plus <- c(seq(0, 80, by = 5), Inf)
synthetic_fairfield_5y <- extrapolate_polymod(
  population = fairfield,
  age_breaks = age_breaks_0_80_plus
)
```

It also fits quite quickly, since it uses a pre-computed model,
`polymod_setting_models`, (See
[`?polymod_setting_models`](https://idem-lab.github.io/conmat/dev/reference/polymod_setting_models.md)
for more details).

Under the hood of `extrapolate_polymod`, this uses this already fit
model for each setting (home, work, school, other), and then predicts
using that model, and the provided data, to predict the new contact
rates.

So the process is:

1.  Create a model that predicts contact rate for each setting
2.  Predict to a new population using that model

Let’s show each step and unpack them.

First let’s create a model that predicts contact rate for each setting:

``` r
polymod_setting_data <- get_polymod_setting_data()
polymod_population <- get_polymod_population()

contact_setting_model_not_sym <- fit_setting_contacts(
  contact_data_list = polymod_setting_data,
  population = polymod_population,
  symmetrical = FALSE
)
```

Here, we first get the polymod setting data (`polymod_setting_data`),
and the polymod population (`polymod_population`), to create a model for
each setting. These data look like this, if you are interested.

``` r
polymod_setting_data
#> 
#> ── Setting Data ────────────────────────────────────────────────────────────────
#> A list of <data.frame>s containing the number of contacts between ages in each
#> setting.
#> There are 86 age breaks, ranging 0-90 years, with an irregular year interval,
#> (on average, 1.05 years)
#> • home: a 8,787x5 <data.frame>
#> • work: a 8,787x5 <data.frame>
#> • school: a 8,787x5 <data.frame>
#> • other: a 8,787x5 <data.frame>
#> ℹ Access each <data.frame> with `x$name`
#> ℹ e.g., `x$home`
polymod_population
#> # A tibble: 21 × 2 (conmat_population)
#>  - age: lower.age.limit
#>  - population: population
#>    lower.age.limit population
#>              <int>      <dbl>
#>  1               0   1898966.
#>  2               5   2017632.
#>  3              10   2192410.
#>  4              15   2369985.
#>  5              20   2467873.
#>  6              25   2484327.
#>  7              30   2649826.
#>  8              35   3043704.
#>  9              40   3117812.
#> 10              45   2879510.
#> # ℹ 11 more rows
```

We also specify the `symmetrical = FALSE` option - by default this is
TRUE. Briefly, this changes some of the terms we use in creating the
model, to use terms that aren’t strictly symmetric.

Now that we’ve got our model, we can predict to our fairfield data, like
so:

``` r
fairfield_hh <- get_abs_per_capita_household_size(lga = "Fairfield (C)")
fairfield_hh
#> [1] 4.199372
contact_model_pred <- predict_setting_contacts(
  population = fairfield,
  contact_model = contact_setting_model_not_sym,
  age_breaks = age_breaks_0_80_plus,
  per_capita_household_size = fairfield_hh
)
```

- `population` is our population to predict to
- `contact_model` is our contact rate model for each setting
- `age_breaks` are our age breaks to predict to
- `per_capita_household_size` is the household size for that population,
  in our case we have a helper function,
  `get_abs_per_capita_household_size` which works for each LGA in
  Australia.

alternatively, you can use the `estimate_setting_contacts` function to
do a similar task:

``` r
contact_model_pred_est <- estimate_setting_contacts(
  contact_data_list = polymod_setting_data,
  survey_population = polymod_population,
  prediction_population = fairfield,
  age_breaks = age_breaks_0_80_plus,
  per_capita_household_size = fairfield_hh,
  symmetrical = FALSE
)
```

This is a bit briefer than the two step process, and might be preferable
to creating a separate model.
