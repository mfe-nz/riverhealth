#' Calculate performance score based on component and reference tables
#'
#' This function calculates performance scores based on the provided component table
#' and reference table. It matches the components in the component table with the
#' corresponding benchmarks in the reference tables and computes performance scores
#' based on Equations 1 and 2 of Clapcott et al. 2019. If metrics are deemed nonlinear, then  the values of bottom_line_range and reference_range will be used to calculate performance scores.
#'
#' @param component_table A nested data frame containing the components to calculate performance scores for. Should be the output of the funciton `make_component_table`
#' @param reference_table  A data frame providing default values for excellent and poor ecological conditions. If the reference_table user input is not the one provided with the package (reference_table_default), it will be flagged as user defined benchmarks.
#'
#' @return A data frame containing the calculated performance scores.
#'
#' @export
#' @examples
#' #' # Create example indicator data frames
#' macroinvertebrates <- data.frame(
#' site = 1:3,class = c("universal"),
#' indicator = "macroinvertebrates",
#' component = "aquatic_life",
#' reporting_scale = c("region_1","region_2","region_1"),
#' mci = c(89,120,135))
#'
#' component_table <- make_component_table(indicators =list(macroinvertebrates))
#'
#' calculate_performance_scores(component_table = component_table,
#' reference_table = reference_table_default)
#'

calculate_performance_scores <- function(component_table,
                                         reference_table){
# input validation --------------------------------------------------------

  component_table <- check_component_table(component_table = component_table)


# check if default baselines are being used -------------------------------

  default_baseline <- identical(reference_table, reference_table_default)

# select the corresponding reference tables -------------------------------

reference_table <- reference_table %>%
  dplyr::filter(component %in% component_table$component,
         indicator %in% component_table$indicator)

key_columns <- c("metric","class","bottom_line","reference","healthy_value","indicator","component","cut","npsfm","attribute","suitability", "reference_range","bottom_line_range","key_metric")

 nested_reference_tables <- nest_reference_table(reference_table = reference_table,
                                          key_columns = key_columns)

# join component and reference tables -------------------------------------

 component_table_reference <- join_references(component_table = component_table,
                                              nested_reference_tables = nested_reference_tables)

# calculate references/bottom line values ---------------------------------

  #match measured values with references
  component_table_reference <- component_table_reference %>%
    dplyr::rowwise() %>%
    dplyr::mutate("reference_table"= list(dplyr::left_join(data, metric_health, by = c("metric", "class")))) %>%
    dplyr::select(-data, -metric_health)


  component_table_reference <- component_table_reference %>%
   tidyr::unnest(reference_table)

# calculate performance scores --------------------------------------------

  #calculate scores depending on the input of "healthy" value.

   component_table_reference <- component_table_reference %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      score = if (healthy_value == "nonlinear") {
        calculate_nonlinear_performance_score(
          value = value,
          reference = reference,
          bottom_line = bottom_line,
          reference_range = reference_range,
          bottom_line_range = bottom_line_range
        )
      } else if (healthy_value == "low") {
        min(1, max(0, (bottom_line - value) / (bottom_line - reference)))
      } else {
        min(1, max(0, (value - bottom_line) / (reference - bottom_line)))
      }
    )


  #nest for easy manipulation
  component_table_reference <- component_table_reference %>%
    dplyr::mutate("default_baseline"= default_baseline) %>%
    dplyr::group_nest(indicator, component,.key = "performance_scores")

  component_table_reference


}


