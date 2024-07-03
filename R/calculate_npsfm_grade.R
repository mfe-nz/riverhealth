
#' Calculate NPSFM Grades
#'
#' This function calculates NPSFM  grades  based on mean metric values and grade bands defined in the 2020 National Policy Statement for Freshwater Management.
#'
#'
#' @param indicators A list of data frames containing information about indicators. Each data frame should have columns: "site", "class", "indicator", "component", and "reporting_scale", plus extra columns for metrics measured.
#' @param reference_table  A data frame providing default values for excellent and poor ecological conditions. If the reference_table user input is not the one provided with the package (reference_table_default), it will be flagged as user defined benchmarks.
#' @param overall_score Logical indicating whether to calculate overall scores or group by reporting scale (default is TRUE).
#' @export
#' @examples
#'  macroinvertebrates <- data.frame( site = 1:3,class = c("universal"),
#'  indicator = "macroinvertebrates",
#'  component = "aquatic_life",
#'  reporting_scale = c("region_1","region_2","region_1"),
#'  mci = c(89,120,135))
#'
#'  calculate_npsfm_grade(indicators = list(macroinvertebrates),
#'  reference_table = reference_table_default,
#'  overall = TRUE)


calculate_npsfm_grade <- function(indicators,
                                  reference_table,
                                  overall_score = TRUE){

  if(!is.list(indicators) || length(indicators)< 1){
    stop("Indicators must be a list with at least one element")
  }
  #nest data
  component_table <- make_component_table(indicators = indicators)

  #match data with references
  performance_table <- calculate_performance_scores(component_table = component_table,
                                                    reference_table = reference_table)

  performance_table <- performance_table %>%
    tidyr::unnest(performance_scores)

  if(overall_score){
  grouping_vars <-  c("indicator", "component", "class" , "metric")
  }else{
  grouping_vars <-  c("indicator", "component","class","reporting_scale","metric")
    }


  npsfm_grade <-  performance_table %>%
    dplyr::group_by(dplyr::across(dplyr::all_of(grouping_vars))) %>%
    dplyr::summarise("metric_mean"= mean(value),
              "attribute"= unique(attribute),
              "reference"= unique(reference),
              "bottom_line"= unique(bottom_line),
              "cut"=unique(cut),
              "healthy_value"= unique(healthy_value),
              "npsfm"= unique(npsfm),
              "npsfm_grade"= ifelse(npsfm,  calculate_metric_grade(value=metric_mean,reference=reference,bottom_line=bottom_line,cut=cut, healthy_value = healthy_value), NA)  ) %>%
    dplyr::mutate("reporting_scale"= "overall")

  npsfm_grade <- npsfm_grade %>%
    tidyr::drop_na() %>%
    dplyr::select(-healthy_value,-npsfm)%>%
    dplyr::relocate(component,
             indicator,
             attribute,
             metric,
             class,
             reporting_scale,
             metric_mean,
             npsfm_grade,
             reference,
             bottom_line,
             cut)


  npsfm_grade


}
