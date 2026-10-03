test_that("simulators restore the random-number stream", {
  set.seed(1)
  before <- .Random.seed
  onc <- simulate_oncology(n_per_arm = 8)
  expect_equal(.Random.seed, before)
  expect_equal(nrow(onc$adsl), 16)
  expect_true(all(c("adsl", "adtr") %in% names(onc)))
})

test_that("review plots return ggplot objects", {
  onc <- simulate_oncology(n_per_arm = 12)
  p <- plot_km(onc$adsl, time = "os_months", event = "os_event", arm = "arm")
  expect_s3_class(p, "ggplot")
  expect_s3_class(plot_waterfall(onc$adsl), "ggplot")
  saf <- simulate_safety(n_per_arm = 20)
  expect_s3_class(plot_edish(saf$adlb), "ggplot")
  expect_s3_class(plot_ae(saf$adae, denom = saf$adsl), "ggplot")
})

test_that("catalog names a function for every row", {
  cat <- ta_plot_catalog()
  expect_true(all(cat$function_name %in% getNamespaceExports("trialfigs")))
})
