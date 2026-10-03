\name{plot_swimmer}
\alias{plot_swimmer}
\title{Swimmer plot of time on treatment}
\description{
One bar per subject, with points for objective response and progression.
Limited to the longest durations so the figure stays readable.
}
\usage{
plot_swimmer(data, id = "usubjid", arm = "arm",
  duration = "trtdur_months", response_time = "resp_months",
  progression_time = "pd_months", max_n = 30, xlab = "Months",
  title = "Time on treatment")
}
\arguments{
\item{data}{Subject-level data.}
\item{id,arm,duration}{Column names.}
\item{response_time,progression_time}{Optional column names.}
\item{max_n}{Maximum subjects, taken as the longest durations.}
\item{xlab,title}{Labels.}
}
\value{A ggplot object.}
\examples{
onc <- simulate_oncology(n_per_arm = 12)
plot_swimmer(onc$adsl, max_n = 10)
}
