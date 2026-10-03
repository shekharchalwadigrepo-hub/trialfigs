\name{plot_ae}
\alias{plot_ae}
\title{Adverse-event incidence dot plot}
\description{
Percent of subjects with each term and a Wilson interval, ordered by the
risk difference versus the reference arm.
}
\usage{
plot_ae(data, term = "term", arm = "arm", denom = NULL, id = "usubjid",
  reference = "Placebo", title = "Subjects with an adverse event")
}
\arguments{
\item{data}{One row per subject per event.}
\item{term,arm,id}{Column names.}
\item{denom}{Subject-level denominator. Required for a correct percent.}
\item{reference}{Arm used when ordering by risk difference.}
\item{title}{Plot title.}
}
\value{A ggplot object.}
\examples{
saf <- simulate_safety(n_per_arm = 25)
plot_ae(saf$adae, denom = saf$adsl, reference = "Placebo")
}
