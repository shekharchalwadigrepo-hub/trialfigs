# Gallery

``` r

library(trialfigs)
```

All figures are generated from **synthetic data** and are for
illustration only.

## Oncology

``` r

onc <- simulate_oncology(n_per_arm = 60)
```

``` r

plot_km(
  onc$adsl,
  time = "os_months",
  event = "os_event",
  arm = "arm",
  title = "Overall Survival"
)
```

![](gallery_files/figure-html/unnamed-chunk-3-1.png)

``` r

plot_waterfall(onc$adsl)
```

![](gallery_files/figure-html/unnamed-chunk-4-1.png)

``` r

plot_swimmer(onc$adsl, max_n = 20)
```

![](gallery_files/figure-html/unnamed-chunk-5-1.png)

``` r

plot_spider(onc$adtr)
```

![](gallery_files/figure-html/unnamed-chunk-6-1.png)

## Safety

``` r

saf <- simulate_safety(n_per_arm = 40)
```

``` r

plot_ae(saf$adae, denom = saf$adsl, reference = "Placebo")
```

![](gallery_files/figure-html/unnamed-chunk-8-1.png)

``` r

plot_edish(saf$adlb)
#> Warning: Use of `lab[[id]]` is discouraged.
#> ℹ Use `.data[[id]]` instead.
```

![](gallery_files/figure-html/unnamed-chunk-9-1.png)

``` r

plot_exposure(saf$adsl)
```

![](gallery_files/figure-html/unnamed-chunk-10-1.png)

## Cardiovascular

``` r

cv <- simulate_cardiovascular(n_per_arm = 50)
```

``` r

plot_km(
  cv$adsl,
  time = "mace_months",
  event = "mace_event",
  arm = "arm",
  title = "Time to First MACE"
)
```

![](gallery_files/figure-html/unnamed-chunk-12-1.png)

``` r

plot_change(
  cv$advs,
  title = "Mean Change in SBP",
  ylab = "Mean change in SBP (mmHg)"
)
```

![](gallery_files/figure-html/unnamed-chunk-13-1.png)

## Endocrinology

``` r

endo <- simulate_endocrinology(n_per_arm = 40)
```

``` r

plot_change(
  endo$adlb,
  title = "Mean Change in HbA1c",
  ylab = "Mean change in HbA1c (%)"
)
```

![](gallery_files/figure-html/unnamed-chunk-15-1.png)

## Immunology

``` r

imm <- simulate_immunology(n_per_arm = 40)
```

``` r

# Note: immunology returns adeff (not adlb)
plot_change(
  imm$adeff,
  title = "Mean Change in DAS28",
  ylab = "Mean change in DAS28"
)
```

![](gallery_files/figure-html/unnamed-chunk-17-1.png)

## Infectious Disease

``` r

inf <- simulate_infectious(n_per_arm = 40)
```

``` r

# Note: infectious disease uses "day" instead of "week"
plot_change(
  inf$adlb,
  visit = "day",
  title = "Mean Change in log10 Viral Load",
  xlab = "Day",
  ylab = "Mean change in log10 viral load"
)
```

![](gallery_files/figure-html/unnamed-chunk-19-1.png)

``` r

plot_km(
  inf$adsl,
  time = "clear_days",
  event = "clear_event",
  arm = "arm",
  title = "Time to Virologic Clearance",
  xlab = "Days"
)
```

![](gallery_files/figure-html/unnamed-chunk-20-1.png)

## Neuroscience

``` r

neuro <- simulate_neuroscience(n_per_arm = 40)
```

``` r

# Note: neuroscience returns adeff (not adlb)
plot_change(
  neuro$adeff,
  title = "Mean Change in MADRS",
  ylab = "Mean change in MADRS"
)
```

![](gallery_files/figure-html/unnamed-chunk-22-1.png)
