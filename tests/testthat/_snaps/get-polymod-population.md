# get_polymod_contact_data() works

    Code
      get_polymod_contact_data()
    Output
      # A tibble: 8,787 x 4
         age_from age_to contacts participants
            <int>  <dbl>    <dbl>        <int>
       1        0      0       31           92
       2        0      1       12           92
       3        0      2       26           92
       4        0      3       22           92
       5        0      4       15           92
       6        0      5       12           92
       7        0      6       11           92
       8        0      7       12           92
       9        0      8        7           92
      10        0      9        8           92
      # ... with 8,777 more rows

# get_polymod_population() works

    Code
      get_polymod_population()
    Output
      # A tibble: 21 x 2
         lower.age.limit population
                   <int>      <dbl>
       1               0   1841420.
       2               5   1950666.
       3              10   2122856.
       4              15   2323822.
       5              20   2406141.
       6              25   2377541.
       7              30   2552587.
       8              35   2982293.
       9              40   3044427.
      10              45   2828202.
      # ... with 11 more rows

# get_polymod_setting_data() works

    Code
      get_polymod_setting_data()
    Output
      $home
      # A tibble: 8,787 x 4
         age_from age_to contacts participants
            <int>  <dbl>    <dbl>        <int>
       1        0      0       10           92
       2        0      1        7           92
       3        0      2       11           92
       4        0      3       15           92
       5        0      4       12           92
       6        0      5        6           92
       7        0      6        8           92
       8        0      7        9           92
       9        0      8        6           92
      10        0      9        6           92
      # ... with 8,777 more rows
      
      $work
      # A tibble: 8,787 x 4
         age_from age_to contacts participants
            <int>  <dbl>    <dbl>        <int>
       1        0      0        0           92
       2        0      1        0           92
       3        0      2        0           92
       4        0      3        0           92
       5        0      4        0           92
       6        0      5        0           92
       7        0      6        0           92
       8        0      7        0           92
       9        0      8        0           92
      10        0      9        0           92
      # ... with 8,777 more rows
      
      $school
      # A tibble: 8,787 x 4
         age_from age_to contacts participants
            <int>  <dbl>    <dbl>        <int>
       1        0      0       13           92
       2        0      1        2           92
       3        0      2        3           92
       4        0      3        2           92
       5        0      4        1           92
       6        0      5        3           92
       7        0      6        0           92
       8        0      7        0           92
       9        0      8        0           92
      10        0      9        0           92
      # ... with 8,777 more rows
      
      $other
      # A tibble: 8,787 x 4
         age_from age_to contacts participants
            <int>  <dbl>    <dbl>        <int>
       1        0      0        7           92
       2        0      1        7           92
       3        0      2       11           92
       4        0      3       12           92
       5        0      4        4           92
       6        0      5        4           92
       7        0      6        4           92
       8        0      7        5           92
       9        0      8        2           92
      10        0      9        3           92
      # ... with 8,777 more rows
      

