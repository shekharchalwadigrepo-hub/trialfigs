\name{plot_km}
\alias{plot_km}
\title{Kaplan-Meier curve with number at risk}
\description{
Event-free curve with censoring ticks, dashed confidence limits, a log-rank
p-value and the number at risk. Competing risks are not modelled.
}
\usage{
plot_km(data, time, event, arm, xlab = "Time (months)",
  ylab = "Event-free probability", title = "Kaplan-Meier estimate",
  subtitle = NULL, conf_int = TRUE, risk_times = NULL, palette = NULL,
  population = "Intent-to-treat population")
}
\arguments{
\item{data}{Subject-level data.}
\item{time,event,arm}{Column names. \code{event} is 1 for the event and 0 for censoring.}
\item{xlab,ylab,title,subtitle}{Labels.}
\item{conf_int}{Draw pointwise confidence limits.}
\item{risk_times}{Times for the number at risk. Default is \code{pretty()}.}
\item{palette}{Named color vector.}
\item{population}{Analysis-population note printed in the caption.}
}
\value{A ggplot object.}
\examples{
onc <- simulate_oncology(n_per_arm = 15)
plot_km(onc$adsl, time = "os_months", event = "os_event", arm = "arm")
}
