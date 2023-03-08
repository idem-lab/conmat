# NGMs from each generate_ngm type return the same object

    Code
      perth_ngm_lga
    Message
      
      -- NGM Setting Matrices --------------------------------------------------------
    Output
      
    Message
      A list of matrices, each <matrix> containing the number of newly infected
      individuals for a specified age group.
    Output
      
    Message
      There are 16 age breaks, ranging 0-75+ years, with a regular 5 year interval
    Output
      
    Message
      * home: a 16x16 <matrix>
      * school: a 16x16 <matrix>
      * work: a 16x16 <matrix>
      * other: a 16x16 <matrix>
      * all: a 16x16 <matrix>
      i Access each <matrix> with `x$name`
      i e.g., `x$home`

---

    Code
      perth_ngm
    Message
      
      -- NGM Setting Matrices --------------------------------------------------------
    Output
      
    Message
      A list of matrices, each <matrix> containing the number of newly infected
      individuals for a specified age group.
    Output
      
    Message
      There are 16 age breaks, ranging 0-75+ years, with a regular 5 year interval
    Output
      
    Message
      * home: a 16x16 <matrix>
      * school: a 16x16 <matrix>
      * work: a 16x16 <matrix>
      * other: a 16x16 <matrix>
      * all: a 16x16 <matrix>
      i Access each <matrix> with `x$name`
      i e.g., `x$home`

---

    Code
      perth_ngm_oz
    Message
      
      -- NGM Setting Matrices --------------------------------------------------------
    Output
      
    Message
      A list of matrices, each <matrix> containing the number of newly infected
      individuals for a specified age group.
    Output
      
    Message
      There are 16 age breaks, ranging 0-75+ years, with a regular 5 year interval
    Output
      
    Message
      * home: a 16x16 <matrix>
      * school: a 16x16 <matrix>
      * work: a 16x16 <matrix>
      * other: a 16x16 <matrix>
      * all: a 16x16 <matrix>
      i Access each <matrix> with `x$name`
      i e.g., `x$home`

# generate_ngm fails when given wrong age breaks

    Code
      generate_ngm(perth_contact, age_breaks = age_breaks_0_85, R_target = 1.5)
    Condition
      Error in `check_age_breaks()`:
      ! Age breaks must be the same, but they are different:
               `x[14:17]`: 65 70 75 Inf       
      `age_breaks[14:19]`: 65 70 75  80 85 Inf
      i You can check the age breaks using `age_breaks(<object>)`

