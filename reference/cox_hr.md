# Cox hazard ratio with the investigational arm in the numerator

The reference level is the other arm, so a ratio below 1 favours the
investigational arm. One row is returned, for binding into a forest.

## Usage

``` r
cox_hr(data, time, event, arm, investigational = "Investigational",
  subgroup = "Overall")
```

## Arguments

- data:

  Subject-level data.

- time,event,arm:

  Column names.

- investigational:

  Level of `arm` treated as the experimental arm.

- subgroup:

  Label stored in the result.

## Value

A one-row data frame with subgroup, estimate, limits and n.

## Examples

``` r
onc <- simulate_oncology(n_per_arm = 20)
cox_hr(onc$adsl, "os_months", "os_event", "arm")
#>   subgroup  estimate       lcl       ucl  n
#> 1  Overall 0.3149958 0.1271583 0.7803058 40
```
