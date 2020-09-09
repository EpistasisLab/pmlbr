links_to_stats <- 'https://github.com/EpistasisLab/penn-ml-benchmarks/raw/master/pmlb/all_summary_stats.tsv'
summary_stats <- read.csv(links_to_stats, sep = '\t')
colnames(summary_stats) <- tolower(gsub('X.', 'n_', colnames(summary_stats)))
dataset_names <- summary_stats$dataset

regression_dataset_names <- sort(subset(summary_stats, task == 'regression')$dataset)
classification_dataset_names <- sort(subset(summary_stats, task == 'classification')$dataset)

usethis::use_data(summary_stats, dataset_names,
                  classification_dataset_names,
                  regression_dataset_names,
                  overwrite = TRUE)
