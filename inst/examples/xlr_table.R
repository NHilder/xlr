\dontshow{
  oldWd <- setwd(tempdir())
}

library(xlr)
library(dplyr)
# Create a xlr_table, we set the footnotes and the title
# It converts to the xlr types by default
x <- xlr_table(mtcars,
                title = "mtcars is a fun data set",
                footnote = "mtcars is a data set that comes with base R")
# The title and the footnote print to console
x
# You can use mutate and summarise with xlr_tables and they are preserved
x |>
  summarise(mean_mpg = sum(mpg))
# Rename a column
x |>
  rename(new_name = mpg)
# When you want to change how elements of the table look when written using
# write_xlsx, you can update it with update them
x <- x |>
  # make the font bigger
  update_theme(title_format = xlr_format(font_size = 14))
# you must write it in order to see the formatting changes
write_xlsx(x,
             "example.xlsx",
             "A example sheet",
             TOC = FALSE)

\dontshow{
  # restore wd
  setwd(oldWd)
}
