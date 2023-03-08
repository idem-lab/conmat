library(dplyr)
contact_data <- get_polymod_contact_data("all") %>%
  filter(
    age_from <= 20,
    age_to <= 20
  )

population <- get_polymod_population() %>%
  filter(lower.age.limit <= 20)

m_all <- fit_single_contact_model(
  contact_data = contact_data,
  population = population
)

age_breaks_5y <- c(seq(0, 10, by = 5), Inf)

synthetic_pred <- predict_contacts(
  model = m_all,
  population = population,
  age_breaks = age_breaks_5y
)

test_that("predict_contacts() works", {
  expect_s3_class(synthetic_pred, "tbl_df")
  expect_snapshot(names(synthetic_pred))
  expect_snapshot(dim(synthetic_pred))
  expect_snapshot(synthetic_pred$age_group_from)
  expect_snapshot(synthetic_pred$age_group_to)
})

synthetic_all_5y <- synthetic_pred %>%
  predictions_to_matrix()

test_that("predictions_to_matrix() works", {
  expect_snapshot(dim(synthetic_all_5y))
  expect_snapshot(rownames(synthetic_all_5y))
  expect_snapshot(colnames(synthetic_all_5y))
})
