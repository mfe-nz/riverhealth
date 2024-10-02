#' Prepare Doughnut Chart Data
#'
#' This  internal function prepares data for plotting doughnut charts by transforming the input plot_table.
#'
#' @param plot_table A data frame containing data for plotting doughnut charts.
#' @return A modified data frame with expanded rows suitable for plotting doughnut charts.
#'
#
#' @export

prepare_doughnut_chart <- function(plot_table,score_table){


  plot_table <- plot_table %>%
    dplyr::rowwise() %>%
    dplyr::mutate("plot_data"= list( plot_results <- data.frame(
      "availability" = c(0.7,availability_score, 1-availability_score),
      "grade"=c("Z", ifelse(is.na(grade),"W",grade),"W"),
      "order"= c(3,2,1),
      "reporting_scale"= reporting_scale
    )     )   )    %>%
    dplyr::select(component,indicator,plot_data) %>%
    tidyr::unnest(plot_data)


  #more data wrangling for label arrangement as well as adding the general component score
  plot_table <- plot_table %>%
    dplyr::group_by(indicator,reporting_scale) %>%
    dplyr::mutate("indicator_factor"= as.factor(indicator),
                  "index"= as.numeric(indicator_factor)) %>%
    dplyr::select(-indicator_factor) %>%
    dplyr::mutate("accumulated"= cumsum(availability)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate("label_position"=  (accumulated- availability) + (availability/2),
                  "label_group"= paste0(indicator,"_",order),
                  "label_text"= ifelse(grade %in% c("Z","W"), " ",grade ),
                  "component_score_position"= 0.35,
                  "component_score"= ifelse(order %in% c(2,1), " ", unique(score_table$component_grade)))

  plot_table

}
