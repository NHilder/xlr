library(testthat)
library(dplyr)

test_that("remove_NA removes rows where any column is NA (complete = TRUE)", {
  df <- data.frame(
    x = c(1, 2, NA, 4),
    y = c(1, NA, 3, 4),
    z = c(1, 2, 3, 4)
  )

  result <- remove_NA(df, c(x, y), complete = TRUE)

  expect_equal(nrow(result), 2)
  expect_equal(result$x, c(1, 4))
  expect_equal(result$y, c(1, 4))
})

test_that("remove_NA removes rows where all columns are NA (complete = FALSE)", {
  df <- data.frame(
    x = c(1, NA, NA, 4),
    y = c(1, 2, NA, 4),
    z = c(1, 2, 3, 4)
  )

  result <- remove_NA(df, c(x, y), complete = FALSE)

  expect_equal(nrow(result), 3)
  expect_equal(result$x, c(1, NA, 4))
  expect_equal(result$y, c(1, 2, 4))
})

test_that("remove_NA uses complete = TRUE as default", {
  df <- data.frame(
    x = c(1, NA, 3, 4),
    y = c(1, 2, 3, 4)
  )

  result <- remove_NA(df, x)

  expect_equal(nrow(result), 3)
  expect_false(any(is.na(result$x)))
})

test_that("remove_NA works with single column", {
  df <- data.frame(
    x = c(1, NA, 3, 4),
    y = c(1, 2, 3, 4)
  )

  result_default <- remove_NA(df, x)
  result_true <- remove_NA(df, x, complete = TRUE)

  expect_equal(result_default, result_true)
  expect_equal(nrow(result_default), 3)
  expect_false(any(is.na(result_default$x)))
})

test_that("remove_NA returns unchanged data when no columns selected", {
  df <- data.frame(
    x = c(1, NA, 3),
    y = c(1, 2, 3)
  )

  result <- remove_NA(df, starts_with("z"))

  expect_equal(result, df)
})

test_that("remove_NA works with tidy-select helpers", {
  df <- data.frame(
    x_1 = c(1, NA, 3),
    x_2 = c(1, 2, NA),
    y = c(1, 2, 3)
  )

  result <- remove_NA(df, starts_with("x"), complete = TRUE)

  expect_equal(nrow(result), 1)
  expect_equal(result$x_1, 1)
})

test_that("remove_NA preserves all columns", {
  df <- data.frame(
    x = c(1, NA, 3),
    y = c(1, 2, 3),
    z = c(4, 5, 6)
  )

  result <- remove_NA(df, x)

  expect_equal(ncol(result), 3)
  expect_true(all(c("x", "y", "z") %in% names(result)))
})

test_that("remove_NA handles all NA columns correctly with complete = TRUE", {
  df <- data.frame(
    x = c(NA, NA, NA),
    y = c(1, 2, 3)
  )

  result <- remove_NA(df, x, complete = TRUE)

  expect_equal(nrow(result), 0)
})

test_that("remove_NA handles all NA columns correctly with complete = FALSE", {
  df <- data.frame(
    x = c(NA, NA, NA),
    y = c(1, 2, 3)
  )

  result <- remove_NA(df, x, complete = FALSE)

  expect_equal(nrow(result), 0)
})

test_that("remove_NA handles no NA columns correctly", {
  df <- data.frame(
    x = c(1, 2, 3),
    y = c(4, 5, 6)
  )

  result <- remove_NA(df, c(x, y))

  expect_equal(result, df)
})

test_that("remove_NA with complete = FALSE keeps rows with at least one non-NA", {
  df <- data.frame(
    x = c(1, NA, NA, 4),
    y = c(1, NA, NA, 4),
    z = c(1, 2, 3, 4)
  )

  result <- remove_NA(df, c(x, y), complete = FALSE)

  expect_equal(nrow(result), 2)
  expect_equal(result$x, c(1, 4))
  expect_equal(result$z, c(1, 4))
})

test_that("remove_NA distinguishes between complete TRUE and FALSE", {
  df <- data.frame(
    x = c(1, NA, NA, 4, NA),
    y = c(NA, 2, NA, 4, NA),
    z = c(1, 2, 3, 4, 5)
  )

  result_true <- remove_NA(df, c(x, y), complete = TRUE)
  result_false <- remove_NA(df, c(x, y), complete = FALSE)

  # complete = TRUE: removes rows where all is NA (rows 3, 5)
  expect_equal(nrow(result_true), 1)
  expect_equal(result_true$z, 4)

  # complete = FALSE: removes rows where ALL are NA (row 5 only)
  expect_equal(nrow(result_false), 3)
  expect_equal(result_false$z, c(1, 2, 4))
})

test_that("remove_NA works correctly with example from documentation", {
  df <- data.frame(
    x = c(1, 2, NA, 4, NA),
    y = c(NA, 2, 3, NA, NA),
    z = c(1, 2, 3, 4, 5)
  )

  # Default behavior (complete = TRUE): remove if ANY is NA
  result_default <- remove_NA(df, c(x, y))
  expect_equal(nrow(result_default), 1)
  expect_equal(result_default$x, 2)

  # complete = FALSE: remove if ALL are NA
  result_false <- remove_NA(df, c(x, y), complete = FALSE)
  expect_equal(nrow(result_false), 4)
  expect_equal(result_false$z, c(1, 2, 3, 4))
})

test_that("remove_NA works within a function silently", {
  df <- data.frame(
    x = c(1, NA, NA, 4),
    y = c(1, NA, NA, 4),
    z = c(1, 2, 3, 4)
  )

  foo <- function(data,selection){
    remove_NA(data, {{selection}}, complete = FALSE)
  }

  expect_silent(foo(df,c("x","y")))
})


test_that("remove_NA handles NULL", {
  expect_silent(remove_NA(mtcars, NULL, complete = FALSE))
})

test_that("remove_NA handles NULL inside another function", {
  foo <- function(selection=NULL){
    remove_NA(mtcars, {{selection}}, complete = FALSE)
  }
  expect_silent(foo())
})
