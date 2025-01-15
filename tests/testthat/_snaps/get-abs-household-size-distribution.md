# get_abs_household_size_distribution works

    Code
      get_abs_household_size_distribution(lga = "Fairfield (C)")
    Output
      # A tibble: 8 x 5
      # Groups:   lga [1]
         year state lga           household_size n_people
        <dbl> <chr> <chr>                  <dbl>    <dbl>
      1  2016 NSW   Fairfield (C)              1     9002
      2  2016 NSW   Fairfield (C)              2    26776
      3  2016 NSW   Fairfield (C)              3    31599
      4  2016 NSW   Fairfield (C)              4    44676
      5  2016 NSW   Fairfield (C)              5    33890
      6  2016 NSW   Fairfield (C)              6    21216
      7  2016 NSW   Fairfield (C)              7     9800
      8  2016 NSW   Fairfield (C)              8    10976

---

    Code
      get_abs_household_size_distribution(state = "NSW")
    Output
      # A tibble: 1,048 x 5
      # Groups:   state [1]
          year state lga                   household_size n_people
         <dbl> <chr> <chr>                          <dbl>    <dbl>
       1  2016 NSW   Albury (C)                         1     6020
       2  2016 NSW   Albury (C)                         2    13476
       3  2016 NSW   Albury (C)                         3     8220
       4  2016 NSW   Albury (C)                         4    10164
       5  2016 NSW   Albury (C)                         5     5205
       6  2016 NSW   Albury (C)                         6     1866
       7  2016 NSW   Albury (C)                         7      392
       8  2016 NSW   Albury (C)                         8      336
       9  2016 NSW   Armidale Regional (A)              1     2983
      10  2016 NSW   Armidale Regional (A)              2     7326
      # i 1,038 more rows

