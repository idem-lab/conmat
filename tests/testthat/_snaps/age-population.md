# age_population works

    Code
      age_population(data = world_data, location_col = country, location = c("Asia",
        "Afghanistan"), age_col = lower.age.limit, year_col = year, year = c(2010:
      2020))
    Output
      # A tibble: 42 x 5 (conmat_population)
       - age: lower.age.limit
       - population: population
         country      year population lower.age.limit upper.age.limit
         <chr>       <int>      <dbl>           <dbl>           <dbl>
       1 Afghanistan  2010    5199366               0               4
       2 Afghanistan  2015    5239401               0               4
       3 Afghanistan  2010    4662577               5               9
       4 Afghanistan  2015    5141850               5               9
       5 Afghanistan  2010    3905430              10              14
       6 Afghanistan  2015    4642280              10              14
       7 Afghanistan  2010    3025604              15              19
       8 Afghanistan  2015    3944912              15              19
       9 Afghanistan  2010    2450674              20              24
      10 Afghanistan  2015    3117448              20              24
      # i 32 more rows

---

    Code
      age_population(data = world_data, location_col = country, location = "Afghanistan",
        age_col = lower.age.limit)
    Output
      # A tibble: 294 x 5 (conmat_population)
       - age: lower.age.limit
       - population: population
         country      year population lower.age.limit upper.age.limit
         <chr>       <int>      <dbl>           <dbl>           <dbl>
       1 Afghanistan  1950    1291622               0               4
       2 Afghanistan  1955    1355054               0               4
       3 Afghanistan  1960    1539494               0               4
       4 Afghanistan  1965    1762117               0               4
       5 Afghanistan  1970    2025591               0               4
       6 Afghanistan  1975    2326731               0               4
       7 Afghanistan  1980    2484405               0               4
       8 Afghanistan  1985    2276913               0               4
       9 Afghanistan  1990    2377868               0               4
      10 Afghanistan  1995    3325482               0               4
      # i 284 more rows

