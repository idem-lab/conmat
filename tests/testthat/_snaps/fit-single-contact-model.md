# Model coefficients are the same

    Code
      names(m_all$coefficients)
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
      names(m_all_not_sym$coefficients)
    Output
       [1] "(Intercept)"                      "school_probability"              
       [3] "work_probability"                 "s(age_to).1"                     
       [5] "s(age_to).2"                      "s(age_to).3"                     
       [7] "s(age_to).4"                      "s(age_to).5"                     
       [9] "s(age_to).6"                      "s(age_to).7"                     
      [11] "s(age_to).8"                      "s(age_to).9"                     
      [13] "s(age_from).1"                    "s(age_from).2"                   
      [15] "s(age_from).3"                    "s(age_from).4"                   
      [17] "s(age_from).5"                    "s(age_from).6"                   
      [19] "s(age_from).7"                    "s(age_from).8"                   
      [21] "s(age_from).9"                    "s(intergenerational).1"          
      [23] "s(intergenerational).2"           "s(intergenerational).3"          
      [25] "s(intergenerational).4"           "s(intergenerational).5"          
      [27] "s(intergenerational).6"           "s(intergenerational).7"          
      [29] "s(intergenerational).8"           "s(intergenerational).9"          
      [31] "s(intergenerational,age_from).1"  "s(intergenerational,age_from).2" 
      [33] "s(intergenerational,age_from).3"  "s(intergenerational,age_from).4" 
      [35] "s(intergenerational,age_from).5"  "s(intergenerational,age_from).6" 
      [37] "s(intergenerational,age_from).7"  "s(intergenerational,age_from).8" 
      [39] "s(intergenerational,age_from).9"  "s(intergenerational,age_from).10"
      [41] "s(intergenerational,age_from).11" "s(intergenerational,age_from).12"
      [43] "s(intergenerational,age_from).13" "s(intergenerational,age_from).14"
      [45] "s(intergenerational,age_from).15" "s(intergenerational,age_from).16"
      [47] "s(intergenerational,age_from).17" "s(intergenerational,age_from).18"
      [49] "s(intergenerational,age_from).19" "s(intergenerational,age_from).20"
      [51] "s(intergenerational,age_from).21" "s(intergenerational,age_from).22"
      [53] "s(intergenerational,age_from).23" "s(intergenerational,age_from).24"
      [55] "s(intergenerational,age_from).25" "s(intergenerational,age_from).26"
      [57] "s(intergenerational,age_from).27"

