# Simulate an antiviral viral-load set

Log10 viral load and time to clearance. Synthetic data.

## Usage

``` r
simulate_infectious(n_per_arm = 100, seed = 20260319)
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
id <- simulate_infectious(n_per_arm = 15)
plot_change(id$adlb, visit = "day", xlab = "Day")
```
