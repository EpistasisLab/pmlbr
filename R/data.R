#' Names of all available datasets
#'
#' A list of the names of available datasets
#'
#' @source \url{https://github.com/EpistasisLab/penn-ml-benchmarks}
"dataset_names"

#' Names of available classification datasets
#'
#' A list of the names of available classification datasets
#'
#' @source \url{https://github.com/EpistasisLab/penn-ml-benchmarks}
"classification_dataset_names"

#' Names of available regression datasets
#'
#' A list of the names of available regression datasets
#'
#' @source \url{https://github.com/EpistasisLab/penn-ml-benchmarks}
"regression_dataset_names"

#' Summary statistics for the all datasets
#'
#' @format A data frame with 10 variables:
#' \describe{
#'   \item{dataset:}{Dataset name}
#'   \item{n_instances:}{Number of data observations (equal to number of rows)}
#'   \item{n_features:}{Total number of features (number of columns - 1)}
#'   \item{n_binary_features:}{Number of binary features}
#'   \item{n_categorical_features:}{Number of categorical features}
#'   \item{n_continuous_features:}{Number of continuous features}
#'   \item{n_classes:}{Number of classes in target variable}
#'   \item{endpoint_type:}{Value type of endpoint/target (can be binary, categorical or continuous)}
#'   \item{imbalance:}{Imbalance metric, where zero means that the dataset is perfectly balanced and the higher the value, the more imbalanced the dataset}
#'   \item{task:}{Type of problem/task. Can be classification or regression.}
#' }
#'
#' @source \url{https://github.com/EpistasisLab/penn-ml-benchmarks}
"summary_stats"
