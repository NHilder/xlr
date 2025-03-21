% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_table_of_contents.R
\name{create_table_of_contents}
\alias{create_table_of_contents}
\title{Adds a table of contents to an .xlsx (\code{Excel}) file}
\usage{
create_table_of_contents(
  file,
  title = NA_character_,
  overwrite = TRUE,
  pull_titles = TRUE,
  TOC_sheet_name = "Table of Contents"
)
}
\arguments{
\item{file}{the file name.}

\item{title}{the title for the table.}

\item{overwrite}{logical. When \code{TRUE} overwrite the file, if \code{FALSE} it will
not overwrite the file.}

\item{pull_titles}{when \code{TRUE} take the titles from the \code{Excel} sheets, and add
them to the description in the TOC_sheet_name.}

\item{TOC_sheet_name}{string. the sheet name for the table of contents.}
}
\value{
Returns a logical or error if writing the file succeeded.
}
\description{
This function adds a table of contents to an \code{Excel} file by reading the
information from the \code{Excel} sheet in, and then using that data to create
the table of contents. It guesses what the information is, see details below.
}
\details{
This function uses the sheet names to create the table of contents. For the
titles it pulls the text that is the position A1 in each of the sheets. It
chooses this as this is the default location of titles when you write a
\link{xlr_table} with \link{write_xlsx}.
}
\examples{
\dontshow{
oldWd <- setwd(tempdir())
}
library(xlr)
library(openxlsx)
table_list <- list("Sheet name 1" = mtcars,
                   "Sheet name 2" = mtcars)

output_file <- "example_file.xlsx"

# using write xlsx we create an `Excel` document
# You could use xlr::write_xlsx to create a table of
# contents automatically.
write.xlsx(table_list,
           output_file)

# Now add the table of contents to the existing file
create_table_of_contents(output_file,
                         "A workbook with example tables",
                         # it only makes sense to pull titles when
                         # the first cell has a text description
                         pull_titles = FALSE)
\dontshow{
  # restore wd
  setwd(oldWd)
}
}
