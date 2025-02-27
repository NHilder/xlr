library(xlr)
library(openxlsx)
table_list <- list("Sheet name 1" = mtcars,
                   "Sheet name 2" = mtcars)

output_file <- "example_file.xlsx"

\dontrun{
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
                         pull_titles = FALSE)}
