# Adverse-event incidence dot plot

Percent of subjects with each term and a Wilson interval, ordered by the
risk difference versus the reference arm.

## Usage

``` r
plot_ae(data, term = "term", arm = "arm", denom = NULL, id = "usubjid",
  reference = "Placebo", title = "Subjects with an adverse event")
```

## Arguments

- data:

  One row per subject per event.

- term,arm,id:

  Column names.

- denom:

  Subject-level denominator. Required for a correct percent.

- reference:

  Arm used when ordering by risk difference.

- title:

  Plot title.

## Value

A ggplot object.

## Examples

``` r
saf <- simulate_safety(n_per_arm = 25)
plot_ae(saf$adae, denom = saf$adsl, reference = "Placebo")
```
