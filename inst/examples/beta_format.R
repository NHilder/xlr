library(BETAexcel)
# You can initialise a beta_format, it comes with a list of defaults
bf <- beta_format()
# It outputs what the style looks like
bf
# You can update the format by defining a new format
bf <- beta_format(font_size = 11,
                  # not that font is not validated
                  font = "helvetica")
# The main use of beta_format is to change the format of a vector of
# a beta type
bd <- beta_double(1:200,
                  dp = 1,
                  style = bf)
# You can also use it to change the styles of an beta_table, this only
# affect the format in excel
bt <- beta_table(mtcars, "A clever title", "A useful footnote")
bt <- bt |>
      update_theme(footnote_format = beta_format(font_size = 7))
