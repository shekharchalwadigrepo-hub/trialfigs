# Core safety displays used in every therapeutic area.

#' Adverse-event incidence dot plot.
#'
#' One row per preferred term. Points are the percent of subjects with the
#' event; bars are Wilson intervals. Terms are ordered by the risk difference
#' (investigational minus reference). This matches the PHUSE recommendation to
#' show incidence with uncertainty rather than a p-value parade.
#'
#' @param data One row per subject per event, or a pre-aggregated frame if
#'   `already_summarised = TRUE`.
#' @param term,arm Column names.
#' @param denom Subject-level data used as the denominator. Must contain `arm`
#'   and a subject id. If NULL, denominators are taken from unique ids in `data`,
#'   which undercounts subjects with no event.
#' @param id Subject id column in `data` and `denom`.
#' @param reference Arm treated as the control when ordering by risk difference.
#' @param title Plot title.
#' @return A ggplot object.
#' @export
plot_ae <- function(data,
                    term = "term",
                    arm = "arm",
                    denom = NULL,
                    id = "usubjid",
                    reference = "Placebo",
                    title = "Subjects with an adverse event") {
  .require_cols(data, c(term, arm, id))
  if (is.null(denom)) {
    warning("No denominator frame supplied; subjects with zero events are missing from the percent.", call. = FALSE)
    denom <- unique(data[, c(id, arm), drop = FALSE])
  }
  .require_cols(denom, c(id, arm))
  den_n <- as.data.frame(table(denom[[arm]]), stringsAsFactors = FALSE)
  names(den_n) <- c("arm", "n")
  ev <- unique(data[, c(id, arm, term), drop = FALSE])
  cnt <- as.data.frame(table(ev[[arm]], ev[[term]]), stringsAsFactors = FALSE)
  names(cnt) <- c("arm", "term", "x")
  cnt <- merge(cnt, den_n, by = "arm", all.x = TRUE)
  cnt$pct <- 100 * cnt$x / cnt$n
  z <- stats::qnorm(0.975)
  p <- cnt$x / cnt$n
  den <- 1 + z^2 / cnt$n
  center <- (p + z^2 / (2 * cnt$n)) / den
  half <- z * sqrt(p * (1 - p) / cnt$n + z^2 / (4 * cnt$n^2)) / den
  cnt$lcl <- 100 * pmax(0, center - half)
  cnt$ucl <- 100 * pmin(1, center + half)

  wide <- reshape(
    cnt[, c("arm", "term", "pct")],
    idvar = "term", timevar = "arm", direction = "wide"
  )
  ref_col <- paste0("pct.", reference)
  inv_col <- setdiff(grep("^pct\\.", names(wide), value = TRUE), ref_col)[1]
  if (!is.null(inv_col) && ref_col %in% names(wide)) {
    wide$rd <- wide[[inv_col]] - wide[[ref_col]]
    wide <- wide[order(wide$rd), , drop = FALSE]
    cnt$term <- factor(cnt$term, levels = wide$term)
  }
  pal <- .arm_palette(unique(as.character(cnt$arm)))
  ggplot2::ggplot(cnt, ggplot2::aes(pct, term, colour = arm)) +
    ggplot2::geom_segment(
      ggplot2::aes(x = lcl, xend = ucl, y = term, yend = term),
      position = ggplot2::position_dodge(width = 0.5)
    ) +
    ggplot2::geom_point(position = ggplot2::position_dodge(width = 0.5), size = 2.3) +
    ggplot2::scale_colour_manual(values = pal) +
    ggplot2::labs(
      title = title,
      subtitle = "Ordered by risk difference versus the reference arm",
      x = "Subjects, percent (Wilson 95% CI)", y = NULL, colour = NULL,
      caption = "Denominator is treated subjects in the supplied population, not subjects with an event."
    ) +
    fda_theme()
}

#' eDISH plot of peak ALT versus peak total bilirubin.
#'
#' Axes are multiples of the upper limit of normal on a log scale. Reference
#' lines are ALT = 3x ULN and total bilirubin = 2x ULN, the Hy's law quadrant
#' in the FDA drug-induced liver injury guidance. A point in that quadrant is
#' a case for narrative review, not by itself a Hy's law case: alkaline
#' phosphatase and an alternative cause still have to be assessed.
#'
#' @param data One row per subject, peak values.
#' @param alt,bili,arm Column names, values in multiples of ULN.
#' @param id Optional subject id, labelled for quadrant cases.
#' @param title Plot title.
#' @return A ggplot object.
#' @export
plot_edish <- function(data,
                       alt = "alt_xuln",
                       bili = "bili_xuln",
                       arm = "arm",
                       id = "usubjid",
                       title = "eDISH: peak ALT vs peak total bilirubin") {
  .require_cols(data, c(alt, bili, arm))
  df <- data
  df$.alt <- df[[alt]]
  df$.bili <- df[[bili]]
  df$.arm <- df[[arm]]
  df$quadrant <- df$.alt >= 3 & df$.bili >= 2
  pal <- .arm_palette(unique(as.character(df$.arm)))
  p <- ggplot2::ggplot(df, ggplot2::aes(.alt, .bili, colour = .arm)) +
    ggplot2::geom_vline(xintercept = 3, linetype = "dashed") +
    ggplot2::geom_hline(yintercept = 2, linetype = "dashed") +
    ggplot2::geom_point(size = 1.8, alpha = 0.75) +
    ggplot2::scale_x_log10() +
    ggplot2::scale_y_log10() +
    ggplot2::scale_colour_manual(values = pal) +
    ggplot2::annotate(
      "text", x = 6, y = 4.5, label = "Hy's law\nquadrant",
      size = 3, colour = "#922B21", hjust = 0
    ) +
    ggplot2::labs(
      title = title,
      subtitle = "Peak on treatment, multiples of ULN",
      x = "Peak ALT (x ULN)", y = "Peak total bilirubin (x ULN)", colour = NULL,
      caption = paste0(
        "Quadrant cases (ALT >= 3x and bilirubin >= 2x ULN): ",
        sum(df$quadrant),
        ". Confirm ALP and alternative etiology before calling Hy's law. FDA DILI guidance."
      )
    ) +
    fda_theme()
  if (!is.null(id) && id %in% names(df) && any(df$quadrant)) {
    lab <- df[df$quadrant, , drop = FALSE]
    p <- p + ggplot2::geom_text(
      data = lab,
      ggplot2::aes(label = lab[[id]]),
      nudge_x = 0.08, nudge_y = 0.08, size = 2.4, show.legend = FALSE
    )
  }
  p
}

#' Baseline versus post-baseline maximum laboratory value.
#'
#' Points above the identity line rose after baseline. A horizontal line at
#' the upper limit of normal marks the usual outlier threshold.
#'
#' @param data One row per subject.
#' @param baseline,post,arm Column names, same units.
#' @param uln Upper limit of normal in those units. Drawn if not NULL.
#' @param title,xlab,ylab Labels.
#' @return A ggplot object.
#' @export
plot_lab_shift <- function(data,
                           baseline = "alt_base",
                           post = "alt_max",
                           arm = "arm",
                           uln = NULL,
                           title = "Baseline vs post-baseline maximum",
                           xlab = "Baseline",
                           ylab = "Post-baseline maximum") {
  .require_cols(data, c(baseline, post, arm))
  df <- data
  df$.base <- df[[baseline]]
  df$.post <- df[[post]]
  df$.arm <- df[[arm]]
  lim <- max(c(df$.base, df$.post), na.rm = TRUE) * 1.05
  pal <- .arm_palette(unique(as.character(df$.arm)))
  p <- ggplot2::ggplot(df, ggplot2::aes(.base, .post, colour = .arm)) +
    ggplot2::geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
    ggplot2::geom_point(alpha = 0.7, size = 1.7) +
    ggplot2::scale_colour_manual(values = pal) +
    ggplot2::coord_cartesian(xlim = c(0, lim), ylim = c(0, lim)) +
    ggplot2::labs(
      title = title, x = xlab, y = ylab, colour = NULL,
      caption = "Points above the identity line increased after baseline."
    ) +
    fda_theme()
  if (!is.null(uln)) {
    p <- p + ggplot2::geom_hline(yintercept = uln, linewidth = 0.3)
  }
  p
}

#' Treatment duration by arm.
#'
#' @param data Subject-level data.
#' @param duration,arm Column names.
#' @param xlab,title Labels.
#' @return A ggplot object.
#' @export
plot_exposure <- function(data,
                          duration = "trtdur_days",
                          arm = "arm",
                          xlab = "Treatment duration (days)",
                          title = "Exposure") {
  .require_cols(data, c(duration, arm))
  df <- data
  df$.dur <- df[[duration]]
  df$.arm <- df[[arm]]
  pal <- .arm_palette(unique(as.character(df$.arm)))
  med <- aggregate(df$.dur, list(df$.arm), stats::median)
  ggplot2::ggplot(df, ggplot2::aes(.arm, .dur, fill = .arm)) +
    ggplot2::geom_boxplot(width = 0.55, outlier.shape = NA, alpha = 0.85) +
    ggplot2::geom_jitter(width = 0.12, alpha = 0.25, size = 1) +
    ggplot2::scale_fill_manual(values = pal) +
    ggplot2::labs(
      title = title, x = NULL, y = xlab, fill = NULL,
      caption = paste0(
        "Median days: ",
        paste(paste0(med[[1]], " ", round(med[[2]], 1)), collapse = "; "),
        "."
      )
    ) +
    fda_theme() +
    ggplot2::theme(legend.position = "none")
}
