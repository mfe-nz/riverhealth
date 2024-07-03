test_that("calculate_suitability_score works", {
  #creating values below, in the middle and above benchmarrks
  macroinvertebrates <- data.frame(
    site = 1:3,class = c("universal"),
    indicator = "macroinvertebrates",
    component = "aquatic_life",
    reporting_scale = c("region_1","region_2","region_1"),
    mci = c(89,120,135))

  fish <- data.frame(
    site = 1:3,
    class = c("universal"),
    indicator = "fish",
    component = "aquatic_life",
    reporting_scale = "region_1",
    fish_ibi = c(16,26,35))


  component_table <- make_component_table(indicators = list(macroinvertebrates, fish))

  performance_scores <- calculate_performance_scores(component_table = component_table, reference_table = reference_table_default)

  result_1 <- calculate_suitability_score(
    performance_table = performance_scores,
    npsfm_only = FALSE,
    overall_score = TRUE
  )
  #if overall score is TRUE, only one row per indicator
  testthat::expect_equal(nrow(result_1),2)

  result_2 <- calculate_suitability_score(
    performance_table = performance_scores,
    npsfm_only = FALSE,
    overall_score = FALSE
  )

  #if overall score is FALSE, expect a row per indicator and reporting_scale_combination
  testthat::expect_equal(nrow(result_2),3)

  #however the number of observations should not differ

  testthat::expect_equal( sum(result_1$observations), sum(result_2$observations) )



})
