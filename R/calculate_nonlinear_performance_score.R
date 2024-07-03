#' Calculate Nonlinear Performance Score
#'
#' This function calculates a nonlinear performance score based on provided values, reference ranges, and bottom lines.
#'
#' @param value A numeric vector representing the actual values.
#' @param reference A numeric vector representing the reference values.
#' @param bottom_line A numeric vector representing the bottom line values.
#' @param reference_range A numeric vector representing the reference range upper bounds.
#' @param bottom_line_range A numeric vector representing the bottom line range lower bounds.
#'
#' @return A numeric vector of the same length as 'value', representing the calculated performance scores.
#'
#' @export


calculate_nonlinear_performance_score <- function(value,
                                                  reference,
                                                  bottom_line,
                                                  reference_range,
                                                  bottom_line_range){

  # Check if all inputs are numeric
  if (!all(sapply(list(value, reference, bottom_line, reference_range, bottom_line_range), is.numeric))) {
    stop("All input vectors must be numeric.")
  }

  # Determine the higher reference value
  higher_reference <- pmax(reference, reference_range)

  # Determine the lower reference value
  lower_reference <- pmin(reference, reference_range)

  # Determine the higher bottom_line value
  higher_bottom_line <- pmax(bottom_line, bottom_line_range)

  # Determine the lower bottom_line value
  lower_bottom_line <- pmin(bottom_line, bottom_line_range)

  # Calculate results, based  on where is the observed value located respect to the bottom line and reference values
  above_lower_ref <- value >= lower_reference
  below_higher_ref <- value <= higher_reference
  above_lower_bottom <- value > lower_bottom_line
  below_higher_bottom <- value < higher_bottom_line

  results <- numeric(length(value))

  results[above_lower_ref & below_higher_ref] <- 1

  above_lower_ref_below_bottom <- above_lower_ref &
    !below_higher_ref & above_lower_bottom
  results[above_lower_ref_below_bottom] <- pmin(1, pmax(
    0,
    (higher_bottom_line - value) / (higher_bottom_line - higher_reference)
  )[above_lower_ref_below_bottom])

  below_higher_ref_above_bottom <- !above_lower_ref &
    below_higher_bottom
  results[below_higher_ref_above_bottom] <- pmin(1, pmax(
    0,
    (value - lower_bottom_line) / (lower_reference - lower_bottom_line)
  )[below_higher_ref_above_bottom])

 results
}








