# estimate_setting_contacts works

    Code
      estimate_setting_contacts(contact_data_list = contact_data_cut,
        survey_population = get_polymod_population(), prediction_population = get_polymod_population(),
        age_breaks = c(seq(0, 10, by = 5), Inf), per_capita_household_size = NULL)
    Condition
      Warning in `dplyr::left_join()`:
      Detected an unexpected many-to-many relationship between `x` and `y`.
      i Row 1 of `x` matches multiple rows in `y`.
      i Row 125 of `y` matches multiple rows in `x`.
      i If a many-to-many relationship is expected, set `relationship = "many-to-many"` to silence this warning.
      Warning in `dplyr::left_join()`:
      Detected an unexpected many-to-many relationship between `x` and `y`.
      i Row 1 of `x` matches multiple rows in `y`.
      i Row 125 of `y` matches multiple rows in `x`.
      i If a many-to-many relationship is expected, set `relationship = "many-to-many"` to silence this warning.
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
    Condition
      Warning in `dplyr::left_join()`:
      Detected an unexpected many-to-many relationship between `x` and `y`.
      i Row 1 of `x` matches multiple rows in `y`.
      i Row 125 of `y` matches multiple rows in `x`.
      i If a many-to-many relationship is expected, set `relationship = "many-to-many"` to silence this warning.
      Warning in `dplyr::left_join()`:
      Detected an unexpected many-to-many relationship between `x` and `y`.
      i Row 1 of `x` matches multiple rows in `y`.
      i Row 125 of `y` matches multiple rows in `x`.
      i If a many-to-many relationship is expected, set `relationship = "many-to-many"` to silence this warning.
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

