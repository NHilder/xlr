library(xlr)
library(dplyr)

# You can use this function to calculate the number of people that have
# responded to the question `What is your favourite colour`
build_mtable(clothes_opinions,
             "Q2",
             table_title = "What is your favourite colour?")

# The function also lets you to see the number of NA questions (this is
# where someone doesn't answer any option)
build_mtable(clothes_opinions,
             "Q2",
             table_title = "What is your favourite colour?",
             use_NA = TRUE)

# You can also cut all questions in the multiple response functions by another
# column
build_mtable(clothes_opinions,
             "Q2",
             gender2,
             table_title = "Your favourite colour by gender")

# By setting `use_questions=TRUE` then the footnote will be the questions
# labels. This is useful to see what the question is.
# The function will try to pull out this based on the question label, and
# will manipulate try and get the correct label.
build_mtable(clothes_opinions,
             "Q2",
             gender2,
             table_title = "Your favourite colour by gender",
             use_questions = TRUE)

# It is common for your data to include 'other' responses in a multiple
# response column. You should remove the column before running build_mtable
clothes_opinions |>
  select(-Q3_other) |>
  build_mtable("Q3")

# You can also specify up to a maxium of two different multiple response
# columns.
clothes_opinions |>
  select(-Q3_other) |>
  build_mtable(c("Q2", "Q3"))

# These cam also be cut by other columns.
clothes_opinions |>
  select(-Q3_other) |>
  build_mtable(c("Q2", "Q3"),
               gender2)

# This function also supports weights and manual footnotes
clothes_opinions |>
  select(-Q3_other) |>
  build_mtable(c("Q2", "Q3"),
               gender2,
               wt = weight,
               footnote = "This is an example footnote.")
