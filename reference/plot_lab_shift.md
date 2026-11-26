# Baseline versus post-baseline maximum

Points above the identity line rose after baseline.

## Usage

``` r
plot_lab_shift(data, baseline = "alt_base", post = "alt_max", arm = "arm",
  uln = NULL, title = "Baseline vs post-baseline maximum",
  xlab = "Baseline", ylab = "Post-baseline maximum")
```

## Arguments

- data:

  One row per subject.

- baseline,post,arm:

  Column names.

- uln:

  Upper limit of normal, drawn if not NULL.

- title,xlab,ylab:

  Labels.

## Value

A ggplot object.

## Examples

``` r
saf <- simulate_safety(n_per_arm = 20)
plot_lab_shift(saf$adlb, uln = 1)
```
