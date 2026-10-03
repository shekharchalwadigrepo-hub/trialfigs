# Efficacy displays used across therapeutic areas.

#' Kaplan-Meier curve with censoring ticks and number at risk.
#'
#' Suitable for overall survival, progression-free survival, MACE, and time
#' to virologic clearance. The caption carries the log-rank p-value and the
#' number at risk. Competing risks are not modelled; say so when death is a
#' competing event for a non-fatal endpoint.
#'
#' @param data Subject-level data.
#' @param time,event,arm Column names. `event` is 1 for the event and 0 for censoring.
#' @param xlab,ylab,title,subtitle Labels.
#' @param conf_int Draw pointwise confidence limits as dashed steps.
#' @param risk_times Times at which to print number at risk. Default is `pretty()`.
#' @param palette Named color vector. Defaults to [fda_palette()].
#' @param population Analysis-population note printed in the caption.
#' @return A ggplot object.
#' @export
plot_km <- function(data,
                    time,
                    event,
                    arm,
                    xlab = "Time (months)",
                    ylab = "Event-free probability",
                    title = "Kaplan-Meier estimate",
                    subtitle = NULL,
                    conf_int = TRUE,
                    risk_times = NULL,
                    palette = NULL,
                    population = "Intent-to-treat population") {
  .require_cols(data, c(time, event, arm))
  df <- data[, c(time, event, arm), drop = FALSE]
  names(df) <- c(".time", ".event", ".arm")
  df <- df[stats::complete.cases(df), , drop = FALSE]
  df$.arm <- factor(df$.arm)
  df$.event <- as.integer(df$.event)
  if (any(!df$.event %in% c(0L, 1L))) {
    stop("event must be coded 0 (censor) or 1 (event).", call. = FALSE)
  }

  fit <- survival::survfit(survival::Surv(.time, .event) ~ .arm, data = df)
  strata_lengths <- fit$strata
  if (is.null(strata_lengths)) {
    strata_lengths <- stats::setNames(length(fit$time), levels(df$.arm)[1])
  }
  arm_labels <- sub("^.arm=", "", names(strata_lengths))
  pieces <- vector("list", length(strata_lengths))
  idx <- 1L
  for (i in seq_along(strata_lengths)) {
    n_i <- strata_lengths[[i]]
    n_arm <- sum(df$.arm == arm_labels[i])
    if (n_i == 0L) {
      sl <- data.frame(.time = 0, surv = 1, lower = 1, upper = 1, n.censor = 0)
    } else {
      rows <- idx:(idx + n_i - 1L)
      sl <- data.frame(
        .time = c(0, fit$time[rows]),
        surv = c(1, fit$surv[rows]),
        lower = c(1, fit$lower[rows]),
        upper = c(1, fit$upper[rows]),
        n.censor = c(0, fit$n.censor[rows])
      )
    }
    sl$.arm <- arm_labels[i]
    sl$n_arm <- n_arm
    pieces[[i]] <- sl
    idx <- idx + n_i
  }
  curve <- do.call(rbind, pieces)
  curve$.arm <- factor(curve$.arm, levels = levels(df$.arm))

  sd <- survival::survdiff(survival::Surv(.time, .event) ~ .arm, data = df)
  pval <- stats::pchisq(sd$chisq, length(sd$n) - 1, lower.tail = FALSE)
  if (is.null(risk_times)) {
    tmax <- max(df$.time)
    risk_times <- pretty(c(0, tmax), n = 5)
    risk_times <- risk_times[risk_times <= tmax + 1e-8]
  }
  risk_lines <- vapply(levels(df$.arm), function(a) {
    sub <- df[df$.arm == a, , drop = FALSE]
    counts <- vapply(risk_times, function(t) sum(sub$.time >= t - 1e-8), integer(1))
    paste(counts, collapse = "   ")
  }, character(1))
  caption <- paste0(
    population, ". Log-rank p = ", .fmt_p(pval), ".\n",
    "Number at risk at ", paste(format(risk_times), collapse = ", "), ":\n",
    paste(paste0(levels(df$.arm), "  ", risk_lines), collapse = "\n")
  )
  pal <- .arm_palette(levels(df$.arm), palette)

  p <- ggplot2::ggplot(curve, ggplot2::aes(.time, surv, colour = .arm)) +
    ggplot2::geom_step(linewidth = 0.9, direction = "hv")
  if (isTRUE(conf_int)) {
    p <- p +
      ggplot2::geom_step(
        ggplot2::aes(y = lower), linetype = "dashed", linewidth = 0.35, alpha = 0.85
      ) +
      ggplot2::geom_step(
        ggplot2::aes(y = upper), linetype = "dashed", linewidth = 0.35, alpha = 0.85
      )
  }
  cens <- df[df$.event == 0, , drop = FALSE]
  if (nrow(cens)) {
    cens$surv <- vapply(seq_len(nrow(cens)), function(i) {
      sub <- curve[curve$.arm == cens$.arm[i] & curve$.time <= cens$.time[i] + 1e-8, , drop = FALSE]
      sub$surv[nrow(sub)]
    }, numeric(1))
    p <- p + ggplot2::geom_point(
      data = cens,
      ggplot2::aes(.time, surv, shape = "Censored"),
      size = 1.5, stroke = 0.6
    )
  }
  p +
    ggplot2::scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
    ggplot2::scale_colour_manual(values = pal) +
    ggplot2::scale_shape_manual(values = c(Censored = 3)) +
    ggplot2::labs(
      title = title, subtitle = subtitle, x = xlab, y = ylab,
      caption = caption, colour = NULL, shape = NULL
    ) +
    fda_theme()
}

#' RECIST 1.1 waterfall of best percent change in tumor burden.
#'
#' Reference lines at -30 percent (partial response threshold) and +20 percent
#' (progressive disease threshold) follow RECIST 1.1. Subjects with no
#' post-baseline assessment are omitted and counted in the caption.
#'
#' @param data Subject-level data with best percent change and response.
#' @param pct,response,arm Column names.
#' @param id Subject identifier column, used only for ordering labels if requested.
#' @param title,subtitle Labels.
#' @param palette Named colors for response categories.
#' @return A ggplot object.
#' @export
plot_waterfall <- function(data,
                           pct = "pct_change",
                           response = "bor",
                           arm = "arm",
                           id = "usubjid",
                           title = "Best percent change in sum of diameters",
                           subtitle = "RECIST 1.1 reference lines at -30% and +20%",
                           palette = NULL) {
  .require_cols(data, c(pct, response, arm))
  df <- data
  n_ne <- sum(is.na(df[[pct]]))
  df <- df[!is.na(df[[pct]]), , drop = FALSE]
  df <- df[order(df[[pct]], decreasing = FALSE), , drop = FALSE]
  df$.x <- seq_len(nrow(df))
  df$.pct <- df[[pct]]
  df$.response <- factor(df[[response]], levels = c("CR", "PR", "SD", "PD", "NE"))
  pal <- if (is.null(palette)) fda_palette() else palette
  ggplot2::ggplot(df, ggplot2::aes(.x, .pct, fill = .response)) +
    ggplot2::geom_col(width = 0.85) +
    ggplot2::geom_hline(yintercept = c(-30, 20), linetype = "dashed", linewidth = 0.4) +
    ggplot2::scale_fill_manual(values = pal, drop = FALSE) +
    ggplot2::scale_x_continuous(expand = c(0.01, 0.01)) +
    ggplot2::labs(
      title = title,
      subtitle = subtitle,
      x = "Subjects ordered by best percent change",
      y = "Best percent change from baseline",
      fill = NULL,
      caption = paste0(
        "Evaluable n = ", nrow(df),
        ". Not evaluable or no post-baseline scan: ", n_ne,
        ". Dashed lines: RECIST 1.1 PR (-30%) and PD (+20%) thresholds."
      )
    ) +
    fda_theme()
}

#' Swimmer plot of time on treatment.
#'
#' Each bar is one subject. Points mark objective response and progression
#' when those columns are present. Limited to `max_n` subjects so the figure
#' stays readable in a briefing book; state the selection rule in the caption.
#'
#' @param data Subject-level data.
#' @param id,arm,duration Column names. Duration is on the x-axis scale.
#' @param response_time,progression_time Optional column names.
#' @param max_n Maximum subjects, taken as the longest durations.
#' @param xlab,title Labels.
#' @return A ggplot object.
#' @export
plot_swimmer <- function(data,
                         id = "usubjid",
                         arm = "arm",
                         duration = "trtdur_months",
                         response_time = "resp_months",
                         progression_time = "pd_months",
                         max_n = 30,
                         xlab = "Months",
                         title = "Time on treatment") {
  .require_cols(data, c(id, arm, duration))
  df <- data[order(data[[duration]], decreasing = TRUE), , drop = FALSE]
  df <- utils::head(df, max_n)
  df$.id <- factor(df[[id]], levels = rev(df[[id]]))
  df$.dur <- df[[duration]]
  df$.arm <- df[[arm]]
  pal <- .arm_palette(unique(as.character(df$.arm)))
  p <- ggplot2::ggplot(df, ggplot2::aes(y = .id, colour = .arm)) +
    ggplot2::geom_segment(
      ggplot2::aes(x = 0, xend = .dur, yend = .id),
      linewidth = 1.8, lineend = "butt"
    )
  if (!is.null(response_time) && response_time %in% names(df)) {
    resp <- df[!is.na(df[[response_time]]), , drop = FALSE]
    if (nrow(resp)) {
      resp$.rx <- resp[[response_time]]
      p <- p + ggplot2::geom_point(
        data = resp,
        ggplot2::aes(x = .rx, y = .id, shape = "Objective response"),
        size = 2.2, colour = "black"
      )
    }
  }
  if (!is.null(progression_time) && progression_time %in% names(df)) {
    pd <- df[!is.na(df[[progression_time]]), , drop = FALSE]
    if (nrow(pd)) {
      pd$.px <- pd[[progression_time]]
      p <- p + ggplot2::geom_point(
        data = pd,
        ggplot2::aes(x = .px, y = .id, shape = "Progression"),
        size = 2.2, colour = "black"
      )
    }
  }
  p +
    ggplot2::scale_colour_manual(values = pal) +
    ggplot2::scale_shape_manual(values = c(`Objective response` = 16, Progression = 4)) +
    ggplot2::labs(
      title = title,
      subtitle = paste0("Longest ", nrow(df), " treatment durations shown"),
      x = xlab, y = NULL, colour = NULL, shape = NULL,
      caption = "Selection is by duration for display, not a responder analysis."
    ) +
    fda_theme() +
    ggplot2::theme(axis.text.y = ggplot2::element_text(size = 7))
}

#' Spider plot of percent change in tumor burden over time.
#'
#' Individual lines are faint; the arm mean is overlaid. This is a descriptive
#' display, not a model of tumor growth.
#'
#' @param data Longitudinal data, one row per subject per visit.
#' @param id,time,pct,arm Column names.
#' @param title Plot title.
#' @return A ggplot object.
#' @export
plot_spider <- function(data,
                        id = "usubjid",
                        time = "week",
                        pct = "pct_change",
                        arm = "arm",
                        title = "Percent change in sum of diameters") {
  .require_cols(data, c(id, time, pct, arm))
  df <- data[stats::complete.cases(data[, c(id, time, pct, arm)]), , drop = FALSE]
  df$.time <- df[[time]]
  df$.pct <- df[[pct]]
  df$.id <- df[[id]]
  df$.arm <- df[[arm]]
  means <- aggregate(df$.pct, by = list(arm = df$.arm, time = df$.time), FUN = mean)
  names(means)[3] <- "pct"
  pal <- .arm_palette(unique(as.character(df$.arm)))
  ggplot2::ggplot() +
    ggplot2::geom_hline(yintercept = c(-30, 20), linetype = "dashed", linewidth = 0.3) +
    ggplot2::geom_line(
      data = df,
      ggplot2::aes(.time, .pct, group = .id, colour = .arm),
      alpha = 0.25, linewidth = 0.4
    ) +
    ggplot2::geom_line(
      data = means,
      ggplot2::aes(time, pct, colour = arm),
      linewidth = 1.2
    ) +
    ggplot2::scale_colour_manual(values = pal) +
    ggplot2::labs(
      title = title,
      subtitle = "Faint lines are subjects; heavy lines are arm means",
      x = "Week", y = "Percent change from baseline", colour = NULL,
      caption = "Dashed lines: RECIST 1.1 -30% and +20%. Means are descriptive."
    ) +
    fda_theme()
}

#' Forest plot of a ratio or a difference.
#'
#' Use `null = 1` for hazard ratios and odds ratios, and `null = 0` for mean
#' differences. Intervals that cross the null are drawn in grey.
#'
#' @param data One row per subgroup or endpoint.
#' @param label,estimate,lcl,ucl Column names.
#' @param n Optional column of sample size printed on the right.
#' @param null Null value drawn as a vertical line.
#' @param xlab,title,subtitle Labels.
#' @param favour_left,favour_right Optional axis annotations.
#' @return A ggplot object.
#' @export
plot_forest <- function(data,
                        label = "subgroup",
                        estimate = "estimate",
                        lcl = "lcl",
                        ucl = "ucl",
                        n = NULL,
                        null = 1,
                        xlab = "Hazard ratio (95% CI)",
                        title = "Subgroup forest plot",
                        subtitle = NULL,
                        favour_left = "Favours investigational",
                        favour_right = "Favours control") {
  .require_cols(data, c(label, estimate, lcl, ucl))
  df <- data
  df$.label <- factor(df[[label]], levels = rev(unique(df[[label]])))
  df$.est <- df[[estimate]]
  df$.lcl <- df[[lcl]]
  df$.ucl <- df[[ucl]]
  df$.cross <- df$.lcl < null & df$.ucl > null
  right <- max(df$.ucl, na.rm = TRUE)
  p <- ggplot2::ggplot(df, ggplot2::aes(y = .label)) +
    ggplot2::geom_vline(xintercept = null, linetype = "dashed") +
    ggplot2::geom_segment(ggplot2::aes(x = .lcl, xend = .ucl, yend = .label, colour = .cross)) +
    ggplot2::geom_point(ggplot2::aes(x = .est, colour = .cross), size = 2.4) +
    ggplot2::scale_colour_manual(
      values = c(`TRUE` = "grey45", `FALSE` = "#1B4F72"),
      guide = "none"
    ) +
    ggplot2::labs(
      title = title, subtitle = subtitle, x = xlab, y = NULL,
      caption = paste(
        favour_left, "to the left of the null;", favour_right, "to the right.",
        "Grey intervals cross the null."
      )
    ) +
    fda_theme()
  if (!is.null(n) && n %in% names(df)) {
    df$.nlab <- paste0("n=", df[[n]])
    p <- p + ggplot2::geom_text(
      data = df,
      ggplot2::aes(x = right * 1.08, y = .label, label = .nlab),
      hjust = 0, size = 3, colour = "grey20"
    ) +
      ggplot2::coord_cartesian(clip = "off") +
      ggplot2::theme(plot.margin = ggplot2::margin(8, 48, 8, 8))
  }
  p
}

#' Mean change from baseline with a 95 percent confidence interval.
#'
#' The interval is the normal approximation to the standard error of the mean
#' at each visit. Replace with model-based LS means when the SAP specifies MMRM.
#'
#' @param data Longitudinal data.
#' @param visit,change,arm Column names.
#' @param title,xlab,ylab Labels.
#' @return A ggplot object.
#' @export
plot_change <- function(data,
                        visit = "week",
                        change = "chg",
                        arm = "arm",
                        title = "Mean change from baseline",
                        xlab = "Week",
                        ylab = "Mean change (95% CI)") {
  .require_cols(data, c(visit, change, arm))
  df <- data[stats::complete.cases(data[, c(visit, change, arm)]), , drop = FALSE]
  se <- function(x) stats::sd(x) / sqrt(length(x))
  sm <- aggregate(df[[change]], by = list(visit = df[[visit]], arm = df[[arm]]), FUN = mean)
  names(sm)[3] <- "mean"
  ss <- aggregate(df[[change]], by = list(visit = df[[visit]], arm = df[[arm]]), FUN = se)
  nn <- aggregate(df[[change]], by = list(visit = df[[visit]], arm = df[[arm]]), FUN = length)
  sm$se <- ss[[3]]
  sm$n <- nn[[3]]
  z <- stats::qnorm(0.975)
  sm$lcl <- sm$mean - z * sm$se
  sm$ucl <- sm$mean + z * sm$se
  pal <- .arm_palette(unique(as.character(sm$arm)))
  ggplot2::ggplot(sm, ggplot2::aes(visit, mean, colour = arm, group = arm)) +
    ggplot2::geom_hline(yintercept = 0, linewidth = 0.3) +
    ggplot2::geom_ribbon(
      ggplot2::aes(ymin = lcl, ymax = ucl, fill = arm),
      alpha = 0.15, colour = NA
    ) +
    ggplot2::geom_line(linewidth = 0.8) +
    ggplot2::geom_point(size = 2) +
    ggplot2::scale_colour_manual(values = pal) +
    ggplot2::scale_fill_manual(values = pal) +
    ggplot2::labs(
      title = title, x = xlab, y = ylab, colour = NULL, fill = NULL,
      caption = "Interval is mean +/- 1.96 SE. Use the SAP model (often MMRM) for the primary contrast."
    ) +
    fda_theme()
}

#' Binary responder rate with a Wilson score interval.
#'
#' @param data Subject-level data.
#' @param responder Logical or 0/1 column.
#' @param arm Arm column.
#' @param title,ylab Labels.
#' @return A ggplot object.
#' @export
plot_responder <- function(data,
                           responder,
                           arm,
                           title = "Responder rate",
                           ylab = "Responders, percent (Wilson 95% CI)") {
  .require_cols(data, c(responder, arm))
  df <- data[stats::complete.cases(data[, c(responder, arm)]), , drop = FALSE]
  df$.y <- as.integer(df[[responder]])
  arms <- unique(df[[arm]])
  out <- lapply(arms, function(a) {
    sub <- df[df[[arm]] == a, , drop = FALSE]
    x <- sum(sub$.y)
    n <- nrow(sub)
    p <- x / n
    z <- stats::qnorm(0.975)
    den <- 1 + z^2 / n
    center <- (p + z^2 / (2 * n)) / den
    half <- z * sqrt(p * (1 - p) / n + z^2 / (4 * n^2)) / den
    data.frame(
      arm = a, n = n, x = x, pct = 100 * p,
      lcl = 100 * max(0, center - half),
      ucl = 100 * min(1, center + half),
      stringsAsFactors = FALSE
    )
  })
  sm <- do.call(rbind, out)
  pal <- .arm_palette(as.character(sm$arm))
  ggplot2::ggplot(sm, ggplot2::aes(arm, pct, fill = arm)) +
    ggplot2::geom_col(width = 0.65) +
    ggplot2::geom_errorbar(ggplot2::aes(ymin = lcl, ymax = ucl), width = 0.15) +
    ggplot2::geom_text(ggplot2::aes(label = sprintf("%.1f%%\n(%d/%d)", pct, x, n)), vjust = -0.3, size = 3.2) +
    ggplot2::scale_fill_manual(values = pal) +
    ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = c(0, 0.18)), limits = c(0, NA)) +
    ggplot2::labs(
      title = title, x = NULL, y = ylab, fill = NULL,
      caption = "Wilson score interval. Define response in the SAP before unblinding."
    ) +
    fda_theme() +
    ggplot2::theme(legend.position = "none")
}

#' Cox hazard ratio with the investigational arm in the numerator.
#'
#' The reference level is every arm other than `investigational`, so a ratio
#' below 1 favours the investigational arm. One row is returned.
#' @param data Subject-level data.
#' @param time,event,arm Column names.
#' @param investigational Level of `arm` treated as the experimental arm.
#' @param subgroup Label stored in the result, for binding rows into a forest.
#' @return A one-row data frame with `subgroup`, `estimate`, `lcl`, `ucl`, `n`.
#' @export
cox_hr <- function(data,
                   time,
                   event,
                   arm,
                   investigational = "Investigational",
                   subgroup = "Overall") {
  .require_cols(data, c(time, event, arm))
  df <- data[stats::complete.cases(data[, c(time, event, arm)]), , drop = FALSE]
  ref <- setdiff(unique(as.character(df[[arm]])), investigational)
  df$.time <- df[[time]]
  df$.event <- df[[event]]
  df$.arm <- stats::relevel(factor(df[[arm]]), ref = ref[1])
  fit <- survival::coxph(survival::Surv(.time, .event) ~ .arm, data = df)
  ci <- summary(fit)$conf.int
  data.frame(
    subgroup = subgroup,
    estimate = unname(ci[1, 1]),
    lcl = unname(ci[1, 3]),
    ucl = unname(ci[1, 4]),
    n = nrow(df),
    stringsAsFactors = FALSE
  )
}

