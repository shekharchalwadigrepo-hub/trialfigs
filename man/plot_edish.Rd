\name{plot_edish}
\alias{plot_edish}
\title{eDISH plot of peak ALT versus peak bilirubin}
\description{
Log-scale multiples of the upper limit of normal. Reference lines are ALT
3x ULN and total bilirubin 2x ULN. A point in that quadrant needs narrative
review; it is not by itself a Hy's law case.
}
\usage{
plot_edish(data, alt = "alt_xuln", bili = "bili_xuln", arm = "arm",
  id = "usubjid", title = "eDISH: peak ALT vs peak total bilirubin")
}
\arguments{
\item{data}{One row per subject, peak values.}
\item{alt,bili,arm}{Column names, values in multiples of ULN.}
\item{id}{Optional subject id, labelled for quadrant cases.}
\item{title}{Plot title.}
}
\value{A ggplot object.}
\examples{
saf <- simulate_safety(n_per_arm = 25)
plot_edish(saf$adlb)
}
