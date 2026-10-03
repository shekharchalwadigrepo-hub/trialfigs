\name{simulate_endocrinology}
\alias{simulate_endocrinology}
\title{Simulate a type 2 diabetes HbA1c set}
\description{Longitudinal HbA1c. Synthetic data.}
\usage{simulate_endocrinology(n_per_arm = 150, seed = 20260317)}
\arguments{
\item{n_per_arm}{Subjects per arm.}
\item{seed}{Random seed, restored after the call.}
}
\value{A list with \code{adsl} and \code{adlb}.}
\examples{
endo <- simulate_endocrinology(n_per_arm = 15)
plot_change(endo$adlb)
}
