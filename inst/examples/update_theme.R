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
                   xlr_format(font_size = 12,
                               text_style = c("bold","underline")))
# To see the change you must write to an Excel file
write_xlsx(bt,
           "example.xlsx",
           "Test")

\dontshow{
  # restore wd
  setwd(oldWd)
}
