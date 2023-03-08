# setting_prediction_matrix works

    Code
      setting_prediction_matrix(home = one_by_nine, work = one_by_nine, age_breaks = age_breaks_0_80_plus)
    Message
      
      -- Setting Prediction Matrices -------------------------------------------------
    Output
      
    Message
      A list of matrices containing the model predicted contact rate between ages in
      each setting.
    Output
      
    Message
      There are 9 age breaks, ranging 0-80+ years, with a regular 10 year interval
    Output
      
    Message
      * home: a 9x9 <matrix>
      * work: a 9x9 <matrix>
      * all: a 9x9 <matrix>
      i Access each <matrix> with `x$name`
      i e.g., `x$home`

# as_setting_prediction_matrix works

    Code
      as_setting_prediction_matrix(mat_list, age_breaks = age_breaks_0_80_plus)
    Message
      
      -- Setting Prediction Matrices -------------------------------------------------
    Output
      
    Message
      A list of matrices containing the model predicted contact rate between ages in
      each setting.
    Output
      
    Message
      There are 9 age breaks, ranging 0-80+ years, with a regular 10 year interval
    Output
      
    Message
      * home: a 9x9 <matrix>
      * work: a 9x9 <matrix>
      * all: a 9x9 <matrix>
      i Access each <matrix> with `x$name`
      i e.g., `x$home`

# as_setting_prediction_matrix warns when setting pred matrix given

    Code
      as_setting_prediction_matrix(setting_mat, age_breaks = age_breaks_0_80_plus)
    Condition
      Warning:
      `as_setting_prediction_matrix` not used as this object is alreadt of a <conmat_setting_prediction_matrix> method not implemented for <conmat_setting_prediction_matrix/list>.

# as_setting_prediction_matrix fails when wrong object given

    Code
      as_setting_prediction_matrix(iris, age_breaks = age_breaks_0_80_plus)
    Condition
      Error in `as_setting_prediction_matrix()`:
      ! `as_setting_prediction_matrix` method not implemented for <data.frame>

