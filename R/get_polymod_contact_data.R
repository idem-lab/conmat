#' Format polymod data and filter contacts to certain settings
#'
#' @param setting PARAM_DESCRIPTION, Default: c("all", "home", "work", "school", "other")
#' @param ages PARAM_DESCRIPTION, Default: 0:100
#' @param contact_age_imputation PARAM_DESCRIPTION, Default: c("sample", "mean", "remove_participant")
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # EXAMPLE1
#' }
#' }
#' @export
get_polymod_contact_data <- function(setting = c("all", "home", "work", "school", "other"),
                                     countries = c("Belgium", "Finland", "Germany", "Italy", "Luxembourg", "Netherlands", 
                                                 "Poland", "United Kingdom"),
                                     ages = 0:100,
                                     contact_age_imputation = c("sample", "mean", "remove_participant")) {
  setting <- match.arg(setting)
  contact_age_imputation <- match.arg(contact_age_imputation)

  contact_data <- polymod$participants %>%
    filter(
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
    )
}
