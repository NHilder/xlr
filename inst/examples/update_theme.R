library(BETAexcel)
# set up a basic table
bt <- beta_table(mtcars,
                 "A title",
                 "A footnote")
# now we want to update the title
# This changes what it look likes when we print it to excel
bt <- update_theme(bt,
                   beta_format(font_size = 12,
                               text_style = c("bold","underline")))
\dontrun{
write_xlsx(bt,
           "example.xlsx",
           "Test")}
