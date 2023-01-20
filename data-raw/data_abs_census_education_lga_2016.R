library(tidyverse)
library(janitor)
library(readxl)
library(conmat)

data_abs_lga_education <- list()
for (i in 1:6)

{
  abs_lga_education_df <-
    read_excel(
      "data-raw/2016_abs_lga_education.xls",
      sheet = i,
      skip = 7,
      n_max = 566
    )

  df <- abs_lga_education_df %>%
    row_to_names(1)
  colnames(df)[2] <- "lga"
  df <- df[-1, ]

  data_abs_lga_education[[i]] <- df %>%
    select(-c(Total, `AGEP Age`)) %>%
    filter(lga != "Total") %>%
    pivot_longer(
      cols = "0":"115",
      names_to = "age",
      values_to = colnames(abs_lga_education_df[1])
    )
}

data_abs_census_lga_education <- data_abs_lga_education %>%
  reduce(left_join, by = c("lga", "age")) %>%
  clean_names() %>%
  mutate(across(.cols = -lga, .fn = as.numeric)) %>%
  mutate(
    year = 2016,
    population_educated = full_time_student +
      part_time_student +
      institution_typp_stated_full_time_part_time_status_stup_not_stated,
    proportion = population_educated / total
  ) %>%
  mutate(
    proportion = case_when(
      total == 0 & population_educated == 0 ~ 0,
      TRUE ~ as.numeric(proportion)
    ),
    anomaly_flag = case_when(
      total >= population_educated ~ FALSE,
      total < population_educated ~ TRUE
    ),
    anomaly_flag = as.logical(anomaly_flag)
  ) %>%
  select(year,
    lga,
    age,
    population_educated,
    total_population = total,
    proportion,
    anomaly_flag
  ) %>%
  mutate(
    lga = case_when(
      lga == "Botany Bay (C)" ~ "Bayside (A)",
      lga == "Rockdale (C)" ~ "Bayside (A)",
      lga == "Gundagai (A)" ~ "Cootamundra-Gundagai Regional (A)",
      lga == "Nambucca (A)" ~ "Nambucca Valley (A)",
      lga == "Western Plains Regional (A)" ~ "Dubbo Regional (A)",
      lga == "Mallala (DC)" ~ "Adelaide Plains (DC)",
      lga == "Orroroo/Carrieton (DC)" ~ "Orroroo-Carrieton (DC)",
      lga == "Break O'Day (M)" ~ "Break O`Day (M)",
      lga == "Glamorgan/Spring Bay (M)" ~ "Glamorgan-Spring Bay (M)",
      lga == "Waratah/Wynyard (M)" ~ "Waratah-Wynyard (M)",
      lga == "Kalamunda (S)" ~ "Kalamunda (C)",
      lga == "Kalgoorlie/Boulder (C)" ~ "Kalgoorlie-Boulder (C)",
      TRUE ~ lga
    )
  )

visdat::vis_miss(data_abs_census_lga_education)
summary(data_abs_census_lga_education)
summary(data_abs_census_lga_education$anomaly_flag)


data_lga_state <- read_csv("data-raw/2011_lga_state.csv") %>%
  select(
    state = STATE_NAME_2011,
    lga_code = LGA_CODE_2011,
    lga = LGA_NAME_2011
  ) %>%
  mutate(state = abs_abbreviate_states(state)) %>%
  distinct_all() %>%
  dplyr::mutate(state = replace_na(state, "Other Territories")) %>%
  mutate(
    lga = case_when(
      lga == "Botany Bay (C)" ~ "Bayside (A)",
      lga == "Rockdale (C)" ~ "Bayside (A)",
      lga == "Gundagai (A)" ~ "Cootamundra-Gundagai Regional (A)",
      lga == "Nambucca (A)" ~ "Nambucca Valley (A)",
      lga == "Western Plains Regional (A)" ~ "Dubbo Regional (A)",
      lga == "Mallala (DC)" ~ "Adelaide Plains (DC)",
      lga == "Orroroo/Carrieton (DC)" ~ "Orroroo-Carrieton (DC)",
      lga == "Break O'Day (M)" ~ "Break O`Day (M)",
      lga == "Glamorgan/Spring Bay (M)" ~ "Glamorgan-Spring Bay (M)",
      lga == "Waratah/Wynyard (M)" ~ "Waratah-Wynyard (M)",
      lga == "Kalamunda (S)" ~ "Kalamunda (C)",
      lga == "Kalgoorlie/Boulder (C)" ~ "Kalgoorlie-Boulder (C)",
      TRUE ~ lga
    )
  )


# No usual address : https://www.abs.gov.au/ausstats/abs@.nsf/Lookup/2900.0main+features100882016

data_lga_state <- data_lga_state %>%
  mutate(lga = case_when(
    (state == "NSW" & lga == "Campbelltown (C)") ~ "Campbelltown (C) (NSW)",
    TRUE ~ as.character(lga)
  ))

conmat::abs_household_lga %>%
  distinct(lga, state) -> conmat_abs_household_data

lgas_in_education_census <- data_abs_census_lga_education %>%
  select(lga) %>%
  distinct() %>%
  mutate(
    lga = case_when(
      lga == "Botany Bay (C)" ~ "Bayside (A)",
      lga == "Rockdale (C)" ~ "Bayside (A)",
      lga == "Gundagai (A)" ~ "Cootamundra-Gundagai Regional (A)",
      lga == "Nambucca (A)" ~ "Nambucca Valley (A)",
      lga == "Western Plains Regional (A)" ~ "Dubbo Regional (A)",
      lga == "Mallala (DC)" ~ "Adelaide Plains (DC)",
      lga == "Orroroo/Carrieton (DC)" ~ "Orroroo-Carrieton (DC)",
      lga == "Break O'Day (M)" ~ "Break O`Day (M)",
      lga == "Glamorgan/Spring Bay (M)" ~ "Glamorgan-Spring Bay (M)",
      lga == "Waratah/Wynyard (M)" ~ "Waratah-Wynyard (M)",
      lga == "Kalamunda (S)" ~ "Kalamunda (C)",
      lga == "Kalgoorlie/Boulder (C)" ~ "Kalgoorlie-Boulder (C)",
      TRUE ~ lga
    )
  )
lga_state <- lgas_in_education_census %>%
  left_join(data_lga_state, by = "lga") %>%
  mutate(
    state = case_when(
      str_detect(lga, "(ACT)") ~ "ACT",
      str_detect(lga, "(NSW)") ~ "NSW",
      str_detect(lga, "(NT)") ~ "NT",
      str_detect(lga, "(OT)") ~ "Other Territories",
      str_detect(lga, "(Qld)") ~ "QLD",
      str_detect(lga, "(SA)") ~ "SA",
      str_detect(lga, "(Tas.)") ~ "TAS",
      str_detect(lga, "(Vic.)") ~ "VIC",
      str_detect(lga, "(WA)") ~ "WA",
      TRUE ~ as.character(state)
    )
  ) %>%
  left_join(conmat_abs_household_data, by = c("lga")) %>%
  mutate(state_new = case_when(
    is.na(state.x) ~ as.character(state.y),
    is.na(state.y) ~ as.character(state.x),
    TRUE ~ as.character(state.y)
  )) %>%
  select(lga, state = state_new)

data_abs_census_lga_education %>%
  left_join(lga_state, by = "lga") %>%
  relocate(year, state, everything()) %>%
  filter(!str_detect(lga, "No usual address")) %>%
  mutate(lga = case_when(
    (state == "VIC" & lga == "Kingston (C)") ~ "Kingston (C) (Vic.)",
    (state == "VIC" & lga == "Latrobe (C)") ~ "Latrobe (C) (Vic.)",
    (state == "QLD" & lga == "Central Highlands (R)") ~ "Central Highlands (R) (Qld)",
    (state == "QLD" & lga == "Flinders (S)") ~ "Flinders (S) (Qld)",
    (state == "SA" & lga == "Campbelltown (C)") ~ "Campbelltown (C) (SA)",
    (state == "SA" & lga == "Kingston (DC)") ~ "Kingston (DC) (SA)",
    (state == "TAS" & lga == "Central Coast (M)") ~ "Central Coast (M) (Tas.)",
    (state == "TAS" & lga == "Flinders (M)") ~ "Flinders (M) (Tas.)",
    (state == "TAS" & lga == "Central Highlands (M)") ~ "Central Highlands (M) (Tas.)",
    (state == "TAS" & lga == "Latrobe (M)") ~ "Latrobe (M) (Tas.)",
    TRUE ~ as.character(lga)
  )) -> data_abs_lga_education
# mutate(lga = case_when(
#   str_detect(lga, "Migratory - Offshore - Shipping") ~ as.character(lga),
#   TRUE ~ str_trim(str_remove_all(lga, pattern = patterns))
# ))


data_abs_lga_education %>%
  select(lga) %>%
  distinct() %>%
  left_join(conmat_abs_household_data) -> check_lga
summary(data_abs_census_lga_education)

skimr::skim(data_abs_lga_education)

use_data(data_abs_lga_education, compress = "xz", overwrite = TRUE)
