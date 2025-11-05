here::i_am("code/02_make_scatter.R")

data1 <- readRDS(
  file=here::here("output/data1.rds")
)

library(dplyr)
library(ggplot2)

scatterplot <- ggplot(data1, aes(x = as.numeric(qualifying_position), y = as.numeric(results_position), 
                                 color = performance_category)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "gray") + 
  scale_color_manual(values = c(
    "Podium (P1–P3)" = "#DC0000",       # Ferrari red
    "Points Zone (P4–P10)" = "#FFF500", 
    "Non-Scoring (P11–P20/DNF)" = "gray"
  )) +
  scale_y_reverse() +  
  scale_x_reverse() +  
  labs(
    title = "Qualifying Position vs Race Finish (Leclerc, Ferrari 2019-2024)",
    x = "Qualifying Position",
    y = "Race Finish Position",
    color = "Performance Category"
  ) +
  theme_minimal()

ggsave(
  here::here("output/scatterplot.png"),
  plot = scatterplot,
  device = "png"
)
