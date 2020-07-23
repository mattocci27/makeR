#' Make function
#'
#' Make Makefile of your R project
#'
#' @family make functions
#' @param path Path to output file
#' @param output Outputfile, typically `Makefile`
#' @param clean Should return cleaned Makefile? (default = T)
#' @return `make_fun()` returns the input `x` invisibly.
#' @seealso
#' @examples
#' tmp <- tempdir()
#' ex_dir <- file.path(system.file("simple", package = "MakeR"), "")
#' system(paste("tree", ex_dir))
#' make_fun(ex_dir, "Makefile")

#' @export
#make_fun <- function(path = NULL, output = "Makefile", clean = T, file_omit = NULL){
make_fun <- function(path = NULL, output = "Makefile", dir_omit = NULL , clean = T){
  if (is.null(path)) path <- paste0(getwd(), "/") else path

  #path <- "/home/mattocci/Dropbox/MS/sad_imm/"

  #files <- list.files(path)
  files <- list.files(path, recursive = T, include.dir = T)
  files2 <- files[str_detect(files, "\\.r$|\\.rmd$")]
  #files2 <- files[str_detect(files, "\\.r$|\\.sh$")]
  #files2 <- files[str_detect(files, "\\.r$")]
  files2 <- files2[files2 != "make_make.r" & files2 != "vis.r"]
 
  #file_omit <- NULL
  #length(file_omit)
  #dir_omit <- "old/"

  if (!is.null(dir_omit)) {
    for (i in 1:length(dir_omit)) {
      files2 <- files2[!str_detect(files2, dir_omit[i])]
    }
  }
  #file_omit <- c("data_cleaning.r", "fig_theme.r")
  #files3 <- files2

  #for (i in 1:length(file_omit)) {
  #  files2 <- files2[files2 != file_omit[i]]
  #}

  target_vec <- target_first_line(path)
  #out <- file(paste(output), "w") # write
  out <- file(paste0(path, output), "w") # write

  writeLines(paste(".PHONY : all"), out, sep = "\n")
  writeLines(paste0("all : ", target_vec), out, sep = "\n\n")

  for (i in 1:length(files2)) {
    #Lines <- readLines(paste(files2[i]))
    Lines <- readLines(paste0(path, files2[i]))
    #Lines <- readLines(paste(path, files2[i], sep = "\\"))
    Lines2 <- Lines[!str_detect(Lines, "^#")]

    dep <- Lines2[str_detect(Lines2, "read_csv|read.csv|read.delim|source|load|\\.stan$|read_delim|read_csv2")]
    dep2 <- str_split(dep, '"')
    dep3 <- sapply(dep2, "[", 2)
    dep4 <- str_c(na.omit(dep3), sep = " ", collapse = " ")
    target <- Lines2[str_detect(Lines2, "ggsave|write.csv|save.image|write_delim|write_csv|write_csv2|write_excel_csv|write_excel_csv_2|write_tsv")]
    target2 <- str_split(target, '"')
    target3 <- sapply(target2, "[", 2)

    #target3

    if (length(target3) > 0) target_TF <- is.na(target3) %>% unique
    if (length(target_TF) > 1) target_TF <- TRUE
    if ((length(dep2) > 0) && !target_TF) {

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
    tmp <- tibble(target4, dep4, com2) %>%
      unnest #%>%
     # filter(!is.na(target4))
    if (length(target3) != 0) {
      for (j in 1:nrow(tmp)) {
        tmp2 <-tmp[j,]
        writeLines(paste(tmp2$target4), out, sep = ": ")
        writeLines(paste(tmp2$dep4), out, sep = "\n")
        writeLines(paste0("\t", tmp2$com2), out, sep = "\n\n")
        #writeLines(paste0("  ", tmp2$com2), out, sep = "\n\n")
      }
    }

    }

  }
  close(out)
  if (clean == T) {
    make_clean(paste0(path, output))
  } else {
    print(paste("Created", output))
    system(paste0("cat ", path, "/Makefile"))
  }
}


#' @export
target_first_line <- function(path) {
  #files <- list.files(path)
  files <- list.files(path, recursive = T, include.dir = T)
  #files2 <- files[str_detect(files, "\\.r$|\\.rmd$|\\.sh$")]
  #files2 <- files[str_detect(files, "\\.r$")]
  files2 <- files[str_detect(files, "\\.r$|\\.rmd$")]
  target_new <- NULL
  for (i in 1:length(files2)) {
    Lines <- readLines(paste0(path, files2[i]))
   # Lines <- readLines(paste(path, files2[i], "\\"))
    Lines2 <- Lines[!str_detect(Lines, "^#")]
    #target <- Lines2[str_detect(Lines2, "ggsave|write.csv|save.image")]
    target <- Lines2[str_detect(Lines2, "ggsave|write.csv|save.image|write_delim|write_csv|write_csv2|write_excel_csv|write_excel_csv_2|write_tsv")]
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

#' @export
make_clean <- function(x){
 # x <- "Makefile"
#  x <- paste0(path, output)
  moge <- readLines(x)
  moge2 <- moge[-1:-3]
  df1 <- tibble(target = moge2[(1:length(moge2)) %% 3 == 1] %>%
                str_split(., ":") %>% 
                sapply(., "[[", 1),
              depends = moge2[(1:length(moge2)) %% 3 == 1] %>%
                str_split(., ":") %>% 
                sapply(., "[[", 2),
              commands = moge2[(1:length(moge2)) %% 3 == 2]) 
  tmp <- NULL
  tar <- NULL
  label <- NULL
  tar[1] <- df1[1, "target"] %>% unlist
  tmp[1] <- df1[1, "depends"] %>% unlist
  for (i in 2:nrow(df1)) {
    tmp1 <- df1[i-1, "depends"] %>% unlist
    tmp2 <- df1[i, "depends"] %>% unlist
    tar1 <- df1[i-1, "target"] %>% unlist
    tar2 <- df1[i, "target"] %>% unlist
    com1 <- df1[i-1, "commands"]
    com2 <- df1[i, "commands"]
    if (com1 == com2) {
      #tar[i] <- paste(tar1, tar2, sep = " ")
      tar[i] <- str_split(paste(tar[i-1], tar2), " ") %>% unlist %>% unique %>%
        str_c(., sep = " ", collapse = " ")
      tmp[i] <- str_split(paste(tmp[i-1], tmp2), " ") %>% unlist %>% unique %>%
        str_c(., sep = " ", collapse = " ")
      label[i-1] <- "duplicate"
    }  else {
      tar[i] <- tar2
      tmp[i] <- tmp2
      label[i-1] <- "check"
    }
  }
  label[nrow(df1)] <- "check"

  df_dc <- df1 %>%
    mutate(target = tar) %>%
    mutate(depends = tmp) %>%
    mutate(label = label) %>%
    filter(!is.na(target)) %>%
    filter(label == "check") %>%
    mutate(target = str_replace_all(target, " ", "-"))

  tar_vec <- df_dc$target %>%
    str_c(., sep = " ", collapse = " ")
  out <- file(x, "w") # write
  writeLines(paste(".PHONY : all"), out, sep = "\n")
  writeLines(paste0("all : ", tar_vec), out, sep = "\n\n")
  for (i in 1:nrow(df_dc)) {
    tmp2 <- df_dc[i, ]
    writeLines(paste(tmp2$target), out, sep = ":")
    writeLines(paste(tmp2$depends), out, sep = "\n")
    writeLines(paste0("\t", tmp2$commands), out, sep = "\n\n")
    #writeLines(paste0(tmp2$commands), out, sep = "\n\n")
  }
  close(out)
  #print(paste("Created", x))
  print(paste("Created cleaned Makefile"))
  system(paste0("cat ", x))
}
