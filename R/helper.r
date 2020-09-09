#' Help function
#'
#' Make Makefile of your R project
#'
#'
#' @export
#' @param output Outputfile, typically `Makefile`
#' @return `make_fun()` returns the input `x` invisibly.
#' @seealso
#' @examples


#Lines <- readLines(paste0(path, files2[i]))
#file_path_ori <- "inst/hpc/model/model.r"
#
#Lines <- readLines(paste0("inst/hpc/model/model.r"))
#Lines2 <- Lines[!str_detect(Lines, "^#")]
#Lines3 <- Lines2[str_detect(Lines2, "argv|save.image|paste|str_c")]
#Lines3 %>% str_replace("save.image", "a <- ")
#
#path <- tempdir()
#output <- "tmp.r"
#file_path <- file.path(path, output)
#out <- file(file.path(path, output), "w") # write
#writeLines(Lines3, con = out, sep = "\n")
#close(out)
#
#readLines(file.path(path, output))
#
## shell
#Lines <- readLines(paste0("inst/hpc/sh/model.sh"))
#model_line <- Lines[str_detect(Lines, "\\.r")]
#str_replace(model_line, "./model/model.r", file_path )
#
#path <- tempdir()
#output <- "tmp.r"
#out <- file(file.path(path, output), "w") # write
#writeLines(Lines3, con = out, sep = "\n")
#close(out)
#
#readLines(file.path(path, output))
