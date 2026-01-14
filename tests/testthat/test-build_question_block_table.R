test_that("That when no columns start with the block column we get an error", {
  expect_snapshot(build_qtable(mtcars,"p"),
                  error = TRUE)
})

test_that("that errors from inputting an invalid column is caught correctly", {
  expect_snapshot(build_qtable(mtcars,"mpg",not_a_col),
                  error = TRUE)
})


test_that("that errors from inputting an invalid column is caught correctly", {
  expect_snapshot(build_qtable(mtcars,"mpg",c(wt,not_a_col)),
                  error = TRUE)
})

test_that("When we select data that has two different types, we get a error",{
  df <- data.frame(x1 = c(1:3),
                   x2 = c("a","b","c"))
  expect_snapshot(build_qtable(df,c(x1,x2)),
                  error = TRUE)
})

test_that("When we select data that when the data.frame has different class
          but the first element of the class statement is the same
          we get no error.",{
  df <- data.frame(x1 = haven::labelled(c(1L,2L,3L),c(a = 1L, b = 2L, c = 3L)),
                   x2 = haven::labelled(c(1.0,2.0,3.0),c(a = 1.0, b = 2.0, c = 3.0)))
  expect_no_error(build_qtable(df,c(x1,x2)))
})

test_that("When we select data that is a factor with two different levels
          then we get an error.",
{
  df <- data.frame(x1 = factor(c(1L,2L,2L),c(a = 1L, b = 2L)),
                   x2 = factor(c(1.0,2.0,3.0),c(a = 1.0, b = 2.0, c = 3.0)))
  expect_snapshot(build_qtable(df,c(x1,x2)),
                  error = TRUE)
})

test_that("When we select data that is a character that when
          converted to a factor have different levels then we get an error",
{
  df <- data.frame(x1 = c("a","a"),
                   x2 = c("a","b"))
  expect_snapshot(build_qtable(df,c(x1,x2)),
                  error = TRUE)
})

test_that("When we select data and the first column is the superset of the
          remaining columns, we get no error",
{
  df <- data.frame(x1 = c("a","b"),
                   x2 = c("a","a"))
  expect_silent(build_qtable(df,c(x1,x2)))
})

test_that("build_qtable() works with the simplest data",{

  df <-create_block_question_df() |>
    mutate(across(starts_with("Q1"),
                  ~ haven::as_factor(.x) |>
                    haven::zap_label()))
  output <-
    data.frame(`Question Block` = xlr_vector(c("Q1_1", "Q1_1", "Q1_1", "Q1_1", "Q1_1", "Q1_2", "Q1_2",
                                  "Q1_2", "Q1_2", "Q1_2", "Q1_3", "Q1_3", "Q1_4", "Q1_4")),
               value = xlr_vector(c("Strongly Disagree", "Disagree",
                                     "Neutral", "Agree", "Strongly Agree", "Strongly Disagree", "Disagree",
                                     "Neutral", "Agree", "Strongly Agree", "Strongly Disagree", "Strongly Agree",
                                     "Disagree", "Agree")),
               N = xlr_integer(c(2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L,
                                  2L, 2L, 5L, 5L, 5L, 5L)),
               Percent = xlr_percent(c(0.2, 0.2, 0.2, 0.2, 0.2,
                                        0.2, 0.2, 0.2, 0.2, 0.2, 0.5, 0.5, 0.5, 0.5))
    ,check.names = FALSE) |>
    xlr_table()

  # should expect them to the same
  expect_equal(build_qtable(df,starts_with("Q1")),output)
})

test_that("build_qtable() works for data with column labels",{

  df <-create_block_question_df()
  output <-
    data.frame(`Question Block` = xlr_vector(c("Pants are good to wear", "Pants are good to wear",
                                  "Pants are good to wear", "Pants are good to wear", "Pants are good to wear",
                                  "Shirts are good to wear", "Shirts are good to wear", "Shirts are good to wear",
                                  "Shirts are good to wear", "Shirts are good to wear", "Shoes are good to wear",
                                  "Shoes are good to wear", "Q1_4", "Q1_4")),
               value = xlr_vector(c("Strongly Disagree", "Disagree",
                                   "Neutral", "Agree", "Strongly Agree", "Strongly Disagree", "Disagree",
                                   "Neutral", "Agree", "Strongly Agree", "Strongly Disagree", "Strongly Agree",
                                   "Disagree", "Agree")),
               N = xlr_integer(c(2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L,
                                  2L, 2L, 5L, 5L, 5L, 5L)),
               Percent = xlr_percent(c(0.2, 0.2, 0.2, 0.2, 0.2,
                                      0.2, 0.2, 0.2, 0.2, 0.2, 0.5, 0.5, 0.5, 0.5))
               ,check.names = FALSE) |>
    xlr_table()

  # should expect them to the same
  expect_equal(build_qtable(df,starts_with("Q1")),output)
})


test_that("build_qtable() works with weights as expected",{
  df <- create_block_question_df()
  output <-
    data.frame(`Question Block` = xlr_vector(c("Pants are good to wear", "Pants are good to wear",
                                  "Pants are good to wear", "Pants are good to wear", "Pants are good to wear",
                                  "Shirts are good to wear", "Shirts are good to wear", "Shirts are good to wear",
                                  "Shirts are good to wear", "Shirts are good to wear", "Shoes are good to wear",
                                  "Shoes are good to wear", "Q1_4", "Q1_4")),
               value = xlr_vector(c("Strongly Disagree", "Disagree",
                                     "Neutral", "Agree", "Strongly Agree", "Strongly Disagree", "Disagree",
                                     "Neutral", "Agree", "Strongly Agree", "Strongly Disagree", "Strongly Agree",
                                     "Disagree", "Agree")),
               N = xlr_numeric(c(0.5, 0.6, 0.5, 0.7, 0.9, 0.9,
                                 0.7, 0.5, 0.6, 0.5, 0.9, 2.3, 0.9, 2.3),
                               dp = 1),
               Percent = xlr_percent(c(0.15625, 0.1875, 0.15625,
                                        0.21875, 0.28125, 0.28125, 0.21875, 0.15625, 0.1875, 0.15625,
                                        0.28125, 0.71875, 0.28125, 0.71875))
               ,check.names = FALSE) |>
    xlr_table()

  # should expect them to the same
  expect_equal(build_qtable(df,starts_with("Q1"),wt = weight),output)
  # works with a character
  expect_equal(build_qtable(df,starts_with("Q1"),wt = "weight"),output)
})

#
test_that("build_qtable() works with integer weights",{
  df <-create_block_question_df() |>
    mutate(weight = as.integer(weight *100))
  output <-
    data.frame(`Question Block` = xlr_vector(c("Pants are good to wear", "Pants are good to wear",
                                  "Pants are good to wear", "Pants are good to wear", "Pants are good to wear",
                                  "Shirts are good to wear", "Shirts are good to wear", "Shirts are good to wear",
                                  "Shirts are good to wear", "Shirts are good to wear", "Shoes are good to wear",
                                  "Shoes are good to wear", "Q1_4", "Q1_4")),
               value = xlr_vector(c("Strongly Disagree", "Disagree",
                                     "Neutral", "Agree", "Strongly Agree", "Strongly Disagree", "Disagree",
                                     "Neutral", "Agree", "Strongly Agree", "Strongly Disagree", "Strongly Agree",
                                     "Disagree", "Agree")),
               N = xlr_numeric(c(0.5, 0.6, 0.5, 0.7, 0.9, 0.9,
                                 0.7, 0.5, 0.6, 0.5, 0.9, 2.3, 0.9, 2.3),
                               dp = 1),
               Percent = xlr_percent(c(0.15625, 0.1875, 0.15625,
                                        0.21875, 0.28125, 0.28125, 0.21875, 0.15625, 0.1875, 0.15625,
                                        0.28125, 0.71875, 0.28125, 0.71875))
               ,check.names = FALSE) |>
    mutate(N = N*100) |>
    xlr_table()

  # should expect them to the same
  expect_equal(build_qtable(df,starts_with("Q1"),wt = weight),output)
  # works with a character
  expect_equal(build_qtable(df,starts_with("Q1"),wt = "weight"),output)
})


test_that("build_qtable() works with cuts",{
  df <-create_block_question_df()
  output <-
    data.frame(gender = c("f", "f", "f", "f", "f",
                          "f", "f", "f", "f", "f", "f", "f", "f", "f", "m", "m", "m", "m",
                          "m", "m", "m", "m", "m", "m", "m", "m", "m", "m"),
               `Question Block` = xlr_vector(c("Pants are good to wear", "Pants are good to wear",
                                  "Pants are good to wear", "Pants are good to wear", "Pants are good to wear",
                                  "Shirts are good to wear", "Shirts are good to wear", "Shirts are good to wear",
                                  "Shirts are good to wear", "Shirts are good to wear", "Shoes are good to wear",
                                  "Shoes are good to wear", "Q1_4", "Q1_4", "Pants are good to wear",
                                  "Pants are good to wear", "Pants are good to wear", "Pants are good to wear",
                                  "Pants are good to wear", "Shirts are good to wear", "Shirts are good to wear",
                                  "Shirts are good to wear", "Shirts are good to wear", "Shirts are good to wear",
                                  "Shoes are good to wear", "Shoes are good to wear", "Q1_4", "Q1_4")),
               value = xlr_vector(c("Strongly Disagree", "Disagree",
                                     "Neutral", "Agree", "Strongly Agree", "Strongly Disagree", "Disagree",
                                     "Neutral", "Agree", "Strongly Agree", "Strongly Disagree", "Strongly Agree",
                                     "Disagree", "Agree", "Strongly Disagree", "Disagree", "Neutral",
                                     "Agree", "Strongly Agree", "Strongly Disagree", "Disagree", "Neutral",
                                     "Agree", "Strongly Agree", "Strongly Disagree", "Strongly Agree",
                                     "Disagree", "Agree")),
               N = xlr_integer(c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
                                  1L, 1L, 2L, 3L, 2L, 3L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
                                  3L, 2L, 3L, 2L)),
               Percent = xlr_percent(c(0.2, 0.2, 0.2, 0.2, 0.2,
                                        0.2, 0.2, 0.2, 0.2, 0.2, 0.4, 0.6, 0.4, 0.6, 0.2, 0.2, 0.2, 0.2,
                                        0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.6, 0.4, 0.6, 0.4))
               ,check.names = FALSE) |>
    xlr_table()

  # should expect them to the same
  expect_equal(build_qtable(df,starts_with("Q1"),gender),output)
  # should expect them to be the same with a character
  expect_equal(build_qtable(df,starts_with("Q1"),"gender"),output)
})

test_that("build_qtable() works with multiple cuts",{
  df <-
    create_block_question_df() |>
    select(group, gender, Q1_1, Q1_2)

  output <-
    data.frame(group = c("a", "a", "a", "a", "a", "a",
                         "a", "a", "a", "a", "b", "b", "b", "b", "b", "b", "b", "b", "b",
                         "b"),
               gender = c("f", "f", "f", "f", "m",
                          "m", "m", "m", "m", "m", "f", "f", "f", "f", "f", "f", "m", "m",
                          "m", "m"),
               `Question Block` = xlr_vector(c("Pants are good to wear", "Pants are good to wear",
                                  "Shirts are good to wear", "Shirts are good to wear", "Pants are good to wear",
                                  "Pants are good to wear", "Pants are good to wear", "Shirts are good to wear",
                                  "Shirts are good to wear", "Shirts are good to wear", "Pants are good to wear",
                                  "Pants are good to wear", "Pants are good to wear", "Shirts are good to wear",
                                  "Shirts are good to wear", "Shirts are good to wear", "Pants are good to wear",
                                  "Pants are good to wear", "Shirts are good to wear", "Shirts are good to wear")),
               value = xlr_vector(c("Disagree", "Agree", "Disagree",
                                     "Agree", "Strongly Disagree", "Neutral", "Strongly Agree", "Strongly Disagree",
                                     "Neutral", "Strongly Agree", "Strongly Disagree", "Neutral",
                                     "Strongly Agree", "Strongly Disagree", "Neutral", "Strongly Agree",
                                     "Disagree", "Agree", "Disagree", "Agree")),
               N = xlr_integer(c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
                                  1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L)),
               Percent = xlr_percent(c(0.5, 0.5, 0.5, 0.5, 0.333333333333333,
                                   0.333333333333333, 0.333333333333333, 0.333333333333333, 0.333333333333333,
                                   0.333333333333333, 0.333333333333333, 0.333333333333333, 0.333333333333333,
                                   0.333333333333333, 0.333333333333333, 0.333333333333333, 0.5,
                                   0.5, 0.5, 0.5))
               ,check.names = FALSE) |>
    xlr_table()

  # should expect them to the same
  expect_equal(build_qtable(df,starts_with("Q1"),c(group,gender)),output)
  expect_equal(build_qtable(df,starts_with("Q1"),c(group,"gender")),output)
})

test_that("test that the adding the title works as expected",{
  df <-create_block_question_df()
  expect_equal(build_qtable(df,starts_with("Q1"),table_title = "Test") |> pull_title(),
               "Test")
})

test_that("test that adding a footnote manually is added correctly",{
  df <-create_block_question_df()
  expect_equal(build_qtable(df,starts_with("Q1"),table_title = "Test",footnote = "A footnote") |> pull_footnote(),
               "A footnote")
})

test_that("test that adding a footnote manually and adding footnote_question throws an erorr",{
  df <-create_block_question_df()
  expect_snapshot(build_qtable(df,starts_with("Q1"),table_title = "Test",use_questions = TRUE, footnote = "A footnote"),
                  error = TRUE)
})

test_that("using use_NA results in the expect removal",{
  df <-create_block_question_df() |>
    select(Q1_1, Q1_2)

  df[1,] <- c(NA,df[1,"Q1_2"])
  df[10,] <- c(df[10,"Q1_1"],NA)

  # There should be an NA in this output
  expect_true(build_qtable(df,starts_with("Q1"), use_NA = TRUE) |>
                is.na() |>
                any())
  # there are no NA's in any of
  # the columns
  expect_false(build_qtable(df,starts_with("Q1"), use_NA = FALSE) |>
                is.na() |>
                any())
})

test_that("use_questions pulls out the column names (the questions) as expected",{
  df <-create_block_question_df()

  # There should be an NA in this output
  expect_equal(build_qtable(df,starts_with("Q1"), c(gender2,gender3), use_questions = TRUE) |>
                 pull_footnote(),
               c("Questions",
                 "The sex of the participant",
                 "The gender of the participant"))
  })


test_that("use_questions pulls out the column names (the questions) as expected",{
  df <-create_block_question_df()

  # There should be an NA in this output
  expect_equal(build_qtable(df,starts_with("Q1"), c(gender2,gender3), use_questions = TRUE) |>
                 pull_footnote(),
               c("Questions",
                 "The sex of the participant",
                 "The gender of the participant"))
})


test_that("build_qtable removes NA for each question, instead of the entire observation if it contains a NA ", {
  # Create a sample data frame for a question block (Q1 with sub-questions Q1_a, Q1_b, Q1_c)
  test_data <- data.frame(
    ID = 1:5,  # Respondent IDs
    Q1_a = c("Yes", "No", NA, "Yes", "No"),  # Mix of valid and NA responses
    Q1_b = c("No", NA, "Yes", "Yes", "No"),
    Q1_c = c(NA, "Yes", "No", "No", NA),
    Q1_d = c(NA, "Yes", NA, NA, NA)
  ) |>
    mutate(across(everything(), ~factor(.x,c("Yes","No"))))

  # Run build_qtable on the question block (assuming it processes columns Q1_a, Q1_b, Q1_c)
  result <- build_qtable(test_data, all_of(c("Q1_a", "Q1_b", "Q1_c","Q1_d")))

  # Expected behavior:
  # - Respondent 1: Q1_a = Yes, Q1_b = No, Q1_c = NA (should contribute to Q1_a and Q1_b counts)
  # - Respondent 2: Q1_a = No, Q1_b = NA, Q1_c = Yes (should contribute to Q1_a and Q1_c counts)
  # - Respondent 3: Q1_a = NA, Q1_b = Yes, Q1_c = No (should contribute to Q1_b and Q1_c counts)
  # - Respondent 4: Q1_a = Yes, Q1_b = Yes, Q1_c = No (should contribute to all)
  # - Respondent 5: Q1_a = No, Q1_b = No, Q1_c = NA (should contribute to Q1_a and Q1_b counts)
  # - Total N = 5 (all respondents have at least one non-NA response)

  # Expected frequency table (example structure, adjust based on build_qtable output)
  expected <- tibble::tribble(
    ~`Question Block`, ~value, ~N, ~Percent,
    "Q1_a", "No", 2L, .50,
    "Q1_a", "Yes", 2L, .50,
    "Q1_b", "No", 2L, .50,
    "Q1_b", "Yes", 2L, .50,
    "Q1_c", "No", 2L, 2/3,
    "Q1_c", "Yes", 1L, 1/3,
    "Q1_d", "Yes", 1L, 1
  ) |>
    xlr_table() |>
    mutate(Percent = xlr_percent(Percent)) |>
    arrange(`Question Block`,desc(value))
  # Check that the output matches expected frequencies
  expect_equal(result, expected,info = "The xlr tables match")
})


test_that("build_qtable removes NA for each question, instead of the entire observation if it contains a NA ", {
  # Create a sample data frame for a question block (Q1 with sub-questions Q1_a, Q1_b, Q1_c)
  test_data <- data.frame(
    ID = 1:5,  # Respondent IDs
    Q1_a = c("Yes", "No", NA, "Yes", "No"),  # Mix of valid and NA responses
    Q1_b = c("No", NA, "Yes", "Yes", "No"),
    Q1_c = c(NA, "Yes", "No", "No", NA),
    Q1_d = c(NA, NA, NA, NA, NA)
  ) |>
    mutate(across(everything(), ~factor(.x,c("Yes","No"))))

  # Run build_qtable on the question block (assuming it processes columns Q1_a, Q1_b, Q1_c)
  result <- build_qtable(test_data, all_of(c("Q1_a", "Q1_b", "Q1_c","Q1_d")))

  # Expected frequency table (example structure, adjust based on build_qtable output)
  expected <- tibble::tribble(
    ~`Question Block`, ~value, ~N, ~Percent,
    "Q1_a", "No", 2L, .50,
    "Q1_a", "Yes", 2L, .50,
    "Q1_b", "No", 2L, .50,
    "Q1_b", "Yes", 2L, .50,
    "Q1_c", "No", 2L, 2/3,
    "Q1_c", "Yes", 1L, 1/3
  ) |>
    xlr_table() |>
    mutate(Percent = xlr_percent(Percent))|>
    arrange(`Question Block`,desc(value))
  # Check that the output matches expected frequencies
  expect_equal(result, expected,info = "The xlr tables match")
})

#- Claude tests

# Test suite for build_qtable input validation
test_that("build_qtable errors when block columns have different types", {
  # Create test data with mixed types
  test_data <- tibble(
    q1_numeric = c(1, 2, 3, 1, 2),
    q1_character = c("a", "b", "c", "a", "b"),
    q1_factor = factor(c("a", "b", "c", "a", "b"))
  )

  # Should error: numeric vs character
  expect_error(
    build_qtable(test_data, block_cols = c(q1_numeric, q1_character)),
    "do not have the same type"
  )

  # Should error: character vs factor
  expect_error(
    build_qtable(test_data, block_cols = c(q1_character, q1_factor)),
    "do not have the same type"
  )
})

test_that("build_qtable errors when factor block columns have different levels", {
  # Create factors with different levels
  test_data <- tibble(
    q1 = factor(c("Yes", "No", "Yes", "No"), levels = c("Yes", "No")),
    q2 = factor(c("Yes", "No", "Yes", "No"), levels = c("Yes", "No", "Maybe")),
    q3 = factor(c("Agree", "Disagree", "Agree", "Disagree"),
                levels = c("Agree", "Disagree"))
  )

  # Should error: q2 has extra level "Maybe"
  expect_error(
    build_qtable(test_data, block_cols = starts_with("q")),
    "columns you selected have different elements"
  )

  # Should error: q3 has completely different levels
  expect_error(
    build_qtable(test_data, block_cols = c(q1, q3)),
    "columns you selected have different elements"
  )
})

test_that("build_qtable errors with informative message showing problem column", {
  test_data <- tibble(
    q1 = factor(c("Yes", "No"), levels = c("Yes", "No")),
    q2 = factor(c("Yes", "No"), levels = c("Yes", "No")),
    q3 = factor(c("Yes", "No"), levels = c("Yes", "No", "Maybe"))
  )

  # Error message should mention q3
  expect_error(
    build_qtable(test_data, block_cols = starts_with("q")),
    "q3"
  )
})

test_that("build_qtable errors when haven_labelled columns have different labels", {
  # Create labelled data with different value labels
  test_data <- tibble(
    q1 = labelled(c(1, 2, 1, 2), labels = c("Yes" = 1, "No" = 2)),
    q2 = labelled(c(1, 2, 1, 2), labels = c("Agree" = 1, "Disagree" = 2)),
    q3 = labelled(c(1, 2, 1, 2), labels = c("Yes" = 1, "No" = 2, "Maybe" = 3))
  )

  # Should error: different labels
  expect_error(
    build_qtable(test_data, block_cols = c(q1, q2)),
    "columns you selected have different elements"
  )

  # Should error: different number of labels
  expect_error(
    build_qtable(test_data, block_cols = c(q1, q3)),
    "columns you selected have different elements"
  )
})

test_that("build_qtable handles edge cases with similar but not identical levels", {
  # Levels in different order (should still work with setequal)
  test_data1 <- tibble(
    q1 = factor(c("Yes", "No"), levels = c("Yes", "No")),
    q2 = factor(c("No", "Yes"), levels = c("No", "Yes"))
  )

  # This should NOT error because setequal ignores order
  expect_no_error(
    build_qtable(test_data1, block_cols = starts_with("q"))
  )

  # Levels with whitespace differences
  test_data2 <- tibble(
    q1 = factor(c("Yes", "No"), levels = c("Yes", "No")),
    q2 = factor(c("Yes ", "No"), levels = c("Yes ", "No"))
  )

  # Should error: "Yes" != "Yes "
  expect_error(
    build_qtable(test_data2, block_cols = starts_with("q")),
    "columns you selected have different elements"
  )
})

test_that("build_qtable errors when mixing labelled and unlabelled columns", {
  test_data <- tibble(
    q1 = labelled(c(1, 2, 1, 2), labels = c("Yes" = 1, "No" = 2)),
    q2 = c(1, 2, 1, 2)  # plain numeric
  )

  # Should error: different types
  expect_error(
    build_qtable(test_data, block_cols = starts_with("q")),
    "do not have the same type"
  )
})

test_that("build_qtable handles single column in block_cols", {
  test_data <- tibble(
    q1 = factor(c("Yes", "No", "Yes", "No"), levels = c("Yes", "No"))
  )

  # Should work with single column (no comparison needed)
  expect_no_error(
    build_qtable(test_data, block_cols = q1)
  )
})

test_that("build_qtable errors with subset/superset level relationships", {
  # q2 is a superset of q1 levels
  test_data <- tibble(
    q1 = factor(c("Yes", "No"), levels = c("Yes", "No")),
    q2 = factor(c("Yes", "No"), levels = c("Yes", "No", "Maybe", "Don't Know"))
  )

  # Should error even though q1 levels are subset of q2
  expect_error(
    build_qtable(test_data, block_cols = c(q1, q2)),
    "columns you selected have different elements"
  )
})

test_that("build_qtable errors when coerced factors have different levels", {
  # Character columns that when coerced to factors have different levels
  test_data <- tibble(
    q1 = c("a", "b", "c"),
    q2 = c("a", "b", "d")  # 'd' instead of 'c'
  )

  # Should error: different unique values
  expect_error(
    build_qtable(test_data, block_cols = starts_with("q")),
    "columns you selected have different elements"
  )
})

test_that("build_qtable provides helpful error message context", {
  test_data <- tibble(
    satisfaction_q1 = factor(c("Yes", "No"), levels = c("Yes", "No")),
    satisfaction_q2 = factor(c("Yes", "No"), levels = c("Yes", "No")),
    satisfaction_q3 = factor(c("Good", "Bad"), levels = c("Good", "Bad"))
  )

  error_msg <- tryCatch(
    build_qtable(test_data, block_cols = starts_with("satisfaction")),
    error = function(e) e
  )

  # Check that error message contains helpful suggestions
  expect_match(error_msg$body, "satisfaction_q3", all = FALSE)
  expect_match(error_msg$body, "converting your columns to factors", all = FALSE)
})

test_that("build_qtable correctly identifies first mismatched column", {
  test_data <- tibble(
    q1 = factor(c("A", "B"), levels = c("A", "B")),
    q2 = factor(c("A", "B"), levels = c("A", "B")),
    q3 = factor(c("X", "Y"), levels = c("X", "Y")),  # First mismatch
    q4 = factor(c("P", "Q"), levels = c("P", "Q"))   # Also different
  )

  # Should mention q3 as the first problematic column
  expect_error(
    build_qtable(test_data, block_cols = starts_with("q")),
    "q3"
  )
})

