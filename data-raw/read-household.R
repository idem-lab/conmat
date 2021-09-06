library(readr)
household <- read_csv(here("data-raw/ABS_C16_T23_LGA_06092021160753604.csv"))

View(household)

household

# multiply the number of households by the number people in a household
# e.g., 6000 households of size 1 - there are 6000 people who live alone
# do this for each group for one through to 7

# for 8 or more - take Total population, and subtract the sum of the other
# 1-7 groups (from LGA data)