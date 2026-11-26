# RECIST waterfall of best percent change

Bars of best percent change in the sum of diameters. Reference lines at
-30 and +20 follow RECIST 1.1. Subjects with no post-baseline value are
omitted.

## Usage

``` r
plot_waterfall(data, pct = "pct_change", response = "bor", arm = "arm",
  id = "usubjid", title = "Best percent change in sum of diameters",
  subtitle = "RECIST 1.1 reference lines at -30% and +20%",
  palette = NULL)
```

## Arguments

- data:

  Subject-level data.

- pct,response,arm,id:

  Column names.

- title,subtitle:

  Labels.

- palette:

  Named colors for response categories.

## Value

A ggplot object.

## Examples

``` r
onc <- simulate_oncology(n_per_arm = 15)
plot_waterfall(onc$adsl)
```
