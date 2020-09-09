

# pmlb

![Lifecycle
](https://img.shields.io/badge/lifecycle-maturing-blue.svg?style=flat)
![R 
%>%= 3.1.0](https://img.shields.io/badge/R->%3D3.1.0-blue.svg?style=flat)
![Dependencies
](https://img.shields.io/badge/dependencies-none-brightgreen.svg?style=flat)
[![R build status](https://github.com/EpistasisLab/pmlb/workflows/R-CMD-check/badge.svg)](https://github.com/EpistasisLab/pmlb/actions)

pmlb is an R interface to the [Penn Machine Learning Benchmarks](https://github.com/EpistasisLab/penn-ml-benchmarks) (PMLB) data repository 

If you like pmlb, give it a star, or fork it and contribute!


## Usage

<img src="man/figures/pmlblite_usage_animated.gif" align="center" />

Check available data sets and download data from the PMLB repository:

```r
library(pmlb)

# Data set names
classification_dataset_names
regression_dataset_names

# Data set summaries
classification_summary
regression_summary

# Download features and labels for iris data set in single data frame
iris <- fetch_data('iris')
iris

# Download features and labels for iris data set in separate data structures
iris <- fetch_data('iris', return_X_y=TRUE)
iris$x # data frame
iris$y # vector
```


## Installation

Should work with any recent version of R.

```r
install.packages("devtools") # Install devtools package if necessary
library(devtools)
devtools::install_github("EpistasisLab/pmlb")
```


## Details

The PMLB repository contains a curated collection of data sets for evaluating and comparing machine learning algorithms. 
These data sets cover a range of applications, and include binary/multi-class classification problems and regression problems, 
as well as combinations of categorical, ordinal, and continuous features.  There are approximately 290 data sets included in the PMLB repository
and there are no missing values in these data sets.

All binary and multiclass classification data sets are in the `classification` category, and all regression data sets are in the `regression` category.

### Data set format

All data sets are stored in a common format:

* First row is the column names
* Each following row corresponds to an individual observation
* The target column is named `target`
* All columns are tab (`\t`) separated
* All files are compressed with `gzip` to conserve space


The python interface to the [PMLB](https://github.com/EpistasisLab/penn-ml-benchmarks) repository is great but can't be used from the R language.

This R library includes summaries of the classification and regression data sets but does **not**
include any of the PMLB data sets.  The data sets can be downloaded using the `fetch_data` function which
is similar to the corresponding PMLB python function.  

Further info:
```r
?fetch_data
?regression_summary
?classification_summary
```


### Citing

If you use PMLB in a scientific publication, please consider citing the following paper:

Randal S. Olson, William La Cava, Patryk Orzechowski, Ryan J. Urbanowicz, and Jason H. Moore (2017).
[PMLB: a large benchmark suite for machine learning evaluation and comparison](https://biodatamining.biomedcentral.com/articles/10.1186/s13040-017-0154-4).
BioData Mining 10, page 36.


## Roadmap

* Add tests
* Submit library to CRAN


## Contributing

Pull requests are welcome.  For major changes, please open an issue first to discuss what you would like to change.

Integration of other data repositories are particularly welcome.


## Alternatives

* [Penn Machine Learning Benchmarks](https://github.com/EpistasisLab/penn-ml-benchmarks)
* [OpenML](https://www.openml.org/search?type=data)
    Approximately 2,500 datasets - available for download using [R module](https://github.com/openml/openml-r)
* [UC Irvine Machine Learning Repository](https://archive.ics.uci.edu/ml/index.php)
* [mlbench: Machine Learning Benchmark Problems](https://cran.r-project.org/package=mlbench)
* [Rdatasets: An archive of datasets distributed with R](https://vincentarelbundock.github.io/Rdatasets/)
* [datasets.load: Visual interface for loading datasets in RStudio from all installed (unloaded) packages](https://cran.r-project.org/package=datasets.load)
* [stackoverflow: How do I get a list of built-in data sets in R?](https://stackoverflow.com/questions/33797666/how-do-i-get-a-list-of-built-in-data-sets-in-r)

## License
[GPL-2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
