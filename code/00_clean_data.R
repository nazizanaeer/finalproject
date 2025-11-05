here::i_am("code/00_clean_data.R")

library(dplyr)
library(labelled)
library(readr)

### 1.3 Reading in Dataset and Filtering by Driver and Constructor

results <- read.csv("f1_datasets/results.csv")
races <- read.csv("f1_datasets/races.csv")
drivers <- read.csv("f1_datasets/drivers.csv")
qualifying <- read.csv("f1_datasets/qualifying.csv")
circuits <- read.csv("f1_datasets/circuits.csv")

data <- results %>%
  left_join(races, by = "raceId") %>%
  left_join(drivers, by = "driverId") %>%
  left_join(qualifying, by = c("raceId", "driverId")) %>%
  filter(driverRef == "leclerc", constructorId.x == "6")  %>% 
  select(
    raceId, year, round, circuitId, 
    constructorId = constructorId.x, 
    driverId, driverRef, surname, 
    forename, grid, 
    results_position = position.x,   
    qualifying_position = position.y, 
    positionOrder, points, laps, 
    time = time.x, 
    fastestLap, fastestLapTime, fastestLapSpeed, 
    q1, q2, q3 
  )

saveRDS(
  data, 
  file = here::here("output/data.rds")
)

data$fastestLapSpeed <- as.numeric(data$fastestLapSpeed)
data$results_position <- as.numeric(data$results_position)

data1 <- data %>%
  mutate(
    performance_category = case_when(
      results_position %in% 1:3 ~ "Podium (P1–P3)",
      results_position %in% 4:10 ~ "Points Zone (P4–P10)",
      results_position %in% 11:20 | is.na(results_position) ~ "Non-Scoring (P11–P20/DNF)"
    )
  )

data1 <- data1 %>% 
  mutate(
    performance_category = factor(
      performance_category,
      levels = c("Podium (P1–P3)", "Points Zone (P4–P10)", "Non-Scoring (P11–P20/DNF)")
    )
  )

var_label(data1) <- list(
  qualifying_position = "Qualifying Position",
  grid = "Starting Grid",
  results_position = "Race Finish Position",
  points = "Points Scored",
  fastestLapSpeed = "Fastest Lap Speed (km/h)"
)

saveRDS(
  data1, 
  file = here::here("output/data1.rds")
)

table1_vars <- data1 %>%
  select(performance_category,
         qualifying_position, grid, results_position,
         points, fastestLapSpeed)

saveRDS(
  table1_vars, 
  file = here::here("output/table1_vars.rds")
)







