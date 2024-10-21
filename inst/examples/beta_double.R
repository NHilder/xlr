library(BETAexcel)
# Create a variable to represent a double with two decimal places
# The decimal places must be a positive integer
x <- beta_double(2.1134,dp = 2)
# This will print nicely
x
# You can change the styling, which affects how it looks when we print it
x <- beta_double(x, dp = 3L, style = beta_format(font_size = 9, font_colour = "red"))
x
# We can also define a vector of doubles
y <- beta_double(c(22.1055,1.3333333,3.1234567), dp = 2)
y
# You can convert existing data to a double using dplyr verbs
df <- data.frame(col_1 = c(2,3.2,1.33,4.43251))
df |>
  dplyr::mutate(col_pct = as_beta_double(col_1))
# You can use as_beta_double to convert a string in a double
df <- data.frame(col_str = c("12.22","12.34567","100"))
# now we can convert the string to a double(), internally it uses the same
# logic as as.double()
df |>
  dplyr::mutate(col_double = as_beta_double(col_str,2))
