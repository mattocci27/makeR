library(dplyr)
library(readr)
library(ggplot2)

d <- read_csv("./inst/simple/data/data.csv")
d2 <- read_csv("./inst/simple/data/data2.csv")
d3 <- read_csv("./inst/simple/data/data3.csv")

d4 <- inner_join(d, d2, by = "sp") %>%
  inner_join(., d3)

res <- lm(a ~ d, d4)

p <- ggplot(d4, aes(x = a, y = d)) +
  geom_point()

ggsave("./inst/simple/images/fig1.png", p)

save.image("./inst/simple/data/fit.rda")
