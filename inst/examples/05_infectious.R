# Infectious disease: log10 viral load and time to clearance.
source("inst/examples/00_setup.R")

id <- simulate_infectious()

save_fig(
  plot_change(
    id$adlb, visit = "day", change = "chg", arm = "arm",
    title = "Log10 viral load",
    xlab = "Day",
    ylab = "Mean change from baseline, log10 (95% CI)"
  ),
  "05_infectious_viral_load.png"
)

save_fig(
  plot_km(
    id$adsl, time = "clear_days", event = "clear_event", arm = "arm",
    title = "Time to virologic clearance",
    xlab = "Days", ylab = "Clearance-free probability",
    population = "Virologic population. Clearance defined in the SAP."
  ),
  "05_infectious_clearance.png"
)
