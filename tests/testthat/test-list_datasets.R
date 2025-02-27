test_that("pmlb_metadata works as expected", {
  skip_on_cran()
  data <- pmlb_metadata()
  expect_true(is.data.frame(data$summary_stats))
  expect_true(is.character(data$dataset_names))
  expect_true(is.character(data$classification_datasets))
  expect_true(is.character(data$regression_datasets))

  expect_true("penguins" %in% dataset_names())
  expect_true("penguins" %in% classification_datasets())
  expect_true("1089_USCrime" %in% regression_datasets())
})
