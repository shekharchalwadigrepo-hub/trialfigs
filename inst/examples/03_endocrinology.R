# Endocrinology: HbA1c change and glycemic responder.
source("inst/examples/00_setup.R")

endo <- simulate_endocrinology()
wk24 <- endo$adlb[endo$adlb$week == 24, ]
wk24$at_goal <- wk24$hba1c < 7

save_fig(
  plot_change(
    endo$adlb, visit = "week", change = "chg", arm = "arm",
    title = "HbA1c",
    ylab = "Mean change from baseline, percent (95% CI)"
  ),
  "03_endocrinology_hba1c.png"
)

save_fig(
  plot_responder(
    wk24, responder = "at_goal", arm = "arm",
    title = "HbA1c below 7 percent at week 24"
  ),
  "03_endocrinology_responder.png"
)
