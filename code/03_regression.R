here::i_am("code/03_regression.R")

data1 <- readRDS(
  file=here::here("output/data1.rds")
)

library(gtsummary)
library(dplyr)
library(gt)
library(broom)
library(broom.helpers)

data1 <- data1 %>%
  mutate(pole = ifelse(grid == 1, 1, 0),
         win = ifelse(positionOrder == 1, 1, 0),
         podium = ifelse(positionOrder %in% c(1,2,3), 1, 0))

logit_model <- glm(win ~ pole, data = data1, family = binomial)

tbl_logit <- tbl_regression(
  logit_model, 
  exponentiate = TRUE, 
  label = list(
    pole ~ "Started on Pole")) %>%
  as_gt() %>%
  tab_header(title = "Effect of Pole Position on Race Win (Leclerc, Ferrari 2019–2024)")

saveRDS(
  tbl_logit,
  file=here::here("output/regression.rds")
)