library(dplyr)
library(readr)

e <- rnorm(200)
f <- rnorm(200, e)
dat <- tibble(e,f) %>%
  mutate(sp = paste0("sp", rep(1:20, each = 10)))

write_csv(dat, "./inst/simple/data/data3.csv")
