# Partial prediction functions work for a single model setting

    Code
      partials_home
    Output
      # A tibble: 58,806 x 22
         age_from age_to gam_age_offdiag gam_age_offdiag_2 gam_age_diag_prod
       *    <dbl>  <dbl>           <int>             <dbl>             <int>
       1        1      1               0                 0                 1
       2        1      1               0                 0                 1
       3        1      1               0                 0                 1
       4        1      1               0                 0                 1
       5        1      1               0                 0                 1
       6        1      1               0                 0                 1
       7        2      1               1                 1                 2
       8        2      1               1                 1                 2
       9        2      1               1                 1                 2
      10        2      1               1                 1                 2
      # i 58,796 more rows
      # i 17 more variables: gam_age_diag_sum <int>, gam_age_pmax <int>,
      #   gam_age_pmin <int>, pop_age_to <dbl>, intergenerational <int>,
      #   school_fraction_age_from <dbl>, school_fraction_age_to <dbl>,
      #   school_probability <dbl>, school_year_probability <dbl>,
      #   school_weighted_pop_fraction <dbl>, work_fraction_age_from <dbl>,
      #   work_fraction_age_to <dbl>, work_probability <dbl>, ...

# Partial prediction functions work for all model settings

    Code
      partials_setting
    Output
      # A tibble: 235,224 x 23
         setting age_from age_to gam_age_offdiag gam_age_offdiag_2 gam_age_diag_prod
       * <chr>      <dbl>  <dbl>           <int>             <dbl>             <int>
       1 home           1      1               0                 0                 1
       2 home           1      1               0                 0                 1
       3 home           1      1               0                 0                 1
       4 home           1      1               0                 0                 1
       5 home           1      1               0                 0                 1
       6 home           1      1               0                 0                 1
       7 home           2      1               1                 1                 2
       8 home           2      1               1                 1                 2
       9 home           2      1               1                 1                 2
      10 home           2      1               1                 1                 2
      # i 235,214 more rows
      # i 17 more variables: gam_age_diag_sum <int>, gam_age_pmax <int>,
      #   gam_age_pmin <int>, pop_age_to <dbl>, intergenerational <int>,
      #   school_fraction_age_from <dbl>, school_fraction_age_to <dbl>,
      #   school_probability <dbl>, school_year_probability <dbl>,
      #   school_weighted_pop_fraction <dbl>, work_fraction_age_from <dbl>,
      #   work_fraction_age_to <dbl>, work_probability <dbl>, ...

# Partial prediction sum functions work for a single model setting

    Code
      partials_summed_home
    Output
      # A tibble: 9,801 x 3
         age_from age_to gam_total_term
       *    <dbl>  <dbl>          <dbl>
       1        1      1          1.51 
       2        1      2          1.55 
       3        1      3          1.55 
       4        1      4          1.50 
       5        1      5          1.43 
       6        1      6          1.33 
       7        1      7          1.21 
       8        1      8          1.07 
       9        1      9          0.934
      10        1     10          0.794
      # i 9,791 more rows

---

    Code
      partials_summed_setting
    Output
      # A tibble: 39,204 x 4
         setting age_from age_to gam_total_term
       * <chr>      <dbl>  <dbl>          <dbl>
       1 home           1      1          1.51 
       2 home           1      2          1.55 
       3 home           1      3          1.55 
       4 home           1      4          1.50 
       5 home           1      5          1.43 
       6 home           1      6          1.33 
       7 home           1      7          1.21 
       8 home           1      8          1.07 
       9 home           1      9          0.934
      10 home           1     10          0.794
      # i 39,194 more rows

