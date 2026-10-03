\name{simulate_immunology}
\alias{simulate_immunology}
\title{Simulate a rheumatoid-arthritis DAS28 set}
\description{Longitudinal DAS28. Synthetic data.}
\usage{simulate_immunology(n_per_arm = 120, seed = 20260318)}
\arguments{
\item{n_per_arm}{Subjects per arm.}
\item{seed}{Random seed, restored after the call.}
}
\value{A list with \code{adsl} and \code{adeff}.}
\examples{
imm <- simulate_immunology(n_per_arm = 15)
plot_change(imm$adeff, title = "DAS28")
}
