# Simulate a two-arm oncology efficacy set

Subject-level survival, RECIST response, and longitudinal tumor
measurements. Data are synthetic. The random-number stream is restored
on exit.

## Usage

``` r
simulate_oncology(n_per_arm = 80, seed = 20260315)
```

## Arguments

- n_per_arm:

  Subjects per arm.

- seed:

  Random seed, restored after the call.

## Value

A list with `adsl` and `adtr`.

## Examples

``` r
onc <- simulate_oncology(n_per_arm = 10)
plot_waterfall(onc$adsl)
```
