\name{plot_responder}
\alias{plot_responder}
\title{Binary responder rate with a Wilson interval}
\description{Percent of responders by arm, with a Wilson score interval.}
\usage{
plot_responder(data, responder, arm, title = "Responder rate",
  ylab = "Responders, percent (Wilson 95\% CI)")
}
\arguments{
\item{data}{Subject-level data.}
\item{responder}{Logical or 0/1 column name.}
\item{arm}{Arm column name.}
\item{title,ylab}{Labels.}
}
\value{A ggplot object.}
\examples{
onc <- simulate_oncology(n_per_arm = 15)
onc$adsl$responder <- onc$adsl$bor \%in\% c("CR", "PR")
plot_responder(onc$adsl, responder = "responder", arm = "arm")
}
