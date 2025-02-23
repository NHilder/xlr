library(xlr)
# set up a basic table
bt <- xlr_table(mtcars,
                 "A title",
                 "A footnote")
# now we want to update the title
# This changes what it look likes when we print it to excel
bt <- update_theme(bt,
                   xlr_format(font_size = 12,
                               text_style = c("bold","underline")))
\dontrun{
write_xlsx(bt,
           "example.xlsx",
           "Test")}
