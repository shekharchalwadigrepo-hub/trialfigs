# Palette, theme, and the therapeutic-area display catalog.

#' Colorblind-safer palette used across submission-style figures.
#'
#' Names cover treatment arms and RECIST best overall response. Unknown
#' levels fall back to a dark qualitative palette inside the plot functions.
#' @export
fda_palette <- function() {
  c(
    Investigational = "#1B4F72",
    Control = "#B9770E",
    Placebo = "#5D6D7E",
    `Standard of care` = "#1A5276",
    CR = "#196F3D",
    PR = "#1A5276",
    SD = "#B7950B",
    PD = "#922B21",
    NE = "#7F8C8D",
    Responder = "#196F3D",
    `Non-responder` = "#7F8C8D"
  )
}

#' Classic theme for regulatory figures.
#'
#' White background, no legend title, caption left-aligned so number-at-risk
#' and analysis-population notes remain readable in a briefing book.
#' @param base_size Base font size in points.
#' @export
fda_theme <- function(base_size = 11) {
  ggplot2::theme_classic(base_size = base_size) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", size = base_size + 1),
      plot.subtitle = ggplot2::element_text(colour = "grey30", size = base_size - 1),
      plot.caption = ggplot2::element_text(
        colour = "grey35", size = base_size - 2, hjust = 0, lineheight = 1.05
      ),
      axis.title = ggplot2::element_text(face = "bold"),
      legend.position = "bottom",
      legend.title = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_line(colour = "grey92", linewidth = 0.3),
      plot.margin = ggplot2::margin(8, 14, 8, 8)
    )
}

#' Recommended displays by therapeutic area for an FDA-style package.
#'
#' This is a working catalog, not an FDA requirement. Pair each row with the
#' estimator and analysis population named in the statistical analysis plan.
#' @export
ta_plot_catalog <- function() {
  data.frame(
    therapeutic_area = c(
      "Oncology", "Oncology", "Oncology", "Oncology", "Oncology",
      "Cardiovascular", "Cardiovascular", "Cardiovascular",
      "Endocrinology", "Endocrinology", "Endocrinology",
      "Immunology", "Immunology",
      "Infectious disease", "Infectious disease",
      "Neuroscience", "Neuroscience",
      "Safety, all areas", "Safety, all areas", "Safety, all areas", "Safety, all areas"
    ),
    display = c(
      "Kaplan-Meier of OS and PFS with number at risk and censoring ticks",
      "Waterfall of best percent change in sum of diameters (RECIST 1.1)",
      "Swimmer plot of time on treatment with response and progression",
      "Spider plot of percent change from baseline over time",
      "Forest plot of hazard ratios by prespecified subgroup",
      "Kaplan-Meier of time to first MACE (note competing risk if relevant)",
      "Forest plot of hazard ratios (primary and components)",
      "Mean change in SBP or LDL-C with 95 percent CI",
      "Mean change in HbA1c with 95 percent CI",
      "Responder rate (for example HbA1c < 7 percent) with Wilson CI",
      "Forest plot of mean difference by subgroup",
      "Mean change in disease score (DAS28, PASI, CDAI)",
      "Binary responder rate (ACR20, PASI75) with CI",
      "Mean change in log10 viral load",
      "Kaplan-Meier of time to virologic clearance",
      "Mean change in symptom score (MADRS, ADAS-Cog, UPDRS)",
      "Responder rate at the prespecified landmark",
      "Adverse-event incidence dot plot with CI, sorted by risk difference",
      "eDISH: peak ALT x ULN vs peak total bilirubin x ULN",
      "Laboratory shift: baseline vs post-baseline maximum",
      "Exposure: treatment duration by arm"
    ),
    function_name = c(
      "plot_km", "plot_waterfall", "plot_swimmer", "plot_spider", "plot_forest",
      "plot_km", "plot_forest", "plot_change",
      "plot_change", "plot_responder", "plot_forest",
      "plot_change", "plot_responder",
      "plot_change", "plot_km",
      "plot_change", "plot_responder",
      "plot_ae", "plot_edish", "plot_lab_shift", "plot_exposure"
    ),
    anchor = c(
      "ICH E3 efficacy; oncology review practice",
      "RECIST 1.1 thresholds -30 percent and +20 percent",
      "Subject-level oncology review",
      "Subject-level oncology review",
      "Subgroup consistency, forest display",
      "Time-to-first-event; state competing-risk limitation",
      "Component and subgroup consistency",
      "Continuous endpoint, LS-mean or raw mean as prespecified",
      "Diabetes briefing practice",
      "Binary responder with interval, not a p-value alone",
      "Subgroup consistency",
      "Continuous clinical score",
      "Binary responder",
      "Virologic mean change",
      "Time to event",
      "Continuous clinical score",
      "Binary responder",
      "PHUSE adverse-event display recommendations",
      "FDA DILI guidance; Hy's law quadrant ALT>=3x and TBILI>=2x ULN",
      "Hepatotoxicity and lab outlier review",
      "Exposure adequacy for safety interpretation"
    ),
    stringsAsFactors = FALSE
  )
}

.arm_palette <- function(levels, palette = NULL) {
  pal <- if (is.null(palette)) fda_palette() else palette
  missing <- setdiff(levels, names(pal))
  if (length(missing)) {
    extra <- grDevices::hcl.colors(length(missing), "Dark 2")
    names(extra) <- missing
    pal <- c(pal, extra)
  }
  pal[levels]
}

.require_cols <- function(data, cols) {
  miss <- setdiff(cols, names(data))
  if (length(miss)) {
    stop("Missing columns: ", paste(miss, collapse = ", "), call. = FALSE)
  }
  invisible(data)
}

.fmt_p <- function(p) {
  if (is.na(p)) return("NA")
  if (p < 0.001) return("<0.001")
  formatC(p, format = "f", digits = 3)
}
