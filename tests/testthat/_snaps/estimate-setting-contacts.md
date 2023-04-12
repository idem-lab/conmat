# estimate_setting_contacts works

    Code
      estimate_setting_contacts(contact_data_list = contact_data_cut,
        survey_population = get_polymod_population(), prediction_population = get_polymod_population(),
        age_breaks = c(seq(0, 10, by = 5), Inf), per_capita_household_size = NULL)
    Message
      
      -- Setting Prediction Matrices -------------------------------------------------
    Output
      
    Message
      A list of matrices containing the model predicted contact rate between ages in
      each setting.
    Output
      
    Message
      There are 3 age breaks, ranging 0-10+ years, with a regular 5 year interval
    Output
      
    Message
      * home: a 3x3 <matrix>
      * work: a 3x3 <matrix>
      * school: a 3x3 <matrix>
      * other: a 3x3 <matrix>
      * all: a 3x3 <matrix>
      i Access each <matrix> with `x$name`
      i e.g., `x$home`

# estimate_setting_contacts works with different demographic data

    Code
      estimate_setting_contacts(contact_data_list = contact_data_cut,
        survey_population = get_polymod_population(), prediction_population = get_polymod_population(),
        age_breaks = c(seq(0, 10, by = 5), Inf), school_demographics = conmat_original_school_demographics,
        work_demographics = conmat_original_work_demographics)
    Message
      
      -- Setting Prediction Matrices -------------------------------------------------
    Output
      
    Message
      A list of matrices containing the model predicted contact rate between ages in
      each setting.
    Output
      
    Message
      There are 3 age breaks, ranging 0-10+ years, with a regular 5 year interval
    Output
      
    Message
      * home: a 3x3 <matrix>
      * work: a 3x3 <matrix>
      * school: a 3x3 <matrix>
      * other: a 3x3 <matrix>
      * all: a 3x3 <matrix>
      i Access each <matrix> with `x$name`
      i e.g., `x$home`

