% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/list_datasets.R
\name{summary_stats}
\alias{summary_stats}
\title{Summary statistics}
\usage{
summary_stats()
}
\value{
A dataframe of summary statistics of all available datasets,
including number of instances/rows, number of columns/features, task, etc.
}
\description{
Summary statistics
}
\examples{
if (interactive()) {
  head(summary_stats())
}
}
