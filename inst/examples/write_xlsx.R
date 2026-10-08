\dontshow{
  oldWd <- setwd(tempdir())
}
library(xlr)
library(tibble)
# we can write a data.frame or tibble with write_xlsx
example_tibble <- tibble(example = c(1:100))

write_xlsx(mtcars,
           "example_file.xlsx",
           sheet_name = "Example sheet")

# you must specify a sheet name.
# If the file already exists, use `if_exists` to choose whether to "append" to
# or "overwrite" it
write_xlsx(example_tibble,
           "example_file.xlsx",
           sheet_name = "Example sheet",
           if_exists = "append")

# You can write a xlr_table.
# When you write a xlr_table you can specify the formatting as well as titles
# and footnotes.
example_xlr_table <- xlr_table(mtcars,
                                 "This is a title",
                                 "This is a footnote")

write_xlsx(example_xlr_table,
           "example_file.xlsx",
           "Example sheet",
           if_exists = "append")

# like openxlsx, you can also pass a list
table_list <- list("Sheet name 1" = xlr_table(mtcars,
                                               "This is a title",
                                               "This is a footnote"),
                   "Sheet name 2" = xlr_table(mtcars,
                                              "This is a title too",
                                              "This is a footnote as well"))

write_xlsx(table_list,
           "example_file.xlsx",
           if_exists = "overwrite")
\dontshow{
  # remove the example file and restore wd
  unlink("example_file.xlsx")
  setwd(oldWd)
}
