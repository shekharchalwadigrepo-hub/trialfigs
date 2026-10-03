# Build every therapeutic-area figure into inst/examples/figures/.
# Usage, from the package root:
#   source("inst/examples/run_all.R")
local({
  scripts <- c(
    "inst/examples/01_oncology.R",
    "inst/examples/02_cardiovascular.R",
    "inst/examples/03_endocrinology.R",
    "inst/examples/04_immunology.R",
    "inst/examples/05_infectious.R",
    "inst/examples/06_neuroscience.R",
    "inst/examples/07_safety.R"
  )
  for (s in scripts) {
    message("---- ", s)
    sys.source(s, envir = new.env(parent = globalenv()))
  }
  print(ta_plot_catalog())
})
