here::i_am("code/01_make_table1.R")

table1_vars <- readRDS(
  file=here::here("output/table1_vars.rds")
)

library(gtsummary)
library(dplyr)

table1_vars$fastestLapSpeed <- as.numeric(table1_vars$fastestLapSpeed)
table1_vars$results_position <- as.numeric(table1_vars$results_position)

table1 <- table1_vars %>%
  tbl_summary(
    by = performance_category,  
    statistic = list(
      qualifying_position ~ "{median} ({p25}, {p75})",
      grid ~ "{median} ({p25}, {p75})",
      results_position ~ "{median} ({p25}, {p75})",
      points ~ "{median} ({p25}, {p75})",
      fastestLapSpeed ~ "{mean} ± {sd}"
    ),
    missing = "no"
  ) %>% 
  modify_spanning_header(all_stat_cols() ~ "**By Performance Category**") %>%
  bold_labels() %>%
  add_p %>% 
  add_overall()

saveRDS(
  table1,
  file = here::here("output/table1.rds")
)