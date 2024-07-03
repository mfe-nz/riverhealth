#' Plot report cards for multiple reporting scales
#'
#' This function generates plots for various environmental components based on provided scores and reference data.
#'
#' @param component_scores A list containing data frames of scores for each component.
#' @param reference_table A reference table used for plotting.
#' @param npsfm_only Logical indicating whether to use only NPSFM components.
#' @param font_size Font size for the plots (default is 15).
#' @param color_table Optional color table for customizing plot colors.
#' @param start_year Optional start year for filtering data.
#' @param end_year Optional end year for filtering data.
#'
#' @return A list of plots, each corresponding to a different reporting scale.
#' @export
#'


plot_report_card <- function(component_scores,
                                reference_table,
                                npsfm_only=FALSE,
                                font_size =15,
                                color_table = NULL,
                                start_year = NULL,
                                end_year= NULL){

  score_table <- do.call(rbind,
                         component_scores)

  reporting_scales <- unique(score_table$reporting_scale)

  plots <- list()

  for(i in reporting_scales){

    score_table_scale <- dplyr::filter(score_table, reporting_scale == i)

    aquatic_life_scale <- dplyr::filter(score_table_scale, component == "aquatic_life")

    water_quality_scale <- dplyr::filter(score_table_scale, component == "water_quality")

    water_quantity_scale <- dplyr::filter(score_table_scale, component == "water_quantity")

    physical_habitat_scale <- dplyr::filter(score_table_scale, component == "physical_habitat")

    ecological_scale <- dplyr::filter(score_table_scale, component == "ecological_processes")


    overall_plot <- plot_overall(score_table = score_table_scale,
                                 reference_table = reference_table,
                                 npsfm_only = npsfm_only,
                                 font_size = font_size,
                                 color_table = color_table
    )

    if(nrow(aquatic_life_scale) < 1){

      aquatic_plot <- plot_empty(component_ind = "aquatic_life",
                                 reporting_scale = i,
                                 reference_table = reference_table,
                                 npsfm_only = npsfm_only,
                                 color_table = color_table,
                                 font_size = font_size,
                                 start_year = start_year,
                                 end_year =end_year )

    }else{
      aquatic_plot <- plot_component(score_table = aquatic_life_scale,
                                     reference_table = reference_table,
                                     npsfm_only = npsfm_only,
                                     font_size = font_size,
                                     color_table = color_table,
                                     start_year = start_year,
                                     end_year =end_year)
    }

    if(nrow(water_quality_scale) < 1){
      water_quality_plot <- plot_empty(component_ind = "water_quality",
                                       reporting_scale = i,
                                       reference_table = reference_table,
                                       npsfm_only = npsfm_only,
                                       color_table = color_table,
                                       font_size = font_size,
                                       start_year = start_year,
                                       end_year =end_year )

    }else{
      water_quality_plot <- plot_component(score_table = water_quality_scale,
                                           reference_table = reference_table,
                                           npsfm_only = npsfm_only,
                                           font_size = font_size,
                                           color_table = color_table)
    }

    if(nrow(water_quantity_scale) < 1){
      water_quantity_plot <- plot_empty(component_ind = "water_quantity",
                                        reporting_scale = i,
                                        reference_table = reference_table,
                                        npsfm_only = npsfm_only,
                                        color_table = color_table,
                                        font_size = font_size,
                                        start_year = start_year,
                                        end_year =end_year )

    }else{
      water_quantity_plot <- plot_component(score_table = water_quantity_scale,
                                            reference_table = reference_table,
                                            npsfm_only = npsfm_only,
                                            font_size = font_size,
                                            color_table = color_table)
    }

    if(nrow(physical_habitat_scale) < 1){
      physical_habitat_plot <- plot_empty(component_ind = "physical_habitat",
                                          reporting_scale = i,
                                          reference_table = reference_table,
                                          npsfm_only = npsfm_only,
                                          color_table = color_table,
                                          font_size = font_size,
                                          start_year = start_year,
                                          end_year =end_year )

    }else{
      physical_habitat_plot <- plot_component(score_table = physical_habitat_scale,
                                              reference_table = reference_table,
                                              npsfm_only = npsfm_only,
                                              font_size = font_size,
                                              color_table = color_table)
    }

    if(nrow(ecological_scale) < 1){
      ecological_plot <- plot_empty(component_ind = "ecological_processes",
                                    reporting_scale = i,
                                    reference_table = reference_table,
                                    npsfm_only = npsfm_only,
                                    color_table = color_table,
                                    font_size = font_size,
                                    start_year = start_year,
                                    end_year =end_year )

    }else{
      ecological_plot <- plot_component(score_table = ecological_scale,
                                        reference_table = reference_table,
                                        npsfm_only = npsfm_only,
                                        font_size = font_size,
                                        color_table = color_table)
    }



    # plot all together -------------------------------------------------------

    logo_plot <- ggplot2::ggplot() +
      ggplot2::theme_void() +
      ggplot2::xlim(0, 5) +
      ggplot2::ylim(0, 5)+
      ggimage::geom_image(
        ggplot2::aes(image = system.file("images", "EH.png", package = "riverhealth"),
                     x=2.5,
                     y=2.5),
        size=.95
      )

    overall_plot  <-  cowplot::plot_grid(
      cowplot::plot_grid(overall_plot[[1]]) +
        ggplot2::theme(plot.background = ggplot2::element_rect(color = "black", size=2)),
      cowplot::plot_grid(logo_plot) +
        ggplot2::theme(plot.background = ggplot2::element_rect(color = "black", size=2)) )


    all_components <- cowplot::plot_grid(overall_plot,
                                aquatic_plot[[1]],
                                water_quality_plot[[1]],
                                water_quantity_plot[[1]],
                                physical_habitat_plot[[1]],
                                ecological_plot[[1]],
                                ncol = 1)



    # save --------------------------------------------------------------------

    plots[[i]] <- all_components

  }

  plots

}


