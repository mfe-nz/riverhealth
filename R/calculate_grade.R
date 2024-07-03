# Calculate Grade
#'
#' This function calculates the grade based on a numeric input value.
#'
#' @param x A numeric vector representing a score from 0-1.
#' @return A character vector indicating the corresponding grades.
#' @examples
#' calculate_grade(0.85) # Returns "A"
#' calculate_grade(0.6) # Returns "B+"
#' calculate_grade(0.3) # Returns "C-"
#' @export
calculate_grade <- function(x) {
  if (!is.numeric(x)) {
    stop("x must be numeric")
  }

  if (any(x < 0 | x > 1)) {
    stop("x values must be within the range [0, 1]")
  }

  grades <- character(length(x))
  grades[x == 1] <- "A"
  grades[x < 1 & x >= 0.75 ] <- "B+"
  grades[x < 0.75 & x >= 0.5] <- "B-"
  grades[x < 0.5 & x >= 0.25] <- "C+"
  grades[x < 0.25 & x > 0] <- "C-"
  grades[x == 0 ] <- "D"

  return(grades)
}
