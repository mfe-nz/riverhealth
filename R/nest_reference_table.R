#' This function nests a reference table by indicator to facilitate joining with component tables for calculating performance scores.
#'
#' @param reference_table A data frame representing the reference table to be nested.
#' @param key_columns A character vector specifying the key columns necessary for further analyses
#'
#' @return A nested data frame with the reference table grouped by indicator.
#'
#' @details This function takes a reference table and nests it based on the indicator and component columns.
#' It also performs type conversion for character columns to ensure consistency and numeric columns
#' for compatibility with subsequent calculations.
#' @export


nest_reference_table <- function(reference_table,
                                 key_columns){
  #input validation
  reference_table <- check_reference_table(reference_table = reference_table, key_columns = key_columns)

  numeric_columns <-  c(
    "bottom_line",
    "reference",
    "cut",
    "npsfm",
    "suitability",
    "reference_range",
    "bottom_line_range"
  )
  character_columns <- key_columns[which(!key_columns %in% numeric_columns)]

  reference_table <- reference_table %>%
    dplyr::mutate(
      dplyr::across(dplyr::all_of(character_columns), as.character),
      dplyr::across(dplyr::all_of(numeric_columns), as.numeric),
      dplyr::across(npsfm, as.logical)
    ) %>%
    dplyr::group_nest(indicator, component, .key = "metric_health")

  reference_table


}
