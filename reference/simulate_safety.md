# Simulate core safety data

Adverse events and peak liver tests in multiples of the upper limit of
normal. Synthetic data.

## Usage

``` r
simulate_safety(n_per_arm = 160, seed = 20260321)
```

## Arguments

- n_per_arm:

  Subjects per arm.

- seed:

  Random seed, restored after the call.

## Value

A list with `adsl`, `adae` and `adlb`.

## Examples

``` r
saf <- simulate_safety(n_per_arm = 20)
plot_edish(saf$adlb)
#> Warning: Use of `lab[[id]]` is discouraged.
#> ℹ Use `.data[[id]]` instead.
```
