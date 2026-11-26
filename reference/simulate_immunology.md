# Simulate a rheumatoid-arthritis DAS28 set

Longitudinal DAS28. Synthetic data.

## Usage

``` r
simulate_immunology(n_per_arm = 120, seed = 20260318)
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
imm <- simulate_immunology(n_per_arm = 15)
plot_change(imm$adeff, title = "DAS28")
```
