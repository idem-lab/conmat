# Plot setting matrices using ggplot2

Plot setting matrices using ggplot2

## Usage

``` r
# S3 method for class 'conmat_age_matrix'
autoplot(object, ..., title = "Contact Matrices")

# S3 method for class 'conmat_setting_prediction_matrix'
autoplot(object, ..., title = "Setting-specific synthetic contact matrices")

# S3 method for class 'transmission_probability_matrix'
autoplot(
  object,
  ...,
  title = "Setting-specific transmission probability matrices"
)

# S3 method for class 'ngm_setting_matrix'
autoplot(object, ..., title = "Setting-specific NGM matrices")

# S3 method for class 'setting_vaccination_matrix'
autoplot(object, ..., title = "Setting-specific vaccination matrices")
```

## Arguments

- object:

  A matrix or a list of square matrices, with row and column names
  indicating the age groups.

- ...:

  Other arguments passed on

- title:

  Title to give to plot setting matrices. Defaults are provided for
  certain objects

## Value

a ggplot visualisation of contact rates

## Examples

``` r
if (interactive()) {
  polymod_contact_data <- get_polymod_setting_data()
  polymod_survey_data <- get_polymod_population()

  setting_models <- fit_setting_contacts(
    contact_data_list = polymod_contact_data,
    population = polymod_survey_data
  )

  fairfield <- abs_age_lga("Fairfield (C)")

  fairfield_hh_size <-
    get_abs_per_capita_household_size(lga = "Fairfield (C)")

  synthetic_settings_5y_fairfield_hh <- predict_setting_contacts(
    population = fairfield,
    contact_model = setting_models,
    age_breaks = c(seq(0, 85, by = 5), Inf),
    per_capita_household_size = fairfield_hh_size
  )

  # Plotting synthetic contact matrices across all settings

  autoplot(
    object = synthetic_settings_5y_fairfield_hh,
    title = "Setting specific synthetic contact matrices"
  )

  # Work setting specific synthetic contact matrices
  autoplot(
    object = synthetic_settings_5y_fairfield_hh$work,
    title = "Work"
  )
}
```
