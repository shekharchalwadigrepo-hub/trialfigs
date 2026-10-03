\name{plot_change}
\alias{plot_change}
\title{Mean change from baseline with a confidence interval}
\description{
The band is the normal approximation to the standard error of the mean.
Replace it with the model named in the statistical analysis plan for a primary contrast.
}
\usage{
plot_change(data, visit = "week", change = "chg", arm = "arm",
  title = "Mean change from baseline", xlab = "Week",
  ylab = "Mean change (95\% CI)")
}
\arguments{
\item{data}{Longitudinal data.}
\item{visit,change,arm}{Column names.}
\item{title,xlab,ylab}{Labels.}
}
\value{A ggplot object.}
\examples{
endo <- simulate_endocrinology(n_per_arm = 15)
plot_change(endo$adlb, title = "HbA1c")
}
