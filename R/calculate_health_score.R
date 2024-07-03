#' Calculate  Health Score
#'
#' This function is a wrapper to harmonize and integrate metric data into indicator and component health scores as outlined by Clapcott et al. 2019
#' @param indicators A list of data frames containing information about indicators. Each data frame should have  data about a different indicator and the columns: "site", "class", "indicator", "component", and "reporting_scale", plus extra columns for metrics measured.
#' @param reference_table  A data frame providing default values for excellent and poor ecological conditions. If the reference_table user input is not the one provided with the package (reference_table_default), it will be flagged as user defined benchmarks.
#' @param overall_score Logical indicating whether to calculate overall scores or group by reporting scale (default is TRUE).
#' @param npsfm_only  Logical indicating whether to consider only NPSFM components (default is FALSE).
#' @export
#' @examples
#'  macroinvertebrates <- data.frame( site = 1:3,class = c("universal"),
#'  indicator = "macroinvertebrates",
#'  component = "aquatic_life",
#'  reporting_scale = c("region_1","region_2","region_1"),
#'  mci = c(89,120,135))
#'
#'  calculate_health_score(indicators = list(macroinvertebrates),
#'  reference_table = reference_table_default)

calculate_health_score <- function(indicators,
                                   reference_table,
                                   npsfm_only=FALSE,
                                   overall_score=TRUE){

  if(!is.list(indicators) || length(indicators)< 1){
    stop("Indicator tables must be provided in a list with at least one element")
  }


  component_table <- make_component_table(indicators = indicators)

  performance_table <- calculate_performance_scores(component_table = component_table,
                                                    reference_table = reference_table)

  score_table <- calculate_suitability_score(performance_table = performance_table,
                                             overall_score = overall_score,
                                             npsfm_only = npsfm_only)

  score_table


}
