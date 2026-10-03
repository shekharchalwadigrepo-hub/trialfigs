# Immunology: DAS28 change and a binary improvement responder.
source("inst/examples/00_setup.R")

imm <- simulate_immunology()
wk12 <- imm$adeff[imm$adeff$week == 12, ]
base <- imm$adeff[imm$adeff$week == 0, c("usubjid", "das28")]
names(base)[2] <- "base_das"
wk12 <- merge(wk12, base, by = "usubjid")
wk12$responder <- (wk12$base_das - wk12$das28) >= 1.2

save_fig(
  plot_change(
    imm$adeff, visit = "week", change = "chg", arm = "arm",
    title = "DAS28",
    ylab = "Mean change from baseline (95% CI)"
  ),
  "04_immunology_das28.png"
)

save_fig(
  plot_responder(
    wk12, responder = "responder", arm = "arm",
    title = "DAS28 improvement of at least 1.2 at week 12"
  ),
  "04_immunology_responder.png"
)
