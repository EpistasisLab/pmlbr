test_that("nearest dataset is itself", {
  skip_on_cran()
  expect_equal(
    nearest_datasets("penguins")[[1]],
    "penguins"
  )
  expect_equal(
    nearest_datasets(fetch_data("lupus"))[[1]],
    "lupus"
  )

  expect_equal(
    nearest_datasets("1089_USCrime")[[1]],
    "1089_USCrime"
  )
})
