\name{plot_spider}
\alias{plot_spider}
\title{Spider plot of percent change over time}
\description{Individual tumor trajectories with the arm mean overlaid.}
\usage{
plot_spider(data, id = "usubjid", time = "week", pct = "pct_change",
  arm = "arm", title = "Percent change in sum of diameters")
}
\arguments{
\item{data}{Longitudinal data, one row per subject per visit.}
\item{id,time,pct,arm}{Column names.}
\item{title}{Plot title.}
}
\value{A ggplot object.}
\examples{
onc <- simulate_oncology(n_per_arm = 8)
plot_spider(onc$adtr)
}
