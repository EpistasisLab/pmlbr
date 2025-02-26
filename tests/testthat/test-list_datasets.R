test_that("pmlb_metadata works as expected", {
  skip_on_cran()
  data <- pmlb_metadata()
  expect_true(is.data.frame(data$summary_stats))
  expect_true(is.character(data$dataset_names))
  expect_true(is.character(data$classification_dataset_names))
  expect_true(is.character(data$regression_dataset_names))
})
