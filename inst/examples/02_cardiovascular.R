# Cardiovascular: time to first MACE, component-style forest, SBP change.
source("inst/examples/00_setup.R")

cv <- simulate_cardiovascular()
adsl <- cv$adsl

save_fig(
  plot_km(
    adsl, time = "mace_months", event = "mace_event", arm = "arm",
    title = "Time to first MACE",
    subtitle = "CV death, nonfatal MI, or nonfatal stroke",
    xlab = "Months", ylab = "Event-free probability",
    population = "Intent-to-treat. Kaplan-Meier ignores competing risks of non-CV death; say so if that rate is material."
  ),
  "02_cardiovascular_mace.png"
)

forest <- rbind(
  cox_hr(adsl, "mace_months", "mace_event", "arm", subgroup = "Overall"),
  cox_hr(adsl[adsl$sex == "F", ], "mace_months", "mace_event", "arm", subgroup = "Female"),
  cox_hr(adsl[adsl$sex == "M", ], "mace_months", "mace_event", "arm", subgroup = "Male"),
  cox_hr(adsl[adsl$prior_mi == "Yes", ], "mace_months", "mace_event", "arm", subgroup = "Prior MI"),
  cox_hr(adsl[adsl$prior_mi == "No", ], "mace_months", "mace_event", "arm", subgroup = "No prior MI"),
  cox_hr(adsl[adsl$age >= 65, ], "mace_months", "mace_event", "arm", subgroup = "Age >= 65"),
  cox_hr(adsl[adsl$age < 65, ], "mace_months", "mace_event", "arm", subgroup = "Age < 65")
)
save_fig(
  plot_forest(forest, n = "n", title = "MACE hazard ratio by subgroup"),
  "02_cardiovascular_forest.png"
)

save_fig(
  plot_change(
    cv$advs, visit = "week", change = "chg", arm = "arm",
    title = "Systolic blood pressure",
    ylab = "Mean change from baseline, mmHg (95% CI)"
  ),
  "02_cardiovascular_sbp.png"
)
