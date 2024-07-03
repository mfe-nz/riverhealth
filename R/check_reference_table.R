#' Check Reference Table
#'
#' This function validates a reference table.
#'
#' @param reference_table The reference table to be validated (data frame). Can be the default provided with the package or provided by the user. If provided by the user, it should have the same col um names as the default.
#' @param key_columns A vector of column names considered key columns.
#' @return The input reference table if validation passes.
#' @export
#'


check_reference_table <- function(reference_table,
                                  key_columns) {

  # Input validation
  if (!is.data.frame(reference_table)) {
    stop("The reference table must be a data frame.")
  }

  if (nrow(reference_table) < 1) {
    stop("The reference table must have at least one observation.")
  }

  if (!is.character(key_columns) || length(key_columns) == 0) {
    stop("key_columns must be a non-empty vector of column names.")
  }

  reference_columns <- colnames(reference_table)

  # Check for missing key columns
  missing_columns <- key_columns[!key_columns %in% reference_columns]

  if (length(missing_columns) > 0) {
    stop(paste("The reference table is missing the following required columns:",
               paste(missing_columns, collapse = ", ")))
  }

  extra_columns <- reference_columns[!reference_columns %in% key_columns]

  if (length(extra_columns) > 0) {
    stop(paste("The reference table contains extra columns:",
               paste(extra_columns, collapse = ", ")))
  }


  if(any(!unique(reference_table$healthy_value) %in% c("high","low","nonlinear"))){
    stop("Healthy values should be either high, low or nonlinear")
  }

  if(any(!unique(reference_table$npsfm) %in% c(TRUE,FALSE))){
    stop("NPSFM column should either be TRUE or FALSE")
  }


  reference_table

}
