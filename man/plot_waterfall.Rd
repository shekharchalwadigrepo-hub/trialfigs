\name{plot_waterfall}
\alias{plot_waterfall}
\title{RECIST waterfall of best percent change}
\description{
Bars of best percent change in the sum of diameters. Reference lines at
-30 and +20 follow RECIST 1.1. Subjects with no post-baseline value are omitted.
}
\usage{
plot_waterfall(data, pct = "pct_change", response = "bor", arm = "arm",
  id = "usubjid", title = "Best percent change in sum of diameters",
  subtitle = "RECIST 1.1 reference lines at -30\% and +20\%",
  palette = NULL)
}
\arguments{
\item{data}{Subject-level data.}
\item{pct,response,arm,id}{Column names.}
\item{title,subtitle}{Labels.}
\item{palette}{Named colors for response categories.}
}
\value{A ggplot object.}
\examples{
onc <- simulate_oncology(n_per_arm = 15)
plot_waterfall(onc$adsl)
}
