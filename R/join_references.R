#' Join References to Component Table
#'
#' This function joins reference tables with a component table based on matching indicators
#' and components. It verifies that each indicator in the component table has a corresponding
#' reference table and that all metrics in the component table have associated references.
#'
#' @param component_table A nested data frame containing information about indicators, components,
#'        and associated metrics.
#' @param nested_reference_tables A nested reference table
#' @return A data frame where each row represents a joined indicator-component pair with its
#'         associated reference information.
#' @export

join_references <- function(component_table,
                            nested_reference_tables){

  for (indicator in component_table$indicator) {
    if (!indicator %in% nested_reference_tables$indicator) {
      stop(paste0("The following reference is missing: ", indicator, collapse = " "))
    }
  }

  if (any(duplicated(nested_reference_tables$indicator))) {
    stop("More than one reference table provided per indicator")
  }

  if (any(
    !unique(nested_reference_tables$component) %in% unique(component_table$component)
  )) {
    stop("Component columns should match between the component table and reference tables.")
  }

  component_table_reference <- component_table %>%
    dplyr::left_join(nested_reference_tables,
              by=c("indicator","component"))

  #check if all metrics have a reference associated to them
  test_metrics <- component_table_reference %>%
    dplyr::rowwise() %>%
    dplyr::mutate("check_match" = list(all(
      unique(data$metric) %in% unique(metric_health$metric)
    )),
    "missing_metrics" = list(ifelse(check_match, " " , paste0(unique(data$metric)[which(!unique(data$metric) %in% unique(metric_health$metric))], collapse = " ") ))) %>%
    dplyr::select(indicator, check_match , missing_metrics) %>%
    tidyr::unnest(c(missing_metrics, check_match))


  for(i in 1:nrow(test_metrics)){
    ind <- test_metrics[i,]
    if(!ind$check_match){
      stop(paste0("The following metrics are missing a reference:", ind$missing_metrics))
    }
  }

  component_table_reference

}
