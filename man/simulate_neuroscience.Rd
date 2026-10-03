\name{simulate_neuroscience}
\alias{simulate_neuroscience}
\title{Simulate a depression MADRS set}
\description{Longitudinal MADRS. Synthetic data.}
\usage{simulate_neuroscience(n_per_arm = 140, seed = 20260320)}
\arguments{
\item{n_per_arm}{Subjects per arm.}
\item{seed}{Random seed, restored after the call.}
}
\value{A list with \code{adsl} and \code{adeff}.}
\examples{
cns <- simulate_neuroscience(n_per_arm = 15)
plot_change(cns$adeff, title = "MADRS")
}
