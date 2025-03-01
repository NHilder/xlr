library(xlr)
# lets define a xlr_percent, a xlr_percent is between a number between [0-1], not
# between 1-100
#
# Create a variable to represent 10%
x <- xlr_percent(0.1)
# This will print nicely
x
# Now we can increase the number of decimal places to display
# The decimal places must be a positive integer
x <- xlr_percent(x, dp = 3L)
x
# We can also define a vector of xlr_percents
y <- xlr_percent(c(0.1055,0.3333333,0.1234567), dp = 2)
y
# You can convert existing data to a xlr_percentage using dplyr verbs
df <- data.frame(col_1 = c(0,0.2,0.33,0.43251))
df |>
  dplyr::mutate(col_pct = as_xlr_percent(col_1))
# You can also change the styling of a xlr_percent column, this is only relevant
# if you print it to `Excel` with write_xlsx
df |>
  dplyr::mutate(col_pct = xlr_percent(col_1,
                                  dp = 2,
                                  style = xlr_format(font_size = 8)))
# You can use as_xlr_percent to convert a string in a xlr_percentage format to a
# xlr_percent
df <- data.frame(col_str = c("12.22%","12.34567%","100%"))
# now we can convert the string to a xlr_xlr_percent()
df |>
  dplyr::mutate(col_xlr_percent = as_xlr_percent(col_str,2))
