library(tidyverse)
library(stringr)
target_first_line <- function() {
  files <- list.files()
  #files2 <- files[str_detect(files, "\\.r$|\\.rmd$|\\.sh$")]
  files2 <- files[str_detect(files, "\\.r$|\\.sh$")]
  target_new <- NULL
  for (i in 1:length(files2)) {
    Lines <- readLines(paste(files2[i]))
    Lines2 <- Lines[!str_detect(Lines, "^#")]
    target <- Lines2[str_detect(Lines2, "ggsave|write.csv|save.image")]
    target2 <- str_split(target, '"')
    target3 <- sapply(target2, "[", 2)
    target_new <- c(target_new, target3)
  }

  target_new2 <- target_new %>%
    unlist %>%
    unique
  target_new3 <- target_new2[!is.na(target_new2)]
  target_new4 <- target_new3[!str_detect(target_new3, "\\|")]
  str_c(target_new4, sep = " ", collapse = " ")
}

make_fun <- function(output){
  files <- list.files()
  #files2 <- files[str_detect(files, "\\.r$|\\.rmd$|\\.sh$")]
  files2 <- files[str_detect(files, "\\.r$|\\.sh$")]
  files2 <- files2[files2 != "make_make.r" & files2 != "vis.r"]

  target_vec <- target_first_line()
  out <- file(paste(output), "w") # write

  writeLines(paste(".PHONY : all"), out, sep = "\n")
  writeLines(paste0("all : ", target_vec), out, sep = "\n\n")

  for (i in 1:length(files2)) {
    Lines <- readLines(paste(files2[i]))
    Lines2 <- Lines[!str_detect(Lines, "^#")]

    dep <- Lines2[str_detect(Lines2, "read_csv|read.csv|source|load")]
    dep2 <- str_split(dep, '"')
    dep3 <- sapply(dep2, "[", 2)
    dep4 <- str_c(dep3, sep = " ", collapse = " ")
    target <- Lines2[str_detect(Lines2, "ggsave|write.csv|save.image")]
    target2 <- str_split(target, '"')
    target3 <- sapply(target2, "[", 2)

    target3

    com <- files2[i]
    if (length(dep) == 0){
      dep4 <- com
    }

    if (str_detect(com, "\\.r$")) {
      com2 <- paste("Rscript", com)
    } else if (str_detect(com, "\\.rmd$")) {
      com2 <- paste0("Rscript -e 'render('", com, "')'" )
    } else if (str_detect(com, "\\.sh$")) {
      com2 <- paste("sh ", com)
    }

    target4 <- as.list(target3)
    tmp <- data_frame(target4, dep4, com2) %>%
      unnest #%>%
     # filter(!is.na(target4))
    if (length(target3) != 0) {
      for (j in 1:nrow(tmp)) {
        tmp2 <-tmp[j,]
        writeLines(paste(tmp2$target4), out, sep = ": ")
        writeLines(paste(tmp2$dep4), out, sep = "\n")
        writeLines(paste0("\t", tmp2$com2), out, sep = "\n\n")
      }
    }
  }

  close(out)
  print(paste("Created", output))
}

#undebug(make_fun)
#make_fun("test.txt")
#out <- file("test.txt", "w") # write
#for (i in 1:4) {
#  Lines <- readLines(paste(files2[i]))
#  Lines2 <- Lines[!str_detect(Lines, "^#")]
#
#  dep <- Lines2[str_detect(Lines2, "read_csv|read.csv|source|load")]
#  dep2 <- str_split(dep, '"')
#  dep3 <- sapply(dep2, "[", 2)
#  dep4 <- str_c(dep3, sep = " ", collapse = " ")
#
#  target <- Lines2[str_detect(Lines2, "my_ggsave2|write.csv|save.image")]
#  target2 <- str_split(target, '"')
#  target3 <- sapply(target2, "[", 2)
#
#  target3
#
#  com <- files2[i]
#
#  if (str_detect(com, "\\.r$")) {
#    com2 <- paste("Rscript", com)
#  } else if (str_detect(com, "\\.rmd$")) {
#    com2 <- paste("Rscript", com)
#  } else if (str_detect(com, "\\.sh$")) {
#    com2 <- paste("sh ", com)
#  }
#
#
#  if (length(target3) > 1) {
#    target4 <- as.list(target3)
#    tmp <- data_frame(target4, dep4, com2) %>%
#      unnest
#    for (j in 1:nrow(tmp)) {
#      tmp2 <-tmp[j,]
#      writeLines(paste(tmp2$target4), out, sep = ": ")
#      writeLines(paste(tmp2$dep4), out, sep = "\n")
#      writeLines(paste0("\t", com2), out, sep = "\n\n")
#    }
#  }
#}
#
#close(out)
