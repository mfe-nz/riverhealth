#' Check validity of component table
#'
#' This function checks the validity of a provided component table to ensure it meets necessary
#' requirements for further processing.
#'
#' @param component_table A data frame containing information about a single component, with columns:
#'                        'indicator', 'component', and 'data'.
#'
#' @return The input component_table if valid; otherwise, raises an error with appropriate message.
#'
#' @export
#'

check_component_table <- function(component_table){
  
  if (!is.data.frame(component_table)) {
    stop("Input 'component_table' must be a data frame.")
  }
  
  if(any(!colnames(component_table) %in% c("indicator", "component", "data")) ){
    stop("The component table must have the following columns: indicator, component, data")
  }
  
  if(nrow(component_table) < 1){
    stop("The component table must have at least one row")
  }
  
 
  component_table
  
}