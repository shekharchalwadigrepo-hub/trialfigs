\name{plot_exposure}
\alias{plot_exposure}
\title{Treatment duration by arm}
\description{Box plot of exposure with the median in the caption.}
\usage{
plot_exposure(data, duration = "trtdur_days", arm = "arm",
  xlab = "Treatment duration (days)", title = "Exposure")
}
\arguments{
\item{data}{Subject-level data.}
\item{duration,arm}{Column names.}
\item{xlab,title}{Labels.}
}
\value{A ggplot object.}
\examples{
saf <- simulate_safety(n_per_arm = 20)
plot_exposure(saf$adsl)
}
