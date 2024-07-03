#' Plot empty components for specified reporting scale
#'
#' This function generates doughnut plots showing the no availability of metrics for a specific
#' component and reporting scale. It visualizes empty plots.
#'
#' @param component_ind Component indicator for which metrics availability is to be plotted.
#' @param reporting_scale Reporting scale to consider for plotting.
#' @param reference_table Reference table containing metric information.
#' @param npsfm_only Logical indicating whether to consider only NPSFM components (default is FALSE).
#' @param color_table Optional color table for customizing plot colors.
#' @param font_size Font size for plot labels (default is 20).
#' @param start_year Optional start year of data collection (default is NULL).
#' @param end_year Optional end year of data collection (default is NULL).
#'
#' @return A list of doughnut plots, each showing an empty plot for the specified
#'         component and reporting scale.
#' @export
#'


plot_empty <- function(component_ind,
                       reporting_scale,
                       reference_table,
                       npsfm_only = FALSE,
                       color_table = NULL,
                       font_size = 20,
                       start_year = NULL,
                       end_year = NULL){

  if(is.null(start_year) | is.null(end_year)){
    year_range <- "unspecified"
  }else{
    year_range <- paste0(start_year,"-", end_year)
  }
#extract all possible metrics given a component
  possible_metrics <- dplyr::filter(reference_table,
                             component ==  component_ind) %>%
    dplyr::select(indicator,
           attribute,
           metric,
           npsfm,
           key_metric)

  score_table <- possible_metrics %>%
    dplyr::mutate("component"= component_ind,
           "reporting_scale"= reporting_scale,
           "metric_score"= 0,
           "indicator_score"=0,
           "indicator_grade" =NA,
           "component_score"= 0,
           "component_grade"=NA,
           "observations" = 0,
           "suitability"=0,
           "default_baseline"= TRUE ) %>%
    dplyr::distinct()


  component_name <- unique(score_table$component) %>%
    sub(pattern="_", replace= " ") %>%
    stringr::str_to_title()
  #this is going to yield and empty table
  availability_table <- calculate_plot_width(score_table = score_table,
                                             reference_table = reference_table,
                                             npsfm_only = npsfm_only)

  #we are reporting per indicator, thus we can summarise all the metrics in an indicator table
  indicator_table <- score_table %>%
    dplyr::group_by(component,indicator, reporting_scale) %>%
    dplyr::summarise("score"= unique(indicator_score),
              "grade"= unique(indicator_grade),
              "observations"= sum(observations))


  #join availability and indicator scores. If no scores are available, assume 0 for plotting.
  plot_table <- dplyr::left_join(availability_table,
                          indicator_table,
                          by= c("component","indicator","reporting_scale"))

  #tidy data for plotting. This involves expanding each observation (indicator*class) times 3, to fill out the doughnut. Creating new categories for when grade is missing(W) and for the interior of the doughnut (Z).
  plot_table <-  prepare_doughnut_chart(plot_table = plot_table)
  #if no color table is provided, then use these colors
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

    )

  }

  #get main label
  component_label<- score_table %>%
    dplyr::group_by(reporting_scale) %>%
    dplyr::summarise("component_grade"= unique(component_grade))%>%
    dplyr::mutate("reporting_scale"= as.factor(reporting_scale)) %>%
    dplyr::arrange(component_grade)

  doughnut_plots <- list()

  #return as many plots as reporting scales
  for(i in 1:length(component_label$reporting_scale)){

    score_plot <- dplyr::filter(score_table, reporting_scale == component_label$reporting_scale[i])

    dp <- plot_table %>%
      dplyr::filter(reporting_scale == component_label$reporting_scale[i]) %>%
      dplyr::mutate(indicator = sub(indicator, pattern="_", replace= " "))%>%
      dplyr::mutate(indicator = sub(indicator, pattern="_", replace= " ")) %>%
      dplyr::mutate(indicator = stringr::str_to_sentence(indicator))

    if( length(unique(dp$indicator)) <= 1 ){
      gap = 1

    }else{
      gap = 0.99
    }

    #make plot
    dp_p <-
      dp %>%
      ggplot2::ggplot(ggplot2::aes(x = indicator)) +
      ggplot2::geom_col(ggplot2::aes( y =availability,fill = grade, group=order),width = gap)+
      ggplot2::scale_fill_manual(values= color_table)+
      ggplot2::geom_text(
        ggplot2::aes(y=1.2, label=label_text, group=label_group), size = font_size/2,
        col="white") +
      theme_clean() +
      ggplot2::geom_hline(yintercept = c(seq(0.7,1.7, 0.1)), col="white", alpha= 0.5)+
      geomtextpath::coord_curvedpolar("x")+
      ggplot2::theme(
        panel.grid = ggplot2::element_blank(),
        plot.title = ggplot2::element_text(color="grey50", size=font_size, face="italic"),
        axis.text.x = ggplot2::element_text(size=font_size, vjust=-0.01),
        legend.position = "none",
        axis.text.y = ggplot2::element_blank(),
        axis.title = ggplot2::element_blank())+
      ggplot2::annotate("text", max(plot_table$index)/2 + 0.5, y=0.001, label=component_label$component_grade[i], size=font_size )

    #creating metadata table
    plot_title <- paste0("Component: ",stringr::str_to_title(component_name))
    plot_group <- paste0("Reporting scale: ",component_label$reporting_scale[i])
    year <- paste0("Year range", ": ", year_range)
    sut_score <- paste0("Average metric suitability", ": ", round(mean(score_plot$suitability),2))
    #flag if user used their own benchmarks.
    default_baselines <- ifelse(all(score_plot$default_baseline), "Metric baselines: default", "Metric baselines: user defined" )

    #Data about each metric
    table_plot <- score_plot%>%
      dplyr::select( "Indicator" =indicator,
                     "Metric" =metric,
                     "Observations"= observations)%>%
      dplyr::mutate(Indicator= stringr::str_to_sentence(Indicator)) %>%
      dplyr::mutate(Indicator = sub(Indicator, pattern="_", replace= " ")) %>%
      dplyr::mutate(Indicator = sub(Indicator, pattern="_", replace= " ")) %>%
      dplyr::mutate(Indicator= ifelse(duplicated(Indicator), " ",Indicator)) %>%
      dplyr::rowwise() %>%
      dplyr::mutate(Metric = get_metric_names(Metric))

    #make metadata table into a grob
    tt3 <- gridExtra::ttheme_minimal(core=list(fg_params=list(hjust=0, x=0, fontsize=font_size/1.5)),
                                     rowhead=list(fg_params=list(hjust=0, x=0, fontsize=font_size/1.5)),
                                     colhead=list(fg_params=list(hjust=0,x=0), fontsize=font_size/1.5))


    table_plot_grob<- gridExtra::tableGrob(table_plot, rows = NULL, theme = tt3)
    #instead of one big table, it works better to have three tables
    test_table <- tidyr::tibble("Indicator" = c(plot_title,
                                                plot_group,
                                                year,
                                                default_baselines,
                                                sut_score),
                                "Metric"= c(""),
                                "Observations"= c(""))

    middle_table <- tidyr::tibble( "Indicator" = c(" ", "Indicator", "No data"),
                            "Metric"= c(" ", "Metric", "No data"),
                            "Observations"= c(" ","Observations", "No data"))

    #bind all tables together
    final_table <- rbind(test_table, middle_table, table_plot)

    test_grob <- gridExtra::tableGrob(final_table,rows = NULL, cols = NULL, theme=tt3)

    #create a ggplot for the metadata
    meta_table <- ggplot2::ggplot() +
      ggplot2::theme_void() +
      ggplot2::xlim(0, 10) +
      ggplot2::ylim(0, 5)+
      ggplot2::annotation_custom(test_grob, xmin=0, xmax=10, ymin=0, ymax=5)

    #create final output
    full_plot  <-  cowplot::plot_grid(
      cowplot::plot_grid(dp_p) +
        ggplot2::theme(plot.background = ggplot2::element_rect(color = "black", size=2)),
      cowplot::plot_grid(meta_table) +
        ggplot2::theme(plot.background = ggplot2::element_rect(color = "black", size=2)) )


    doughnut_plots[[i]] <- full_plot

  }



  doughnut_plots


}

