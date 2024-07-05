#' Macroinvertebrates Data to calculate Zealand River Ecosystem Health Score
#'
#' A simulated dataset containing macroinvertebrates observations aggregated at a site level.
#'
#' @format A data frame with 1021 rows and 8 variables:
#' \describe{
#'   \item{site}{The unique identifier for the spatial scale at which observations were aggregated.}
#'   \item{class}{The reference category used for calculating metric performance scores.}
#'   \item{indicator}{The specific indicator to which metrics belong (i.e., macroinvertebrates)}
#'   \item{component}{The specific component to which the indicator belongs (i.e.,. aquatic_life)}
#'   \item{reporting_scale}{The chosen scale for data integration}
#'   \item{mci}{Simulated values of the metric macroinvertebrate community index (MCI)}
#'   \item{percentage_ept_taxa}{Simulated values of the metric percentage of Ephemeroptera (mayfly), Plecoptera (stonefly) and Trichoptera (caddisfly) taxa. }
#'   \item{ept_taxa_richness}{Simulated values of the richness of EPT taxa.}
#' }

"macroinvertebrates"

#' Fish Data to calculate New Zealand River Ecosystem Health Score
#'
#' A simulated dataset containing fish observations aggregated at a site level.
#'
#' @format A data frame with 2824 rows and 6 variables:
#' \describe{
#'   \item{site}{The unique identifier for the spatial scale at which observations were aggregated.}
#'   \item{class}{The reference category used for calculating metric performance scores.}
#'   \item{indicator}{The specific indicator to which metrics belong (i.e., macroinvertebrates)}
#'   \item{component}{The specific component to which the indicator belongs (i.e.,. aquatic_life)}
#'   \item{reporting_scale}{The chosen scale for data integration}
#'   \item{fish_ibi}{Simulated values of the metric Fish Index of Biological Integrity}
#'   }

"fish"

#' Plant Data to calculate New Zealand River Ecosystem Health Score
#'
#' A simulated dataset containing fish observations aggregated at a site level.
#'
#' @format A data frame with 231 rows and 6 variables:
#' \describe{
#'   \item{site}{The unique identifier for the spatial scale at which observations were aggregated.}
#'   \item{class}{The reference category used for calculating metric performance scores.}
#'   \item{indicator}{The specific indicator to which metrics belong (i.e., macroinvertebrates)}
#'   \item{component}{The specific component to which the indicator belongs (i.e.,. aquatic_life)}
#'   \item{reporting_scale}{The chosen scale for data integration}
#'   \item{periphyton}{Simulated values of the metric periphyton (chlorophyll a)}
#'   }

"plants"


#' Data sources to calculate Zealand River Ecosystem Health Score
#'
#'
#'
#' @format A data frame with 39 rows and 6 variables:
#' \describe{
#'
#'   \item{Component}{The specific component to which the indicator belongs (i.e.,. aquatic_life)}
#'   \item{Indicator}{The specific indicator to which metrics belong (i.e., macroinvertebrates)}
#'   \item{Attribute}{The biophysical attribute a given metric quantifies}
#'   \item{Metric}{Measured or modeled biophysical characteristics of rivers and streams.}
#'   \item{Units}{Measurement units used for each metric.}
#'   \item{Citation}{Source from which benchmarks were derived for a given metric.}

#' }

"data_sources"
