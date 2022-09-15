# abs_age_lga() returns the right shape works

    Code
      abs_age_lga("Albury (C)")
    Output
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
      11 Albury (C)              50  2020       3297
      12 Albury (C)              55  2020       3412
      13 Albury (C)              60  2020       3368
      14 Albury (C)              65  2020       2967
      15 Albury (C)              70  2020       2602
      16 Albury (C)              75  2020       1966
      17 Albury (C)              80  2020       1254
      18 Albury (C)              85  2020       1319

# abs_age_lga() returns the right shape errors

    The LGA name provided does not match LGAs in Australia
    x The lga name 'Imaginary World' did not match (it probably needs 'Imaginary World (C)' or similar
    i See `abs_lga_lookup` for a list of all LGAs

