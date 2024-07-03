#' Calculate Component Score
#'
#' This internal function calculates component scores based on the provided score table.
#'
#' @param indicator_score_table A data frame representing the score table containing metric scores and suitability.
#'
#' @return A data frame containing calculated component scores and grades.
#' @export


calculate_component_score <- function(indicator_score_table){

  #calculate mean indicator score and multiply by the mean suitability.
  component_score_table <- indicator_score_table %>%
    dplyr::group_by(component,indicator, reporting_scale) %>%
    dplyr::mutate("weighted_component_score"= indicator_score * indicator_suitability) %>%
    dplyr::ungroup()

  #calculate component score and grade
  component_score_table <- component_score_table %>%
    dplyr::group_by(component, reporting_scale) %>%
    dplyr::summarise("component_score"= sum(weighted_component_score)/sum(indicator_suitability),
              "component_grade"= calculate_grade(component_score))

  component_score_table

}
