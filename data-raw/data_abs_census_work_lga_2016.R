library(readr)
library(tidyverse)
library(janitor)
library(conmat)

data_lga_state <- read_csv("data-raw/2011_lga_state.csv") %>%
  select(state = STATE_NAME_2011,
         lga_code = LGA_CODE_2011,
         lga = LGA_NAME_2011) %>%
  mutate(state = abbreviate_states(state)) %>%
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

abs_census_lga_work <-
  read_csv(
    "data-raw/2016_abs_census_lga_work.csv",
    col_types = cols(...1 = col_character()),
    skip = 8,
    n_max = 65873
  ) %>% row_to_names(1) %>% clean_names() %>%
  rename(age = na,
         lga = lfsp_labour_force_status) %>%
  slice(-1) %>%
  mutate(
    year = 2016,
    employed_worked_full_time = as.numeric(employed_worked_full_time),
    employed_worked_part_time = as.numeric(employed_worked_part_time),
    employed_away_from_work = as.numeric(employed_away_from_work),
    total = as.numeric(total)
  )

for (i in 1:nrow(abs_census_lga_work))
{
  if (is.na(abs_census_lga_work$age[i]) == TRUE) {
    abs_census_lga_work$age[i] <- abs_census_lga_work$age[i - 1]
  } else {
    abs_census_lga_work$age[i] <- abs_census_lga_work$age[i]
  }
}

# new total calculated as total in the data is giving weird values such as < employed people in the given lga. Check
# Etheridge (S)for age 46


data_abs_census_lga_work <- abs_census_lga_work %>%
  filter(age != "Total") %>%
  mutate(across(.cols = -lga, .fn = as.numeric)) %>%
  arrange(lga) %>%
  mutate(
    employed_population = as.numeric(
      employed_worked_full_time +
        employed_worked_part_time +
        employed_away_from_work
    ),
    proportion = employed_population / total,
    anomaly_flag = case_when(
      total >= employed_population ~ FALSE,
      total < employed_population ~ TRUE
    ),
    anomaly_flag = as.logical(anomaly_flag)
  ) %>%
  mutate(proportion = case_when(
    total == 0 & employed_population == 0 ~ 0,
    TRUE ~ as.numeric(proportion)
  )) %>%
  select(year,
         lga,
         age,
         employed_population,
         total_population = total,
         proportion,
         anomaly_flag)%>%
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
    (state == "NSW" &
       lga == "Campbelltown (C)") ~ "Campbelltown (C) (NSW)",
    TRUE ~ as.character(lga)
  ))

conmat::abs_household_lga %>%
  distinct(lga, state) -> conmat_abs_household_data

lgas_in_work_census <- data_abs_census_lga_work %>%
  select(lga) %>%
  distinct()%>%
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
lga_state <- lgas_in_work_census %>%
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

# patterns <-
#   c(
#     "\\(Vic\\.\\)|\\(ACT\\)|\\(NSW\\)|\\(NT\\)|\\(OT\\)|\\(Qld\\)|\\(SA\\)|\\(Tas\\.\\)|\\(WA\\)"
#   )

data_abs_census_lga_work %>%
  left_join(lga_state, by = "lga") %>%
  relocate(year, state, everything()) %>%
  filter(!str_detect(lga, "No usual address")) %>%
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
    ))%>%
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
  ))-> data_abs_lga_work
  # mutate(lga = case_when(
  #   str_detect(lga, "Migratory - Offshore - Shipping") ~ as.character(lga),
  #   TRUE ~ str_trim(str_remove_all(lga, pattern = patterns))
  # )) 

summary(data_abs_lga_work)

data_abs_lga_work %>%
  filter(anomaly_flag == FALSE) %>%
  ggplot(aes(x = age, y = proportion)) +
  geom_point()

# lga%>%clean_names()->lga
# data_abs_lga_work%>%
#   distinct(lga,state)%>%
#   left_join(lga%>%
#               select(official_name_state,long_official_name_local_government_area),
#             by=c("lga"="long_official_name_local_government_area"),keep=
#             TRUE)->check_lga
# all_lga <- conmat::abs_lga_lookup
# check_lga%>%
# anti_join(all_lga)%>%filter(is.na(official_name_state))->c

use_data(data_abs_lga_work, compress = "xz", overwrite = TRUE)

visdat::vis_miss(data_abs_lga_work)

data_abs_lga_work%>%
  filter(is.na(state))%>%
  distinct(lga)->missing
