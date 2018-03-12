library(dplyr)

a <- rnorm(200)
b <- rnorm(200)
dat <- data_frame(a,b) %>%
  mutate(sp = paste0("sp", rep(1:20, each = 10)))

write.csv(dat, "data.csv", row.names = F)
