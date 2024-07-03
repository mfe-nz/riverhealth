testthat::test_that("make_component_table works with valid input", {
  # Create example indicator data frames
  macroinvertebrates <- data.frame(
    site = 1:3,
    class = c("default", "productive", "default"),
    indicator = "macroinvertebrates",
    component = "aquatic_life",
    reporting_scale = "region",
    metric1 = runif(3),
    metric2 = runif(3)
  )

  fish <- data.frame(
    site = 1:3,
    class = c("default", "productive", "default"),
    indicator = "fish",
    component = "aquatic_life",
    reporting_scale = "region",
    metric1 = runif(3),
    metric2 = runif(3)
  )

  plants <- data.frame(
    site = 1:3,
    class = c("default", "productive", "default"),
    indicator = "plants",
    component = "aquatic_life",
    reporting_scale = "region",
    metric1 = runif(3),
    metric2 = runif(3)
  )

  indicators <- list(macroinvertebrates, fish, plants)

  result <- make_component_table(indicators)

  # Check if result is a data frame
  testthat::expect_true(is.data.frame(result))

  # Check if the number of rows is equal to the number of indicators
  testthat::expect_equal(nrow(result), length(indicators))

  # Check if key columns are present in the result
  key_columns <- c("indicator", "component","data")
  testthat::expect_true(all(key_columns %in% colnames(result)))
})


# invalid input -----------------------------------------------------------


testthat::test_that("make_component_table only works when indicators come from the same component", {
  # Create example indicator data frames
  macroinvertebrates <- data.frame(
    site = 1:3,
    class = c("default", "productive", "default"),
    indicator = "macroinvertebrates",
    component = "aquaticLife",
    reporting_scale = "region",
    metric1 = runif(3),
    metric2 = runif(3)
  )

  fish <- data.frame(
    site = 1:3,
    class = c("default", "productive", "default"),
    indicator = "fish",
    component = "aquatic_life",
    reporting_scale = "region",
    metric1 = runif(3),
    metric2 = runif(3)
  )

  indicators <- list(macroinvertebrates,fish)

  # Check if error is thrown. Thi is a bit ciruclar but ok.
  testthat::expect_error(make_component_table(indicators))

})


# check that NAs are excluded ---------------------------------------------

testthat::test_that("make_component_table only works when indicators come from the same component", {
  # Create example indicator data frames
  macroinvertebrates <- data.frame(
    site = 1:3,
    class = c("default", "productive", NA),
    indicator = "macroinvertebrates",
    component = "aquatic_life",
    reporting_scale = "region",
    metric1 = runif(3),
    metric2 = runif(3)
  )

  fish <- data.frame(
    site = 1:3,
    class = c("default", "productive", "default"),
    indicator = "fish",
    component = "aquatic_life",
    reporting_scale = "region",
    metric1 = c(1,2,NA),
    metric2 = runif(3)
  )

  indicators <- list(macroinvertebrates,fish)

  result <- make_component_table(indicators)

  #if information about a site is missing, all metrics from that site get dropped out
  testthat::expect_equal(length(unique(result$data[[1]]$site)),2)
  #if only a metric has NA, then that metric gets dropped but the rest from the same site are not.
  testthat::expect_equal(length(unique(result$data[[2]]$site)),3)

})

