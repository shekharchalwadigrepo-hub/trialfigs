\name{simulate_infectious}
\alias{simulate_infectious}
\title{Simulate an antiviral viral-load set}
\description{Log10 viral load and time to clearance. Synthetic data.}
\usage{simulate_infectious(n_per_arm = 100, seed = 20260319)}
\arguments{
\item{n_per_arm}{Subjects per arm.}
\item{seed}{Random seed, restored after the call.}
}
\value{A list with \code{adsl} and \code{adlb}.}
\examples{
id <- simulate_infectious(n_per_arm = 15)
plot_change(id$adlb, visit = "day", xlab = "Day")
}
