library(tidyverse)
library(janitor)


aus_states <- c("New South Wales","Victoria","Queensland",                         
                "South Australia",                    
                "Western Australia",                     
                "Tasmania" ,                             
                "Northern Territory",                    
                "Australian Capital Territory")

abs_census_labour_status <- read_csv("data-raw/2016_abs_census_labour_status.csv", 
                                     skip = 8,n_max = 138)

get_data <- function(i){
  abs_census_labour_status%>%
    slice(i:c(i+11))%>%
    slice(-1)%>%
    row_to_names(1)%>%
    rename(Status=`AGEP Age`)%>%
    select(-`Total`)%>%
    pivot_longer(-Status,names_to = "Age",values_to="population")%>%
    filter(grepl('Employed|Total',Status))%>%
    pivot_wider(names_from = Status,values_from = population)%>%
    clean_names()%>%
    filter(total!= 0)%>%
    mutate(
      year=2016,
      age=as.numeric(age),
      employed_population=as.numeric(employed_worked_full_time+
                                       employed_worked_part_time+
                                       employed_away_from_work),
      proportion=employed_population/total,
      state=abs_census_labour_status$...1[[i]])%>%
    mutate(state=conmat::abbreviate_states(state))%>%
    select(year,state,age,employed_population,total_population=total,proportion)
}


data_abs_state_work_2016 <- map_dfr(seq(1,85,14),get_data)

data_abs_state_work_2016%>%
  ggplot(aes(x = age, y = proportion)) +
  geom_point() + facet_wrap( ~ state)

# maybe mention in the documentation that data from abs have been randomly adjusted 
# to avoid the release of confidential data. 
# No reliance should be placed on small cells.

data_abs_state_work_2016%>%
  filter(state=="VIC")%>%
  arrange(-proportion) 
