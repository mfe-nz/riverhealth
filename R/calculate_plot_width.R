#' Calculate availability score for plotting
#'
#' This function calculates the availability score based on the suitability of collected data
#' compared to potential data that could have been collected, for each component and indicator.
#'
#' @param reference_table Reference table containing information on suitability of data collection.
#' @param score_table Score table containing actual data collected.
#' @param npsfm_only Logical indicating whether to consider only NPSFM components (default is TRUE).
#' @param all_components Logical indicating whether to calculate availability for all components
#'                       (default is FALSE). If FALSE, availability is calculated for each component
#'                       and its indicators. Users should not have to alter this argument.
#'
#' @return A data frame with availability scores calculated for each component and indicator or reporting scale.
#' @export
#'


calculate_plot_width <- function(reference_table,
                                 score_table,
                                 npsfm_only=TRUE,
                                 all_components=FALSE){

  if(npsfm_only){
    reference_table <- dplyr::filter(reference_table,
                              npsfm ==TRUE)

    score_table <- dplyr::filter(score_table,
                          npsfm==TRUE)}

  if(all_components){
    group_variables <- c("component","reporting_scale")

    score_variables <- c("component")

  }else{

    group_variables <- c("component","indicator","reporting_scale")

    score_variables <- c("component","indicator")

    component_name <- unique(score_table$component)

    reference_table <- reference_table %>%
      dplyr::filter(component %in% component_name )

  }


  availability_table <- dplyr::select(score_table,
                               component,
                               indicator,
                               metric,
                               attribute,
                               reporting_scale,
                               suitability) %>%
    dplyr::group_by(dplyr::across(dplyr::all_of(group_variables))) %>%
    dplyr::summarise("total_score"= sum(suitability) )


  #calculate availability score based on how many key metrics are available and their suitability score. For those attributes that have many possible metrics, we assume suitability is equal among metrics and select one

  reference_scores <-  reference_table %>%
    dplyr::filter(key_metric==TRUE) %>%
    dplyr::select(component,indicator,attribute,metric,suitability) %>%
    dplyr::group_by(component,indicator,attribute) %>%
    dplyr::slice_sample(n=1)%>%
    dplyr::ungroup() %>%
    dplyr::group_by(dplyr::across(dplyr::all_of(score_variables))) %>%
    dplyr::summarise("total_possible_score"= sum(suitability) )



  if(all_components){

    expand_table <- expand.grid(component= reference_scores$component,
                                reporting_scale= unique(score_table$reporting_scale))


    reference_scores <- dplyr::left_join(reference_scores,
                                  expand_table,
                                  by = "component")

    availability_table <- dplyr::full_join(
      reference_scores,
      availability_table,
      by=c("component","reporting_scale")) %>%
      dplyr::mutate("total_score"= ifelse(is.na(total_score),0,total_score))

  }else{
    expand_table <- expand.grid(indicator= reference_scores$indicator,
                                reporting_scale= unique(score_table$reporting_scale))

    reference_scores <- dplyr::left_join(reference_scores,
                                  expand_table,
                                  by = "indicator")

    availability_table <- dplyr::full_join(
      reference_scores,
      availability_table,
      by=c("component","indicator","reporting_scale")) %>%
      dplyr::mutate("total_score"= ifelse(is.na(total_score),0,total_score))

  }


  availability_table <- availability_table %>%
    dplyr::mutate("availability_score"= total_score/total_possible_score) %>%
    dplyr::mutate("availability_score"= ifelse(availability_score > 1,1,availability_score)) %>%
    dplyr::select(-total_score, -total_possible_score)


  availability_table

}

