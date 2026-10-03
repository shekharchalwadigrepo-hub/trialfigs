# trialfigs

Efficacy and safety graphics for a clinical review package, organised by therapeutic area.

This is an independent R package. It is not an FDA product and not a guarantee that a figure will be accepted. Reference lines follow RECIST 1.1 and the FDA drug-induced liver injury guidance. Data from the simulators are synthetic.

Suggested GitHub repository name: **`trialfigs`**.
R package name: **`trialfigs`**.

## Install

```r
# Once the repository exists:
install.packages("remotes")
remotes::install_github("YOURUSER/trialfigs")
library(trialfigs)
```

From a local checkout:

```r
install.packages(c("ggplot2", "survival"))
install.packages(".", repos = NULL, type = "source")
```

## What to plot, by therapeutic area

`ta_plot_catalog()` returns this map. The function column is what the example scripts call.

| Therapeutic area | Display reviewers expect | Function |
| --- | --- | --- |
| Oncology | Kaplan–Meier of overall survival and progression-free survival, with censoring ticks and number at risk | `plot_km` |
| Oncology | Waterfall of best percent change in sum of diameters. Dashed lines at −30% and +20% (RECIST 1.1) | `plot_waterfall` |
| Oncology | Swimmer plot: time on treatment, objective response, progression | `plot_swimmer` |
| Oncology | Spider plot: individual tumor trajectories plus the arm mean | `plot_spider` |
| Oncology | Objective response rate with a Wilson interval | `plot_responder` |
| Oncology | Forest of hazard ratios by prespecified subgroup | `plot_forest`, `cox_hr` |
| Cardiovascular | Kaplan–Meier of time to first MACE. State the competing-risk limitation if non-CV death is common | `plot_km` |
| Cardiovascular | Forest of hazard ratios, overall and by subgroup | `plot_forest` |
| Cardiovascular | Mean change in SBP or LDL-C with a 95% interval | `plot_change` |
| Endocrinology | Mean change in HbA1c | `plot_change` |
| Endocrinology | Responder rate, for example HbA1c < 7% at the landmark visit | `plot_responder` |
| Immunology | Mean change in DAS28, PASI, or CDAI | `plot_change` |
| Immunology | Binary responder (ACR20, PASI75, DAS28 improvement) | `plot_responder` |
| Infectious disease | Mean change in log10 viral load | `plot_change` |
| Infectious disease | Time to virologic clearance | `plot_km` |
| Neuroscience | Mean change in MADRS, ADAS-Cog, or UPDRS | `plot_change` |
| Neuroscience | Landmark responder, for example 50% MADRS reduction | `plot_responder` |
| Safety, all areas | Adverse-event incidence dot plot with Wilson intervals, ordered by risk difference | `plot_ae` |
| Safety, all areas | eDISH: peak ALT × ULN vs peak total bilirubin × ULN. Quadrant is ALT ≥ 3× and bilirubin ≥ 2× | `plot_edish` |
| Safety, all areas | Baseline vs post-baseline maximum laboratory value | `plot_lab_shift` |
| Safety, all areas | Exposure: treatment duration by arm | `plot_exposure` |

Primary contrasts in a real submission should come from the model named in the SAP (Cox, MMRM, negative binomial). The intervals in `plot_change` are mean ± 1.96 SE, labelled as such, so they are not silently substituted for an MMRM LS-mean.

## Real example

Data below are simulated. Do not describe them as trial results.

```r
library(trialfigs)

onc <- simulate_oncology(n_per_arm = 80)

plot_km(
  onc$adsl,
  time = "os_months", event = "os_event", arm = "arm",
  title = "Overall survival",
  xlab = "Months", ylab = "Overall survival"
)

plot_waterfall(onc$adsl)
plot_swimmer(onc$adsl, max_n = 24)
plot_spider(onc$adtr)

forest <- rbind(
  cox_hr(onc$adsl, "os_months", "os_event", "arm", subgroup = "Overall"),
  cox_hr(onc$adsl[onc$adsl$sex == "F", ], "os_months", "os_event", "arm", subgroup = "Female"),
  cox_hr(onc$adsl[onc$adsl$sex == "M", ], "os_months", "os_event", "arm", subgroup = "Male")
)
plot_forest(forest, n = "n", title = "Overall survival by subgroup")

saf <- simulate_safety()
plot_ae(saf$adae, denom = saf$adsl, reference = "Placebo")
plot_edish(saf$adlb)
plot_exposure(saf$adsl)
```

Build the full gallery from the package root:

```r
source("inst/examples/run_all.R")
# PNGs land in inst/examples/figures/
```

| Script | Area | Figures |
| --- | --- | --- |
| `inst/examples/01_oncology.R` | Oncology | OS, PFS, waterfall, swimmer, spider, forest, ORR |
| `inst/examples/02_cardiovascular.R` | Cardiovascular | MACE, subgroup forest, SBP change |
| `inst/examples/03_endocrinology.R` | Endocrinology | HbA1c change, HbA1c < 7% |
| `inst/examples/04_immunology.R` | Immunology | DAS28 change, DAS28 responder |
| `inst/examples/05_infectious.R` | Infectious disease | Viral-load change, time to clearance |
| `inst/examples/06_neuroscience.R` | Neuroscience | MADRS change, 50% responder |
| `inst/examples/07_safety.R` | Safety, all areas | AE dot plot, eDISH, ALT shift, exposure |

## Repository layout

```
trialfigs/
  DESCRIPTION              package metadata
  NAMESPACE                exports
  LICENSE                  MIT
  README.md
  NEWS.md
  trialfigs.Rproj
  .Rbuildignore
  .gitignore
  .github/workflows/R-CMD-check.yaml
  R/theme.R                palette, theme, catalog
  R/simulate.R             one simulator per therapeutic area
  R/plots_efficacy.R       KM, waterfall, swimmer, spider, forest, change, responder
  R/plots_safety.R         AE, eDISH, lab shift, exposure
  man/trialfigs-package.Rd
  inst/examples/           runnable review-style scripts
```

## Put it on GitHub

```bash
cd trialfigs
git init
git add .
git commit -m "Initial trialfigs package"
gh repo create trialfigs --public --source=. --remote=origin --push
```

Replace `YOURUSER` in `DESCRIPTION` and in the install snippet above.

## Conventions worth keeping

- Population in the caption (ITT, safety, virologic), not only in a footnote nobody reads.
- Number at risk on every Kaplan–Meier. Censoring ticks on.
- RECIST lines only on tumor-burden plots, and only if the endpoint is RECIST.
- eDISH quadrant cases get a narrative. Alkaline phosphatase and an alternative cause still have to be checked before anyone writes “Hy’s law”.
- Subgroup forests are descriptive unless the subgroup was prespecified and the multiplicity plan says otherwise.
- Do not invent a p-value the SAP did not specify.

## References the figures follow

- Eisenhauer EA et al. New response evaluation criteria in solid tumours: revised RECIST guideline (version 1.1). Eur J Cancer. 2009.
- FDA. Guidance for Industry. Drug-Induced Liver Injury: Premarketing Clinical Evaluation. 2009. eDISH and Hy’s law quadrant.
- PHUSE. Analysis and Displays Associated with Adverse Events, and the safety-topics white papers.
- ICH E3. Structure and Content of Clinical Study Reports.
