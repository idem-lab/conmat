# Changelog

## conmat 0.1.0

### Changes

- Adds new functions:

  - [`age_breaks()`](https://idem-lab.github.io/conmat/reference/age_breaks.md)
    accessor function for `conmat_setting_prediction_matrix`
  - [`setting_prediction_matrix()`](https://idem-lab.github.io/conmat/reference/setting_prediction_matrix.md)
  - [`as_setting_prediction_matrix()`](https://idem-lab.github.io/conmat/reference/as_setting_prediction_matrix.md)
    for coercing lists into a `setting_prediction_matrix`
  - [`transmission_probability_matrix()`](https://idem-lab.github.io/conmat/reference/transmission_probability_matrix.md)
    for creating new transmission probability matrices
  - [`partial_effects()`](https://idem-lab.github.io/conmat/reference/partial-prediction.md)
    and
    [`partial_effects_sum()`](https://idem-lab.github.io/conmat/reference/partial-prediction-sum.md)
    to provide partial predictions allow you to explore and understand
    the impact of each of the covariates used in the conmat GAM model.
    ([\#88](https://github.com/idem-lab/conmat/issues/88)).

- there is now a print method for age group information in setting
  matrices - [\#139](https://github.com/idem-lab/conmat/issues/139)

- improved age break checking
  [\#138](https://github.com/idem-lab/conmat/issues/138)

- extended
  [`add_school_work_participation()`](https://idem-lab.github.io/conmat/reference/add_school_work_participation.md),
  [`add_modelling_features()`](https://idem-lab.github.io/conmat/reference/add_modelling_features.md),
  [`fit_single_contact_model()`](https://idem-lab.github.io/conmat/reference/fit_single_contact_model.md),
  [`fit_setting_contacts()`](https://idem-lab.github.io/conmat/reference/fit_setting_contacts.md),
  [`estimate_setting_contacts()`](https://idem-lab.github.io/conmat/reference/estimate_setting_contacts.md)
  to use different school and work demographics arguments.
  ([\#82](https://github.com/idem-lab/conmat/issues/82) and
  [\#15](https://github.com/idem-lab/conmat/issues/15), resolved by
  [\#153](https://github.com/idem-lab/conmat/issues/153)).

- exports
  [`new_ngm_setting_matrix()`](https://idem-lab.github.io/conmat/reference/new_ngm_setting_matrix.md)
  and
  [`new_setting_data()`](https://idem-lab.github.io/conmat/reference/new_setting_data.md)

- Exports new
  [`age_breaks()`](https://idem-lab.github.io/conmat/reference/age_breaks.md)
  method for class `setting_contact_model` (used in
  [`fit_setting_contacts()`](https://idem-lab.github.io/conmat/reference/fit_setting_contacts.md)).

- use \|\> over %\>%
  ([\#206](https://github.com/idem-lab/conmat/issues/206))

- Resolve
  [`dplyr::case_when()`](https://dplyr.tidyverse.org/reference/case-and-replace-when.html)
  issue ([\#207](https://github.com/idem-lab/conmat/issues/207))

### Breaking changes

- change `get_per_capita_household_size` to
  `get_abs_per_capita_household_size`
- change `get_data_abs_age_work` to `abs_age_work`
- change `get_data_abs_age_education` to `abs_age_education`
- change `get_household_size_distribution` -\>
  `get_abs_household_size_distribution`
- change `abs_household_size_population` -\>
  `get_abs_household_size_population`
- change `abs_per_capita_household_size_lga` -\>
  `get_abs_per_capita_household_size_lga`
- change `abs_per_capita_household_size_state` -\>
  `get_abs_per_capita_household_size_state`
- `abbreviate_states` -\> `abs_abbreviate_states`
- `unabbreviate_states` -\> `abs_unabbreviate_states`

## conmat 0.0.1.9000

### Changes

- new `conmat_age_matrix` class, replaces `conmat_prediction_matrix`,
  knows about its age breaks
- accessor method,
  [`age_breaks()`](https://idem-lab.github.io/conmat/reference/age_breaks.md),
  which accesses age break information
- updated autoplot method for `conmat_age_matrix`
- accessor method,
  [`raw_eigenvalue()`](https://idem-lab.github.io/conmat/reference/raw_eigenvalue.md)
  for getting the raw eigenvalue from a next generation matrix,
  “ngm_setting_matrix”.
- accessor method, `scaling` for getting the value of R_target/raw
  eigenvalue.
- add `autoplot` methods for ngm, vaccination, and transmission
  probability

### Breaking Changes

- `generate_ngm` no longer accepts LGA or state inputs, which now occurs
  in `generate_ngm_oz`. The `generate_ngm` function has had S3 methods
  created for it, so it can take input from `conmat_population` (such as
  the output from \[abs_age_lga()\]), or a
  `conmat_setting_prediction_matrix`, which is the output from
  \[extrapolate_polymod()\] or \[predict_setting_contacts()\].

## conmat 0.0.0.9004

- Added a `NEWS.md` file to track changes to the package.
- Decouple prediction and estimation of models with
  `fit_setting_contacts` to fit models, and `predict_setting_contacts`
  to predict. Fixes [\#7](https://github.com/idem-lab/conmat/issues/7)
- Implement parallelisation with `furrr`. Resolves
  [\#31](https://github.com/idem-lab/conmat/issues/31)
- Change argument of `fit_setting_contacts` from `survey_population` to
  just `population`
- Reduce vignette size, closes
  [\#28](https://github.com/idem-lab/conmat/issues/28)
- Add transmission probability data from Eyre et al., closes
  [\#39](https://github.com/idem-lab/conmat/issues/39)
- Add household adjustment -
  [\#41](https://github.com/idem-lab/conmat/issues/41)
- Added setting weights, related to
  [\#44](https://github.com/idem-lab/conmat/issues/44) (but no longer
  Eyre weights)
- Added `apply_vaccination` to take in vaccination rates of ages and
  apply to contact matrices
  [\#40](https://github.com/idem-lab/conmat/issues/40)
- Data from `get_polymod_population` has been revised as a result of the
  [socialmixr
  package](https://github.com/epiforecasts/socialmixr/blob/main/NEWS.md)
  being updated to version 0.2.0, where the world population data has
  been updated to 2017 by switching from the wpp2015 to wpp2017 package.
  We have explored the new data and found it to be very similar and
  should not introduce any errant errors. See the exploration
  [here](https://gist.github.com/njtierney/4862fa73abab97093d779fa7f2904d11).
- Added new print methods for: `conmat_setting_prediction_matrix`,
  `conmat_prediction_matrix`, `ngm_setting_matrix`,
  `setting_contact_model`, `setting_vaccination_matrix`, and
  `setting_data`, see
  [\#116](https://github.com/idem-lab/conmat/issues/116). Main change is
  that list objects don’t return the entire list and output but a
  summary of the list contents and details on what that object contains.
- Added a new S3 method for `conmat_population` to avoid fragile use of
  the `lower.age.limit` variable name. This resolves
  [\#77](https://github.com/idem-lab/conmat/issues/77).
