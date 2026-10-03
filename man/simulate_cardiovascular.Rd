\name{simulate_cardiovascular}
\alias{simulate_cardiovascular}
\title{Simulate a cardiovascular outcomes set}
\description{Time to first MACE and systolic blood pressure. Synthetic data.}
\usage{simulate_cardiovascular(n_per_arm = 220, seed = 20260316)}
\arguments{
\item{n_per_arm}{Subjects per arm.}
\item{seed}{Random seed, restored after the call.}
}
\value{A list with \code{adsl} and \code{advs}.}
\examples{
cv <- simulate_cardiovascular(n_per_arm = 20)
plot_km(cv$adsl, time = "mace_months", event = "mace_event", arm = "arm")
}
