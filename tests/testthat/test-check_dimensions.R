




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
            matrix(1:16,
                   nrow = 4,
                   ncol = 4,
                   dimnames = list(
                     c("[0,5)",  "[5,10)" ,  "[10,15)",  "[15,Inf)"),
                     c("[0,5)",  "[5,10)" ,  "[10,15)",  "[15,Inf)")
                   )) -> demo_matrix
            
            demo_matrix <-  replicate(5, demo_matrix, simplify = FALSE)  
            
            names(demo_matrix) <- c("home"  , "school" , "work" ,  "other",  "all")
            
            
            expect_snapshot_error(
              apply_vaccination(
                ngm = demo_matrix,
                data = vaccination_effect_example_data,
                coverage_col = coverage,
                acquisition_col = acquisition,
                transmission_col = transmission
              )
            )
            
          })
