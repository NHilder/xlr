library(xlr)
library(tibble)
# we can write a data.frame or tibble with write_xlsx
example_tibble <- tibble(example = c(1:100))

\dontrun{
write_xlsx(mtcars,
           "example_file.xlsx")

# you can specify a sheet name
write_xlsx(example_tibble,
           "example_file.xlsx",
           sheet_name = "Example sheet")}

# You can write a xlr_table.
# When you write a xlr_table you can specify the formatting as well as titles
# and footnotes.
example_xlr_table <- xlr_table(mtcars,
                                 "This is a title",
                                 "This is a footnote")

\dontrun{
write_xlsx(example_xlr_table,
           "example_file.xlsx")}

# like openxlsx, you can also pass a list
table_list <- list("Sheet name 1" = xlr_table(mtcars,
                                               "This is a title",
                                               "This is a footnote"),
                   "Sheet name 2" = xlr_table(mtcars,
                                              "This is a title too",
                                              "This is a footnote as well"))

\dontrun{
write_xlsx(table_list,
           "example_file.xlsx")}
