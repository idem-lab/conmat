# apply_vaccination() errors when there's an incorrect variable name

    Problem with `mutate()` column `acquisition_multiplier`.
    i `acquisition_multiplier = 1 - acquisition_column * coverage`.
    x object 'acquisition_column' not found
    Caused by error:
    ! object 'acquisition_column' not found

# apply_vaccination() produces expected output

    Code
      ngm_VIC_vacc
    Message <cliMessage>
      
      -- Vaccination Setting Matrices ------------------------------------------------
    Output
      
    Message <cliMessage>
      A list of matrices, each <matrix> containing the adjusted number of newly
      infected individuals for age groups. These numbers have been adjusted based on
      proposed vaccination rates in age groups
    Output
      
    Message <cliMessage>
      * home: a 17x17 <matrix>
      * school: a 17x17 <matrix>
      * work: a 17x17 <matrix>
      * other: a 17x17 <matrix>
      * all: a 17x17 <matrix>
      i Access each <matrix> with `x$name`
      i e.g., `x$home`

