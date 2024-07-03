#' Make Component Table
#'
#' This function generates a nested data frame with metrics categorized by indicators.
#'
#' @param indicators A list of data frames containing information about indicators. Each data frame should have columns: "site", "class", "indicator", "component", and "reporting_scale", plus extra columns for metrics measured.
#' @return A nested data frame where each row is a different indicator and metric data is nested.
#' @export
#' @details
#' This function nests metric data within indicators from the same component to aid manipulation of disparate metrics. Data is nested in a long format, where each row is an observation for a given metric, for  a given site. If information is missing from a site, the whole site will be dropped. If information is missing from a metric, only that observation will be dropped.
#' @examples
#' # Create example indicator data frames
#' macroinvertebrates <- data.frame(
#' site = 1:3,class = c("default", "productive", "default"),
#' indicator = "macroinvertebrates",
#' component = "aquatic_life",
#' reporting_scale = "region",
#' metric1 = runif(3),
#' metric2 = runif(3))
#'
#' fish <- data.frame(
#' site = 1:3,
#' class = c("default", "productive", "default"),
#' indicator = "fish",
#' component = "aquatic_life",
#' reporting_scale = "region",
#' metric1 = runif(3),
#' metric2 = runif(3))
#'
#' make_component_table(list(macroinvertebrates, fish))



make_component_table <- function(indicators) {

  if(length(indicators) < 1){
    stop("No indicator tables provided.")
  }

  #these are columns needed to categorize metrics.
  key_columns <-  c("site","class","indicator","component", "reporting_scale")
  # Apply nest_indicator function to each indicator data frame
  nested_indicators <- lapply(indicators, nest_indicator_table, key_columns= key_columns)

  # Combine nested indicators into a single data frame
  component_table <- do.call(rbind, nested_indicators)

  if(length(unique(component_table$component)) > 1 ){
    stop("Only indicators belonging to the same component should be provided.")
  }

  component_table
}
