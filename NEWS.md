# conmat 0.0.0.9004

* Added a `NEWS.md` file to track changes to the package.
* Decouple prediction and estimation of models with `fit_setting_contacts` to 
  fit models, and `predict_setting_contacts` to predict. Fixes [#7](https://github.com/njtierney/conmat/issues/7)
* Implement parallelisation with `furrr`. Resolves [#31](https://github.com/njtierney/conmat/issues/31)
* Change argument of `fit_setting_contacts` from `survey_population` to just `population`
* Reduce vignette size, closes [#28](https://github.com/njtierney/conmat/issues/28)
* Add transmission probability data from Eyre et al., closes [#39](https://github.com/njtierney/conmat/issues/39)
* Add household adjustment - [#41](https://github.com/njtierney/conmat/issues/41)