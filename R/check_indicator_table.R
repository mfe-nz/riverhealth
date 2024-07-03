#' Check Indicator Table
#'
#' This function validates an indicator table and identifies metrics.
#'
#' @param indicator_table The indicator table to be validated (data frame).
#' @param key_columns A vector of column names considered key columns.
#' @return The input indicator table if validation passes.
#' @export



check_indicator_table <- function(indicator_table,
                                  key_columns) {

  # Input validation
  if (!is.data.frame(indicator_table)) {
    stop("The indicator table must be a data frame.")
  }

  if (nrow(indicator_table) < 1) {
    stop("The indicator table must have at least one observation.")
  }

  if (!is.character(key_columns) || length(key_columns) == 0) {
    stop("key_columns must be a non-empty vector of column names.")
  }

  indicator_columns <- colnames(indicator_table)

  # Check for missing key columns
  missing_columns <- key_columns[!key_columns %in% indicator_columns]
  if (length(missing_columns) > 0) {
    stop(paste("The indicator table is missing the following required columns:",
               paste(missing_columns, collapse = ", ")))
  }

  # Identify metrics
  metrics <- indicator_columns[!indicator_columns %in% key_columns]

  if (length(metrics) < 1) {
    stop("The indicator table does not contain any measured or modelled metrics.")
  }

  if(length(unique(indicator_table$indicator)) > 1){
    stop("The indicator table should only contain data about one indicator")
  }


  if(length(unique(indicator_table$component)) > 1){
    stop("The indicator table should only contain data about one component")
  }

  return(indicator_table)
}
