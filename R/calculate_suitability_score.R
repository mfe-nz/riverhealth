#' Calculate Suitability Weighted Score
#'
#' This function calculates suitability scores based on the provided performance table and optional suitability table.
#'
#' @param performance_table A data frame representing the performance table containing nested metric performance scores.
#' @param npsfm_only Logical indicating whether to consider only NPSFM components (default is FALSE).
#' @param overall_score Logical indicating whether to calculate overall scores or group by reporting scale (default is TRUE).
#' @export
#' @examples
#'  macroinvertebrates <- data.frame( site = 1:3,class = c("universal"),
#'  indicator = "macroinvertebrates",
#'  component = "aquatic_life",
#'  reporting_scale = c("region_1","region_2","region_1"),
#'  mci = c(89,120,135))
#'
#'  component_table <- make_component_table(indicators = list(macroinvertebrates))
#'
#'  performance_scores <- calculate_performance_scores(component_table = component_table,
#'   reference_table = reference_table_default)
#'
#' calculate_suitability_score(performance_table = performance_scores,
#' npsfm_only = FALSE,overall_score = TRUE)
#'


calculate_suitability_score <- function(performance_table,
                                        npsfm_only= FALSE,
                                        overall_score = TRUE){
 score_table <- performance_table

  # calculate average metric scores -----------------------------------------

  #we calculate average by groups defined by reporting scale. If two metrics belong to the same numeric attribute, then the one with the lowest average performance score gets chosen. This selection is  either done by reporting scales or for an overall group.

  if(!overall_score){
    score_table <- score_table %>%
      dplyr::rowwise() %>%
      dplyr::mutate("metric_scores"= list(performance_scores %>%
                                     dplyr::group_by(metric,reporting_scale,attribute) %>%
                                     dplyr::summarise(
                                       "metric_score" = mean(score),
                                       "suitability" = unique(suitability),
                                       "observations"= dplyr::n(),
                                       "npsfm"= unique(npsfm),
                                       "key_metric"= unique(key_metric),
                                       "default_baseline" = unique(default_baseline),
                                       "attribute"= unique(attribute)) %>%
                                       dplyr::ungroup() %>%
                                       dplyr::group_by(reporting_scale,attribute) %>%
                                       dplyr::slice_min(metric_score) %>%
                                       dplyr::ungroup()
      ) )
  } else{
    score_table <- score_table %>%
      dplyr::rowwise() %>%
      dplyr::mutate("metric_scores"= list(performance_scores %>%
                                            dplyr::group_by(metric, attribute) %>%
                                            dplyr::summarise("metric_score" = mean(score),
                                               "suitability"= unique(suitability),
                                               "observations"= dplyr::n(),
                                               "npsfm"= unique(npsfm),
                                               "key_metric"= unique(key_metric),
                                               "default_baseline" = unique(default_baseline),
                                               "attribute"= unique(attribute)
                                     ) %>%
                                       dplyr::mutate("reporting_scale"= "overall")   %>%
                                       dplyr::ungroup() %>%
                                       dplyr::group_by(reporting_scale,attribute) %>%
                                       dplyr::slice_min(metric_score) %>%
                                       dplyr::ungroup()

      )    )

  }

  # calculate suitability weighted scores -----------------------------------
  #if scores are supposed to be calculated only for npsfm metrics
  if(npsfm_only){
    score_table <- score_table %>%
      dplyr::rowwise() %>%
      dplyr::mutate(
        "metric_scores" = list( filter(metric_scores, npsfm ==TRUE) ) )

  }

  #unnest
  score_table <- score_table %>%
    dplyr::select(-performance_scores) %>%
    tidyr::unnest(metric_scores)

  if(nrow(score_table)<1){
    warning("There were no npsfm metrics available for analyses. Do you want to change npsfm=FALSE?")

    empty_score <- score_table %>%
      dplyr::select(component,
             indicator,
             attribute,
             metric,
             reporting_scale,
             metric_score,
             observations,
             suitability,
             key_metric,
             default_baseline) %>%
      dplyr::mutate( "indicator_score" = NA,
              "indicator_grade"=NA,
              "component_score"=NA,
              "component_grade"=NA)%>%
      dplyr::relocate(component,
               indicator,
               attribute,
               metric,
               reporting_scale,
               metric_score,
               indicator_score,
               indicator_grade,
               component_score,
               component_grade,
               observations,
               suitability,
               key_metric,
               default_baseline)

    return(empty_score)
  }

  # calculate indicator score -----------------------------------------------

  indicator_score_table <- calculate_indicator_score(score_table = score_table)

  # calculate component score -----------------------------------------------

  component_score_table <- calculate_component_score(indicator_score_table = indicator_score_table)


  # results -----------------------------------------------------------------

  score_table <- dplyr::left_join(score_table,
                           indicator_score_table,
                           by=c("component","indicator","reporting_scale")) %>%
    dplyr::select(-indicator_suitability)

  score_table  <- dplyr::left_join(score_table,
                            component_score_table,
                            by= c("component","reporting_scale"))

  score_table <- score_table %>%
    dplyr::relocate(component,
             indicator,
             attribute,
             metric,
             reporting_scale,
             metric_score,
             indicator_score,
             indicator_grade,
             component_score,
             component_grade,
             observations,
             suitability,
             key_metric,
             default_baseline)

  score_table
}

