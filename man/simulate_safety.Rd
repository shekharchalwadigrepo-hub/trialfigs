\name{simulate_safety}
\alias{simulate_safety}
\title{Simulate core safety data}
\description{
Adverse events and peak liver tests in multiples of the upper limit of
normal. Synthetic data.
}
\usage{simulate_safety(n_per_arm = 160, seed = 20260321)}
\arguments{
\item{n_per_arm}{Subjects per arm.}
\item{seed}{Random seed, restored after the call.}
}
\value{A list with \code{adsl}, \code{adae} and \code{adlb}.}
\examples{
saf <- simulate_safety(n_per_arm = 20)
plot_edish(saf$adlb)
}
