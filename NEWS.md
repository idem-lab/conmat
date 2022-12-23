# conmat 0.0.1.9000

## Breaking Changes

* `generate_ngm` no longer accepts LGA or state inputs, which now occurs in `generate_ngm_oz`. The `generate_ngm` function has had S3 methods created for it,
 so it can take input from `conmat_population` (such as the output from 
 [abs_age_lga()]), or a `conmat_setting_prediction_matrix`, which is the
 output from [extrapolate_polymod()] or [predict_setting_contacts()].

# conmat 0.0.0.9004

* Added a `NEWS.md` file to track changes to the package.
* Decouple prediction and estimation of models with `fit_setting_contacts` to 
  fit models, and `predict_setting_contacts` to predict. Fixes [#7](https://github.com/njtierney/conmat/issues/7)
* Implement parallelisation with `furrr`. Resolves [#31](https://github.com/njtierney/conmat/issues/31)
* Change argument of `fit_setting_contacts` from `survey_population` to just `population`
* Reduce vignette size, closes [#28](https://github.com/njtierney/conmat/issues/28)
* Add transmission probability data from Eyre et al., closes [#39](https://github.com/njtierney/conmat/issues/39)
* Add household adjustment - [#41](https://github.com/njtierney/conmat/issues/41)
* Added setting weights, related to #44 (but no longer Eyre weights)
* Added `apply_vaccination` to take in vaccination rates of ages and apply to contact matrices [#40](https://github.com/njtierney/conmat/issues/40)
* Data from `get_polymod_population` has been revised as a result of the [socialmixr package](https://github.com/epiforecasts/socialmixr/blob/main/NEWS.md) being updated to version 0.2.0, where the world population data has been updated to 2017 by switching from the wpp2015 to wpp2017 package. We have explored the new data and found it to be very similar and should not introduce any errant errors. See the exploration [here](https://gist.github.com/njtierney/4862fa73abab97093d779fa7f2904d11).
* Added new print methods for: `conmat_setting_prediction_matrix`, `conmat_prediction_matrix`, `ngm_setting_matrix`, `setting_contact_model`, `setting_vaccination_matrix`, and `setting_data`, see #116. Main change is that list objects don't return the entire list and output but a summary of the list contents and details on what that object contains.
* Added a new S3 method for `conmat_population` to avoid fragile use of the `lower.age.limit` variable name. This resolves #77.

