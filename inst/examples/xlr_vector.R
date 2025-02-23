library(xlr)
# Create a xlr_vector object, this is used so we can add styling to an existing
# vector so that it prints nicely in excel
#
# Note currently the style will not change the style in the console
x <- xlr_vector(1:100,
                 excel_format = "00.0##",
                 style = xlr_format(font_size = 8))

# You can also use it so that dates are nicely printed in excel
dates <- c("02/27/92", "02/27/92", "01/14/92", "02/28/92", "02/01/92")
dates <- as.Date(dates, "%m/%d/%y")
x <- xlr_vector(dates,
                 # Print it as a long date in excel
                 excel_format = "LONGDATE")
# You can convert existing data to a xlr_vectors using dplyr verbs
iris |>
  dplyr::mutate(iris_format = as_xlr_vector(Species,
                                             "TEXT",
                                             xlr_format(text_style = "italic")))
