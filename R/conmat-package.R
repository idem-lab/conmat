#' @keywords internal
#' @importFrom stats predict
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL

if (getRversion() >= "2.15.1") utils::globalVariables(c("."))
globalVariables(
  c(
    "abs_household_lga",
    "abs_pop_age_lga_2020",
    "across",
    "age_from",
    "age_group",
    "age_group_from",
    "age_group_to",
    "age_to",
    "case_age",
    "cnt_age",
    "cnt_age_est_max",
    "cnt_age_est_min",
    "cnt_home",
    "cnt_leisure",
    "cnt_otherplace",
    "cnt_school",
    "cnt_transport",
    "cnt_work",
    "contact_age",
    "contacted",
    "contacts",
    "country",
    "events_activities",
    "everything",
    "eyre_transmission_probabilities",
    "fraction",
    "get_polymod_percapita_household_size",
    "household",
    "lga",
    "lower.age.limit",
    "missing_any_contact_age",
    "missing_any_contact_setting",
    "model_per_capita_household_size",
    "n_households",
    "n_people",
    "n_persons_usually_resident",
    "part_age",
    "part_id",
    "participants",
    "per_capita_household_size",
    "pop_age_from",
    "pop_age_to",
    "population",
    "predict",
    "probability",
    "school_fraction_age_from",
    "school_fraction_age_to",
    "se_contacts",
    "setting",
    "setting_weights",
    "size",
    "state",
    "weight",
    "work_education",
    "work_fraction_age_from",
    "work_fraction_age_to",
    "year"
  )
)
