
<!-- README.md is generated from README.Rmd. Please edit that file -->

# riverhealth

<!-- badges: start -->

This document outlines the process for using a R package to calculate
the New Zealand River Ecosystem Health Score, as proposed by Clapcott et
al. (2019). The score serves as a simple and holistic measure of the
biophysical condition of rivers and streams in New Zealand. It is based
on the Freshwater Biophysical Ecosystem Health Framework and evaluates
five core components of ecosystem health: *Aquatic Life*, *Physical
Habitat*, *Water Quality*, *Water Quantity*, and *Ecological Processes*.
<!-- badges: end -->

## Installation

You can install the development version of riverhealth from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("cawthron/riverhealth")
```

## Preparing data

Before using `riverhealth`, it is assumed that users have followed the
steps required to apply the Freshwater Biophysical Ecosystem Health
Framework (Figure 1). This package assists users in **Step 1** by
providing default reference values for metrics, in **Step 2** by
harmonising and integrating data, and in **Step 3** by calculating
performance scores and plots for ecosystem health reporting. Users must
complete other steps in the process before using this tool. Such as the
establishment of representative monitoring sites, data collection,
metric calculation, and data aggregation to a chosen spatial and
temporal scale (e.g., the calculation of a 5-yr median for a given
site).

<figure>
<img src="flow_diagram.jpg"
alt="Figure 1 Flow diagram of the steps in the application of the framework for freshwater ecosystem health (from Clapcott et al. 2019) with steps undertaken by this R package highlighted." />
<figcaption aria-hidden="true">Figure 1 Flow diagram of the steps in the
application of the framework for freshwater ecosystem health (from
Clapcott et al. 2019) with steps undertaken by this R package
highlighted.</figcaption>
</figure>

## Reference table

A nationally applicable reference table is provided with the package.
This table provides default values for excellent ecological condition
(minimum human impact) as well as for poor ecological condition (e.g.,
national bottom lines) for metrics against which sites are compared with
to calculate performance scores. The reference table was populated using
best available information.

For attributes in the National Policy Statement for Freshwater
Management (NPSFM) 2020, the default values are provided in Tables in
Appendix 2A and 2B. In this tool, the metric value denoting an A band
was used for excellent condition and the metric value denoting the
national bottom line was used for poor condition. Exceptions include:
Dissolved reactive phosphorus and Fish Index of Biotic Integrity, where
the metric value denoting the D band was used for poor condition;
Ecosystem metabolism (both gross primary production and ecosystem
respiration) default values were informed by Young et al. (2008) and
STAG Report to the Minister for the Environment (2019). For attributes
not in the NPSFM, the references used to inform default guidelines
values can be found in the Appendix.

We recommend using the reference table provided with the package. The
default reference table is included with the package and can be accessed
once the package is installed as `reference_table_default`:

| component            | indicator                | attribute                      | metric                         | class       | bottom_line | bottom_line_range | reference | reference_range |    cut | healthy_value | npsfm | suitability | key_metric |
|:---------------------|:-------------------------|:-------------------------------|:-------------------------------|:------------|------------:|------------------:|----------:|----------------:|-------:|:--------------|:------|------------:|:-----------|
| aquatic_life         | fish                     | fish_ibi                       | fish_ibi                       | universal   |      18.000 |                NA |    34.000 |              NA |  28.00 | high          | TRUE  |           3 | TRUE       |
| aquatic_life         | fish                     | exotic_species                 | exotic_species                 | universal   |       6.000 |                NA |     0.000 |              NA |     NA | low           | FALSE |           1 | TRUE       |
| aquatic_life         | fish                     | taxa_richness                  | taxa_richness                  | universal   |      20.000 |                NA |     5.000 |              NA |     NA | low           | FALSE |           1 | FALSE      |
| aquatic_life         | plants                   | exotic_species                 | exotic_species                 | universal   |       3.000 |                NA |     0.000 |              NA |     NA | low           | FALSE |           1 | TRUE       |
| aquatic_life         | plants                   | plant_productivity             | periphyton                     | default     |     200.000 |                NA |    50.000 |              NA | 120.00 | low           | TRUE  |           3 | TRUE       |
| aquatic_life         | plants                   | plant_productivity             | periphyton                     | productive  |     200.000 |                NA |    50.000 |              NA | 120.00 | low           | TRUE  |           3 | TRUE       |
| aquatic_life         | plants                   | plant_productivity             | macrophyte_channel_clogginess  | universal   |      30.000 |                NA |    10.000 |              NA |     NA | low           | FALSE |           2 | TRUE       |
| aquatic_life         | plants                   | weighted_composite_cover       | weighted_composite_cover       | universal   |      55.000 |                NA |    20.000 |              NA |     NA | low           | FALSE |           2 | FALSE      |
| aquatic_life         | macroinvertebrates       | mci                            | mci                            | universal   |      90.000 |                NA |   130.000 |              NA | 110.00 | high          | TRUE  |           3 | TRUE       |
| aquatic_life         | macroinvertebrates       | mci                            | qmci                           | universal   |       4.500 |                NA |     6.500 |              NA |   5.50 | high          | TRUE  |           3 | TRUE       |
| aquatic_life         | macroinvertebrates       | aspm                           | aspm                           | universal   |       0.300 |                NA |     0.600 |              NA |   0.40 | high          | TRUE  |           3 | FALSE      |
| aquatic_life         | macroinvertebrates       | ept_taxa_richness              | ept_taxa_richness              | universal   |       5.000 |                NA |    15.000 |              NA |     NA | high          | FALSE |           1 | FALSE      |
| aquatic_life         | macroinvertebrates       | percentage_ept_taxa            | percentage_ept_taxa            | universal   |      25.000 |                NA |    70.000 |              NA |     NA | high          | FALSE |           1 | FALSE      |
| aquatic_life         | macroinvertebrates       | exotic_species                 | exotic_species                 | universal   |       3.000 |                NA |     0.000 |              NA |     NA | low           | FALSE |           1 | TRUE       |
| aquatic_life         | waterbirds               | abundance                      | abundance                      | universal   |          NA |                NA |        NA |              NA |     NA | high          | FALSE |           1 | FALSE      |
| aquatic_life         | waterbirds               | taxa_richness                  | taxa_richness                  | universal   |          NA |                NA |        NA |              NA |     NA | low           | FALSE |           1 | TRUE       |
| aquatic_life         | microbes                 | bacterial_community_index      | bacterial_community_index      | universal   |          NA |                NA |        NA |              NA |     NA | high          | FALSE |           1 | TRUE       |
| water_quality        | dissolved_oxygen         | dissolved_oxygen               | do_7_day_min                   | universal   |       5.000 |                NA |     8.000 |              NA |   7.00 | low           | TRUE  |           3 | TRUE       |
| water_quality        | dissolved_oxygen         | dissolved_oxygen               | do_1_day_min                   | universal   |       4.000 |                NA |     7.500 |              NA |   5.00 | low           | TRUE  |           3 | TRUE       |
| water_quality        | temperature              | cox_rutherford_index           | cox_rutherford_index           | maritime    |      24.000 |                NA |    18.000 |              NA |  20.00 | low           | FALSE |           1 | TRUE       |
| water_quality        | temperature              | cox_rutherford_index           | cox_rutherford_index           | eastern_dry |      26.000 |                NA |    20.000 |              NA |  22.00 | low           | FALSE |           1 | TRUE       |
| water_quality        | suspended_fine_sediment  | visual_clarity                 | visual_clarity                 | 1           |       1.340 |                NA |     1.780 |              NA |   1.55 | low           | TRUE  |           3 | TRUE       |
| water_quality        | suspended_fine_sediment  | visual_clarity                 | visual_clarity                 | 2           |       0.610 |                NA |     0.930 |              NA |   0.76 | low           | TRUE  |           3 | TRUE       |
| water_quality        | suspended_fine_sediment  | visual_clarity                 | visual_clarity                 | 3           |       2.220 |                NA |     2.950 |              NA |   2.57 | low           | TRUE  |           3 | TRUE       |
| water_quality        | suspended_fine_sediment  | visual_clarity                 | visual_clarity                 | 4           |       0.980 |                NA |     1.380 |              NA |   1.17 | low           | TRUE  |           3 | TRUE       |
| water_quality        | contaminants             | ammonia                        | ammonia_median                 | universal   |       1.300 |                NA |     0.030 |              NA |   0.24 | low           | TRUE  |           3 | TRUE       |
| water_quality        | contaminants             | ammonia                        | amonia_95_percentile           | universal   |       2.200 |                NA |     0.050 |              NA |   0.40 | low           | TRUE  |           3 | TRUE       |
| water_quality        | contaminants             | nitrate                        | nitrate_median                 | universal   |       6.900 |                NA |     1.000 |              NA |   2.40 | low           | TRUE  |           3 | TRUE       |
| water_quality        | contaminants             | nitrate                        | nitrate_95_percentile          | universal   |       9.800 |                NA |     1.500 |              NA |   3.50 | low           | TRUE  |           3 | TRUE       |
| water_quality        | contaminants             | metals                         | copper                         | universal   |       1.300 |                NA |     0.200 |              NA |     NA | low           | FALSE |           3 | FALSE      |
| water_quality        | contaminants             | metals                         | lead                           | universal   |       9.400 |                NA |     1.000 |              NA |     NA | low           | FALSE |           3 | FALSE      |
| water_quality        | contaminants             | metals                         | zinc                           | universal   |      31.000 |                NA |     2.400 |              NA |     NA | low           | FALSE |           3 | FALSE      |
| water_quality        | nutrients                | dissolved_reactive_phosphorus  | drp_median                     | universal   |       0.180 |                NA |     0.006 |              NA |   0.01 | low           | TRUE  |           3 | TRUE       |
| water_quality        | nutrients                | dissolved_reactive_phosphorus  | drp_95_percentile              | universal   |       0.054 |                NA |     0.021 |              NA |   0.03 | low           | TRUE  |           3 | TRUE       |
| water_quality        | nutrients                | dissolved_inorganic_nitrogen   | din_median                     | universal   |       1.000 |                NA |     0.240 |              NA |     NA | low           | FALSE |           2 | TRUE       |
| water_quality        | nutrients                | dissolved_inorganic_nitrogen   | din_95_percentile              | universal   |       2.050 |                NA |     0.560 |              NA |     NA | low           | FALSE |           3 | TRUE       |
| water_quantity       | extent                   | water_allocation_index         | water_allocation_index         | universal   |       0.300 |                NA |     0.000 |              NA |     NA | low           | FALSE |           2 | TRUE       |
| water_quantity       | extent                   | median_flow                    | median_flow                    | universal   |      20.000 |                NA |    10.000 |              NA |     NA | low           | FALSE |           2 | TRUE       |
| water_quantity       | extent                   | mean_annual_flow               | mean_annual_flow               | universal   |      20.000 |                NA |    10.000 |              NA |     NA | low           | FALSE |           2 | TRUE       |
| water_quantity       | hydrological_variability | fre3                           | fre3                           | universal   |          NA |                NA |        NA |              NA |     NA | low           | FALSE |           1 | TRUE       |
| water_quantity       | hydrological_variability | mean:median                    | mean:median                    | universal   |          NA |                NA |        NA |              NA |     NA | low           | FALSE |           1 | FALSE      |
| water_quantity       | connectivity             | floodplain                     | floodplain                     | universal   |          NA |                NA |        NA |              NA |     NA | high          | FALSE |           1 | TRUE       |
| water_quantity       | connectivity             | groundwater                    | groudwater                     | universal   |          NA |                NA |        NA |              NA |     NA | high          | FALSE |           1 | FALSE      |
| physical_habitat     | substrate                | deposited_fine_sediment        | deposited_fine_sediment        | 1           |      21.000 |                NA |     7.000 |              NA |  14.00 | low           | TRUE  |           3 | TRUE       |
| physical_habitat     | substrate                | deposited_fine_sediment        | deposited_fine_sediment        | 2           |      29.000 |                NA |    10.000 |              NA |  19.00 | low           | TRUE  |           3 | TRUE       |
| physical_habitat     | substrate                | deposited_fine_sediment        | deposited_fine_sediment        | 3           |      27.000 |                NA |     9.000 |              NA |  18.00 | low           | TRUE  |           3 | TRUE       |
| physical_habitat     | substrate                | deposited_fine_sediment        | deposited_fine_sediment        | 4           |      27.000 |                NA |    13.000 |              NA |  19.00 | low           | TRUE  |           3 | TRUE       |
| physical_habitat     | form                     | natural_character_index        | natural_character_index        | universal   |          NA |                NA |        NA |              NA |     NA | high          | FALSE |           1 | TRUE       |
| physical_habitat     | form                     | catchment_impermeability       | catchment_impermeability       | universal   |      15.000 |                NA |     5.000 |              NA |     NA | low           | FALSE |           1 | TRUE       |
| physical_habitat     | form                     | bank_stability                 | bank_stability                 | universal   |      75.000 |                NA |     5.000 |              NA |     NA | low           | FALSE |           1 | TRUE       |
| physical_habitat     | extent                   | wetland_extent                 | wetland_extent                 | universal   |      10.000 |                NA |    60.000 |              NA |     NA | high          | FALSE |           2 | FALSE      |
| physical_habitat     | extent                   | rapid_habitat_assessment_score | rapid_habitat_assessment_score | universal   |      25.000 |                NA |    75.000 |              NA |     NA | high          | FALSE |           2 | TRUE       |
| physical_habitat     | riparian                 | shade                          | shade                          | universal   |      10.000 |                NA |    70.000 |              NA |     NA | high          | FALSE |           2 | TRUE       |
| physical_habitat     | riparian                 | riparian_function              | riparian_function              | universal   |      22.000 |                NA |    55.000 |              NA |     NA | high          | FALSE |           1 | FALSE      |
| ecological_processes | biotic_interactions      | food_web_indeces               | food_web_indeces               | universal   |          NA |                NA |        NA |              NA |     NA | high          | TRUE  |           1 | TRUE       |
| ecological_processes | biogeochemical_processes | gross_primary_productivity     | gross_primary_productivity     | wadeable    |       7.000 |                NA |     3.500 |              NA |     NA | low           | TRUE  |           2 | TRUE       |
| ecological_processes | biogeochemical_processes | gross_primary_productivity     | gross_primary_productivity     | nonwadeable |       8.000 |                NA |     3.000 |              NA |     NA | low           | TRUE  |           2 | TRUE       |
| ecological_processes | biogeochemical_processes | ecosystem_respiration          | ecosystem_respiration          | wadeable    |       9.500 |             0.800 |     1.600 |            5.80 |     NA | nonlinear     | TRUE  |           2 | TRUE       |
| ecological_processes | biogeochemical_processes | ecosystem_respiration          | ecosystem_respiration          | nonwadeable |      13.000 |             0.600 |     1.600 |            3.00 |     NA | nonlinear     | TRUE  |           2 | TRUE       |
| ecological_processes | biogeochemical_processes | cotton_breakdown               | cotton_breakdown               | universal   |       0.050 |             0.005 |     0.030 |            0.01 |     NA | low           | FALSE |           1 | FALSE      |

Each row corresponds to a different metric and each column denotes:

- **component:** Each component describes a different aspect of
  freshwater biophysical ecosystem health.
- **indicator:** Within a component, indicators aggregate similar
  metrics. This column denotes the indicator to which a given metric
  belongs to.
- **attribute:** The biophysical attributes a given metric aims to
  quantify. The attribute classification often matches the metric
  classification, but it can vary when multiple metrics measure the same
  attribute(e.g., both the *do_7_day_min* and *do_1_day_min* metrics
  measure the *dissolved oxygen* attribute).
- **metric:** Measured or modeled biophysical characteristics of rivers
  and streams.
- **class:** The category used for calculating metric performance scores
  (e.g., productive/default, sediment class). Different categories will
  have different benchmarks.
- **bottom_line:** This numerical value is a benchmark that denotes a
  degraded state or poor condition for a given metric, against which
  sites will be compared to calculate performance scores.
- **bottom_line_range:** For non-linear metrics only, these values
  denote the range that comprises a degraded state for a given metric.
  If the metric is linear, then this column should be NA.
- **reference:** This numerical value is a benchmark that denotes a
  healthy state or excellent condition for a given metric, against which
  sites will be compared to calculate performance scores.
- **reference_line_range:** For non-linear metrics only, these values
  denote the range that comprises a healthy state for a given metric. If
  the metric is linear, then this column should be NA.
- **cut:** For NPSFM metrics, this numerical value is the benchmark that
  denotes metric grades between the **bottom_line** and the
  **reference** values (e.g., delineating B/C grades). These values are
  only used to calculate NPSFM grade bands and are not used to calculate
  metric performance scores.
- **healthy_value:** A categorical value that denotes whether high or
  low values of a metric indicate a healthy stream. Categories are
  *high*, *low*, or *non-linear*.
- **NPSFM:** A Boolean variable (*TRUE* or *FALSE*) denoting if a metric
  is part of the National Policy Statement for Freshwater Management
  2020.
- **suitability:** A numerical value (*1*, *2*, or *3*) for each metric,
  assigned using expert assessment to quantify if metrics are fit for
  purpose. These values are used in the data integration process.
- **key_metric:** A Boolean variable denoting if a metric is necessary
  for a holistic assessment of a river or stream. Metrics denoted as key
  metrics will be used to calculate plotting ratios of each indicator.

If the user needs to apply different benchmarks (e.g., to account for
regional guideline values or spatial variation), they can use their own
user-defined reference table. However, a user-defined reference table
must follow the exact same format as the default reference table. The
final output will indicate whether the default or user-defined
benchmarks were used. We recommend the user employ best practice
guidelines to inform alternative benchmarks, such as those used in
Clapcott et al (2019).

A note on metric **suitability** values. In the default reference table,
these were assigned using the following logic: All metrics with tables
in Appendix 2A and 2B of the NPSFM 2020 were assigned a 3, indicating
high suitability. Metrics with standardised methods and/or national
datasets and/or national guideline values were assigned a 2, indicating
medium suitability. Remaining metrics that did not meet the above
definitions or only provided partial assessment of an indicator compared
to an alternative metric (e.g., *taxa_richness* compared to *fish_ibi*)
were assigned a 1, indicating low suitability.

A note on **key_metric** identification. Metrics were labelled as key
metrics if they contributed to a holistic assessment of ecological
integrity, which includes nativeness, pristineness, diversity, and
resilience, where applicable. Each indicator must contain at least one
key metric even if that metric has low suitability. For example, plant
*exotic_species* is a key metric despite a suitability of 1 because
there are no alternative metrics assessing nativeness.

## Preparing data - Indicator tables

Within each component, indicator tables should be prepared
independently. Each table should be presented as a tidy data frame,
where each variable constitutes a column, and each observation forms a
row. The data in these tables should already be aggregated at the
desired level for analysis. For example, as detailed in Clapcott et
al. (2019), data were aggregated at the site level using the mean
average for the given period (e.g. 2013-2017).

Each indicator table must include the following columns:

- **site:** The unique identifier for the spatial scale at which
  observations were aggregated (e.g. NZSegment, Site name).
- **class:** The category of a given site in the context of the metrics
  being measured (e.g. productive/default for *periphyton*, sediment
  class for *visual_clarity*).
- **indicator:** This column denotes the indicator to which the given
  metrics belong to. Values in this column should be an exact match to
  the indicators listed in the **Reference Table**.
- **component:** This column denotes the component to which the given
  metric/s belong to. Values in this column should be an exact match to
  the components listed in the **Reference Table**.
- **reporting_scale:** The chosen scale for data integration. This could
  be, for example, Freshwater Management Unit, region, or stream class.
  This column should be the same for all indicator tables for
  calculating an ecosystem health score. The names for all reporting
  scales should be consistent across all indicator tables.
- **individual metric columns:** Each metric observed or modelled should
  have its own column, containing the respective metric values for
  evaluating the indicator. At least one metric column is required.
  Column names should be an exact match to the metrics listed in the
  **Reference Table** (eg., *fish_ibi*, *qmci*).

As an example, all subsequent analyses will show how to calculate health
scores for the *Aquatic Life* component using simulated data. This data
is provided with the package. The first few rows of the
`macroinvertebrates` indicator table show:
