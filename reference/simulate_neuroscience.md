# Simulate a depression MADRS set

Longitudinal MADRS. Synthetic data.

## Usage

``` r
simulate_neuroscience(n_per_arm = 140, seed = 20260320)
```

## Arguments

- n_per_arm:

  Subjects per arm.

- seed:

  Random seed, restored after the call.

## Value

A list with `adsl` and `adeff`.

## Examples

``` r
cns <- simulate_neuroscience(n_per_arm = 15)
plot_change(cns$adeff, title = "MADRS")
```
