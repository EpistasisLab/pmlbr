#' Get metadata for all datasets in PMLB.
#'
#' Metadata like summary statistics and names of available datasets
#' on the PMLB repository.
#'
#' @return A list containing summary_stats, dataset_names, classification_datasets, and regression_datasets
#' @export
#' @examples
#' if (interactive()) {
#'   sample(pmlb_metadata()$dataset_names, 10)
#' }
pmlb_metadata <- function() {
  if (!exists("summary_stats", envir = .pmlbr_env)) {
    links_to_stats <- 'https://github.com/EpistasisLab/pmlb/raw/master/pmlb/all_summary_stats.tsv'
    summary_stats <- utils::read.csv(links_to_stats, sep = '\t')
    colnames(summary_stats) <- tolower(gsub(
      'X.',
      'n_',
      colnames(summary_stats)
    ))
    assign(
      "summary_stats",
      summary_stats,
      envir = .pmlbr_env
    )
    assign(
      "dataset_names",
      summary_stats$dataset,
      envir = .pmlbr_env
    )
    assign(
      "regression_datasets",
      sort(summary_stats[summary_stats$task == "regression", "dataset"]),
      envir = .pmlbr_env
    )
    assign(
      "classification_datasets",
      sort(summary_stats[summary_stats$task == "classification", "dataset"]),
      envir = .pmlbr_env
    )
  }

  list(
    summary_stats = .pmlbr_env$summary_stats,
    dataset_names = .pmlbr_env$dataset_names,
    classification_datasets = .pmlbr_env$classification_datasets,
    regression_datasets = .pmlbr_env$regression_datasets
  )
}


#' All available datasets
#'
#' @return A character vector of all dataset names.
#' @export
#' @examples
#' if (interactive()) {
#'   sample(dataset_names(), 10)
#' }
dataset_names <- function() {
  pmlb_metadata()$dataset_names
}

#' Classification datasets
#'
#' @return A character vector of classification dataset names.
#' @export
#' @examples
#' if (interactive()) {
#'   sample(classification_datasets(), 10)
#' }
classification_datasets <- function() {
  pmlb_metadata()$classification_datasets
}

#' Regression datasets
#'
#' @return A character vector of regression dataset names.
#' @export
#' @examples
#' if (interactive()) {
#'   sample(regression_datasets(), 10)
#' }
regression_datasets <- function() {
  pmlb_metadata()$regression_datasets
}

#' Summary statistics
#'
#' @return A dataframe of summary statistics of all available datasets,
#' including number of instances/rows, number of columns/features, task, etc.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   head(summary_stats())
#' }
summary_stats <- function() {
  pmlb_metadata()$summary_stats
}
