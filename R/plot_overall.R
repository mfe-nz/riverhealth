#' Plot overall river ecosystem health
#'
#' This function generates doughnut plots showing the overall health score and component availability
#' for each reporting scale based on provided scores and reference data.
#'
#' @param score_table Data frame containing scores for each component and reporting scale.
#' @param reference_table Reference table used for calculating availability and grades.
#' @param npsfm_only Logical indicating whether to consider only NPSFM components (default is FALSE).
#' @param color_table Optional color table for customizing plot colors.
#' @param font_size Font size for plot labels (default is 20).
#'
#' @return A list of doughnut plots, each showing the overall health score and component availability
#'         for a different reporting scale.
#' @export
#'


plot_overall <- function(score_table,
                         reference_table,
                         npsfm_only = FALSE,
                         color_table = NULL,
                         font_size = 20){

  if(npsfm_only){
    reference_table <- dplyr::filter(reference_table,
                              npsfm ==TRUE)

    score_table <- dplyr::filter(score_table,
                          npsfm==TRUE)}

  # The overall river ecosystem health score is the arithmetic mean of suitability-weighted component scores.

  overall_score <- mean(score_table$component_score)
  overall_grade <- calculate_grade(overall_score)

  #calculate the width of each component
  availability_table <- calculate_plot_width(score_table = score_table,
                                             reference_table = reference_table,
                                             npsfm_only = npsfm_only,
                                             all_components = TRUE
  )
  #summarise data by comopnent
  component_table <- score_table %>%
    dplyr::group_by(component, reporting_scale) %>%
    dplyr::summarise("score"= unique(component_score),
              "grade"= unique(component_grade),
              "observations"= sum(observations))

  plot_table <- dplyr::left_join(availability_table,
                          component_table,
                          by= c("component","reporting_scale"))%>%
    dplyr::mutate(dplyr::across(c(score, observations), ~ifelse(is.na(.), 0, .)))
  #prepare data for doughnut chart

  #data wrangling
  plot_table <- plot_table %>%
    dplyr::rowwise() %>%
    dplyr::mutate("plot_data"= list( plot_results <- data.frame(
      "availability" = c(0.7,availability_score, 1-availability_score),
      "grade"=c("Z", ifelse(is.na(grade),"W",grade),"W"),
      "order"= c(3,2,1),
      "reporting_scale"= reporting_scale
    )     )   )    %>%
    dplyr::select(component,plot_data) %>%
    tidyr::unnest(plot_data)

  if(is.null(color_table)){
    color_table <- c(
      "Z" = "white",
      "W" = "#bdbcbc",
      "A" = "#20a7ad",
      "B+" = "#85bb5b",
      "B-" = "#85bb5b",
      "C+" = "#ffa827",
      "C-" = "#ffa827",
      "D" = "#e85129"

    )}


  plot_table <- plot_table %>%
    dplyr::group_by(component,reporting_scale) %>%
    dplyr::mutate("component_factor"= as.factor(component),
           "index"= as.numeric(component_factor)) %>%
    dplyr::select(-component_factor) %>%
    dplyr::mutate("accumulated"= cumsum(availability)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate("label_position"=  (accumulated- availability) + (availability/2),
           "label_group"= paste0(component,"_",order),
           "label_text"= ifelse(grade %in% c("Z","W"), " ",grade ),
           "component_score_position"= 0.35,
           "component_score"= ifelse(order %in% c(2,1), " ", overall_grade))

  gap<-0.99

  reporting_scales <- unique(score_table$reporting_scale)

  component_label<- score_table %>%
    dplyr::group_by(reporting_scale) %>%
    dplyr::summarise("overall_grade"= calculate_grade(mean(component_score)))


  doughnut_plots <- list()

  for(i in reporting_scales){
    dp <- dplyr::filter(plot_table,
                 reporting_scale==i)%>%
      dplyr::mutate(component = sub(component, pattern="_", replace= " "))%>%
      dplyr::mutate(component = sub(component, pattern="_", replace= " ")) %>%
      dplyr::mutate(component = stringr::str_to_sentence(component))

    dp_score <- dplyr::filter(component_label, reporting_scale==i)

    score_plot <- dplyr::filter(score_table, reporting_scale == i)

    dp_p <- dp %>%
      ggplot2::ggplot(ggplot2::aes(x = component)) +
      ggplot2::geom_col(ggplot2::aes(y = availability, fill = grade, group = order), width = gap) +
      ggplot2::scale_fill_manual(values = color_table) +
      ggplot2::geom_text(
        ggplot2::aes(y = 1.2, label = label_text, group = label_group), size = font_size / 2, col = "white") +
      geomtextpath::coord_curvedpolar("x") +
      theme_clean() +
      ggplot2::geom_hline(yintercept = c(seq(0.7, 1.7, 0.1)), col = "white", alpha = 0.5) +
      ggplot2::theme(
        plot.title = ggplot2::element_text(color = "grey50", size = font_size, face = "italic"),
        axis.text.x = ggplot2::element_text(size = font_size, vjust = -0.01),
        legend.position = "none",
        panel.grid = ggplot2::element_blank(),
        axis.text.y = ggplot2::element_blank(),
        axis.title = ggplot2::element_blank()) +
      ggplot2::annotate("text", 2.5, y = 0.001, label = dp_score$overall_grade[1], size = font_size)


    doughnut_plots[[i]] <- dp_p

  }

  doughnut_plots
}
