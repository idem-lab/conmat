# abs_age_lga() returns the right shape works

    # A tibble: 18 x 4
       lga        lower.age.limit  year population
       <chr>                <dbl> <dbl>      <dbl>
     1 Albury (C)               0  2020       3764
     2 Albury (C)               5  2020       3614
     3 Albury (C)              10  2020       3369
     4 Albury (C)              15  2020       3334
     5 Albury (C)              20  2020       3603
     6 Albury (C)              25  2020       3736
     7 Albury (C)              30  2020       3443
     8 Albury (C)              35  2020       3371
     9 Albury (C)              40  2020       3187
    10 Albury (C)              45  2020       3449
    # ... with 8 more rows
    # i Use `print(n = ...)` to see more rows

# abs_age_lga() returns the right shape errors

    The LGA name provided does not match LGAs in Australia
    x The lga name 'Imaginary World' did not match (it probably needs 'Imaginary World (C)' or similar
    i See `abs_lga_lookup` for a list of all LGAs

