\name{plot_lab_shift}
\alias{plot_lab_shift}
\title{Baseline versus post-baseline maximum}
\description{Points above the identity line rose after baseline.}
\usage{
plot_lab_shift(data, baseline = "alt_base", post = "alt_max", arm = "arm",
  uln = NULL, title = "Baseline vs post-baseline maximum",
  xlab = "Baseline", ylab = "Post-baseline maximum")
}
\arguments{
\item{data}{One row per subject.}
\item{baseline,post,arm}{Column names.}
\item{uln}{Upper limit of normal, drawn if not NULL.}
\item{title,xlab,ylab}{Labels.}
}
\value{A ggplot object.}
\examples{
saf <- simulate_safety(n_per_arm = 20)
plot_lab_shift(saf$adlb, uln = 1)
}
