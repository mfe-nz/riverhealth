#' Get formatted names for environmental metrics
#'
#' This function retrieves human-readable names for specified environmental metrics.
#'
#' @param metric Character string specifying the metric name (e.g., "fish_ibi", "mci").
#'
#' @return A character string containing the formatted metric name.
#'
#' @examples
#' # Example usage:
#' get_metric_names("fish_ibi")
#' # Returns "F-IBI"
#'
#' @export
#'

get_metric_names <- function(metric){

  unique_names <- data.frame("metrics"=c("fish_ibi","mci","qmci","aspm","ept_taxa_richness", "percentage_ept_taxa", "bacterial_community_index", "cox_rutherford_index", "ammonia_95_percentile", "nitrate_95_percentile", "drp_95_percentile", "din_95_percentile","water_allocation_index","fre3","catchment_impermeability","rapid_habitat_assessment_score", "drp_median", "din_median"),
                             "name"= c("F-IBI", "MCI","QMCI", "ASPM", "EPT taxa richness", "%EPT taxa", "BCI","Cox-Rutherford Index", "Ammonia 95 percentile","Nitrate 95 percentile","DRP 95 percentile","DIN 95th percentile","Water Allocation Index","FRE3","Impermeability","RHA score", "DRP median", "DIN median"))


  if(metric %in% unique_names$metrics){
    name  <- dplyr::filter(unique_names,
                    metrics == metric)

    metric <- name$name

  }else{
    metric <- sub(metric, pattern="_", replace= " ") %>%
      sub(metric, pattern="_", replace= " ")%>%
      sub(metric, pattern="_", replace= " ")%>%
      sub(metric, pattern="_", replace= " ") %>%
      stringr::str_to_sentence()

  }

  metric


}
