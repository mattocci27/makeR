#' Clean function
#'
#' Make Makefile of your R project
#'
#' @family make functions
#' @param output Outputfile, typically `Makefile`
#' @return `make_fun()` returns the input `x` invisibly.
#' @seealso
#' @examples
#' #tmp <- tempdir()
#' #ex_dir <- file.path(system.file("simple", package = "MakeR"), "")
#' #system(paste("tree", ex_dir))
#' #make_fun(ex_dir, "Makefile")
#' #system(paste0("cat ", ex_dir, "/Makefile"))
#' #make_clean(paste0(ex_dir, "Makefile"))
#' @export
make_clean <- function(x){
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
  for (i in 2:nrow(df1)) {
    tmp1 <- df1[i-1, "depends"]
    tmp2 <- df1[i, "depends"]
    tar1 <- df1[i-1, "target"] %>% unlist
    tar2 <- df1[i, "target"] %>% unlist
    com1 <- df1[i-1, "commands"]
    com2 <- df1[i, "commands"]
    if ((tmp1 == tmp2) && (com1 == com2)) {
      tmp[i] <- paste(tar1, tar2, sep = "_")
    }  else {
      tmp[i] <- tar2
  }}
  df_dc <- df1 %>%
    mutate(target = tmp) %>%
    filter(!is.na(target))
  tar_vec <- df_dc$target %>%
    str_c(., sep = " ", collapse = " ")
  out <- file(x, "w") # write
  writeLines(paste(".PHONY : all"), out, sep = "\n")
  writeLines(paste0("all : ", tar_vec), out, sep = "\n\n")
  for (i in 1:nrow(df_dc)) {
    tmp2 <- df_dc[i, ]
    writeLines(paste(tmp2$target), out, sep = ": ")
    writeLines(paste(tmp2$depends), out, sep = "\n")
    writeLines(paste0("\t", tmp2$commands), out, sep = "\n\n")
  }
  close(out)
  #print(paste("Created", x))
  print(paste("Created cleaned Makefile"))
  system(paste0("cat ", x))
}
