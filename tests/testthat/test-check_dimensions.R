



test_that("check_dimensions() returns nothing when compatible dimensions",
          {
            list(matrix(1:6, nrow = 3, ncol = 2),
                 matrix(1:6, nrow = 3, ncol = 2)) -> demo_matrix
            
            names(demo_matrix) <- c("matrix_a", "matrix_b")
            
            demo_data <- tibble::tibble(x = 1:2, y = 2 * x)
            
            expect_silent(check_dimensions(demo_matrix,
                                           demo_data))
          })



test_that("check_dimensions() returns error", {
  list(matrix(1:6, nrow = 3, ncol = 2),
       matrix(1:6, nrow = 3, ncol = 2)) -> demo_matrix
  
  names(demo_matrix) <- c("matrix_a", "matrix_b")
  
  demo_data <- tibble::tibble(x = 1:6, y = 2 * x)
  expect_snapshot_error(check_dimensions(demo_matrix,
                                         demo_data))
})

test_that("apply_vaccination gives error when incompatible dimensions present",
          {
            ngm_fairfield_15_plus <- generate_ngm(
              lga_name = "Fairfield (C)",
              age_breaks = c(seq(0, 15, by = 5), Inf),
              R_target = 1.5
            )
            expect_snapshot_error(
              apply_vaccination(
                ngm = ngm_fairfield_15_plus,
                data = vaccination_effect_example_data,
                coverage_col = coverage,
                acquisition_col = acquisition,
                transmission_col = transmission
              )
            )
            
          })
