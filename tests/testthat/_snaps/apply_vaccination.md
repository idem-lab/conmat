# apply_vaccination() errors when there's an incorrect variable name

    Code
      apply_vaccination(ngm = ngm_VIC, data = vaccination_effect_example_data,
        coverage_col = coverage, acquisition_col = acquisition_column,
        transmission_col = transmission)
    Error <dplyr:::mutate_error>
      Problem while computing `acquisition_multiplier = 1 - acquisition_column * coverage`.
      Caused by error:
      ! object 'acquisition_column' not found

