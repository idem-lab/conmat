# predict_setting_contact model prints appropriately

    Code
      contact_model_pred
    Message
      
      -- Setting Prediction Matrices -------------------------------------------------
    Output
      
    Message
      A list of matrices containing the model predicted contact rate between ages in
      each setting.
    Output
      
    Message
      There are 5 age breaks, ranging 0-20+ years, with a regular 5 year interval
    Output
      
    Message
      * home: a 5x5 <matrix>
      * work: a 5x5 <matrix>
      * school: a 5x5 <matrix>
      * other: a 5x5 <matrix>
      * all: a 5x5 <matrix>
      i Access each <matrix> with `x$name`
      i e.g., `x$home`

# fit_setting_contact model prints appropriately

    Code
      contact_model
    Message
      
      -- Fitted Setting Contact Models -----------------------------------------------
    Output
      
    Message
      A list of fitted <bam> models for each setting. Each <bam> model predicts the
      contact rate between ages, for that setting.
    Output
      
    Message
      There are 20 age breaks, ranging 0-20 years, with a regular 1 year interval
    Output
      
    Message
      * home: a <bam> model (441 obs)
      * work: a <bam> model (441 obs)
      * school: a <bam> model (441 obs)
      * other: a <bam> model (441 obs)
      i Access each <bam> with `x$name`
      i e.g., `x$home`

# list names are kept

    Code
      names(contact_model)
    Output
      [1] "home"   "work"   "school" "other" 

---

    Code
      names(contact_model_pred)
    Output
      [1] "home"   "work"   "school" "other"  "all"   

# Model coefficients are the same

    Code
      names(contact_model[[1]]$coefficients)
    Output
       [1] "(Intercept)"            "school_probability"     "work_probability"      
       [4] "s(gam_age_offdiag).1"   "s(gam_age_offdiag).2"   "s(gam_age_offdiag).3"  
       [7] "s(gam_age_offdiag).4"   "s(gam_age_offdiag).5"   "s(gam_age_offdiag).6"  
      [10] "s(gam_age_offdiag).7"   "s(gam_age_offdiag).8"   "s(gam_age_offdiag).9"  
      [13] "s(gam_age_offdiag_2).1" "s(gam_age_offdiag_2).2" "s(gam_age_offdiag_2).3"
      [16] "s(gam_age_offdiag_2).4" "s(gam_age_offdiag_2).5" "s(gam_age_offdiag_2).6"
      [19] "s(gam_age_offdiag_2).7" "s(gam_age_offdiag_2).8" "s(gam_age_offdiag_2).9"
      [22] "s(gam_age_diag_prod).1" "s(gam_age_diag_prod).2" "s(gam_age_diag_prod).3"
      [25] "s(gam_age_diag_prod).4" "s(gam_age_diag_prod).5" "s(gam_age_diag_prod).6"
      [28] "s(gam_age_diag_prod).7" "s(gam_age_diag_prod).8" "s(gam_age_diag_prod).9"
      [31] "s(gam_age_diag_sum).1"  "s(gam_age_diag_sum).2"  "s(gam_age_diag_sum).3" 
      [34] "s(gam_age_diag_sum).4"  "s(gam_age_diag_sum).5"  "s(gam_age_diag_sum).6" 
      [37] "s(gam_age_diag_sum).7"  "s(gam_age_diag_sum).8"  "s(gam_age_diag_sum).9" 
      [40] "s(gam_age_pmax).1"      "s(gam_age_pmax).2"      "s(gam_age_pmax).3"     
      [43] "s(gam_age_pmax).4"      "s(gam_age_pmax).5"      "s(gam_age_pmax).6"     
      [46] "s(gam_age_pmax).7"      "s(gam_age_pmax).8"      "s(gam_age_pmax).9"     
      [49] "s(gam_age_pmin).1"      "s(gam_age_pmin).2"      "s(gam_age_pmin).3"     
      [52] "s(gam_age_pmin).4"      "s(gam_age_pmin).5"      "s(gam_age_pmin).6"     
      [55] "s(gam_age_pmin).7"      "s(gam_age_pmin).8"      "s(gam_age_pmin).9"     

---

    Code
      names(contact_model[[2]]$coefficients)
    Output
       [1] "(Intercept)"            "school_probability"     "work_probability"      
       [4] "s(gam_age_offdiag).1"   "s(gam_age_offdiag).2"   "s(gam_age_offdiag).3"  
       [7] "s(gam_age_offdiag).4"   "s(gam_age_offdiag).5"   "s(gam_age_offdiag).6"  
      [10] "s(gam_age_offdiag).7"   "s(gam_age_offdiag).8"   "s(gam_age_offdiag).9"  
      [13] "s(gam_age_offdiag_2).1" "s(gam_age_offdiag_2).2" "s(gam_age_offdiag_2).3"
      [16] "s(gam_age_offdiag_2).4" "s(gam_age_offdiag_2).5" "s(gam_age_offdiag_2).6"
      [19] "s(gam_age_offdiag_2).7" "s(gam_age_offdiag_2).8" "s(gam_age_offdiag_2).9"
      [22] "s(gam_age_diag_prod).1" "s(gam_age_diag_prod).2" "s(gam_age_diag_prod).3"
      [25] "s(gam_age_diag_prod).4" "s(gam_age_diag_prod).5" "s(gam_age_diag_prod).6"
      [28] "s(gam_age_diag_prod).7" "s(gam_age_diag_prod).8" "s(gam_age_diag_prod).9"
      [31] "s(gam_age_diag_sum).1"  "s(gam_age_diag_sum).2"  "s(gam_age_diag_sum).3" 
      [34] "s(gam_age_diag_sum).4"  "s(gam_age_diag_sum).5"  "s(gam_age_diag_sum).6" 
      [37] "s(gam_age_diag_sum).7"  "s(gam_age_diag_sum).8"  "s(gam_age_diag_sum).9" 
      [40] "s(gam_age_pmax).1"      "s(gam_age_pmax).2"      "s(gam_age_pmax).3"     
      [43] "s(gam_age_pmax).4"      "s(gam_age_pmax).5"      "s(gam_age_pmax).6"     
      [46] "s(gam_age_pmax).7"      "s(gam_age_pmax).8"      "s(gam_age_pmax).9"     
      [49] "s(gam_age_pmin).1"      "s(gam_age_pmin).2"      "s(gam_age_pmin).3"     
      [52] "s(gam_age_pmin).4"      "s(gam_age_pmin).5"      "s(gam_age_pmin).6"     
      [55] "s(gam_age_pmin).7"      "s(gam_age_pmin).8"      "s(gam_age_pmin).9"     

---

    Code
      names(contact_model[[3]]$coefficients)
    Output
       [1] "(Intercept)"            "school_probability"     "work_probability"      
       [4] "s(gam_age_offdiag).1"   "s(gam_age_offdiag).2"   "s(gam_age_offdiag).3"  
       [7] "s(gam_age_offdiag).4"   "s(gam_age_offdiag).5"   "s(gam_age_offdiag).6"  
      [10] "s(gam_age_offdiag).7"   "s(gam_age_offdiag).8"   "s(gam_age_offdiag).9"  
      [13] "s(gam_age_offdiag_2).1" "s(gam_age_offdiag_2).2" "s(gam_age_offdiag_2).3"
      [16] "s(gam_age_offdiag_2).4" "s(gam_age_offdiag_2).5" "s(gam_age_offdiag_2).6"
      [19] "s(gam_age_offdiag_2).7" "s(gam_age_offdiag_2).8" "s(gam_age_offdiag_2).9"
      [22] "s(gam_age_diag_prod).1" "s(gam_age_diag_prod).2" "s(gam_age_diag_prod).3"
      [25] "s(gam_age_diag_prod).4" "s(gam_age_diag_prod).5" "s(gam_age_diag_prod).6"
      [28] "s(gam_age_diag_prod).7" "s(gam_age_diag_prod).8" "s(gam_age_diag_prod).9"
      [31] "s(gam_age_diag_sum).1"  "s(gam_age_diag_sum).2"  "s(gam_age_diag_sum).3" 
      [34] "s(gam_age_diag_sum).4"  "s(gam_age_diag_sum).5"  "s(gam_age_diag_sum).6" 
      [37] "s(gam_age_diag_sum).7"  "s(gam_age_diag_sum).8"  "s(gam_age_diag_sum).9" 
      [40] "s(gam_age_pmax).1"      "s(gam_age_pmax).2"      "s(gam_age_pmax).3"     
      [43] "s(gam_age_pmax).4"      "s(gam_age_pmax).5"      "s(gam_age_pmax).6"     
      [46] "s(gam_age_pmax).7"      "s(gam_age_pmax).8"      "s(gam_age_pmax).9"     
      [49] "s(gam_age_pmin).1"      "s(gam_age_pmin).2"      "s(gam_age_pmin).3"     
      [52] "s(gam_age_pmin).4"      "s(gam_age_pmin).5"      "s(gam_age_pmin).6"     
      [55] "s(gam_age_pmin).7"      "s(gam_age_pmin).8"      "s(gam_age_pmin).9"     

---

    Code
      names(contact_model[[4]]$coefficients)
    Output
       [1] "(Intercept)"            "school_probability"     "work_probability"      
       [4] "s(gam_age_offdiag).1"   "s(gam_age_offdiag).2"   "s(gam_age_offdiag).3"  
       [7] "s(gam_age_offdiag).4"   "s(gam_age_offdiag).5"   "s(gam_age_offdiag).6"  
      [10] "s(gam_age_offdiag).7"   "s(gam_age_offdiag).8"   "s(gam_age_offdiag).9"  
      [13] "s(gam_age_offdiag_2).1" "s(gam_age_offdiag_2).2" "s(gam_age_offdiag_2).3"
      [16] "s(gam_age_offdiag_2).4" "s(gam_age_offdiag_2).5" "s(gam_age_offdiag_2).6"
      [19] "s(gam_age_offdiag_2).7" "s(gam_age_offdiag_2).8" "s(gam_age_offdiag_2).9"
      [22] "s(gam_age_diag_prod).1" "s(gam_age_diag_prod).2" "s(gam_age_diag_prod).3"
      [25] "s(gam_age_diag_prod).4" "s(gam_age_diag_prod).5" "s(gam_age_diag_prod).6"
      [28] "s(gam_age_diag_prod).7" "s(gam_age_diag_prod).8" "s(gam_age_diag_prod).9"
      [31] "s(gam_age_diag_sum).1"  "s(gam_age_diag_sum).2"  "s(gam_age_diag_sum).3" 
      [34] "s(gam_age_diag_sum).4"  "s(gam_age_diag_sum).5"  "s(gam_age_diag_sum).6" 
      [37] "s(gam_age_diag_sum).7"  "s(gam_age_diag_sum).8"  "s(gam_age_diag_sum).9" 
      [40] "s(gam_age_pmax).1"      "s(gam_age_pmax).2"      "s(gam_age_pmax).3"     
      [43] "s(gam_age_pmax).4"      "s(gam_age_pmax).5"      "s(gam_age_pmax).6"     
      [46] "s(gam_age_pmax).7"      "s(gam_age_pmax).8"      "s(gam_age_pmax).9"     
      [49] "s(gam_age_pmin).1"      "s(gam_age_pmin).2"      "s(gam_age_pmin).3"     
      [52] "s(gam_age_pmin).4"      "s(gam_age_pmin).5"      "s(gam_age_pmin).6"     
      [55] "s(gam_age_pmin).7"      "s(gam_age_pmin).8"      "s(gam_age_pmin).9"     

# Matrix dims are kept

    Code
      map(contact_model_pred, dim)
    Output
      $home
      [1] 5 5
      
      $work
      [1] 5 5
      
      $school
      [1] 5 5
      
      $other
      [1] 5 5
      
      $all
      [1] 5 5
      

