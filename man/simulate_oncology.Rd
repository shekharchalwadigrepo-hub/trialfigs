\name{simulate_oncology}
\alias{simulate_oncology}
\title{Simulate a two-arm oncology efficacy set}
\description{
Subject-level survival, RECIST response, and longitudinal tumor measurements.
Data are synthetic. The random-number stream is restored on exit.
}
\usage{simulate_oncology(n_per_arm = 80, seed = 20260315)}
\arguments{
\item{n_per_arm}{Subjects per arm.}
\item{seed}{Random seed, restored after the call.}
}
\value{A list with \code{adsl} and \code{adtr}.}
\examples{
onc <- simulate_oncology(n_per_arm = 10)
plot_waterfall(onc$adsl)
}
