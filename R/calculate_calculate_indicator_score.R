#' Calculate Indicator Score
#'
#' This function calculates indicator scores based on the provided score table.
#'
#' @param score_table A data frame representing the score table containing metric scores and suitability.
#'
#' @return A data frame containing calculated indicator scores and grades aggregated at the indicator and reporting scale level
#' @export


calculate_indicator_score <- function(score_table){

  # Calculate weighted indicator score
  score_table <- score_table %>%
    dplyr::mutate(weighted_indicator_score = metric_score * suitability)

  # Group by component, indicator, and reporting scale, and summarize
  score_summary <- score_table %>%
    dplyr::group_by(component, indicator, reporting_scale) %>%
    dplyr::summarise(
      indicator_score = sum(weighted_indicator_score) / sum(suitability),
      indicator_grade = calculate_grade(indicator_score),
      indicator_suitability = mean(suitability)
    )

  return(score_summary)
}
