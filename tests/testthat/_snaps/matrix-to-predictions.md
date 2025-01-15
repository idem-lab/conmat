# matrix_to_predictions works

    Code
      matrix_to_predictions(fairfield_school_mat)
    Output
      # A tibble: 16 x 3
         age_group_to age_group_from contacts
         <fct>        <fct>             <dbl>
       1 [0,5)        [0,5)            0.918 
       2 [0,5)        [5,10)           0.361 
       3 [0,5)        [10,15)          0.0608
       4 [0,5)        [15,Inf)         0.0470
       5 [5,10)       [0,5)            0.380 
       6 [5,10)       [5,10)           4.72  
       7 [5,10)       [10,15)          0.422 
       8 [5,10)       [15,Inf)         0.0955
       9 [10,15)      [0,5)            0.0677
      10 [10,15)      [5,10)           0.441 
      11 [10,15)      [10,15)          7.20  
      12 [10,15)      [15,Inf)         0.147 
      13 [15,Inf)     [0,5)            0.660 
      14 [15,Inf)     [5,10)           1.27  
      15 [15,Inf)     [10,15)          1.85  
      16 [15,Inf)     [15,Inf)         1.36  

# predictions_to_matrix works

    Code
      predictions_to_matrix(fairfield_school_contacts)
    Output
                    [0,5)    [5,10)    [10,15)   [15,Inf)
      [0,5)    0.91761752 0.3613661 0.06083403 0.04696433
      [5,10)   0.38026461 4.7206582 0.42158012 0.09549837
      [10,15)  0.06772895 0.4409607 7.20182626 0.14732824
      [15,Inf) 0.65963688 1.2684675 1.85420868 1.35593915

