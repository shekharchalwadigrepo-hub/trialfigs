# Simulate a type 2 diabetes HbA1c set

Longitudinal HbA1c. Synthetic data.

## Usage

``` r
simulate_endocrinology(n_per_arm = 150, seed = 20260317)
```

## Arguments

- n_per_arm:

  Subjects per arm.

- seed:

  Random seed, restored after the call.

## Value

A list with `adsl` and `adlb`.

## Examples

``` r
endo <- simulate_endocrinology(n_per_arm = 15)
plot_change(endo$adlb)
```
