# abs_age_work_state works

    Code
      abs_age_work_state(state = "NSW")
    Output
      # A tibble: 116 x 6
          year state   age employed_population total_population proportion
         <dbl> <chr> <dbl>               <dbl>            <dbl>      <dbl>
       1  2016 NSW       0                   0            87708          0
       2  2016 NSW       1                   0            92876          0
       3  2016 NSW       2                   0            93584          0
       4  2016 NSW       3                   0            95179          0
       5  2016 NSW       4                   0            95791          0
       6  2016 NSW       5                   0            95216          0
       7  2016 NSW       6                   0            96479          0
       8  2016 NSW       7                   0            95142          0
       9  2016 NSW       8                   0            95833          0
      10  2016 NSW       9                   0            95516          0
      # ... with 106 more rows

---

    Code
      abs_age_work_state(state = c("QLD", "TAS"), age = 5)
    Output
      # A tibble: 2 x 6
         year state   age employed_population total_population proportion
        <dbl> <chr> <dbl>               <dbl>            <dbl>      <dbl>
      1  2016 QLD       5                   0            61981          0
      2  2016 TAS       5                   0             6132          0

# abs_age_work_lga works

    Code
      abs_age_work_lga(lga = "Albany (C)", age = 1:5)
    Output
      # A tibble: 5 x 8
         year state lga          age employed_population total_popul~1 propo~2 anoma~3
        <dbl> <chr> <chr>      <dbl>               <dbl>         <dbl>   <dbl> <lgl>  
      1  2016 WA    Albany (C)     1                   0           348       0 FALSE  
      2  2016 WA    Albany (C)     2                   0           413       0 FALSE  
      3  2016 WA    Albany (C)     3                   0           434       0 FALSE  
      4  2016 WA    Albany (C)     4                   0           418       0 FALSE  
      5  2016 WA    Albany (C)     5                   0           376       0 FALSE  
      # ... with abbreviated variable names 1: total_population, 2: proportion,
      #   3: anomaly_flag

---

    Code
      abs_age_work_lga(lga = c("Albury (C)", "Barcoo (S)"), age = 39)
    Output
      # A tibble: 2 x 8
         year state lga          age employed_population total_popul~1 propo~2 anoma~3
        <dbl> <chr> <chr>      <dbl>               <dbl>         <dbl>   <dbl> <lgl>  
      1  2016 NSW   Albury (C)    39                 434           587   0.739 FALSE  
      2  2016 QLD   Barcoo (S)    39                   5             4   1.25  TRUE   
      # ... with abbreviated variable names 1: total_population, 2: proportion,
      #   3: anomaly_flag

