summary_stats <- read.csv('https://raw.githubusercontent.com/EpistasisLab/penn-ml-benchmarks/010f4224694b0362b858be16a81055f7e401047d/datasets/all_summary_stats.csv')
colnames(summary_stats) <- tolower(gsub('X.', 'n_', colnames(summary_stats)))
dataset_names <- summary_stats$dataset

regression_dataset_names <- subset(summary_stats, problem_type == 'regression')$dataset
classification_dataset_names <- subset(summary_stats, problem_type == 'classification')$dataset

usethis::use_data(summary_stats, dataset_names,
                  classification_dataset_names,
                  regression_dataset_names,
                  overwrite = TRUE)
