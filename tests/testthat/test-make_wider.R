test_that("that errors from inputting an invalid x is caught correctly", {
  expect_snapshot(make_wider(1),
                  error = TRUE)

  expect_snapshot(make_wider("not_a_df"),
                  error = TRUE)
})

test_that("that errors from missing N or Percent is caught correctly", {
  df <- data.frame(a = 1)
  expect_snapshot(make_wider(df),
                  error = TRUE)

  df <- data.frame(N = c(1,2))
  expect_snapshot(make_wider(df),
                  error = TRUE)

  df <- data.frame(Percent = c(0.5,0.5))
  expect_snapshot(make_wider(df),
                  error = TRUE)
})

test_that("make_wider errors when only one grouping variable", {
  df <- data.frame(
    gender = c("f","m"),
    N = c(5,5),
    Percent = c(0.5,0.5)
  ) |>
    mutate(
      N = xlr_integer(N),
      Percent = xlr_percent(Percent)
    )
  expect_snapshot(make_wider(df),
                  error = TRUE)
})

test_that("make_wider works on the simple case", {
  # Using output from build_table similar
  df <- create_block_question_df()

  input <- build_table(df, c(group, gender))

  output <- data.frame(
    gender = c("f","m"),
    a = xlr_n_percent(c(2,3), c(0.4, 0.6)),
    b = xlr_n_percent(c(3,2), c(0.6,0.4))
  ) |>
    xlr_table()

  expect_equal(make_wider(input),
               output)
})

test_that("make_wider works with top_variable specified", {
  df <- create_block_question_df()

  input <- build_table(df, c(group, gender))

  output <- data.frame(
    group = c("a","b"),
    f = xlr_n_percent(c(2,3), c(.4,.6)),
    m = xlr_n_percent(c(3,2), c(.6,.4))
  ) |>
    xlr_table()

  expect_equal(make_wider(input, gender),
               output)
})

test_that("make_wider preserves dp and style", {
  df <- create_block_question_df()

  input <- build_table(df, c(group, gender)) |>
    mutate(Percent = xlr_percent(Percent, dp = 3L, style = xlr_format_numeric(font_size = 8)))

  result <- make_wider(input)

  expect_equal(pull_dp(result$a), 3L)
  expect_equal(pull_style(result$a), xlr_format_numeric(font_size = 8))

  expect_equal(pull_dp(result$b), 3L)
  expect_equal(pull_style(result$b), xlr_format_numeric(font_size = 8))
})

test_that("that errors from inputting an invalid top_variable is caught correctly", {
  df <- create_block_question_df()

  input <- build_table(df, c(group, gender))

  expect_snapshot(make_wider(input, not_a_col),
                  error = TRUE)
})

test_that("make_wider works with a call", {
  # Using output from build_table similar
  df <- create_block_question_df()

  expect_silent(df |>
    build_table(c(group, gender)) |>
    make_wider()
)
})
