## code to prepare `conmat-original-school-work-demographics` dataset goes here
conmat_original_school_demographics <- tibble(
  age = 0:120,
  school_fraction = 0
) %>%
  mutate(
    school_fraction = case_when(
      # preschool
      age %in% 2:4 ~ 0.5,
      # compulsory education
      age %in% 5:16 ~ 1,
      # voluntary education
      age %in% 17:18 ~ 0.5,
      # university
      age %in% 19:25 ~ 0.1,
      # other
      .default = 0.05
    )
  )

usethis::use_data(conmat_original_school_demographics, overwrite = TRUE)

conmat_original_work_demographics <- tibble(
  age = 0:120,
  work_fraction = 0
) %>%
  mutate(
    work_fraction = case_when(
      # child labour
      age %in% 12:19 ~ 0.2,
      # young adults (not at school)
      age %in% 20:24 ~ 0.7,
      # main workforce
      age %in% 25:60 ~ 1,
      # possibly retired
      age %in% 61:65 ~ 0.7,
      .default = 0.05
    )
  )

usethis::use_data(conmat_original_work_demographics, overwrite = TRUE)
