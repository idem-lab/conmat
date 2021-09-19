# predict_contacts() works

    Code
      names(synthetic_pred)
    Output
      [1] "age_group_from" "age_group_to"   "contacts"      

---

    Code
      dim(synthetic_pred)
    Output
      [1] 9 3

---

    Code
      synthetic_pred$age_group_from
    Output
      [1] [0,5)    [0,5)    [0,5)    [5,10)   [5,10)   [5,10)   [10,Inf) [10,Inf)
      [9] [10,Inf)
      Levels: [0,5) [5,10) [10,Inf)

---

    Code
      synthetic_pred$age_group_to
    Output
      [1] [0,5)    [5,10)   [10,Inf) [0,5)    [5,10)   [10,Inf) [0,5)    [5,10)  
      [9] [10,Inf)
      Levels: [0,5) [5,10) [10,Inf)

# predictions_to_matrix() works

    Code
      dim(synthetic_all_5y)
    Output
      [1] 3 3

---

    Code
      rownames(synthetic_all_5y)
    Output
      [1] "[0,5)"    "[5,10)"   "[10,Inf)"

---

    Code
      colnames(synthetic_all_5y)
    Output
      [1] "[0,5)"    "[5,10)"   "[10,Inf)"

