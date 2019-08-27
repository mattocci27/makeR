#' vis function
#'
#' Make Makefile of your R project
#'
#' @family vis functions
#' @param output Outputfile, typically `Makefile`
#' @return `make_fun()` returns the input `x` invisibly.
#' @seealso
#' @examples
#' tmp <- tempdir()
#' ex_dir <- file.path(system.file("simple", package = "MakeR"), "")
#' system(paste("tree", ex_dir))
#' make_fun(ex_dir, "Makefile", clean = FALSE)
#' plan <- make_dat_fun(paste0(ex_dir, "Makefile"))
#' vis_fun(plan)
#' @export
vis_fun <- function(make_dat, direction = "LR") {
  visNetwork(
             make_dat$nodes,
             make_dat$edges,
             shape = make_dat$shape,
             arrows = make_dat$arrows,
             group = make_dat$group,
             width = "100%") %>%
  visHierarchicalLayout(direction = direction) %>%
  visGroups(groupname = "command",
            shape = "circle",
            color = "#03A9F4") %>%
  visGroups(groupname = "data",
            shape = "square",
            color = "#009688") %>%
  visGroups(groupname = "figure",
            shape = "triangle",
            color = "#FFC107") %>%
  visLegend(
            addNodes = make_dat$shape)
}

#' @export
get_target <- function(Lines) {
  target <- NULL
  Lines2 <- Lines[!str_detect(Lines, "PHONY|^clean")]
  for (i in 1:(length(Lines2)-2)) {
    if (Lines2[i] == "") {
      tmp <- Lines2[i+1]
      tmp2 <- str_split(tmp, ":")[[1]][1]
      target <- c(target, tmp2)
    }
  }
  target
}

#' @export
get_commands <- function(Lines) {
  com <- NULL
  Lines2 <- Lines[!str_detect(Lines, "PHONY|^clean")]
  for (i in 1:(length(Lines2))) {
    if (str_detect(Lines2[i], "\t")) {
    #if (str_detect(Lines2[i], "  ")) {
      tmp2 <- str_split(Lines2[i], " ")[[1]][2]
      com <- c(com, tmp2)
    }
  }
  com
}

#' @export
get_dependency <- function(Lines) {
  dep <- list()
  Lines2 <- Lines[!str_detect(Lines, "PHONY|^clean")]
  j <- 1
  for (i in 1:(length(Lines2)-2)) {
    if (Lines2[i] == "") {
      tmp <- Lines2[i+1]
      tmp2 <- str_split(tmp, ": | ")[[1]][-1]
      dep[[j]] <-  tmp2
      j <- j + 1
    }
  }
  dep[dep == "character(0)"] <- NA
  dep
}

#Lines <- readLines(paste("Makefile"))
#Lines <- Lines[!str_detect(Lines, "^#")]


#' @export
make_dat_fun <- function(x){
#  Makefile <- "Makefile"
  Lines <- readLines(paste(x))
  Lines <- Lines[!str_detect(Lines, "^#")]

  dep <- get_dependency(Lines)
  com <- get_commands(Lines)
  target <- get_target(Lines)

  node_f <- c(com, target, unlist(dep)) %>%
    unique

  # order by lines
 # node_f <- data_frame(com, target, dep) %>%
 #   unnest %>%
 #   t %>%
 #   as.vector %>%
 #   unique

  node_dat <- data_frame(node_f) %>%
    mutate(node_n = 1:nrow(.)) %>%
    mutate(obj = ifelse(str_detect(node_f, "\\.r$"),
                        "circle",
                        "square")) %>%
    mutate(obj  = ifelse(str_detect(node_f, "\\.png$|\\.eps$|\\.pdf"),
                        "triangle",
                        obj)) %>%
    mutate(gr = ifelse(str_detect(node_f, "\\.r$|\\.R$"),
                        "command",
                        "data")) %>%
    mutate(gr = ifelse(str_detect(node_f, "\\.png$|\\.eps$"),
                        "figure",
                        gr))

  node_id <- node_dat %>%
    select(node_f, node_n)

  com_to_target <- data_frame(com, target) %>%
    left_join(., node_id, by = c("com" = "node_f")) %>%
    rename(start_id = node_n) %>%
    left_join(., node_id, by = c("target" = "node_f")) %>%
    rename(end_id = node_n) %>%
    select(start_id, end_id) %>%
    mutate(arrows = "to")

  com_to_target

  target_to_com <- data_frame(dep, com) %>%
    unnest %>%
    select(dep, com) %>%
    left_join(., node_id, by = c("dep" = "node_f")) %>%
    rename(start_id = node_n) %>%
    left_join(., node_id, by = c("com" = "node_f")) %>%
    rename(end_id = node_n) %>%
    select(start_id, end_id) %>%
    mutate(arrows = "to")

  target_to_com

  edge <- bind_rows(com_to_target, target_to_com) %>%
    unique

  edge

  nodes <- data.frame(
    id = 1:nrow(node_dat),
    label = node_dat$node_f,
    shape = node_dat$obj,
    group = node_dat$gr
    )

  edges <- data.frame(
    from = edge$start_id,
    to = edge$end_id,
    arrows = edge$arrows
#  label = dep4$dep
  )

  list(nodes = nodes, edges = edges)
}


#' @export
debug_make <- function() {
  Lines <- run(commandline = "make --just-print")$stderr
  if (Lines == "") {
    return("no change. Up to date")
  }
  tmp <- str_split(Lines, "]") %>% unlist
  changed <- tmp[str_detect(tmp, "\\[Changed:")]
  changed2 <- str_split(changed, "\\[Changed: ") %>%
    sapply(., "[", 2)
  changed3 <- str_split(changed2, " ") %>%
    unlist %>%
    unique
  making <- tmp[str_detect(tmp, "\\[Making:")]
  making2 <- str_split(making, "\\[Making: ") %>%
    sapply(., "[", 2)

  c(changed3, making2) %>%
    unique
}

#plan <- make_dat_fun("Makefile")
#debug(make_dat_fun)
#plan <- make_dat_fun("test.txt")
#debug_make()
#run(commandline = "make --just-print")
#vis_fun(plan)
#moge <- function(x){
#  Lines <- readLines(paste(x))
#  Lines <- Lines[!str_detect(Lines, "^#")]
#  Lines
#}
#moge("Makefile")
#
#dep <- get_dependency(moge("Makefile"))
