library(BETAexcel)
# lets define a beta_percent, a beta_percent is between a number between [0-1], not
# between 1-100
#
# Create a variable to represent 10%
x <- beta_percent(0.1)
# This will print nicely
x
# Now we can increase the number of decimal places to display
# The decimal places must be a positive integer
x <- beta_percent(x, dp = 3L)
x
# We can also define a vector of beta_percents
y <- beta_percent(c(0.1055,0.3333333,0.1234567), dp = 2)
y
# You can convert existing data to a beta_percentage using dplyr verbs
df <- data.frame(col_1 = c(0,0.2,0.33,0.43251))
df |>
  dplyr::mutate(col_pct = as_beta_percent(col_1))
# You can also change the styling of a beta_percent column, this is only relevant
# if you print it to excel with write_xlsx
df |>
  dplyr::mutate(col_pct = beta_percent(col_1,
                                  dp = 2,
                                  style = beta_format(font_size = 8)))
# You can use as_beta_percent to convert a string in a beta_percentage format to a
# beta_percent
df <- data.frame(col_str = c("12.22%","12.34567%","100%"))
# now we can convert the string to a beta_beta_percent()
df |>
  dplyr::mutate(col_beta_percent = as_beta_percent(col_str,2))
