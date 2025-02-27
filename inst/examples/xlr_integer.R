library(xlr)
# Create a variable to represent an integer
x <- xlr_integer(2)
# This will print nicely
x
# You can change the styling, which affects how it looks when we save it as an
# `Excel` document
x <- xlr_integer(x, style = xlr_format(font_size = 9, font_colour = "red"))
x
# We can also define a vector of integers
y <- xlr_integer(c(1,2,3))
y
# You can convert existing data to a integer using dplyr verbs
# It formats large numbers nicely
df <- data.frame(col_1 = c(1:100*100))
df |>
  dplyr::mutate(col_pct = as_xlr_integer(col_1))
# You can use as_xlr_integer to convert a string in a integer
df <- data.frame(col_str = c("12","13","14"))
# now we can convert the string to a integer(), internally it uses the same
# logic as as.integer()
df |>
  dplyr::mutate(col_percent = as_xlr_integer(col_str))
