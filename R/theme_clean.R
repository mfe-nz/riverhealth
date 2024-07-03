#' Clean Theme for ggplot2 Plots
#'
#' This function defines a custom ggplot2 theme that enhances the appearance of plots
#' by removing minor grid lines, adjusting strip text size and alignment, and setting
#' a background color for strip panels.
#'
#' @return A ggplot2 theme object with customized settings.
#' @export


theme_clean <- function() {
  ggplot2::theme_minimal() +
    ggplot2::theme(panel.grid.minor = ggplot2::element_blank(),
          strip.text = ggplot2::element_text( hjust = 0),
          strip.background = ggplot2::element_rect(fill = "grey80", color = NA))
}
