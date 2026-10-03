# Contributor notes

- Keep simulated data inside `simulate_*`. Do not commit a real subject-level file.
- A new therapeutic area needs a simulator, a row in `ta_plot_catalog()`, and a script in `inst/examples/`.
- Do not drop the analysis population from captions.
- Run `source("inst/examples/run_all.R")` from the package root before a pull request.
