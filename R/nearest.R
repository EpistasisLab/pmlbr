#' Select nearest datasets given input `x`.
#'
#' If `x` is a data.frame object, computes dataset characteristics.
#' If `x` is a character object specifying dataset name from PMLB,
#' use the already computed dataset statistics/characteristics in `summary_stats`.
#'
#' @param x Character string of dataset name from PMLB,
#' or data.frame of n_samples x n_features(or n_features+1 with a target column)
#' @param y Vector of target column. Required when `x`` does not contain the target column.
#' @param n_neighbors Integer. The number of dataset names to return as neighbors.
#' @param dimensions Character vector specifying dataset characteristics to include in similarity calculation.
#' Dimensions must correspond to numeric columns of
#' [all_summary_stats.tsv](https://github.com/EpistasisLab/pmlb/blob/master/pmlb/all_summary_stats.tsv).
#' If 'all' (default), uses all numeric columns.
#' @param task Character string specifying classification or regression for summary stat generation.
#' @param target_name Character string specifying column of target/dependent variable.
#' @param \dots Further arguments passed to each method.
#'
#' @return Character string of names of most similar datasets to df, most similar dataset first.
#' @rdname nearest_datasets-methods
#'
#' @export
#'
#' @examples
#' nearest_datasets('penguins')
#' nearest_datasets(fetch_data('penguins'))
#'
nearest_datasets <- function(x, ...){
  UseMethod('nearest_datasets', x)
}


#' @rdname nearest_datasets-methods
#' @export
nearest_datasets.default <- function(x, ...){
  stop('`x` must be of class `data.frame` or `character`.')
}


#' @rdname nearest_datasets-methods
#' @export
nearest_datasets.character <- function(
  x, n_neighbors = 5,
  dimensions = c('n_instances', 'n_features'),
  target_name = 'target', ...) {

  if (!(x %in% dataset_names))
    stop("'dataset_name' ", x, " not found in PMLB.\n * Check spelling, capitalisation etc.", call.=FALSE)
  dataset_stats <- summary_stats[summary_stats$dataset == x, ]

  num_cols <- unlist(lapply(summary_stats, function(x) is.numeric(x)||is.integer(x)))
  summary_task <- summary_stats[summary_stats$task == dataset_stats$task, ] # restrict to same task
  summary_i <- summary_task[, num_cols]

  if (length(dimensions) == 1 && dimensions == 'all'){
    dimensions <- colnames(summary_i)
  } else {
    stopifnot(dimensions %in% colnames(summary_i))
    summary_i <- summary_i[, dimensions]
  }

  dataset_stats <- dataset_stats[, dimensions]
  nearest_indices <- FNN::get.knnx(summary_i, dataset_stats, k = n_neighbors)

  summary_task[nearest_indices$nn.index, 'dataset']
}


#' @rdname nearest_datasets-methods
#' @export
nearest_datasets.data.frame <- function(
  x, y = NULL, n_neighbors = 5,
  dimensions = c('n_instances', 'n_features'),
  task = c('classification', 'regression'),
  target_name = 'target', ...) {

  df <- if (is.null(y)) x else data.frame(x, target = y)

  # get summary stats for dataset
  if (is.null(task)){
    task <- if (length(unique(df$target)) < 5) 'classification' else 'regression'
  } else {
    task <- match.arg(task)
  }

  if (!(target_name %in% colnames(df)))
    stop(paste('Either x or y must contain', target_name))

  num_cols <- unlist(lapply(summary_stats, function(x) is.numeric(x)||is.integer(x)))
  summary_task <- summary_stats[summary_stats$task == task, ] # restrict to same task
  summary_i <- summary_task[, num_cols]

  if (length(dimensions) == 1 && dimensions == 'all'){
    dimensions <- colnames(summary_i)
  } else {
    stopifnot(dimensions %in% colnames(summary_i))
    summary_i <- summary_i[, dimensions]
  }

  feat_names <- setdiff(colnames(df), target_name)
  types <- vector('character')
  for (i in feat_names){
    types[i] <- get_type(df[,i], include_binary = TRUE)
  }

  feat <- table(types)
  for (type in c('binary', 'categorical', 'continuous')){
    if (!type %in% names(feat)) feat[type] <- 0
  }
  imb <- compute_imbalance(df[, target_name])

  dataset_stats <- data.frame(
    n_instances = nrow(df),
    n_features = length(feat_names),
    n_binary_features = feat['binary'],
    n_categorical_features = feat['categorical'],
    n_continuous_features = feat['continuous'],
    endpoint_type = get_type(df[, target_name]),
    n_classes = imb[['num_classes']],
    imbalance = imb[['imbalance']],
    task = task
  )

  dataset_stats <- dataset_stats[dimensions]
  nearest_indices <- FNN::get.knnx(summary_i, dataset_stats, k = n_neighbors)

  summary_task[nearest_indices$nn.index, 'dataset']
}

#' Computes imbalance value for a given dataset.
#'
#' @param target_col Factor or character vector of target column.
#'
#' @return A value of imbalance metric,
#' where zero means that the dataset is perfectly balanced
#' and the higher the value, the more imbalanced the dataset.
#'
compute_imbalance <- function(target_col){
  imb <- 0
  classes_count <- table(target_col)
  num_classes <- length(classes_count)
  for (x in classes_count){
    p_x = x/length(target_col)
  }

  if (p_x > 0){
    imb = imb + (p_x - 1/num_classes)*(p_x - 1/num_classes)
  }

  # worst case scenario: all but 1 examplars in 1st class
  # the remaining one in 2nd class
  worst_case <- (num_classes-1)*(1/num_classes)^2 + (1-1/num_classes)^2

  list(num_classes = num_classes, imbalance = imb/worst_case)
}

#' Get type/class of given vector.
#'
#' @param x Input vector.
#' @param include_binary Boolean.
#' Whether binary should be counted separately from categorical.
#'
#' @return Type/class of `x`.
#'
get_type <- function(x, include_binary = FALSE){
  x <- stats::na.omit(x)

  if (inherits(x, 'numeric')){
    return('continuous')
  } else if (inherits(x, 'integer') || inherits(x, 'factor')){
    if (include_binary){
      if (length(unique(x)) == 2) return('binary')}
    return('categorical')
  } else {stop("Cannot get types for dataset columns")}
}
