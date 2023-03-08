# apply_vaccination() errors when there's an incorrect variable name

    i In argument: `acquisition_multiplier = 1 - acquisition_column * coverage`.
    Caused by error:
    ! object 'acquisition_column' not found

# apply_vaccination() produces expected output

    Code
      ngm_VIC_vacc
    Message
      
      -- Vaccination Setting Matrices ------------------------------------------------
    Output
      
    Message
      A list of matrices, each <matrix> containing the adjusted number of newly
      infected individuals for age groups. These numbers have been adjusted based on
      proposed vaccination rates in age groups
    Output
      
    Message
      There are 17 age breaks, ranging 0-80+ years, with a regular 5 year interval
    Output
      
    Message
      * home: a 17x17 <matrix>
      * school: a 17x17 <matrix>
      * work: a 17x17 <matrix>
      * other: a 17x17 <matrix>
      * all: a 17x17 <matrix>
      i Access each <matrix> with `x$name`
      i e.g., `x$home`

