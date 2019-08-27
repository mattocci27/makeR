library(dplyr)
library(readr)

c <- rnorm(200)
d <- rnorm(200, c)
dat <- tibble(c,d) %>%
  mutate(sp = paste0("sp", rep(1:20, each = 10)))

write_csv(dat, "./data/data2.csv")
