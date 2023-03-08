# check_age_breaks works

    Code
      check_age_breaks(age_one, age_one)

---

    Code
      check_age_breaks(age_one, age_two)
    Condition
      Error in `check_age_breaks()`:
      ! Age breaks must be the same, but they are different:
      `old`: 1 2 3 Inf
      `new`: 1 2 3    
      i You can check the age breaks using `age_breaks(<object>)`

