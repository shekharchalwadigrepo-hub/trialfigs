# eDISH plot of peak ALT versus peak bilirubin

Log-scale multiples of the upper limit of normal. Reference lines are
ALT 3x ULN and total bilirubin 2x ULN. A point in that quadrant needs
narrative review; it is not by itself a Hy's law case.

## Usage

``` r
plot_edish(data, alt = "alt_xuln", bili = "bili_xuln", arm = "arm",
  id = "usubjid", title = "eDISH: peak ALT vs peak total bilirubin")
```

## Arguments

- data:

  One row per subject, peak values.

- alt,bili,arm:

  Column names, values in multiples of ULN.

- id:

  Optional subject id, labelled for quadrant cases.

- title:

  Plot title.

## Value

A ggplot object.

## Examples

``` r
saf <- simulate_safety(n_per_arm = 25)
plot_edish(saf$adlb)
#> Warning: Use of `lab[[id]]` is discouraged.
#> ℹ Use `.data[[id]]` instead.
```
