library(xlr)
# You can initialise a xlr_format, it comes with a list of defaults
bf <- xlr_format()
# It outputs what the style looks like
bf
# You can update the format by defining a new format
bf <- xlr_format(font_size = 11,
                  # not that font is not validated
                  font = "helvetica")
# The main use of xlr_format is to change the format of a vector of
# a xlr type
bd <- xlr_numeric(1:200,
                  dp = 1,
                  style = bf)
# You can also use it to change the styles of an xlr_table, this only
# affect the format in `Excel`
bt <- xlr_table(mtcars, "A clever title", "A useful footnote")
bt <- bt |>
      update_theme(footnote_format = xlr_format(font_size = 7))
