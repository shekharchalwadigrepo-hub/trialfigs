# Neuroscience: MADRS change and a 50 percent responder.
source("inst/examples/00_setup.R")

cns <- simulate_neuroscience()
wk8 <- cns$adeff[cns$adeff$week == 8, ]
base <- cns$adeff[cns$adeff$week == 0, c("usubjid", "madrs")]
names(base)[2] <- "base_madrs"
wk8 <- merge(wk8, base, by = "usubjid")
wk8$responder <- wk8$madrs <= 0.5 * wk8$base_madrs

save_fig(
  plot_change(
    cns$adeff, visit = "week", change = "chg", arm = "arm",
    title = "MADRS total score",
    ylab = "Mean change from baseline (95% CI)"
  ),
  "06_neuroscience_madrs.png"
)

save_fig(
  plot_responder(
    wk8, responder = "responder", arm = "arm",
    title = "At least 50 percent MADRS reduction at week 8"
  ),
  "06_neuroscience_responder.png"
)
