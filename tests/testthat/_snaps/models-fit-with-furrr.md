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

---

    Code
      names(contact_model[[2]]$coefficients)
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

---

    Code
      names(contact_model[[3]]$coefficients)
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

---

    Code
      names(contact_model[[4]]$coefficients)
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
      

