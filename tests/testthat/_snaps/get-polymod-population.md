# get_polymod_contact_data() works

    Code
      get_polymod_contact_data()
    Output
      # A tibble: 8,787 x 5
         setting age_from age_to contacts participants
         <chr>      <int>  <dbl>    <int>        <int>
       1 all            0      0       31           92
       2 all            0      1       12           92
       3 all            0      2       26           92
       4 all            0      3       22           92
       5 all            0      4       15           92
       6 all            0      5       12           92
       7 all            0      6       11           92
       8 all            0      7       12           92
       9 all            0      8        7           92
      10 all            0      9        8           92
      # i 8,777 more rows

# get_polymod_population() works

    Code
      get_polymod_population()
    Output
      # A tibble: 21 x 2 (conmat_population)
       - age: lower.age.limit
       - population: population
         lower.age.limit population
                   <int>      <dbl>
       1               0   1898966.
       2               5   2017632.
       3              10   2192410.
       4              15   2369985.
       5              20   2467873.
       6              25   2484327.
       7              30   2649826.
       8              35   3043704.
       9              40   3117812.
      10              45   2879510.
      # i 11 more rows

# get_polymod_setting_data() and derivatives work

    Code
      polymod_setting_data
    Message
      
      -- Setting Data ----------------------------------------------------------------
    Output
      
    Message
      A list of <data.frame>s containing the number of contacts between ages in each
      setting.
    Output
      
    Message
      There are 86 age breaks, ranging 0-90 years, with an irregular year interval,
      (on average, 1.05 years)
    Output
      
    Message
      * home: a 8,787x5 <data.frame>
      * work: a 8,787x5 <data.frame>
      * school: a 8,787x5 <data.frame>
      * other: a 8,787x5 <data.frame>
      i Access each <data.frame> with `x$name`
      i e.g., `x$home`

---

    Code
      polymod_setting_data$home
    Output
      # A tibble: 8,787 x 5
         setting age_from age_to contacts participants
         <chr>      <int>  <dbl>    <int>        <int>
       1 home           0      0       10           92
       2 home           0      1        7           92
       3 home           0      2       11           92
       4 home           0      3       15           92
       5 home           0      4       12           92
       6 home           0      5        6           92
       7 home           0      6        8           92
       8 home           0      7        9           92
       9 home           0      8        6           92
      10 home           0      9        6           92
      # i 8,777 more rows

---

    Code
      polymod_setting_data$work
    Output
      # A tibble: 8,787 x 5
         setting age_from age_to contacts participants
         <chr>      <int>  <dbl>    <int>        <int>
       1 work           0      0        0           92
       2 work           0      1        0           92
       3 work           0      2        0           92
       4 work           0      3        0           92
       5 work           0      4        0           92
       6 work           0      5        0           92
       7 work           0      6        0           92
       8 work           0      7        0           92
       9 work           0      8        0           92
      10 work           0      9        0           92
      # i 8,777 more rows

---

    Code
      polymod_setting_data$school
    Output
      # A tibble: 8,787 x 5
         setting age_from age_to contacts participants
         <chr>      <int>  <dbl>    <int>        <int>
       1 school         0      0       13           92
       2 school         0      1        2           92
       3 school         0      2        3           92
       4 school         0      3        2           92
       5 school         0      4        1           92
       6 school         0      5        3           92
       7 school         0      6        0           92
       8 school         0      7        0           92
       9 school         0      8        0           92
      10 school         0      9        0           92
      # i 8,777 more rows

---

    Code
      polymod_setting_data$other
    Output
      # A tibble: 8,787 x 5
         setting age_from age_to contacts participants
         <chr>      <int>  <dbl>    <int>        <int>
       1 other          0      0        7           92
       2 other          0      1        7           92
       3 other          0      2       11           92
       4 other          0      3       12           92
       5 other          0      4        4           92
       6 other          0      5        4           92
       7 other          0      6        4           92
       8 other          0      7        5           92
       9 other          0      8        2           92
      10 other          0      9        3           92
      # i 8,777 more rows

