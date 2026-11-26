# Swimmer plot of time on treatment

One bar per subject, with points for objective response and progression.
Limited to the longest durations so the figure stays readable.

## Usage

``` r
plot_swimmer(data, id = "usubjid", arm = "arm",
  duration = "trtdur_months", response_time = "resp_months",
  progression_time = "pd_months", max_n = 30, xlab = "Months",
  title = "Time on treatment")
```

## Arguments

- data:

  Subject-level data.

- id,arm,duration:

  Column names.

- response_time,progression_time:

  Optional column names.

- max_n:

  Maximum subjects, taken as the longest durations.

- xlab,title:

  Labels.

## Value

A ggplot object.

## Examples

``` r
onc <- simulate_oncology(n_per_arm = 12)
plot_swimmer(onc$adsl, max_n = 10)
```
