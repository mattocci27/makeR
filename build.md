
## Docker

```
# build
docker build -t maker:4.0.2 ./docker

# tag and push to private repo
docker tag ztpln:4.0.2  192.168.1.123:5000/ztpln:4.0.2
docker push 192.168.1.123:5000/ztpln:4.0.2

docker pull 192.168.1.123:5000/ztpln:4.0.2
docker tag 192.168.1.123:5000/ztpln:4.0.2 ztpln:4.0.2  

# run bash
docker run -it --rm -v $(pwd):/home/mattocci/ztpln -u mattocci ztpln:4.0.2 /bin/bash
docker run -it --rm -v $(pwd):/home/rstudio/makeR -u rstudio maker:4.0.2 /bin/bash

# run rstudio
docker run --rm -p 8787:8787 -v $(pwd):/home/rstudio/makeR -e PASSWORD=test maker:4.0.2
```


## Check

1. Build

```{r}

roxygen2::roxygenise()
#devtools::build_vignettes()
devtools::check(".", manual = TRUE)

devtools::build_manual(".")
devtools::build(".")


devtools::install_deps()
devtools::test()
devtools::test_coverage()
devtools::run_examples()
devtools::document()

devtools::check(".", manual = TRUE)

```

2. Copy pdf and tar.gz to this repo

```
cp ../makeR_0.0.1.900.pdf .
cp ../makeR_0.0.1.900.tar.gz .
```



3. Check

```
R CMD check --as-cran MakeR2_0.0.1.9000.tar.gz
```


5. Check for Windows

```{r}
devtools::check_win_release()
devtools::check_win_devel()
devtools::check_win_oldrelease()
```

6.  rhub

```{r}
library(rhub)
validate_email("mattocci27@gmail.com")
check_on_linux()

check_on_macos()

devtools::check(".", manual = TRUE)

```

