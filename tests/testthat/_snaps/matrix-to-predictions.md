# matrix_to_predictions works

    Code
      matrix_to_predictions(fairfield_school_mat)
    Output
      # A tibble: 16 x 3
         age_group_to age_group_from contacts
         <fct>        <fct>             <dbl>
       1 [0,5)        [0,5)            1.29  
       2 [0,5)        [5,10)           0.342 
       3 [0,5)        [10,15)          0.0358
       4 [0,5)        [15,Inf)         0.0460
       5 [5,10)       [0,5)            0.360 
       6 [5,10)       [5,10)           4.28  
       7 [5,10)       [10,15)          0.389 
       8 [5,10)       [15,Inf)         0.0916
       9 [10,15)      [0,5)            0.0398
      10 [10,15)      [5,10)           0.407 
      11 [10,15)      [10,15)          6.89  
      12 [10,15)      [15,Inf)         0.142 
      13 [15,Inf)     [0,5)            0.646 
      14 [15,Inf)     [5,10)           1.22  
      15 [15,Inf)     [10,15)          1.78  
      16 [15,Inf)     [15,Inf)         1.03  

# predictions_to_matrix works

    Code
      predictions_to_matrix(fairfield_school_contacts)
    Output
                    [0,5)    [5,10)    [10,15)   [15,Inf)
      [0,5)    1.29282238 0.3420768 0.03576273 0.04598657
      [5,10)   0.35984494 4.2783940 0.38874296 0.09155252
      [10,15)  0.03981607 0.4065530 6.89007154 0.14173611
      [15,Inf) 0.64590388 1.2160564 1.78393541 1.03380519

