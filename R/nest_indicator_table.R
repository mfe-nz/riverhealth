
#' Nest Indicator Table
#'
#' This internal function processes an indicator table, pivots it longer, ensures consistent data types and removes NA values for each metric.
#'
#' @param indicator_table The indicator table to be processed as a data frame.
#' @param key_columns A character vector of column names considered key columns.
#' @return A nested data frame with metrics categorized by components.
#' @export


nest_indicator_table <- function(indicator_table,
                                    key_columns) {
  # Validate indicator table
  indicator_table <- check_indicator_table(indicator_table, key_columns = key_columns)

  indicator_columns <- colnames(indicator_table)

  metrics <- indicator_columns[!indicator_columns %in% key_columns]

  indicator_table <- indicator_table %>%
  dplyr::mutate(dplyr::across(dplyr::all_of(metrics), as.numeric))%>%
  dplyr::mutate(dplyr::across(dplyr::all_of(c(key_columns)), as.character))

  # Pivot longer to make all tables homogeneous
  indicator_long <- indicator_table %>%
    tidyr::pivot_longer(cols = !dplyr::all_of(key_columns),
                 names_to = "metric", values_to = "value")

  # Ensure consistent data types
  indicator_long <- indicator_long %>%
    dplyr::mutate(dplyr::across(dplyr::all_of(c(key_columns, "metric")), as.character),
                  dplyr::across(value, as.numeric)) %>%
    tidyr::drop_na()

  # Group and nest to categorize metrics by components
  nested_indicator <- dplyr::group_nest(indicator_long, indicator, component)
  nested_indicator
}
