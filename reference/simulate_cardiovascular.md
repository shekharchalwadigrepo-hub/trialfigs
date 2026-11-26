# Simulate a cardiovascular outcomes set

Time to first MACE and systolic blood pressure. Synthetic data.

## Usage

``` r
simulate_cardiovascular(n_per_arm = 220, seed = 20260316)
```

## Arguments

- n_per_arm:

  Subjects per arm.

- seed:

  Random seed, restored after the call.

## Value

A list with `adsl` and `advs`.

## Examples

``` r
cv <- simulate_cardiovascular(n_per_arm = 20)
plot_km(cv$adsl, time = "mace_months", event = "mace_event", arm = "arm")
#> Warning: Removed 1 row containing missing values or values outside the scale range
#> (`geom_step()`).
#> Warning: Removed 1 row containing missing values or values outside the scale range
#> (`geom_step()`).
```
