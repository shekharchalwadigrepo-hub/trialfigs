# Worked examples. Run from the package root:
#   source("inst/examples/run_all.R")
# Each script also runs on its own after library(trialfigs) or after sourcing.

save_fig <- function(plot, name) {
  dir.create("inst/examples/figures", showWarnings = FALSE, recursive = TRUE)
  ggplot2::ggsave(
    file.path("inst/examples/figures", name),
    plot, width = 7.2, height = 5.2, dpi = 160, bg = "white"
  )
  message("Wrote ", name)
}

if (!requireNamespace("trialfigs", quietly = TRUE) ||
    !("package:trialfigs" %in% search())) {
  # Allow the scripts to run from a source checkout before install.
  if (file.exists("R/theme.R")) {
    lapply(list.files("R", pattern = "\\.R$", full.names = TRUE), source)
  }
} else {
  library(trialfigs)
}
