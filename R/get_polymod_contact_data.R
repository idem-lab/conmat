#' @title Format POLYMOD data and filter contacts to certain settings
#'
#' @description Provides contact and participant POLYMOD data from selected
#'   countries. It impute missing contact ages via one of three methods:
#'   1) imputing contact ages from a random uniform distribution from the range
#'   of ages. 2) using the average of the ages, 3) removal of those
#'   participants. The contact  settings are then classified as "home",
#'   "school", "work" and "others", where "others" include locations such as
#'   leisure, transport or other places. The participants with missing contact
#'   ages or settings are removed, and the number of contacts per participant
#'   and contact age from ages 0-100 are obtained for various countries and
#'   settings.
#'
#' @param setting Which setting to extract data from. Default is all settings.
#'    Options are: "all", "home", "work", "school", and "other".
#' @param countries countries to extract data from. Default is all countries
#'   from this list: "Belgium", "Finland", "Germany", "Italy", "Luxembourg",
#'   "Netherlands", "Poland", and "United Kingdom".
#' @param ages Which ages to return. Default is ages 0 to 100.
#' @param contact_age_imputation How to handle age when it is missing. Choose
#'   one of three methods: 1) "sample", which imputes contact ages from a
#'   random uniform distribution from the range of ages. 2) "mean", use the
#'   average of the ages, 3) "remove_participant" removal of those
#'   participants. Default is "sample".
#' @return A data.frame with columns: "setting" (all, work, home, etc. as
#'   specified in "setting" argument); "age_from" - the age of the participant;
#'   "age_to" - the age of the person the participant had contact with;
#'   "contacts" the number of contacts that person had; "participants" the
#'   number of participants in that row.
#' @examples
#' get_polymod_contact_data()
#' get_polymod_contact_data(setting = "home")
#' get_polymod_contact_data(countries = "Belgium")
#' get_polymod_contact_data(countries = c("Belgium", "Italy"))
#' get_polymod_contact_data(ages = 0:50)
#' get_polymod_contact_data(contact_age_imputation = "sample")
#' get_polymod_contact_data(contact_age_imputation = "mean")
#' get_polymod_contact_data(contact_age_imputation = "remove_participant")
#' @export
get_polymod_contact_data <- function(setting = c("all", "home", "work", "school", "other"),
                                     countries = c(
                                       "Belgium",
                                       "Finland",
                                       "Germany",
                                       "Italy",
                                       "Luxembourg",
                                       "Netherlands",
                                       "Poland",
                                       "United Kingdom"
                                     ),
                                     ages = 0:100,
                                     contact_age_imputation = c("sample", "mean", "remove_participant")) {
  setting <- match.arg(setting)
  contact_age_imputation <- match.arg(contact_age_imputation)

  contact_data <- polymod$participants %>%
    dplyr::filter(
      country %in% countries
    ) %>%
    dplyr::left_join(
      socialmixr::polymod$contacts,
      by = "part_id"
    )

  # impute contact ages according to the required method
  contact_data_imputed <- contact_data %>%
    dplyr::mutate(
      cnt_age_sampled = floor(
        # suppress warnings about NAs in runif
        suppressWarnings(
          stats::runif(
            n = dplyr::n(),
            min = cnt_age_est_min,
            max = cnt_age_est_max + 1
          )
        )
      ),
      cnt_age_mean = floor(
        cnt_age_est_min + (cnt_age_est_max + 1 - cnt_age_est_min) / 2
      ),
      cnt_age = dplyr::case_when(
        !is.na(cnt_age_exact) ~ as.numeric(cnt_age_exact),
        contact_age_imputation == "sample" ~ cnt_age_sampled,
        contact_age_imputation == "mean" ~ cnt_age_mean,
        TRUE ~ NA_real_
      ),
    )

  # filter out any participants with missing contact ages or settings (can't
  # just remove the contacts as that will bias the count)
  contact_data_filtered <- contact_data_imputed %>%
    dplyr::group_by(part_id) %>%
    dplyr::mutate(
      missing_any_contact_age = any(is.na(cnt_age)),
      missing_any_contact_setting = any(
        is.na(cnt_home) |
          is.na(cnt_work) |
          is.na(cnt_school) |
          is.na(cnt_transport) |
          is.na(cnt_leisure) |
          is.na(cnt_otherplace)
      )
    ) %>%
    dplyr::ungroup() %>%
    dplyr::filter(
      !is.na(part_age),
      !missing_any_contact_age,
      !missing_any_contact_setting
    )

  # get contacts by setting (keeping 0s, so we can record 0 contacts for some individuals)
  contact_data_setting <- contact_data_filtered %>%
    dplyr::mutate(
      contacted = dplyr::case_when(
        setting == "all" ~ 1L,
        setting == "home" ~ cnt_home,
        setting == "school" ~ cnt_school,
        setting == "work" ~ cnt_work,
        setting == "other" ~ pmax(cnt_transport, cnt_leisure, cnt_otherplace),
      )
    )

  # collapse down number of contacts per participant and contact age
  contact_data_setting %>%
    dplyr::select(
      part_id,
      age_from = part_age,
      age_to = cnt_age,
      contacted
    ) %>%
    tidyr::complete(
      tidyr::nesting(age_from, part_id),
      age_to = ages,
      fill = list(contacted = 0)
    ) %>%
    dplyr::group_by(
      age_from,
      age_to
    ) %>%
    dplyr::summarise(
      contacts = sum(contacted),
      participants = dplyr::n_distinct(part_id),
      .groups = "drop"
    ) %>%
    # add the setting information, so models can act differently for each
    # setting
    dplyr::mutate(
      setting = setting,
      .before = dplyr::everything()
    )
}
