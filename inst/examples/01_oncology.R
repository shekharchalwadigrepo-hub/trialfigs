# Oncology: OS, PFS, RECIST waterfall, swimmer, spider, subgroup forest.
# Mirrors the figures FDA oncology reviews routinely discuss.
source("inst/examples/00_setup.R")

onc <- simulate_oncology(n_per_arm = 80)
adsl <- onc$adsl

save_fig(
  plot_km(
    adsl, time = "os_months", event = "os_event", arm = "arm",
    title = "Overall survival",
    subtitle = "Simulated two-arm oncology study",
    xlab = "Months", ylab = "Overall survival"
  ),
  "01_oncology_os.png"
)

save_fig(
  plot_km(
    adsl, time = "pfs_months", event = "pfs_event", arm = "arm",
    title = "Progression-free survival",
    xlab = "Months", ylab = "Progression-free survival",
    population = "Intent-to-treat population. Progression by investigator, RECIST 1.1."
  ),
  "01_oncology_pfs.png"
)

save_fig(
  plot_waterfall(adsl, title = "Best percent change in sum of target lesions"),
  "01_oncology_waterfall.png"
)

save_fig(
  plot_swimmer(adsl, max_n = 24, title = "Time on treatment, response, and progression"),
  "01_oncology_swimmer.png"
)

save_fig(
  plot_spider(onc$adtr, title = "Tumor burden over time"),
  "01_oncology_spider.png"
)

forest <- rbind(
  cox_hr(adsl, "os_months", "os_event", "arm", subgroup = "Overall"),
  cox_hr(adsl[adsl$sex == "F", ], "os_months", "os_event", "arm", subgroup = "Female"),
  cox_hr(adsl[adsl$sex == "M", ], "os_months", "os_event", "arm", subgroup = "Male"),
  cox_hr(adsl[adsl$ecog == "0", ], "os_months", "os_event", "arm", subgroup = "ECOG 0"),
  cox_hr(adsl[adsl$ecog == "1", ], "os_months", "os_event", "arm", subgroup = "ECOG 1")
)
save_fig(
  plot_forest(
    forest, n = "n",
    title = "Overall survival by prespecified subgroup",
    subtitle = "Hazard ratio below 1 favours investigational"
  ),
  "01_oncology_forest.png"
)

adsl$responder <- adsl$bor %in% c("CR", "PR")
save_fig(
  plot_responder(adsl, responder = "responder", arm = "arm", title = "Objective response rate"),
  "01_oncology_orr.png"
)
