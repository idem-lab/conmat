# transmission_probability_matrix works

    Code
      transmission_probability_matrix(home = one_05, work = one_05, age_breaks = age_breaks_0_80_plus)
    Message
      
      -- Transmission Probability Matrices -------------------------------------------
    Output
      
    Message
      A list of matrices, each <matrix> containing the relative probability of
      individuals in a given age group infecting an individual in another age group,
      for that setting.
    Output
      
    Message
      There are 9 age breaks, ranging 0-80+ years, with a regular 10 year interval
    Output
      
    Message
      * home: a 9x9 <matrix>
      * work: a 9x9 <matrix>
      i Access each <matrix> with `x$name`
      i e.g., `x$home`

---

    Code
      transmission_probability_matrix(one_05, one_05, age_breaks = age_breaks_0_80_plus)
    Message
      
      -- Transmission Probability Matrices -------------------------------------------
    Output
      
    Message
      A list of matrices, each <matrix> containing the relative probability of
      individuals in a given age group infecting an individual in another age group,
      for that setting.
    Output
      
    Message
      There are 9 age breaks, ranging 0-80+ years, with a regular 10 year interval
    Output
      
    Message
      * one: a 9x9 <matrix>
      * two: a 9x9 <matrix>
      i Access each <matrix> with `x$name`
      i e.g., `x$one`

