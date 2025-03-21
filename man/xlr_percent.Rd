% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/xlr_percent.R
\name{xlr_percent}
\alias{xlr_percent}
\alias{is_xlr_percent}
\alias{as_xlr_percent}
\title{\code{xlr_percent} vector}
\usage{
xlr_percent(x = double(), dp = 0L, style = xlr_format_numeric())

is_xlr_percent(x)

as_xlr_percent(x, dp = 0L, style = xlr_format_numeric())
}
\arguments{
\item{x}{\itemize{
\item For \code{xlr_percent()}: A numeric vector
\item For \code{is_xlr_percent()}: An object to test
\item For \code{as_xlr_percent()} : a numeric or character vector. For a character
vector, the data must be in the format \code{"XXX.YYY...\%"}.
}}

\item{dp}{the number of decimal places to print}

\item{style}{Additional styling options for the vector. See \link{xlr_format_numeric} for more details.}
}
\value{
An S3 vector of class \code{xlr_percent}
}
\description{
This creates a numeric vector that will be printed as a percentage and
exported to \code{Excel} using it's native format.You can convert a vector back to
its base type with \code{\link[=as_base_r]{as_base_r()}}.
}
\examples{
library(xlr)
# lets define a xlr_percent, a xlr_percent is between a number between [0-1], not
# between 1-100
#
# Create a variable to represent 10\%
x <- xlr_percent(0.1)
# This will print nicely
x
# Now we can increase the number of decimal places to display
# The decimal places must be a positive integer
x <- xlr_percent(x, dp = 3L)
x
# We can also define a vector of xlr_percents
y <- xlr_percent(c(0.1055,0.3333333,0.1234567), dp = 2)
y
# You can convert existing data to a xlr_percentage using dplyr verbs
df <- data.frame(col_1 = c(0,0.2,0.33,0.43251))
df |>
  dplyr::mutate(col_pct = as_xlr_percent(col_1))
# You can also change the styling of a xlr_percent column, this is only relevant
# if you print it to `Excel` with write_xlsx
df |>
  dplyr::mutate(col_pct = xlr_percent(col_1,
                                  dp = 2,
                                  style = xlr_format(font_size = 8)))
# You can use as_xlr_percent to convert a string in a xlr_percentage format to a
# xlr_percent
df <- data.frame(col_str = c("12.22\%","12.34567\%","100\%"))
# now we can convert the string to a xlr_xlr_percent()
df |>
  dplyr::mutate(col_xlr_percent = as_xlr_percent(col_str,2))
}
\seealso{
\code{\link[=xlr_vector]{xlr_vector()}}, \code{\link[=xlr_integer]{xlr_integer()}}, \code{\link[=xlr_numeric]{xlr_numeric()}}, \code{\link[=as_base_r]{as_base_r()}}
}
