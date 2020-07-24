# File-based Make for R files

**DISCLAIMER**: This is an experimental repository to generate and visualize Makefile for R projects. It only supports specific conditions (comprehensive arguments are not implemented). Please be careful when you run `make` outside your test repository.

`makeR` checks all R scripts in the directory, and determines file dependency based on keys in the R scripts such as `read.csv`, `read_csv`, `source`, `load`... `makeR` determines file target based on keys such as `save.image`, `write.csv`, `ggsave`...




## Example

The current directory contains three R scripts (`csv_script1-3.r`) that generate csv files (`data1-3.csv`). `analysis.r` will do some analyses using those csv files and produce a figure (`fig1.png`) and a rda file (`fit.rda`). `make_fun` function makes Makefile based on the above.

```{r}
tmp <- tempdir()
ex_dir <- file.path(system.file("simple", package = "MakeR2"), "")
system(paste("ls", ex_dir))
make_fun(ex_dir, "Makefile")

```

![Visualization of Makefile](network.png)

To see the content of Makefile on your terminal:

```{bash}
cat Makefile

## .PHONY : all
## all : fig1.png fit.rda data.csv data2.csv data3.csv
##
## fig1.png: data.csv data2.csv data3.csv
##  Rscript analysis.r
##
## fit.rda: data.csv data2.csv data3.csv
##  Rscript analysis.r
##
## data.csv: csv_script.r
##  Rscript csv_script.r
##
## data2.csv: csv_script2.r
##  Rscript csv_script2.r
##
## data3.csv: csv_script3.r
##  Rscript csv_script3.r
```

To make your R project on your terminal:

```{bash}
make
```

To make your R project on your R console:
```{r}
run("make")
```

## Issues

- Rmarkdown files are not supported.
- Arguments to specify file dependency are not implemented.
