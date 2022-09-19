# abs_age_state() returns the right shape

    Code
      abs_age_state("NSW")
    Output
      # A tibble: 18 x 4
      # Groups:   year, state [1]
          year state lower.age.limit population
         <dbl> <chr>           <dbl>      <dbl>
       1  2020 NSW                 0     495091
       2  2020 NSW                 5     512778
       3  2020 NSW                10     500881
       4  2020 NSW                15     468550
       5  2020 NSW                20     540233
       6  2020 NSW                25     607891
       7  2020 NSW                30     611590
       8  2020 NSW                35     582824
       9  2020 NSW                40     512803
      10  2020 NSW                45     527098
      # ... with 8 more rows
      # i Use `print(n = ...)` to see more rows

# abs_age_state() returns an error

    Code
      abs_age_state("Imaginary World")
    Condition
      Error in `check_state_name()`:
      ! The state name provided does not match states in Australia
      x The state name 'Imaginary World' did not match
      i See `abs_lga_lookup` for a list of all states

