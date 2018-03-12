library(dplyr)

c <- rnorm(200)
d <- rnorm(200, c)
dat <- data_frame(c,d) %>%
  mutate(sp = paste0("sp", rep(1:20, each = 10)))

write.csv(dat, "data2.csv", row.names = F)
