 separate_age_group<- function(data,age_col){
  return(data %>% 
  tidyr::separate({{ age_col }}, c("lower.age.limit", "upper.age.limit"), "[[:punct:]]", extra = "merge")%>% 
  dplyr::mutate(lower.age.limit = readr::parse_number(as.character(lower.age.limit)),
                upper.age.limit = readr::parse_number(as.character(upper.age.limit)))
   
)
 }
 