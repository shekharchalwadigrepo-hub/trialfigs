\name{plot_forest}
\alias{plot_forest}
\title{Forest plot of a ratio or a difference}
\description{
Use \code{null = 1} for hazard ratios and \code{null = 0} for mean differences.
Intervals that cross the null are drawn in grey.
}
\usage{
plot_forest(data, label = "subgroup", estimate = "estimate", lcl = "lcl",
  ucl = "ucl", n = NULL, null = 1, xlab = "Hazard ratio (95\% CI)",
  title = "Subgroup forest plot", subtitle = NULL,
  favour_left = "Favours investigational",
  favour_right = "Favours control")
}
\arguments{
\item{data}{One row per subgroup or endpoint.}
\item{label,estimate,lcl,ucl}{Column names.}
\item{n}{Optional sample-size column.}
\item{null}{Null value drawn as a vertical line.}
\item{xlab,title,subtitle,favour_left,favour_right}{Labels.}
}
\value{A ggplot object.}
\examples{
onc <- simulate_oncology(n_per_arm = 20)
forest <- cox_hr(onc$adsl, "os_months", "os_event", "arm")
plot_forest(forest)
}
