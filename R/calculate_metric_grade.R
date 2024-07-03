#' Calculate Metric Grades (NPSFM)
#'
#' This function calculates grades (A, B, C, D) based on given metric values compared
#' against reference thresholds, bottom lines, and cut-off values. The grading criteria
#' depend on whether the healthy value is "high" or "low".
#'
#' @param value Numeric vector of metric values to be graded.
#' @param reference Numeric vector specifying reference thresholds.
#' @param bottom_line Numeric vector specifying bottom line thresholds.
#' @param cut Numeric vector specifying cut-off thresholds.
#' @param healthy_value Character indicating the health direction of the metric values.
#'        Must be either "high" (higher values are healthier) or "low" (lower values are healthier).
#'
#' @return A character vector containing grades (A, B, C, D) corresponding to each value
#'         based on the provided thresholds and grading criteria.
#'
#' @export


calculate_metric_grade <- function(value, reference, bottom_line, cut, healthy_value) {
  # Check if any argument is NA
  if (anyNA(c(value, reference, bottom_line, cut))) {
    stop("All arguments must be numeric and not NA")
  }
  result <- character(length(value))
  # Vectorized comparison
  if(healthy_value == "high"){
    result[value >= reference] <- "A"
    result[value < reference & value > cut] <- "B"
    result[value < cut & value > bottom_line] <- "C"
    result[value <= bottom_line] <- "D"
  }else{

    result[value <= reference] <- "A"
    result[value > reference & value < cut] <- "B"
    result[value > cut & value < bottom_line] <- "C"
    result[value >= bottom_line] <- "D"
  }


  return(result)
}
