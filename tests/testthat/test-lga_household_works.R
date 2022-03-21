

library(purrr)
library(conmat)

# Checking to see the lga in abs_pop_age_lga_2020 that are not in abs_household_lga (has 552 unique lgas) as
# check_lga_name() in get_per_capita_household_size() uses abs_pop_age_lga_2020 (has 543 unique lgas) 
# therefore renaming the lgas present in abs_pop_age_lga_2020 

get_unique_lgas<- function(household_data){
  population_household_lgas<- left_join(abs_pop_age_lga_2020,household_data,by="lga") 
  per_capita_household_lgas<- population_household_lgas[rowSums(is.na(population_household_lgas)) > 0, ]  
  all_lgas <- unique(per_capita_household_lgas$lga)
  return(all_lgas)
}


safe_get_per_capita_household_size <- safely(get_per_capita_household_size)

all_household_lgas <- get_unique_lgas(abs_household_lga)

household_per_capita_runs <- map(
  .x = all_household_lgas,
  .f = ~safe_get_per_capita_household_size(lga = .x)
)

t_household_per_capita_runs <- transpose(household_per_capita_runs)

# count or test if the result is all not NULL
null_household_lgas<- sum(map_lgl(t_household_per_capita_runs$result, is.null)) 



updated_abs_household_lga<- abs_household_lga  %>%
  mutate(
    lga = case_when(
      lga == "Botany Bay (C)" ~ "Bayside (A)",
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
updated_all_household_lgas <- get_unique_lgas(updated_abs_household_lga)

safe_get_updated_per_capita_household_size <- safely(get_per_capita_household_size)



updated_household_per_capita_runs <- map(
  .x = updated_all_household_lgas,
  .f = ~safe_get_updated_per_capita_household_size(lga = .x)
)

t_updated_household_per_capita_runs <- transpose(updated_household_per_capita_runs)

# count or test if the result is all not NULL
null_updated_household_lgas<- sum(map_lgl(t_updated_household_per_capita_runs$result, is.null)) 



test_that("all lgas present in abs_pop_age_lga_2020", {
  expect_false(isTRUE(all.equal(null_household_lgas, null_updated_household_lgas)))
})
