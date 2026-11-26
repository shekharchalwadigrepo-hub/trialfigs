# Spider plot of percent change over time

Individual tumor trajectories with the arm mean overlaid.

## Usage

``` r
plot_spider(data, id = "usubjid", time = "week", pct = "pct_change",
  arm = "arm", title = "Percent change in sum of diameters")
```

## Arguments

- data:

  Longitudinal data, one row per subject per visit.

- id,time,pct,arm:

  Column names.

- title:

  Plot title.

## Value

A ggplot object.

## Examples

``` r
onc <- simulate_oncology(n_per_arm = 8)
plot_spider(onc$adtr)
```
