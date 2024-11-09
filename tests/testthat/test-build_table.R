test_that("that errors from inputting an invalid column is caught correctly", {
  expect_snapshot(build_table(mtcars,not_a_col),
                  error = TRUE)

  expect_snapshot(build_table(mtcars,"not_a_col"),
                  error = TRUE)
})

test_that("that errors from inputting an invalid column in a vector is caught correctly", {
  expect_snapshot(build_table(mtcars,c(mpg,not_a_col)),
                  error = TRUE)
})

test_that("build_table works on the most simple case", {
  df <-create_block_question_df()

  output <- data.frame(gender = c("f","m"),
                       N = xlr_integer(c(5,5)),
                       Percent = xlr_percent(c(.5,.5))) |>
    xlr_table()

  expect_equal(build_table(df,gender),
               output)

})

test_that("build_table works when using a tidyselect statement to select cols", {
  df <-create_block_question_df()
  output <- data.frame(group = c("a","a","b","b"),
                       gender = c("f","m","f","m"),
                       gender2 = c("female","male","female","male"),
                       gender3 = c("female","male","female","male"),
                       N = xlr_integer(c(2,3,3,2)),
                       Percent = xlr_percent(c(1,1,1,1))) |>
    xlr_table()

  expect_equal(build_table(df,cols = group:gender3),
               output)

})

test_that("build_table works with weights as expected", {
  df <-create_block_question_df()

  output <- data.frame(gender = c("f","m"),
                       N = xlr_numeric(c(1.6,1.6),
                                       1),
                       Percent = xlr_percent(c(.5,.5))) |>
    xlr_table()

  expect_equal(build_table(df,gender,wt = weight),
               output)

})

test_that("build_table works with integer weights as expected", {
  df <-create_block_question_df() |>
    mutate(weight = as.integer(weight * 100))

  output <- data.frame(gender = c("f","m"),
                       N = xlr_numeric(c(160,160),
                                       1),
                       Percent = xlr_percent(c(.5,.5))) |>
    xlr_table()

  expect_equal(build_table(df,gender,wt = weight),
               output)

})


test_that("test that the adding the title works as expected",{
  df <-create_block_question_df()

  expect_equal(build_table(df,"Q1_1",table_title = "Test") |> pull_title(),
               "Test")
})

test_that("test that adding a footnote manually is added correctly",{
  df <-create_block_question_df()
  expect_equal(build_table(df,"Q1_1",table_title = "Test",footnote = "A footnote") |> pull_footnote(),
               "A footnote")
})

test_that("test that adding a footnote manually and adding footnote_question throws an erorr",{
  df <-create_block_question_df()
  expect_snapshot(build_table(df,"Q1_1",table_title = "Test",use_questions = TRUE, footnote = "A footnote"),
                  error = TRUE)
})

test_that("using use_NA results in the expect removal",{
  df <-create_block_question_df() |>
    select(gender,Q1_1)

  df[1,1] <- NA
  df[10,2] <- NA

  # There should be an NA in this output
  expect_true(build_table(df,"Q1_1", use_NA = TRUE) |>
                is.na() |>
                any())
  # there are no NA's in any of
  # the columns
  expect_false(build_table(df,"Q1_1", use_NA = FALSE) |>
                 is.na() |>
                 any())
})

test_that("use_questions pulls out the column names (the questions) as expected",{
  df <-create_block_question_df()

  # There should be an NA in this output
  expect_equal(build_table(df,c(gender2,gender3), use_questions = TRUE) |>
                 pull_footnote(),
               c("Questions",
                 "The sex of the participant",
                 "The gender of the participant"))
})
