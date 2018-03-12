.PHONY : all
all : fig1.png fit.rda data.csv data2.csv data3.csv

fig1.png: data.csv data2.csv data3.csv
	Rscript analysis.r

fit.rda: data.csv data2.csv data3.csv
	Rscript analysis.r

data.csv: csv_script.r
	Rscript csv_script.r

data2.csv: csv_script2.r
	Rscript csv_script2.r

data3.csv: csv_script3.r
	Rscript csv_script3.r

