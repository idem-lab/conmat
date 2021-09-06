# build synthetic age-structured contact matrices with GAMs

library(tidyverse)
library(mgcv)
library(patchwork)
library(socialmixr)

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
