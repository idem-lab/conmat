# Package index

## Core functions

These are the core functions that we intend users to interface with

- [`extrapolate_polymod()`](https://idem-lab.github.io/conmat/dev/reference/extrapolate_polymod.md)
  : Fit all-of-polymod model and extrapolate to a given population an
  age breaks
- [`apply_vaccination()`](https://idem-lab.github.io/conmat/dev/reference/apply_vaccination.md)
  : Apply vaccination effects to next generation contact matrices
- [`generate_ngm()`](https://idem-lab.github.io/conmat/dev/reference/generate_ngm.md)
  : Calculate next generation contact matrices
- [`generate_ngm_oz()`](https://idem-lab.github.io/conmat/dev/reference/generate_ngm_oz.md)
  : Calculate next generation contact matrices from ABS data
- [`reexports`](https://idem-lab.github.io/conmat/dev/reference/reexports.md)
  [`autoplot`](https://idem-lab.github.io/conmat/dev/reference/reexports.md)
  : Objects exported from other packages
- [`autoplot(`*`<conmat_age_matrix>`*`)`](https://idem-lab.github.io/conmat/dev/reference/autoplot-conmat.md)
  [`autoplot(`*`<conmat_setting_prediction_matrix>`*`)`](https://idem-lab.github.io/conmat/dev/reference/autoplot-conmat.md)
  [`autoplot(`*`<transmission_probability_matrix>`*`)`](https://idem-lab.github.io/conmat/dev/reference/autoplot-conmat.md)
  [`autoplot(`*`<ngm_setting_matrix>`*`)`](https://idem-lab.github.io/conmat/dev/reference/autoplot-conmat.md)
  [`autoplot(`*`<setting_vaccination_matrix>`*`)`](https://idem-lab.github.io/conmat/dev/reference/autoplot-conmat.md)
  : Plot setting matrices using ggplot2
- [`autoplot(`*`<partial_predictions_sum>`*`)`](https://idem-lab.github.io/conmat/dev/reference/autoplot-conmat-partial.md)
  [`autoplot(`*`<setting_partial_predictions_sum>`*`)`](https://idem-lab.github.io/conmat/dev/reference/autoplot-conmat-partial.md)
  [`autoplot(`*`<partial_predictions>`*`)`](https://idem-lab.github.io/conmat/dev/reference/autoplot-conmat-partial.md)
  [`autoplot(`*`<setting_partial_predictions>`*`)`](https://idem-lab.github.io/conmat/dev/reference/autoplot-conmat-partial.md)
  : Plot partial predictive plots using ggplot2

## ABS Data accessors and helpers

Functions and data objects to access data from the Australian Bureau of
Statistics

- [`abs_age_education_state()`](https://idem-lab.github.io/conmat/dev/reference/abs-age-education.md)
  [`abs_age_education_lga()`](https://idem-lab.github.io/conmat/dev/reference/abs-age-education.md)
  : Return data on educated population for a given age and state or lga
  of Australia.
- [`abs_age_work_lga()`](https://idem-lab.github.io/conmat/dev/reference/abs-age-work.md)
  [`abs_age_work_state()`](https://idem-lab.github.io/conmat/dev/reference/abs-age-work.md)
  : Return data on employed population for a given age and state or lga
  of Australia
- [`abs_abbreviate_states()`](https://idem-lab.github.io/conmat/dev/reference/abs_abbreviate_states.md)
  : Abbreviate Australian State Names
- [`abs_age_lga()`](https://idem-lab.github.io/conmat/dev/reference/abs_age_data.md)
  [`abs_age_state()`](https://idem-lab.github.io/conmat/dev/reference/abs_age_data.md)
  : Return Australian Bureau of Statistics (ABS) age population data for
  a given Local Government Area (LGA) or state
- [`abs_avg_school`](https://idem-lab.github.io/conmat/dev/reference/abs_avg_school.md)
  : ABS education data for 2016
- [`abs_avg_work`](https://idem-lab.github.io/conmat/dev/reference/abs_avg_work.md)
  : ABS work data for 2016
- [`abs_education_state`](https://idem-lab.github.io/conmat/dev/reference/abs_education_state.md)
  : ABS education by state for 2006-2020
- [`abs_education_state_2020`](https://idem-lab.github.io/conmat/dev/reference/abs_education_state_2020.md)
  : 2020 ABS education population data, interpolated into 1 year bins,
  by state.
- [`abs_employ_age_lga`](https://idem-lab.github.io/conmat/dev/reference/abs_employ_age_lga.md)
  : ABS employment by age and LGA for 2016
- [`abs_household_lga`](https://idem-lab.github.io/conmat/dev/reference/abs_household_lga.md)
  : ABS household data for 2016
- [`abs_lga_lookup`](https://idem-lab.github.io/conmat/dev/reference/abs_lga_lookup.md)
  : ABS lookup table of states, lga code and lga name
- [`abs_pop_age_lga_2016`](https://idem-lab.github.io/conmat/dev/reference/abs_pop_age_lga_2016.md)
  : ABS population by age for 2016 for LGAs
- [`abs_pop_age_lga_2020`](https://idem-lab.github.io/conmat/dev/reference/abs_pop_age_lga_2020.md)
  : ABS population by age for 2020 for LGAs
- [`abs_state_age`](https://idem-lab.github.io/conmat/dev/reference/abs_state_age.md)
  : ABS state population data for 2020
- [`abs_unabbreviate_states()`](https://idem-lab.github.io/conmat/dev/reference/abs_unabbreviate_states.md)
  : Un-abbreviate Australian state names
- [`data_abs_lga_education`](https://idem-lab.github.io/conmat/dev/reference/data_abs_lga_education.md)
  : LGA wise ABS education population data on different ages for year
  2016
- [`data_abs_lga_work`](https://idem-lab.github.io/conmat/dev/reference/data_abs_lga_work.md)
  : LGA wise ABS work population data on different ages for year 2016
- [`data_abs_state_education`](https://idem-lab.github.io/conmat/dev/reference/data_abs_state_education.md)
  : State wise ABS education population data on different ages for year
  2016
- [`data_abs_state_work`](https://idem-lab.github.io/conmat/dev/reference/data_abs_state_work.md)
  : State wise ABS work population data on different ages for year 2016
- [`get_abs_household_size_distribution()`](https://idem-lab.github.io/conmat/dev/reference/get_abs_household_size_distribution.md)
  : Get household size distribution based on state or LGA name
- [`get_abs_household_size_population()`](https://idem-lab.github.io/conmat/dev/reference/get_abs_household_size_population.md)
  : Get population associated with each household size in an LGA or a
  state
- [`get_abs_per_capita_household_size()`](https://idem-lab.github.io/conmat/dev/reference/get_abs_per_capita_household_size.md)
  : Get per capita household size based on state or LGA name
- [`get_abs_per_capita_household_size_lga()`](https://idem-lab.github.io/conmat/dev/reference/get_abs_per_capita_household_size_lga.md)
  : Get household size distribution based on LGA name
- [`get_abs_per_capita_household_size_state()`](https://idem-lab.github.io/conmat/dev/reference/get_abs_per_capita_household_size_state.md)
  : Get household size distribution based on state name

## Data and model objects

Functions and objects for accessing data, models, and assisting with
model fitting.

- [`get_polymod_contact_data()`](https://idem-lab.github.io/conmat/dev/reference/get_polymod_contact_data.md)
  : Format POLYMOD data and filter contacts to certain settings

- [`get_polymod_per_capita_household_size()`](https://idem-lab.github.io/conmat/dev/reference/get_polymod_per_capita_household_size.md)
  : Get polymod per capita household size.

- [`get_polymod_population()`](https://idem-lab.github.io/conmat/dev/reference/get_polymod_population.md)
  : Return the polymod-average population age distribution in 5y

- [`get_polymod_setting_data()`](https://idem-lab.github.io/conmat/dev/reference/get_polymod_setting_data.md)
  : Get polymod setting data

- [`age_population()`](https://idem-lab.github.io/conmat/dev/reference/age_population.md)
  : Get cleaned population data with lower and upper limits of age.

- [`vaccination_effect_example_data`](https://idem-lab.github.io/conmat/dev/reference/vaccination_effect_example_data.md)
  : Example dataset with information on age based vaccination coverage,
  acquisition and transmission

- [`polymod_setting_models`](https://idem-lab.github.io/conmat/dev/reference/polymod_setting_models.md)
  : Polymod Settings models

- [`davies_age_extended`](https://idem-lab.github.io/conmat/dev/reference/davies_age_extended.md)
  : Susceptibility and clinical fraction parameters from Davies et al.

- [`eyre_transmission_probabilities`](https://idem-lab.github.io/conmat/dev/reference/eyre_transmission_probabilities.md)
  : Transmission probabilities of COVID19 from Eyre et al.

- [`polymod`](https://idem-lab.github.io/conmat/dev/reference/polymod.md)
  :

  Social contact data from 8 European countries (imported from
  `socialmixr`)

- [`setting_weights`](https://idem-lab.github.io/conmat/dev/reference/setting_weights.md)
  : Setting weights computed for transmission probabilities.

- [`age_group_lookup`](https://idem-lab.github.io/conmat/dev/reference/age_group_lookup.md)
  : Lookup table of age groups in 5 year bins

- [`get_setting_transmission_matrices()`](https://idem-lab.github.io/conmat/dev/reference/get_setting_transmission_matrices.md)
  : Get Setting Transmission Matrices

- [`prem_germany_contact_matrices`](https://idem-lab.github.io/conmat/dev/reference/prem_germany_contact_matrices.md)
  : Contact matrices as calculated by Prem. et al.

- [`conmat_original_school_demographics`](https://idem-lab.github.io/conmat/dev/reference/conmat_original_school_demographics.md)
  : Original school demographics for conmat

- [`conmat_original_work_demographics`](https://idem-lab.github.io/conmat/dev/reference/conmat_original_work_demographics.md)
  : Original work demographics for conmat

- [`abs_avg_school`](https://idem-lab.github.io/conmat/dev/reference/abs_avg_school.md)
  : ABS education data for 2016

- [`abs_avg_work`](https://idem-lab.github.io/conmat/dev/reference/abs_avg_work.md)
  : ABS work data for 2016

## Extra functions for model fitting and prediction

Functions for model fitting and predictions - for more advanced use

- [`fit_single_contact_model()`](https://idem-lab.github.io/conmat/dev/reference/fit_single_contact_model.md)
  : Fit a single GAM contact model to a dataset
- [`fit_setting_contacts()`](https://idem-lab.github.io/conmat/dev/reference/fit_setting_contacts.md)
  : Fit a contact model to a survey population
- [`aggregate_predicted_contacts()`](https://idem-lab.github.io/conmat/dev/reference/aggregate_predicted_contacts.md)
  : Aggregate predicted contacts to specified age breaks
- [`estimate_setting_contacts()`](https://idem-lab.github.io/conmat/dev/reference/estimate_setting_contacts.md)
  : Get predicted setting specific as well as combined contact matrices
- [`predict_contacts()`](https://idem-lab.github.io/conmat/dev/reference/predict_contacts.md)
  : Predict contact rate between two age populations, given some model.
- [`predict_contacts_1y()`](https://idem-lab.github.io/conmat/dev/reference/predict_contacts_1y.md)
  : Predict contact rate to a given population at full 1y resolution
- [`predict_setting_contacts()`](https://idem-lab.github.io/conmat/dev/reference/predict_setting_contacts.md)
  : Predict setting contacts
- [`predictions_to_matrix()`](https://idem-lab.github.io/conmat/dev/reference/predictions_to_matrix.md)
  : Convert dataframe of predicted contacts into matrix
- [`matrix_to_predictions()`](https://idem-lab.github.io/conmat/dev/reference/matrix_to_predictions.md)
  : Convert a contact matrix as output into a long-form tibble
- [`get_age_population_function()`](https://idem-lab.github.io/conmat/dev/reference/get_age_population_function.md)
  : Return an interpolating function for populations in 1y age
  increments
- [`per_capita_household_size()`](https://idem-lab.github.io/conmat/dev/reference/per_capita_household_size.md)
  : Get per capita household size with household size distribution
- [`add_intergenerational()`](https://idem-lab.github.io/conmat/dev/reference/add_intergenerational.md)
  : Add column, "intergenerational"
- [`add_modelling_features()`](https://idem-lab.github.io/conmat/dev/reference/add_modelling_features.md)
  : Add features required for modelling to the dataset
- [`add_offset()`](https://idem-lab.github.io/conmat/dev/reference/add_offset.md)
  : Adds offset variables
- [`add_population_age_to()`](https://idem-lab.github.io/conmat/dev/reference/add_population_age_to.md)
  : Add the population distribution for contact ages.
- [`add_school_work_participation()`](https://idem-lab.github.io/conmat/dev/reference/add_school_work_participation.md)
  : Add columns describing the fractions of the population in each age
  group that attend school/work (average FTE)
- [`add_symmetrical_features()`](https://idem-lab.github.io/conmat/dev/reference/add_symmetrical_features.md)
  : Add symmetrical, age based features
- [`partial_effects()`](https://idem-lab.github.io/conmat/dev/reference/partial-prediction.md)
  [`partial_effects_sum(`*`<setting_contact_model>`*`)`](https://idem-lab.github.io/conmat/dev/reference/partial-prediction.md)
  : Create partial predictions and partial prediction plots.
- [`partial_effects_sum()`](https://idem-lab.github.io/conmat/dev/reference/partial-prediction-sum.md)
  : Create partial predictive plots for a set of fitted models.

## Creating and accessing information on `conmat_population` objects

Store and use age and population information in a dataframe for use in
other functions in conmat.

- [`conmat_population()`](https://idem-lab.github.io/conmat/dev/reference/conmat_population.md)
  : Define a conmat population
- [`as_conmat_population()`](https://idem-lab.github.io/conmat/dev/reference/as_conmat_population.md)
  : Convert to conmat population
- [`age()`](https://idem-lab.github.io/conmat/dev/reference/accessors.md)
  [`age_label()`](https://idem-lab.github.io/conmat/dev/reference/accessors.md)
  [`population_label()`](https://idem-lab.github.io/conmat/dev/reference/accessors.md)
  [`population()`](https://idem-lab.github.io/conmat/dev/reference/accessors.md)
  : Accessing conmat attributes
- [`age_breaks()`](https://idem-lab.github.io/conmat/dev/reference/age_breaks.md)
  : Extract age break attribute information
- [`raw_eigenvalue()`](https://idem-lab.github.io/conmat/dev/reference/raw_eigenvalue.md)
  : Get raw eigvenvalue from NGM matrix
- [`scaling()`](https://idem-lab.github.io/conmat/dev/reference/scaling.md)
  : Get the scaling from NGM matrix
- [`new_age_matrix()`](https://idem-lab.github.io/conmat/dev/reference/new_age_matrix.md)
  : Build new age matrix
- [`new_ngm_setting_matrix()`](https://idem-lab.github.io/conmat/dev/reference/new_ngm_setting_matrix.md)
  : Establish new BGM setting data
- [`new_setting_data()`](https://idem-lab.github.io/conmat/dev/reference/new_setting_data.md)
  : Establish new setting data
- [`setting_prediction_matrix()`](https://idem-lab.github.io/conmat/dev/reference/setting_prediction_matrix.md)
  : Create a setting prediction matrix
- [`as_setting_prediction_matrix()`](https://idem-lab.github.io/conmat/dev/reference/as_setting_prediction_matrix.md)
  : Coerce object to a setting prediction matrix
- [`transmission_probability_matrix()`](https://idem-lab.github.io/conmat/dev/reference/transmission_probability_matrix.md)
  : Create a setting transmission matrix
