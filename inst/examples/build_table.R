library(xlr)

# You can use this function to calculate the number count and percentage
# of a categorical variable
build_table(
  clothes_opinions,
  gender,
  table_title = "The count of the gender groups")

# You must use a `tidyselect` statement, to select the columns that you wish to
# calculate the count, and group percentage.
# This will calculate the number of observations in each group of age and
# gender.
# The percentage will be the percentage of each age_group in each gender
# group (the row percentage).
build_table(
  clothes_opinions,
  c(gender,age_group),
  table_title = "This is the second example table")

# You can use more complicated tidy select statements if you have a large number
# of columns, but this is probably not recommended
#
# Using use_questions, if you have labelled data, it will take the label and
# include it as a footnote.
# This is useful for when you have exported data from survey platforms
# as a .sav, use `haven::read_sav` to load it into your R environment.
build_table(
  clothes_opinions,
  c(group:gender,Q1_1),
  table_title = "This is the third example table",
  use_questions = TRUE)

# You can also use weights, these weights can be either doubles or integers
# based weights
# You can also set a footnote manually
build_table(
  clothes_opinions,
  age_group,
  table_title = "This is the fourth example table",
  wt = weight,
  footnote = paste0("This is a footnote, you can use it if you want",
                    "more detail in your table."))


