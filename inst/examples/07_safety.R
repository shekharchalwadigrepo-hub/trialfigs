# Core safety, every therapeutic area: AE dot plot, eDISH, lab shift, exposure.
source("inst/examples/00_setup.R")

saf <- simulate_safety()

save_fig(
  plot_ae(
    saf$adae, denom = saf$adsl, reference = "Placebo",
    title = "Treatment-emergent adverse events, selected terms"
  ),
  "07_safety_ae.png"
)

save_fig(
  plot_edish(saf$adlb, title = "eDISH liver-safety plot"),
  "07_safety_edish.png"
)

save_fig(
  plot_lab_shift(
    saf$adlb, baseline = "alt_base", post = "alt_max", uln = 1,
    title = "ALT, baseline vs post-baseline maximum",
    xlab = "Baseline ALT (x ULN)", ylab = "Maximum ALT (x ULN)"
  ),
  "07_safety_alt_shift.png"
)

save_fig(
  plot_exposure(saf$adsl, title = "Treatment duration"),
  "07_safety_exposure.png"
)
