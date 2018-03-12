library(tidyverse)

d <- read_csv("data.csv")
d2 <- read_csv("data2.csv")
d3 <- read_csv("data3.csv")

d4 <- inner_join(d, d2, by = "sp") %>%
  inner_join(., d3)

res <- lm(a ~ d, d4)

p <- ggplot(d4, aes(x = a, y = d)) +
  geom_point()

ggsave("fig1.png", p)

save.image("fit.rda")
