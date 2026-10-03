# Therapeutic-area simulators. Data are synthetic and must not be described
# as trial results or as FDA data.

.exp_time <- function(n, median) stats::rexp(n, rate = log(2) / median)

.clip <- function(x, lo, hi) pmax(lo, pmin(hi, x))

#' Simulate a two-arm oncology efficacy set.
#'
#' Subject-level overall survival, progression-free survival, RECIST best
#' overall response, and a longitudinal tumor frame for spider plots.
#' Medians are illustrative (investigational PFS about 8.4 months).
#' @param n_per_arm Subjects per arm.
#' @param seed Random seed.
#' @return A list with `adsl` and `adtr` (tumor measurements, percent change).
#' @export
simulate_oncology <- function(n_per_arm = 80, seed = 20260315) {
  withr::with_seed(seed, {
  n <- n_per_arm * 2L
  adsl <- data.frame(
    usubjid = sprintf("ONC-%03d", seq_len(n)),
    arm = rep(c("Investigational", "Control"), each = n_per_arm),
    age = as.integer(.clip(round(stats::rnorm(n, 62, 9)), 32, 85)),
    sex = sample(c("F", "M"), n, TRUE, c(0.46, 0.54)),
    ecog = sample(c("0", "1"), n, TRUE, c(0.42, 0.58)),
    region = sample(c("North America", "Europe", "Asia"), n, TRUE, c(0.34, 0.40, 0.26)),
    stringsAsFactors = FALSE
  )
  pfs_med <- ifelse(adsl$arm == "Investigational", 8.4, 4.6)
  os_med <- ifelse(adsl$arm == "Investigational", 18.2, 12.5)
  adsl$pfs_months <- .exp_time(n, pfs_med)
  adsl$os_months <- pmax(adsl$pfs_months, .exp_time(n, os_med))
  adsl$pfs_censor <- stats::runif(n, 9, 18)
  adsl$os_censor <- stats::runif(n, 12, 28)
  adsl$pfs_event <- as.integer(adsl$pfs_months <= adsl$pfs_censor)
  adsl$pfs_months <- pmin(adsl$pfs_months, adsl$pfs_censor)
  adsl$os_event <- as.integer(adsl$os_months <= adsl$os_censor)
  adsl$os_months <- pmin(adsl$os_months, adsl$os_censor)
  shrinkage <- ifelse(
    adsl$arm == "Investigational",
    stats::rnorm(n, -34, 26),
    stats::rnorm(n, -6, 28)
  )
  adsl$pct_change <- .clip(shrinkage, -100, 140)
  adsl$bor <- ifelse(adsl$pct_change <= -100, "CR",
              ifelse(adsl$pct_change <= -30, "PR",
              ifelse(adsl$pct_change < 20, "SD", "PD")))
  ne <- sample(seq_len(n), 6)
  adsl$bor[ne] <- "NE"
  adsl$pct_change[ne] <- NA_real_
  adsl$trtdur_months <- pmin(adsl$pfs_months + stats::runif(n, 0, 1.2), adsl$os_months)
  adsl$resp_months <- ifelse(adsl$bor %in% c("CR", "PR"), stats::runif(n, 1.2, 4.2), NA_real_)
  adsl$pd_months <- ifelse(adsl$pfs_event == 1, adsl$pfs_months, NA_real_)

  weeks <- c(0, 6, 12, 18, 24, 36)
  adtr <- do.call(rbind, lapply(seq_len(n), function(i) {
    best <- adsl$pct_change[i]
    if (is.na(best)) best <- 0
    path <- c(0, best * c(0.35, 0.7, 1, 0.85, 0.7) + stats::rnorm(5, 0, 4))
    if (adsl$bor[i] == "PD") path <- cumsum(c(0, stats::runif(5, 2, 14)))
    data.frame(
      usubjid = adsl$usubjid[i],
      arm = adsl$arm[i],
      week = weeks,
      pct_change = .clip(path, -100, 160),
      stringsAsFactors = FALSE
    )
  }))
  list(adsl = adsl, adtr = adtr)
  })
}

#' Simulate a cardiovascular outcomes set (time to first MACE and SBP).
#' @param n_per_arm Subjects per arm.
#' @param seed Random seed.
#' @return A list with `adsl` and `advs` (systolic blood pressure by visit).
#' @export
simulate_cardiovascular <- function(n_per_arm = 220, seed = 20260316) {
  withr::with_seed(seed, {
  n <- n_per_arm * 2L
  adsl <- data.frame(
    usubjid = sprintf("CV-%04d", seq_len(n)),
    arm = rep(c("Investigational", "Placebo"), each = n_per_arm),
    age = as.integer(.clip(round(stats::rnorm(n, 66, 8)), 45, 90)),
    sex = sample(c("F", "M"), n, TRUE, c(0.38, 0.62)),
    region = sample(c("North America", "Europe", "Asia", "Other"), n, TRUE),
    prior_mi = sample(c("Yes", "No"), n, TRUE, c(0.55, 0.45)),
    stringsAsFactors = FALSE
  )
  med <- ifelse(adsl$arm == "Investigational", 42, 34)
  adsl$mace_months <- .exp_time(n, med)
  adsl$censor_months <- stats::runif(n, 18, 48)
  adsl$mace_event <- as.integer(adsl$mace_months <= adsl$censor_months)
  adsl$mace_months <- pmin(adsl$mace_months, adsl$censor_months)
  visits <- c(0, 4, 12, 24, 36, 52)
  advs <- do.call(rbind, lapply(seq_len(n), function(i) {
    base <- stats::rnorm(1, 148, 12)
    drop <- if (adsl$arm[i] == "Investigational") 11 else 3
    data.frame(
      usubjid = adsl$usubjid[i],
      arm = adsl$arm[i],
      week = visits,
      sbp = base - drop * (visits > 0) * (1 - exp(-visits / 12)) + stats::rnorm(length(visits), 0, 6),
      stringsAsFactors = FALSE
    )
  }))
  advs$chg <- ave(advs$sbp, advs$usubjid, FUN = function(x) x - x[1])
  list(adsl = adsl, advs = advs)
  })
}

#' Simulate a type 2 diabetes HbA1c set.
#' @param n_per_arm Subjects per arm.
#' @param seed Random seed.
#' @return A list with `adsl` and `adlb`.
#' @export
simulate_endocrinology <- function(n_per_arm = 150, seed = 20260317) {
  withr::with_seed(seed, {
  n <- n_per_arm * 2L
  adsl <- data.frame(
    usubjid = sprintf("ENDO-%04d", seq_len(n)),
    arm = rep(c("Investigational", "Placebo"), each = n_per_arm),
    age = as.integer(.clip(round(stats::rnorm(n, 57, 10)), 28, 80)),
    sex = sample(c("F", "M"), n, TRUE),
    baseline_hba1c = .clip(stats::rnorm(n, 8.1, 0.7), 7.0, 11),
    stringsAsFactors = FALSE
  )
  weeks <- c(0, 4, 8, 12, 16, 24)
  adlb <- do.call(rbind, lapply(seq_len(n), function(i) {
    drop <- if (adsl$arm[i] == "Investigational") 1.15 else 0.25
    value <- adsl$baseline_hba1c[i] -
      drop * (weeks > 0) * (1 - exp(-weeks / 8)) +
      stats::rnorm(length(weeks), 0, 0.25)
    data.frame(
      usubjid = adsl$usubjid[i],
      arm = adsl$arm[i],
      week = weeks,
      hba1c = .clip(value, 4.5, 13),
      stringsAsFactors = FALSE
    )
  }))
  adlb$chg <- ave(adlb$hba1c, adlb$usubjid, FUN = function(x) x - x[1])
  list(adsl = adsl, adlb = adlb)
  })
}

#' Simulate a rheumatoid-arthritis DAS28 set.
#' @param n_per_arm Subjects per arm.
#' @param seed Random seed.
#' @return A list with `adsl` and `adeff`.
#' @export
simulate_immunology <- function(n_per_arm = 120, seed = 20260318) {
  withr::with_seed(seed, {
  n <- n_per_arm * 2L
  adsl <- data.frame(
    usubjid = sprintf("IMM-%04d", seq_len(n)),
    arm = rep(c("Investigational", "Placebo"), each = n_per_arm),
    age = as.integer(.clip(round(stats::rnorm(n, 54, 11)), 22, 78)),
    sex = sample(c("F", "M"), n, TRUE, c(0.72, 0.28)),
    baseline_das28 = .clip(stats::rnorm(n, 5.6, 0.8), 3.2, 8),
    stringsAsFactors = FALSE
  )
  weeks <- c(0, 2, 4, 8, 12)
  adeff <- do.call(rbind, lapply(seq_len(n), function(i) {
    drop <- if (adsl$arm[i] == "Investigational") 1.8 else 0.7
    value <- adsl$baseline_das28[i] -
      drop * (weeks > 0) * (1 - exp(-weeks / 4)) +
      stats::rnorm(length(weeks), 0, 0.35)
    data.frame(
      usubjid = adsl$usubjid[i],
      arm = adsl$arm[i],
      week = weeks,
      das28 = .clip(value, 0.5, 9),
      stringsAsFactors = FALSE
    )
  }))
  adeff$chg <- ave(adeff$das28, adeff$usubjid, FUN = function(x) x - x[1])
  list(adsl = adsl, adeff = adeff)
  })
}

#' Simulate an antiviral log10 viral-load set.
#' @param n_per_arm Subjects per arm.
#' @param seed Random seed.
#' @return A list with `adsl` and `adlb`.
#' @export
simulate_infectious <- function(n_per_arm = 100, seed = 20260319) {
  withr::with_seed(seed, {
  n <- n_per_arm * 2L
  adsl <- data.frame(
    usubjid = sprintf("ID-%04d", seq_len(n)),
    arm = rep(c("Investigational", "Control"), each = n_per_arm),
    age = as.integer(.clip(round(stats::rnorm(n, 46, 12)), 18, 75)),
    sex = sample(c("F", "M"), n, TRUE),
    baseline_log10 = .clip(stats::rnorm(n, 6.2, 0.6), 4, 8),
    stringsAsFactors = FALSE
  )
  days <- c(1, 3, 7, 14, 28)
  adlb <- do.call(rbind, lapply(seq_len(n), function(i) {
    drop <- if (adsl$arm[i] == "Investigational") 2.4 else 1.1
    value <- adsl$baseline_log10[i] -
      drop * (days > 1) * (1 - exp(-(days - 1) / 6)) +
      stats::rnorm(length(days), 0, 0.3)
    data.frame(
      usubjid = adsl$usubjid[i],
      arm = adsl$arm[i],
      day = days,
      log10_vl = .clip(value, 1, 8.5),
      stringsAsFactors = FALSE
    )
  }))
  adlb$chg <- ave(adlb$log10_vl, adlb$usubjid, FUN = function(x) x - x[1])
  clear_day <- ifelse(adsl$arm == "Investigational", 16, 26)
  adsl$clear_days <- .exp_time(n, clear_day)
  adsl$clear_censor <- stats::runif(n, 21, 35)
  adsl$clear_event <- as.integer(adsl$clear_days <= adsl$clear_censor)
  adsl$clear_days <- pmin(adsl$clear_days, adsl$clear_censor)
  list(adsl = adsl, adlb = adlb)
  })
}

#' Simulate a depression MADRS set.
#' @param n_per_arm Subjects per arm.
#' @param seed Random seed.
#' @return A list with `adsl` and `adeff`.
#' @export
simulate_neuroscience <- function(n_per_arm = 140, seed = 20260320) {
  withr::with_seed(seed, {
  n <- n_per_arm * 2L
  adsl <- data.frame(
    usubjid = sprintf("CNS-%04d", seq_len(n)),
    arm = rep(c("Investigational", "Placebo"), each = n_per_arm),
    age = as.integer(.clip(round(stats::rnorm(n, 42, 12)), 18, 70)),
    sex = sample(c("F", "M"), n, TRUE, c(0.6, 0.4)),
    baseline_madrs = as.integer(.clip(round(stats::rnorm(n, 32, 4)), 24, 45)),
    stringsAsFactors = FALSE
  )
  weeks <- c(0, 1, 2, 4, 6, 8)
  adeff <- do.call(rbind, lapply(seq_len(n), function(i) {
    drop <- if (adsl$arm[i] == "Investigational") 12 else 7
    value <- adsl$baseline_madrs[i] -
      drop * (weeks > 0) * (1 - exp(-weeks / 2.5)) +
      stats::rnorm(length(weeks), 0, 2.2)
    data.frame(
      usubjid = adsl$usubjid[i],
      arm = adsl$arm[i],
      week = weeks,
      madrs = .clip(value, 0, 50),
      stringsAsFactors = FALSE
    )
  }))
  adeff$chg <- ave(adeff$madrs, adeff$usubjid, FUN = function(x) x - x[1])
  list(adsl = adsl, adeff = adeff)
  })
}

#' Simulate core safety data: adverse events and peak liver tests.
#'
#' Liver values are peak multiples of ULN, the inputs to an eDISH display
#' (FDA DILI guidance: reference lines at ALT 3x ULN and bilirubin 2x ULN).
#' @param n_per_arm Subjects per arm.
#' @param seed Random seed.
#' @return A list with `adsl`, `adae`, and `adlb`.
#' @export
simulate_safety <- function(n_per_arm = 160, seed = 20260321) {
  withr::with_seed(seed, {
  n <- n_per_arm * 2L
  adsl <- data.frame(
    usubjid = sprintf("SAF-%04d", seq_len(n)),
    arm = rep(c("Investigational", "Placebo"), each = n_per_arm),
    age = as.integer(.clip(round(stats::rnorm(n, 58, 11)), 20, 88)),
    sex = sample(c("F", "M"), n, TRUE),
    trtdur_days = as.integer(.clip(round(stats::rexp(n, 1 / 140) + 20), 7, 365)),
    stringsAsFactors = FALSE
  )
  adsl$trtdur_days[adsl$arm == "Investigational"] <- as.integer(
    .clip(adsl$trtdur_days[adsl$arm == "Investigational"] + 15, 7, 365)
  )
  terms <- data.frame(
    term = c(
      "Nausea", "Diarrhoea", "Fatigue", "Headache", "Rash",
      "Neutropenia", "ALT increased", "Nasopharyngitis", "Arthralgia"
    ),
    p_inv = c(0.28, 0.22, 0.24, 0.14, 0.12, 0.11, 0.09, 0.10, 0.08),
    p_pbo = c(0.10, 0.08, 0.16, 0.13, 0.04, 0.02, 0.03, 0.11, 0.07),
    stringsAsFactors = FALSE
  )
  adae <- do.call(rbind, lapply(seq_len(nrow(terms)), function(k) {
    p <- ifelse(adsl$arm == "Investigational", terms$p_inv[k], terms$p_pbo[k])
    hit <- stats::rbinom(n, 1, p) == 1
    if (!any(hit)) return(NULL)
    data.frame(
      usubjid = adsl$usubjid[hit],
      arm = adsl$arm[hit],
      term = terms$term[k],
      stringsAsFactors = FALSE
    )
  }))
  # Peak ALT and bilirubin in multiples of ULN. A few Hy's law quadrant points.
  alt <- exp(stats::rnorm(n, log(1.1), 0.45))
  bili <- exp(stats::rnorm(n, log(0.8), 0.35))
  alt[adsl$arm == "Investigational"] <- alt[adsl$arm == "Investigational"] * 1.25
  hys <- sample(which(adsl$arm == "Investigational"), 2)
  alt[hys] <- stats::runif(2, 4, 9)
  bili[hys] <- stats::runif(2, 2.2, 4.5)
  adlb <- data.frame(
    usubjid = adsl$usubjid,
    arm = adsl$arm,
    alt_xuln = alt,
    bili_xuln = bili,
    alt_base = exp(stats::rnorm(n, log(0.7), 0.25)),
    alt_max = alt,
    stringsAsFactors = FALSE
  )
  list(adsl = adsl, adae = adae, adlb = adlb)
  })
}
