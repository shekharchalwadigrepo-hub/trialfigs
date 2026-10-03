## Test environments
* local Windows 11, R 4.4.1, devtools::check(cran = TRUE)

## R CMD check results
There were no ERRORs or WARNINGs.

There was 1 NOTE:

* checking for future file timestamps ... NOTE
  unable to verify current time

This occurred on Windows 11 with R 4.4.1 because the check could not
verify the current time. It is not caused by a file in the package.

## Reverse dependencies
This is a new submission, so there are no reverse dependencies.