library(dplyr)

e <- rnorm(200)
f <- rnorm(200, e)
dat <- data_frame(e,f) %>%
  mutate(sp = paste0("sp", rep(1:20, each = 10)))

write.csv(dat, "data3.csv", row.names = F)
