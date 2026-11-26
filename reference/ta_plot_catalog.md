# Recommended displays by therapeutic area

Working catalog of figures commonly discussed in a clinical review. Not
a regulatory requirement.

## Usage

``` r
ta_plot_catalog()
```

## Value

A data frame with therapeutic area, display, function name and anchor.

## Examples

``` r
head(ta_plot_catalog())
#>   therapeutic_area
#> 1         Oncology
#> 2         Oncology
#> 3         Oncology
#> 4         Oncology
#> 5         Oncology
#> 6   Cardiovascular
#>                                                                display
#> 1   Kaplan-Meier of OS and PFS with number at risk and censoring ticks
#> 2    Waterfall of best percent change in sum of diameters (RECIST 1.1)
#> 3      Swimmer plot of time on treatment with response and progression
#> 4                Spider plot of percent change from baseline over time
#> 5                Forest plot of hazard ratios by prespecified subgroup
#> 6 Kaplan-Meier of time to first MACE (note competing risk if relevant)
#>    function_name                                               anchor
#> 1        plot_km            ICH E3 efficacy; oncology review practice
#> 2 plot_waterfall    RECIST 1.1 thresholds -30 percent and +20 percent
#> 3   plot_swimmer                        Subject-level oncology review
#> 4    plot_spider                        Subject-level oncology review
#> 5    plot_forest                 Subgroup consistency, forest display
#> 6        plot_km Time-to-first-event; state competing-risk limitation
```
