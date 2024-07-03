testthat::test_that("calculate performance scores works", {
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


  component_table <- make_component_table(indicators =list(macroinvertebrates, fish))

result <- calculate_performance_scores(component_table = component_table,
                                       reference_table = reference_table_default)

testthat::expect_true(is.data.frame(result))
#check that each row is a different indicator
testthat::expect_equal(nrow(result),2)

#check that values below the bottom lines are 0

macro_low <- result$performance_scores[[1]]$score[1]==0
fish_low <-  result$performance_scores[[2]]$score[1]==0

testthat::expect_true(all(macro_low, fish_low ))

# check that values above the reference are 1

macro_high <- result$performance_scores[[1]]$score[3]==1
fish_high <-  result$performance_scores[[2]]$score[3]==1

testthat::expect_true(all(macro_high, fish_high ))

})
