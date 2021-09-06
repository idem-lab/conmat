# build synthetic age-structured contact matrices with GAMs

library(tidyverse)
library(mgcv)
library(patchwork)
library(socialmixr)

# return the polymod-average population age distribution in 5y
# increments (weight country population distributions by number of participants)
# note that we don't want to weight by survey age distributions for this, since
# the total number of *participants* represents the sampling
get_polymod_population <- function() {
  
  polymod$participants %>%
    dplyr::filter(
      !is.na(year)
    ) %>%
    dplyr::group_by(
      country,
      year
    ) %>%
    dplyr::summarise(
      participants = dplyr::n(),
      .groups = "drop"
    ) %>%
    dplyr::left_join(
      socialmixr::wpp_age(),
      by = c("country", "year")
    ) %>%
    dplyr::filter(
      !is.na(lower.age.limit)
    ) %>%
    dplyr::group_by(
      lower.age.limit
    ) %>%
    dplyr::summarise(
      population = stats::weighted.mean(population, participants)
    )
  
}

# apply a 45 degree rotation to age contact pairs, to model trends along the
# diagonal, and perpendicularly across the diagonal
add_rotated_ages <- function(contact_data) {
  theta <- pi / 4
  contact_data %>%
    dplyr::mutate(
      along_diagonal = age_from * cos(theta) + age_to * cos(theta),
      across_diagonal = age_from * cos(theta) - age_to * sin(theta)
    )
}

# add fractions of the population in each age group that attend school/work
# (average FTE), to compute the probability that both participant and contact
# attend school/work
add_school_work_participation <- function(contact_data) {
  contact_data %>%
    dplyr::mutate(
      dplyr::across(
        dplyr::starts_with("age"),
        .fns = list(
          # made up example - replace with education statistics
          school_fraction = ~ dplyr::case_when(
            # preschool
            .x %in% 2:4 ~ 0.5,
            # compulsory education
            .x %in% 5:16 ~ 1,
            # voluntary education
            .x %in% 17:18 ~ 0.5,
            # university
            .x %in% 19:25 ~ 0.1,
            # other
            TRUE ~ 0.05
          ),
          # made up example - replace with labour force statistics
          work_fraction = ~ dplyr::case_when(
            # child labour
            .x %in% 12:19 ~ 0.2,
            # young adults (not at school)
            .x %in% 20:24 ~ 0.7,
            # main workforce
            .x %in% 25:60 ~ 1,
            # possibly retired
            .x %in% 61:65 ~ 0.7,
            # other
            TRUE ~ 0.05
          )
        ),
        .names = "{.fn}_{.col}"
      ),
      # the probabilities that both parties go to school/work. May not be the same
      # place. But proportional to the increase in contacts due to attendance
      school_probability = school_fraction_age_from * school_fraction_age_to,
      work_probability = work_fraction_age_from * work_fraction_age_to,
    )
}

# return an interpolating function to get populations in 1y age increments from
# chunkier distributions produced by socialmixr::wpp_age() (must contain `lower.age.limit` and `population`)
get_age_population_function <- function(population) {
  
  population <- population %>%
    dplyr::arrange(lower.age.limit)
  
  # compute the widths of age bins
  bin_widths <- diff(population$lower.age.limit)
  final_bin_width <- bin_widths[length(bin_widths)]
  bin_widths <- c(bin_widths, final_bin_width)
  
  # range of ages (assume the final bin width is that same as the previous one,
  # since we cannot extrapolate the infinite upper bound without known the upper
  # age limit)
  min_age <- min(population$lower.age.limit)
  max_age <- max(population$lower.age.limit) + final_bin_width
  
  # interpolator to 1y age groups up to 100
  spline <- stats::splinefun(
    x = population$lower.age.limit,
    y = population$population / bin_widths, 
  )
  
  # wrap this up in a function to handle values outside this range
  function(age) {
    population <- stats::spline(age)
    invalid <- age < min(age) | age > max_age
    population[invalid] <- 0
    pmax(population, 0)
  }
  
}

# add the population distribution for contact ages. If 'polymod' then use the
# participant-weighted average of polymod country/year distributions
add_population_age_to <- function(contact_data, population = get_polymod_population()) {
  
  # get function to interpolate population age distributions to 1y bins 
  age_population_function <- get_age_population_function(population)
  
  # add the population in each 'to' age for the survey context
  contact_data %>%
    dplyr::mutate(
      pop_age_to = age_population_function(age_to)
    )
  
}

# add features required for modelling to the dataset
add_modelling_features <- function(contact_data, ...) {
  
  contact_data %>%
    add_population_age_to(...) %>%
    add_school_work_participation() %>%
    add_rotated_ages()
}

# format polymod data and filter contacts to certain settings
get_polymod_contact_data <- function(
  setting = c("all", "home", "work", "school", "other"),
  ages = 0:100,
  contact_age_imputation = c("sample", "mean", "remove_participant")
) {
  
  setting <- match.arg(setting)
  contact_age_imputation <- match.arg(contact_age_imputation)
  
  contact_data <- polymod$participants %>%
    dplyr::left_join(
      polymod$contacts,
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


# predict contacts to a given population at full 1y resolution 
predict_contacts_1y <- function(model, population, age_min = 0, age_max = 100) {
  
  all_ages <- age_min:age_max
  
  # predict contacts to all integer years, adjusting for the population in a given place
  tidyr::expand_grid(
    age_from = all_ages,
    age_to = all_ages,
  ) %>%
    # add on prediction features, setting the population to predict to
    add_modelling_features(
      population = population
    ) %>%
    dplyr::mutate(
      # prediction
      contacts = predict(
        model,
        newdata = .,
        type = "response"
      ),
      # uncertainty
      se_contacts = predict(
        model,
        newdata = .,
        type = "response",
        se.fit = TRUE
      )$se.fit
    ) %>%
    dplyr::select(
      age_from,
      age_to,
      contacts,
      se_contacts
    ) 
}

# aggregate predicted contacts from complete 1y resolution to a stated resolution
# must pass in the population to do approppriate weighting of 'from' age groups
aggregate_predicted_contacts <- function(
  predicted_contacts_1y,
  population,
  age_breaks = c(
    seq(0, 75, by = 5),
    Inf
  )
) {
  
  # get function for 1y age populations in this country
  age_population_function <- get_age_population_function(population)
  
  # aggregate contacts within age breaks
  predicted_contacts_1y %>%
    dplyr::mutate(
      age_group_to = cut(
        pmax(0.1, age_to),
        age_breaks
      )
    ) %>%
    dplyr::filter(
      !is.na(age_group_to)
    ) %>%
    # sum the number of contacts to the 'to' age groups, for each integer
    # participant age
    dplyr::group_by(
      age_from,
      age_group_to
    ) %>%
    dplyr::summarise(
      contacts = sum(contacts),
      .groups = "drop"
    ) %>%
    # *average* the total contacts within the 'from' contacts, weighted by the
    # population distribution (to get contacts for the population-average ember of
    # that age group)
    dplyr::mutate(
      pop_age_from = age_population_function(age_from),
      age_group_from = cut(
        pmax(0.1, age_from),
        age_breaks
      )
    ) %>%
    dplyr::filter(
      !is.na(age_group_from)
    ) %>%
    dplyr::group_by(
      age_group_from,
      age_group_to
    ) %>%
    dplyr::summarise(
      contacts = stats::weighted.mean(contacts, pop_age_from),
      .groups = "drop"
    )
}

# fit a single GAM contact model to a dataset
fit_single_contact_model <- function(contact_data, population) {
  
  # contact model for all locations together
  contact_data %>%
    add_modelling_features(
      population = population
    ) %>%
    mgcv::bam(
      contacts ~
        # multiplicative offset for population in the 'to' age group, to account for
        # opportunity to contact
        stats::offset(log(pop_age_to)) +
        # deviation of contact age distribution from population age distribution
        s(age_to) +
        # number of contacts by age
        s(age_from) +
        # intergenerational contact patterns
        s(abs(age_from - age_to)) +
        # probabilities of both attending (any) school/work
        school_probability +
        work_probability,
      family = stats::poisson,
      # add number of participants as a multilpicative offset here rather than in
      # the formula, so it is not needed for prediction,
      offset = log(participants),
      data = .
    )
}

# predict number of contacts in all combinations of the age groups specified by
# age_breaks, given a model and a population distribution of the time/place to
# predict to
predict_contacts <- function (
  model,
  population,
  age_breaks = c(seq(0, 75, by = 5), Inf)
) {
  
  population <- population %>%
    dplyr::arrange(lower.age.limit)
  
  age_min_integration <- min(population$lower.age.limit)
  bin_widths <- diff(population$lower.age.limit)
  final_bin_width <- bin_widths[length(bin_widths)]
  age_max_integration <- max(population$lower.age.limit) + final_bin_width
  
  pred_1y <- predict_contacts_1y(
    model = model,
    population = population,
    age_min = age_min_integration,
    age_max = age_max_integration
  )
  
  pred_groups <- aggregate_predicted_contacts(
    predicted_contacts_1y = pred_1y,
    population = population,
    age_breaks = age_breaks
  )
  
  pred_groups
  
}

predictions_to_matrix <- function(contact_predictions) {
  contact_predictions %>%
    tidyr::pivot_wider(
      names_from = age_group_to,
      values_from = contacts
    ) %>%
    tibble::column_to_rownames(
      "age_group_from"
    ) %>%
    as.matrix()
}

# given a named list of contact datasets (with names giving the setting, and
# assumed to together make up the full set of contacts for individuals in the
# survey), a representative population distribution for the survey, and a set of
# age breaks at which to aggregate contacts, return a set of predicted contact
# matrices for each setting, and for all combined.
estimate_setting_contacts <- function(
  contact_data_list,
  survey_population,
  prediction_population = survey_population,
  age_breaks
) {
  
  setting_models <- lapply(
    X = contact_data_list,
    FUN = fit_single_contact_model,
    population = survey_population
  )
  
  setting_predictions <- lapply(
    X = setting_models, 
    FUN = predict_contacts,
    population = prediction_population,
    age_breaks = age_breaks
  )
  
  setting_matrices <- lapply(
    X = setting_predictions,
    FUN = predictions_to_matrix
  )
  
  combination <- Reduce("+", setting_matrices)
  setting_matrices$all <- combination
  
  setting_matrices
  
}

# use ggplot to plot a matrix in the output format
plot_matrix <- function(matrix) {
  
  matrix %>%
    matrix_to_predictions() %>%
    ggplot2::ggplot(
      ggplot2::aes(
        x = age_group_from,
        y = age_group_to,
        fill = contacts
      )
    ) +
    ggplot2::geom_tile() +
    ggplot2::coord_fixed() +
    ggplot2::scale_fill_distiller(
      direction = 1,
      trans = "sqrt"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text = ggplot2::element_text(
        size = 6,
        angle = 45,
        hjust = 1
      )
    )
}

# convert a contact matrix as output by these functions (or socialmixr) into a
# long-form tibble
matrix_to_predictions <- function(contact_matrix) {
  contact_matrix %>%
    tibble::as_tibble(
      rownames = "age_group_from"
    ) %>%
    tidyr::pivot_longer(
      cols = -c(age_group_from),
      names_to = "age_group_to",
      values_to = "contacts"
    ) %>%
    dplyr::mutate(
      dplyr::across(
        dplyr::starts_with("age_group"),
        ~factor(.x, levels = unique(.x))
      )
    )
}

# fit all-of-polymod model and extrapolate to a given population an age breaks
extrapolate_polymod <- function(
  population,
  age_breaks = c(seq(0, 75, by = 5), Inf)
) {
  estimate_setting_contacts(
    contact_data_list = get_polymod_setting_data(),
    survey_population = get_polymod_population(),
    prediction_population = population, 
    age_breaks = age_breaks
  )
}

get_polymod_setting_data <- function() {
  list(
    home = get_polymod_contact_data("home"),
    work = get_polymod_contact_data("work"),
    school = get_polymod_contact_data("school"),
    other = get_polymod_contact_data("other")
  )
}

plot_setting_matrices <- function(
  matrices,
  title = "Setting-specific synthetic contact matrices (all polymod data)"
) {
  plot_matrix(matrices$home) +
    ggplot2::ggtitle("home") +
    plot_matrix(matrices$school) +
    ggplot2::ggtitle("school") +
    plot_matrix(matrices$work) +
    ggplot2::ggtitle("work") +
    plot_matrix(matrices$other) +
    ggplot2::ggtitle("other") +
    patchwork::plot_layout(ncol = 2) +
    patchwork::plot_annotation(
      title = title
    )
}

# analysis of polymod data

# set age breaks
age_breaks_5y <- c(seq(0, 75, by = 5), Inf)
age_breaks_1y <- c(seq(0, 100, by = 1), Inf)

# fit a single overall contact model to polymod
m_all <- fit_single_contact_model(
  contact_data = get_polymod_contact_data("all"),
  population = get_polymod_population()
)

# predict contacts at 1y and 5y resolutions for inspection
synthetic_all_5y <- predict_contacts(
  model = m_all, 
  population = get_polymod_population(),
  age_breaks = age_breaks_5y
) %>%
  predictions_to_matrix()

synthetic_all_1y <- predict_contacts(
  model = m_all, 
  population = get_polymod_population(),
  age_breaks = age_breaks_1y
) %>%
  predictions_to_matrix()

# compute setting-specific and combined age matrices for polymod
synthetic_settings_5y_polymod <- extrapolate_polymod(
  population = get_polymod_population()
)

# extrapolate to other contexts
synthetic_settings_5y_italy_2005 <- extrapolate_polymod(
  population = socialmixr::wpp_age("Italy", "2005")
)

synthetic_settings_5y_germany_2005 <- extrapolate_polymod(
  population = socialmixr::wpp_age("Germany", "2005")
)

synthetic_settings_5y_bolivia_2015 <- extrapolate_polymod(
  population = socialmixr::wpp_age("Bolivia", "2015")
)

synthetic_settings_5y_ghana_2015 <- extrapolate_polymod(
  population = socialmixr::wpp_age("Ghana", "2015")
)

# empirical 5y polymod matrix
empirical_all_5y <- socialmixr::contact_matrix(
  survey = polymod,
  age.limits = seq(0, 75, by = 5),
  symmetric = FALSE,
  split = FALSE,
  missing.participant.age = "remove",
  missing.contact.age = "remove"
)$matrix


# plot setting-specific matrices

plot_setting_matrices(synthetic_settings_5y_polymod)

ggplot2::ggsave(
  "~/Desktop/synthetic_setting_specific_polymod.png",
  width = 9,
  height = 8,
  bg = "white"
)

plot_setting_matrices(
  synthetic_settings_5y_italy_2005,
  title = "Setting-specific synthetic contact matrices (Italy 2005 projected)"
)

ggplot2::ggsave(
  "~/Desktop/synthetic_setting_specific_italy.png",
  width = 9,
  height = 8,
  bg = "white"
)

plot_setting_matrices(
  synthetic_settings_5y_germany_2005,
  title = "Setting-specific synthetic contact matrices (Germany 2005 projected)"
)

ggplot2::ggsave(
  "~/Desktop/synthetic_setting_specific_germany.png",
  width = 9,
  height = 8,
  bg = "white"
)

plot_setting_matrices(
  synthetic_settings_5y_bolivia_2015,
  title = "Setting-specific synthetic contact matrices (Bolivia 2015 projected)"
)

ggplot2::ggsave(
  "~/Desktop/synthetic_setting_specific_bolivia.png",
  width = 9,
  height = 8,
  bg = "white"
)

plot_setting_matrices(
  synthetic_settings_5y_ghana_2015,
  title = "Setting-specific synthetic contact matrices (Ghana 2015 projected)"
)

ggplot2::ggsave(
  "~/Desktop/synthetic_setting_specific_ghana.png",
  width = 9,
  height = 8,
  bg = "white"
)

# plot empirical vs synthetic matrices
plot_matrix(empirical_all_5y) +
  ggplot2::ggtitle("empirical (socialmixr)") +
  plot_matrix(synthetic_settings_5y_polymod$all) +
  ggplot2::ggtitle("synthetic by setting, combined") +
  plot_matrix(synthetic_all_5y) +
  ggplot2::ggtitle("synthetic all at once") +
  plot_matrix(synthetic_all_1y) +
  ggplot2::ggtitle("synthetic all at once (1y)") +
  ggplot2::theme(axis.text = ggplot2::element_blank()) +
  patchwork::plot_layout(ncol = 2) +
  patchwork::plot_annotation(
    title = "Empirical vs synthetic matrices (all polymod data)"
  )

ggplot2::ggsave(
  "~/Desktop/empirical_vs_synthetic.png",
  width = 9,
  height = 8,
  bg = "white"
)

# visualise empirical contact rate estimates
dplyr::bind_rows(
  home = get_polymod_contact_data("home"),
  school = get_polymod_contact_data("school"),
  work = get_polymod_contact_data("work"),
  other = get_polymod_contact_data("other"),
  .id = "setting"
) %>%
  dplyr::mutate(
    rate = contacts / participants,
    setting = factor(
      setting,
      levels = c(
        "home", "school", "work", "other"
      )
    )
  ) %>%
  dplyr::group_by(
    setting
  ) %>%
  dplyr::mutate(
    `relative contact rate` = rate / max(rate)
  ) %>%
  dplyr::ungroup() %>%
  ggplot2::ggplot(
    ggplot2::aes(
      x = age_from,
      y = age_to,
      fill = `relative contact rate`
    )
  ) +
  ggplot2::facet_wrap(
    ~ setting,
    ncol = 2,
    scales = "free"
  ) +
  ggplot2::geom_tile() +
  ggplot2::scale_fill_distiller(
    direction = 1,
    trans = "sqrt"
  ) +
  ggplot2::theme_minimal()


ggplot2::ggsave(
  "~/Desktop/polymod_raw_settings.png",
  width = 9,
  height = 8,
  bg = "white"
)
