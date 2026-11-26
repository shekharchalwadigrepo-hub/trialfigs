# Binary responder rate with a Wilson interval

Percent of responders by arm, with a Wilson score interval.

## Usage

``` r
plot_responder(data, responder, arm, title = "Responder rate",
  ylab = "Responders, percent (Wilson 95% CI)")
```

## Arguments

- data:

  Subject-level data.

- responder:

  Logical or 0/1 column name.

- arm:

  Arm column name.

- title,ylab:

  Labels.

## Value

A ggplot object.

## Examples

``` r
onc <- simulate_oncology(n_per_arm = 15)
onc$adsl$responder <- onc$adsl$bor %in% c("CR", "PR")
plot_responder(onc$adsl, responder = "responder", arm = "arm")
```
