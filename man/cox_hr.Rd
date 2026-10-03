\name{cox_hr}
\alias{cox_hr}
\title{Cox hazard ratio with the investigational arm in the numerator}
\description{
The reference level is the other arm, so a ratio below 1 favours the
investigational arm. One row is returned, for binding into a forest.
}
\usage{
cox_hr(data, time, event, arm, investigational = "Investigational",
  subgroup = "Overall")
}
\arguments{
\item{data}{Subject-level data.}
\item{time,event,arm}{Column names.}
\item{investigational}{Level of \code{arm} treated as the experimental arm.}
\item{subgroup}{Label stored in the result.}
}
\value{A one-row data frame with subgroup, estimate, limits and n.}
\examples{
onc <- simulate_oncology(n_per_arm = 20)
cox_hr(onc$adsl, "os_months", "os_event", "arm")
}
