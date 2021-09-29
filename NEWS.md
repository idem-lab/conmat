# conmat 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
* decouple prediction and estimation of models with `fit_setting_contacts` to 
  fit models, and `predict_setting_contacts` to predict. Fixes [#7](https://github.com/njtierney/conmat/issues/7)
* implement parallelisation with `furrr`. Resolves [#31](https://github.com/njtierney/conmat/issues/31)
* change argument of `fit_setting_contacts` from `survey_population` to just `population`
* reduce vignette size, closes [#28](https://github.com/njtierney/conmat/issues/28)
* Add missing LGAs, closes [#37](https://github.com/njtierney/conmat/issues/37)