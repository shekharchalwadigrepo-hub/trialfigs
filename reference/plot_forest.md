# Forest plot of a ratio or a difference

Use `null = 1` for hazard ratios and `null = 0` for mean differences.
Intervals that cross the null are drawn in grey.

## Usage

``` r
plot_forest(data, label = "subgroup", estimate = "estimate", lcl = "lcl",
  ucl = "ucl", n = NULL, null = 1, xlab = "Hazard ratio (95% CI)",
  title = "Subgroup forest plot", subtitle = NULL,
  favour_left = "Favours investigational",
  favour_right = "Favours control")
```

## Arguments

- data:

  One row per subgroup or endpoint.

- label,estimate,lcl,ucl:

  Column names.

- n:

  Optional sample-size column.

- null:

  Null value drawn as a vertical line.

- xlab,title,subtitle,favour_left,favour_right:

  Labels.

## Value

A ggplot object.

## Examples

``` r
onc <- simulate_oncology(n_per_arm = 20)
forest <- cox_hr(onc$adsl, "os_months", "os_event", "arm")
plot_forest(forest)
```
