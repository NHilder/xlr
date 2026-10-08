\dontshow{
  oldWd <- setwd(tempdir())
}
library(xlr)
# set up a basic table
bt <- xlr_table(mtcars,
                 "A title",
                 "A footnote")
# now we want to update the title
# This changes what it look likes when we print it to `Excel`
bt <- update_theme(bt,
                   title_format = xlr_format(font_size = 12,
                                             text_style = c("bold","underline")))

# Only the formats you pass are changed, so this updates the footnote and
# keeps the title format from above
bt <- update_theme(bt,
                   footnote_format = xlr_format(font_size = 9,
                                                font_colour = "grey40"))

# To go back to the default formats, re-create the table
bt_default <- xlr_table(as_base_r(bt),
                        attr(bt, "title"),
                        attr(bt, "footnote"))
# To see the change you must write to an Excel file
write_xlsx(bt,
           "example.xlsx",
           "Test")

\dontshow{
  # remove the example file and restore wd
  unlink("example.xlsx")
  setwd(oldWd)
}
