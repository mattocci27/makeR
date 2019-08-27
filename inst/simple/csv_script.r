library(dplyr)
library(readr)

a <- rnorm(200)
b <- rnorm(200)
dat <- tibble(a,b) %>%
  mutate(sp = paste0("sp", rep(1:20, each = 10)))

write_csv(dat, "./data/data.csv")
