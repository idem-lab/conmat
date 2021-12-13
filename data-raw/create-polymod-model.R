library(conmat)
polymod_contact_data <- get_polymod_setting_data()
polymod_survey_data <- get_polymod_population()

polymod_setting_models <- fit_setting_contacts(
  contact_data_list = polymod_contact_data,
  population = polymod_survey_data
  )

use_data(polymod_setting_models)
