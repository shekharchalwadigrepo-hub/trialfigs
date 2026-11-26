# Mean change from baseline with a confidence interval

The band is the normal approximation to the standard error of the mean.
Replace it with the model named in the statistical analysis plan for a
primary contrast.

## Usage

``` r
plot_change(data, visit = "week", change = "chg", arm = "arm",
  title = "Mean change from baseline", xlab = "Week",
  ylab = "Mean change (95% CI)")
```

## Arguments

- data:

  Longitudinal data.

- visit,change,arm:

  Column names.

- title,xlab,ylab:

  Labels.

## Value

A ggplot object.

## Examples

``` r
endo <- simulate_endocrinology(n_per_arm = 15)
plot_change(endo$adlb, title = "HbA1c")
```
