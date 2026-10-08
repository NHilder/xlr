library(xlr)
tbl <- xlr_table(mtcars, "A title", "A footnote")

# get the title and footnote
get_title(tbl)
get_footnote(tbl)

# set them, the footnote can have several lines
tbl <- tbl |>
  set_title("Motor Trend cars") |>
  set_footnote(c("Source: Motor Trend (1974).", "", "Data from R."))
get_footnote(tbl)

# NULL removes the title
tbl_no_title <- set_title(tbl, NULL)
get_title(tbl_no_title)

# get and set a single format, use update_theme() to set several at once
get_title_format(tbl)
tbl <- set_title_format(tbl, xlr_format(font_size = 14, text_style = "bold"))
