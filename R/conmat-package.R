#' @keywords internal
#' @importFrom stats predict
"_PACKAGE"

# generics to re-export

#' @importFrom ggplot2 autoplot
#' @export
ggplot2::autoplot

#' @import rlang

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
    "abs_avg_school",
    "abs_avg_work",
    "acquisition_multiplier",
    "across",
    "age",
    "age_from",
    "age_group",
    "age_group_from",
    "age_group_to",
    "age_to",
    "bin_width",
    "bounded",
    "case_age",
    "clinical_fraction",
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
    "data_abs_lga_education",
    "data_abs_lga_work",
    "data_abs_state_education",
    "data_abs_state_work",
    "davies_age_extended",
    "events_activities",
    "everything",
    "eyre_transmission_probabilities",
    "fraction",
    "get_polymod_percapita_household_size",
    "household",
    "household_size",
    "infectiousness",
    "lga",
    "log_pop",
    "log_pred",
    "lower.age.limit",
    "max_bound_pop",
    "max_years_over",
    "midpoint",
    "missing_any_contact_age",
    "missing_any_contact_setting",
    "model_per_capita_household_size",
    "modelled_pop",
    "na.omit",
    "n_households",
    "n_people",
    "n_persons_usually_resident",
    "part_age",
    "part_id",
    "participants",
    "per_capita_household_size",
    "polymod_setting_models",
    "pop_age_from",
    "pop_age_to",
    "population",
    "pred_adj",
    "predict",
    "probability",
    "ratio",
    "required_pop",
    "school_fraction",
    "school_fraction_age_from",
    "school_fraction_age_to",
    "school_probability",
    "school_weighted_pop_fraction",
    "school_year_probability",
    "se_contacts",
    "setting",
    "setting_weights",
    "size",
    "smooth.spline",
    "state",
    "susceptibility",
    "target_weight_sum",
    "transmission_multiplier",
    "update",
    "upper.age.limit",
    "weight",
    "weight_sum",
    "work_education",
    "work_fraction",
    "work_fraction_age_from",
    "work_fraction_age_to",
    "year",
    "years_over"
  )
)
