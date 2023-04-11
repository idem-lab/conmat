# abs_age_education_state works

    Code
      abs_age_education_state(state = "VIC")
    Output
      # A tibble: 116 x 6
          year state   age population_educated total_population proportion
         <dbl> <chr> <dbl>               <dbl>            <dbl>      <dbl>
       1  2016 VIC       0                   0            70920      0    
       2  2016 VIC       1                   0            74723      0    
       3  2016 VIC       2                   0            74475      0    
       4  2016 VIC       3               25354            76009      0.334
       5  2016 VIC       4               49763            75084      0.663
       6  2016 VIC       5               64489            73468      0.878
       7  2016 VIC       6               70717            74780      0.946
       8  2016 VIC       7               69543            73391      0.948
       9  2016 VIC       8               69673            73373      0.950
      10  2016 VIC       9               69894            73627      0.949
      # i 106 more rows

---

    Code
      abs_age_education_state(state = "WA", age = 1:5)
    Output
      # A tibble: 5 x 6
         year state   age population_educated total_population proportion
        <dbl> <chr> <dbl>               <dbl>            <dbl>      <dbl>
      1  2016 WA        1                   0            32754      0    
      2  2016 WA        2                   0            32629      0    
      3  2016 WA        3                7633            32783      0.233
      4  2016 WA        4               26355            32463      0.812
      5  2016 WA        5               30743            32910      0.934

---

    Code
      abs_age_education_state(state = c("QLD", "TAS"), age = 5)
    Output
      # A tibble: 2 x 6
         year state   age population_educated total_population proportion
        <dbl> <chr> <dbl>               <dbl>            <dbl>      <dbl>
      1  2016 QLD       5               55416            61981      0.894
      2  2016 TAS       5                5745             6132      0.937

---

    Code
      abs_age_education_lga(lga = "Albury (C)")
    Output
      # A tibble: 116 x 8
          year state lga          age population_educated total_population proportion
         <dbl> <chr> <chr>      <dbl>               <dbl>            <dbl>      <dbl>
       1  2016 NSW   Albury (C)     0                   0              676      0    
       2  2016 NSW   Albury (C)     1                   0              664      0    
       3  2016 NSW   Albury (C)     2                   0              626      0    
       4  2016 NSW   Albury (C)     3                 250              706      0.354
       5  2016 NSW   Albury (C)     4                 431              609      0.708
       6  2016 NSW   Albury (C)     5                 533              608      0.877
       7  2016 NSW   Albury (C)     6                 595              631      0.943
       8  2016 NSW   Albury (C)     7                 608              644      0.944
       9  2016 NSW   Albury (C)     8                 575              609      0.944
      10  2016 NSW   Albury (C)     9                 630              680      0.926
      # i 106 more rows
      # i 1 more variable: anomaly_flag <lgl>

---

    Code
      abs_age_education_lga(lga = "Albury (C)", age = 1:5)
    Output
      # A tibble: 5 x 8
         year state lga          age population_educated total_population proportion
        <dbl> <chr> <chr>      <dbl>               <dbl>            <dbl>      <dbl>
      1  2016 NSW   Albury (C)     1                   0              664      0    
      2  2016 NSW   Albury (C)     2                   0              626      0    
      3  2016 NSW   Albury (C)     3                 250              706      0.354
      4  2016 NSW   Albury (C)     4                 431              609      0.708
      5  2016 NSW   Albury (C)     5                 533              608      0.877
      # i 1 more variable: anomaly_flag <lgl>

---

    Code
      abs_age_education_lga(lga = c("Albury (C)", "Barcoo (S)"), age = 10)
    Output
      # A tibble: 2 x 8
         year state lga          age population_educated total_population proportion
        <dbl> <chr> <chr>      <dbl>               <dbl>            <dbl>      <dbl>
      1  2016 NSW   Albury (C)    10                 615              654      0.940
      2  2016 QLD   Barcoo (S)    10                   7                7      1    
      # i 1 more variable: anomaly_flag <lgl>

