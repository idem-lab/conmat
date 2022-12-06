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
