library(tidyverse)
library(here)
household_raw <- read_csv(file = here("data-raw/ABS_C16_T23_LGA_06092021160753604.csv")) %>%
  rename(
    throw_hhcd_2016 = HHCD_2016,
    household_composition = `Household Composition`,
    throw_nprd_2016 = NPRD_2016,
    n_persons_usually_resident = `Number of Persons Usually Resident`,
    throw_state = STATE,
    state = State,
    throw_region_type = REGIONTYPE,
    throw2_region_type = `Geography Level`,
    throw_lga_code = LGA_2016,
    lga_name = Region,
    year = TIME,
    throw_year = `Census Year`,
    n_households = Value,
    throw_flag = `Flag Codes`,
    throw_flat2 = Flags
  ) %>%
  select(-starts_with("throw")) %>%
  relocate(
    year,
    state,
    lga_name,
    household_composition,
    n_persons_usually_resident,
    n_households
  ) %>%
  mutate(
    n_persons_usually_resident = case_when(
      n_persons_usually_resident == "Total" ~ "total",
      n_persons_usually_resident == "One person" ~ "1",
      n_persons_usually_resident == "Two persons" ~ "2",
      n_persons_usually_resident == "Three persons" ~ "3",
      n_persons_usually_resident == "Four persons" ~ "4",
      n_persons_usually_resident == "Five persons" ~ "5",
      n_persons_usually_resident == "Six persons" ~ "6",
      n_persons_usually_resident == "Seven persons" ~ "7",
      n_persons_usually_resident == "Eight or more persons" ~ "8+"
    )
  )

abs_2016_lga_pop <- abs_pop_age_lga_2016 %>%
  group_by(year, state, lga_name) %>%
  summarise(total_popn = sum(population))

abs_2016_lga_pop

# multiply the number of households by the number people in a household
# e.g., 6000 households of size 1 - there are 6000 people who live alone
# do this for each group for one through to 7

household_raw %>%
  filter(n_persons_usually_resident %in% as.character(c(1:7))) %>%
  mutate(
    n_persons_usually_resident = parse_number(n_persons_usually_resident),
    n_persons_in_household = n_persons_usually_resident * n_households
  )

abs_pop_age_lga_2016
unique(household_raw$household_composition)


# question - with these categories in "household_composition"
# we are just interested in "total households", right?
c(
  "Total Households",
  "One family household with only family members present",
  "One family household with non-family members present",
  "Two family household with only family members present",
  "Two family household with non-family members present",
  "Three or more family household with only family members present",
  "Three or more family household with non-family members present",
  "Lone person household",
  "Group household"
)


household_raw %>%
  filter(n_persons_usually_resident %in% c(
    "total",
    "8+"
  )) %>%
  left_join(
    abs_2016_lga_pop,
    by = c("year", "state", "lga_name")
  )
# for 8 or more - take Total population, and subtract the sum of the other
# 1-7 groups (from LGA data)
