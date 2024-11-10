library(xlr)

# You can use this function to get a block of questions
build_qtable(
  clothes_opinions,
  starts_with("Q1"),
  table_title = "This is an example table")

# Another way you could select the same columns
build_qtable(
  clothes_opinions,
  c(Q1_1,Q1_2,Q1_3,Q1_4),
  table_title = "This is an example table")

# Yet another way to select the same columns
build_qtable(
  clothes_opinions,
  all_of(c("Q1_1","Q1_2","Q1_3","Q1_4")),
  table_title = "This is an example table")
# You can also cut all questions in the block by a single column
build_qtable(
  clothes_opinions,
  starts_with("Q1"),
  gender2,
  table_title = "This is the second example table")

# You can also cut all questions in the block by a multiple columns
# By setting `use_questions=TRUE` then the footnote will be the questions
# labels, for the cut questions
build_qtable(
  clothes_opinions,
  starts_with("Q1"),
  c(gender2,age_group),
  table_title = "This is the third example table",
  use_questions = TRUE)

# You can also use weights, these weights can be either doubles or integers
# based weights
# You can also set a footnote
build_qtable(
  clothes_opinions,
  starts_with("Q1"),
  age_group,
  table_title = "This is the fourth example table",
  wt = weight,
  footnote = paste0("This is a footnote, you can use it if you want ",
                    "more detail in your table."))
