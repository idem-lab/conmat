# matrix_to_predictions works

    Code
      matrix_to_predictions(fairfield_school_mat)
    Output
      # A tibble: 16 x 3
         age_group_to age_group_from contacts
         <fct>        <fct>             <dbl>
       1 [0,5)        [0,5)            1.20  
       2 [0,5)        [5,10)           0.319 
       3 [0,5)        [10,15)          0.0499
       4 [0,5)        [15,Inf)         0.0449
       5 [5,10)       [0,5)            0.335 
       6 [5,10)       [5,10)           4.42  
       7 [5,10)       [10,15)          0.378 
       8 [5,10)       [15,Inf)         0.0945
       9 [10,15)      [0,5)            0.0555
      10 [10,15)      [5,10)           0.395 
      11 [10,15)      [10,15)          6.59  
      12 [10,15)      [15,Inf)         0.136 
      13 [15,Inf)     [0,5)            0.630 
      14 [15,Inf)     [5,10)           1.26  
      15 [15,Inf)     [10,15)          1.71  
      16 [15,Inf)     [15,Inf)         1.07  

# predictions_to_matrix works

    Code
      predictions_to_matrix(fairfield_school_contacts)
    Output
                    [0,5)    [5,10)    [10,15)   [15,Inf)
      [0,5)    1.20444194 0.3185143 0.04988151 0.04488983
      [5,10)   0.33501861 4.4238922 0.37776442 0.09451754
      [10,15)  0.05553508 0.3950164 6.59068412 0.13592176
      [15,Inf) 0.63049952 1.2554395 1.71070565 1.06651014

