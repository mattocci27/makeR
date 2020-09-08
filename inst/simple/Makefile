.PHONY : all
all : ./inst/simple/images/fig1.png

./inst/simple/images/fig1.png: ./inst/simple/data/data.csv ./inst/simple/data/data2.csv ./inst/simple/data/data3.csv
	Rscript analysis.r

./inst/simple/data/fit.rda: ./inst/simple/data/data.csv ./inst/simple/data/data2.csv ./inst/simple/data/data3.csv
	Rscript analysis.r

