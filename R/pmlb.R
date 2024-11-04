#' fetch_data function
#'
#' Download a data set from the PMLB repository, (optionally) store it locally, and return the data set.
#' You must be connected to the internet if you are fetching a data set that is not cached locally.
#'
#' @param dataset_name The name of the data set to load from PMLB
#' @param return_X_y Boolean. Whether to return the data with the features and labels stored
#' in separate data structures or a single structure (can be TRUE or FALSE, defaults to FALSE)
#' @param local_cache_dir The directory on your local machine to store the data files in
#' (defaults to NA, indicating cache will not be used)
#' @param dropna Boolean. Whether rows with NAs should be automatically dropped. Default to TRUE.
#' @seealso \code{\link{summary_stats}}.
#' @export
#' @examples
#' # Features and labels in single data frame
#' penguins <- fetch_data("penguins")
#' head(penguins)
#'
#' # Features and labels stored in separate data structures
#' penguins <- fetch_data("penguins", return_X_y = TRUE)
#' penguins$x # data frame
#' penguins$y # vector
fetch_data <- function(dataset_name, return_X_y = FALSE, local_cache_dir = NA, dropna = TRUE) {
  GITHUB_URL <- "https://github.com/EpistasisLab/pmlb/raw/master/datasets"
  SUFFIX <- ".tsv.gz"

  if (!dataset_name %in% dataset_names) {
    stop("'dataset_name' ", dataset_name, " not found in PMLB.\n * Check spelling, capitalisation etc.", call. = FALSE)
  }

  if (!(is.logical(return_X_y) && length(return_X_y) == 1)) {
    stop("'return_X_y' must be TRUE or FALSE:\n * return_X_y is ", return_X_y, ".", call. = FALSE)
  }

  dataset_url <- paste0(
    GITHUB_URL, "/",
    dataset_name, "/",
    dataset_name,
    SUFFIX
  )

  if (is.na(local_cache_dir)) {
    tmp <- tempfile()
    if (!graceful_download(dataset_url, tmp)) {
      message("Continuing gracefully without the dataset.")
    } else {
      dataset <- utils::read.csv(
        gzfile(tmp),
        sep = "\t",
        header = TRUE,
        stringsAsFactors = FALSE
      )
    }
  } else {
    if (!file.exists(local_cache_dir)) {
      dir.create(file.path(local_cache_dir))
    }

    dataset_path <- file.path(local_cache_dir, paste0(dataset_name, SUFFIX))

    # read file from cache
    if (file.exists(dataset_path)) {
      dataset <- utils::read.csv(dataset_path,
        sep = "\t",
        header = TRUE,
        stringsAsFactors = FALSE
      )
      # download file to cache and read it
    } else {
      if (!graceful_download(dataset_url, dataset_path)) {
        message("Continuing gracefully without the dataset.")
      } else {
        dataset <- utils::read.csv(dataset_path,
          sep = "\t",
          header = TRUE,
          stringsAsFactors = FALSE
        )
      }
    }
  }

  if (return_X_y) {
    dataset <- list(
      x = dataset[, names(dataset) != "target"],
      y = dataset$target
    )
  }

  if (dropna) {
    return(stats::na.omit(dataset))
  }

  dataset
}



#' pmlb: R interface to the Penn Machine Learning Benchmarks data repository
#'
#' The \href{https://github.com/EpistasisLab/pmlb}{PMLB} repository contains a curated collection of data sets for evaluating and
#' comparing machine learning algorithms.
#' These data sets cover a range of applications, and include binary/multi-class classification problems and regression problems,
#' as well as combinations of categorical, ordinal, and continuous features.  There are approximately 290 data sets included in the PMLB repository
#' and there are no missing values in these data sets.
#'
#' This R library includes summaries of the classification and regression data sets but does NOT
#' include any of the PMLB data sets.  The data sets can be downloaded using the \code{\link{fetch_data}} function which
#' is similar to the corresponding PMLB python function.
#'
#' See \code{\link{fetch_data}}, \code{\link{summary_stats}} for usage examples and further information.
#'
#' If you use PMLB in a scientific publication, please consider citing the following paper:
#'
#' Randal S. Olson, William La Cava, Patryk Orzechowski, Ryan J. Urbanowicz, and Jason H. Moore (2017).
#'
#' PMLB: a large benchmark suite for machine learning evaluation and comparison
#'
#' https://biodatamining.biomedcentral.com/articles/10.1186/s13040-017-0154-4
#'
#' BioData Mining 10, page 36.
#'
#' I have no affiliation with the authors of PMLB or the University of Pennsylvania.
#'
#' @docType package
#' @name pmlb
NULL

#' Download a File Gracefully with Retry Mechanism
#'
#' Attempts to download a file from a specified URL, retrying a set number of times if the download fails.
#' This function meets CRAN's requirement for gracefully handling the use of internet resources by
#' catching errors and returning a warning message if the download ultimately fails.
#'
#' @param url Character. The URL of the file to download.
#' @param destfile Character. The path to the destination file where the downloaded content will be saved.
#' @param retries Integer. The maximum number of download attempts (default is 3).
#'
#' @return Logical. Returns `TRUE` if the download succeeds, `FALSE` otherwise.
#' @examples
#' \dontrun{
#' dataset_url <- "https://example.com/dataset.csv"
#' tmp <- tempfile(fileext = ".csv")
#' success <- download_file_gracefully(dataset_url, tmp)
#' if (!success) {
#'   message("Continuing gracefully without the dataset.")
#' }
#' }
graceful_download <- function(url, destfile, retries = 3) {
  attempt <- 1
  while (attempt <= retries) {
    tryCatch(
      {
        utils::download.file(url, destfile)
        message("Download successful.")
        return(TRUE)
      },
      error = function(e) {
        message(paste("Attempt", attempt, "failed:", e$message))
        attempt <<- attempt + 1
      }
    )
  }
  warning("Download failed after ", retries, " attempts.")
  return(FALSE)
}
