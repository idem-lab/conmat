# matrix_to_predictions works

    Code
      matrix_to_predictions(fairfield_school_mat)
    Output
      # A tibble: 16 x 3
         age_group_to age_group_from contacts
         <fct>        <fct>             <dbl>
       1 [0,5)        [0,5)            1.29  
       2 [0,5)        [5,10)           0.340 
       3 [0,5)        [10,15)          0.0350
       4 [0,5)        [15,Inf)         0.0463
       5 [5,10)       [0,5)            0.358 
       6 [5,10)       [5,10)           4.28  
       7 [5,10)       [10,15)          0.389 
       8 [5,10)       [15,Inf)         0.0913
       9 [10,15)      [0,5)            0.0390
      10 [10,15)      [5,10)           0.406 
      11 [10,15)      [10,15)          6.89  
      12 [10,15)      [15,Inf)         0.142 
      13 [15,Inf)     [0,5)            0.651 
      14 [15,Inf)     [5,10)           1.21  
      15 [15,Inf)     [10,15)          1.79  
      16 [15,Inf)     [15,Inf)         1.03  

# predictions_to_matrix works

    Code
      predictions_to_matrix(fairfield_school_contacts)
    Output
                   [0,5)    [5,10)    [10,15)   [15,Inf)
      [0,5)    1.2943919 0.3399276 0.03498491 0.04632389
      [5,10)   0.3575674 4.2793707 0.38857887 0.09134242
      [10,15)  0.0389501 0.4063799 6.89347560 0.14196259
      [15,Inf) 0.6506417 1.2132657 1.78676032 1.03167455

