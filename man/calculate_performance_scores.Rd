% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calculate_performance_score.R
\name{calculate_performance_scores}
\alias{calculate_performance_scores}
\title{Calculate performance score based on component and reference tables}
\usage{
calculate_performance_scores(component_table, reference_table)
}
\arguments{
\item{component_table}{A nested data frame containing the components to calculate performance scores for. Should be the output of the funciton \code{make_component_table}}

\item{reference_table}{A data frame providing default values for excellent and poor ecological conditions. If the reference_table user input is not the one provided with the package (reference_table_default), it will be flagged as user defined benchmarks.}
}
\value{
A data frame containing the calculated performance scores.
}
\description{
This function calculates performance scores based on the provided component table
and reference table. It matches the components in the component table with the
corresponding benchmarks in the reference tables and computes performance scores
based on Equations 1 and 2 of Clapcott et al. 2019. If metrics are deemed nonlinear, then  the values of bottom_line_range and reference_range will be used to calculate performance scores.
}
\examples{
#' # Create example indicator data frames
macroinvertebrates <- data.frame(
site = 1:3,class = c("universal"),
indicator = "macroinvertebrates",
component = "aquatic_life",
reporting_scale = c("region_1","region_2","region_1"),
mci = c(89,120,135))

component_table <- make_component_table(indicators =list(macroinvertebrates))

calculate_performance_scores(component_table = component_table,
reference_table = reference_table_default)

}
