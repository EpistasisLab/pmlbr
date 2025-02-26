#' Get Summary Statistics
#'
#' Downloads and processes the latest summary statistics from PMLB.
#' Use cache if available.
#'
#' @return A list containing summary_stats, dataset_names, classification_dataset_names, and regression_dataset_names
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
      "regression_dataset_names",
      sort(summary_stats[summary_stats$task == "regression", "dataset"]),
      envir = .pmlbr_env
    )
    assign(
      "classification_dataset_names",
      sort(summary_stats[summary_stats$task == "classification", "dataset"]),
      envir = .pmlbr_env
    )
  }

  list(
    summary_stats = .pmlbr_env$summary_stats,
    dataset_names = .pmlbr_env$dataset_names,
    classification_dataset_names = .pmlbr_env$classification_dataset_names,
    regression_dataset_names = .pmlbr_env$regression_dataset_names
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
  pmlb_metadata()$classification_dataset_names
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
  pmlb_metadata()$regression_dataset_names
}

#' All summary statistics
#'
#' @return A character vector of regression dataset names.
#' @export
#' @examples
#' if (interactive()) {
#'   head(summary_stats())
#' }
summary_stats <- function() {
  pmlb_metadata()$summary_stats
}
