# Treatment duration by arm

Box plot of exposure with the median in the caption.

## Usage

``` r
plot_exposure(data, duration = "trtdur_days", arm = "arm",
  xlab = "Treatment duration (days)", title = "Exposure")
```

## Arguments

- data:

  Subject-level data.

- duration,arm:

  Column names.

- xlab,title:

  Labels.

## Value

A ggplot object.

## Examples

``` r
saf <- simulate_safety(n_per_arm = 20)
plot_exposure(saf$adsl)
```
