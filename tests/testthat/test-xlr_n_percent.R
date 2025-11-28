
test_that("xlr_n_percent() empty initialization works correctly", {
  # it should have class xlr_n_percent
  expect_s3_class(xlr_n_percent(), "xlr_n_percent")
  # it should be length zero
  expect_true(length(xlr_n_percent()) == 0)
  # it should have the default attributes
  expect_equal(pull_dp(xlr_n_percent()), 0)
  expect_equal(pull_style(xlr_n_percent()), xlr_format_numeric())
})

test_that("xlr_n_percent() initialization works", {
  # it should have class xlr_n_percent
  expect_s3_class(xlr_n_percent(n = 1, pct = 0.5), "xlr_n_percent")
  # it should have the correct vector length
  expect_equal(length(xlr_n_percent(n = 1, pct = 0.5)), 1)
  expect_equal(length(xlr_n_percent(n = 1:100, pct = (1:100)/100)), 100)
  # we can update the attributes
  expect_equal(pull_dp(xlr_n_percent(n = 1, pct = 0.5, dp = 3)), 3)
  expect_equal(pull_style(xlr_n_percent(n = 1, pct = 0.5, style = xlr_format_numeric(font_size = 8))),
               xlr_format_numeric(font_size = 8))
})

test_that("validate_xlr_n_percent() checks lengths, NAs, and dp correctly", {
  expect_error(xlr_n_percent(n = 1:2, pct = 0.5), "Lengths of `n` and `pct` do not match")
  expect_error(xlr_n_percent(n = c(1, NA), pct = c(NA, 0.5)), "NA' positions in both vectors must match")
  expect_error(xlr_n_percent(n = 1, pct = 0.5, dp = 13), "'dp' must be less than or equal to 12")
  expect_silent(xlr_n_percent(n = 1, pct = 0.5, dp = 12))
  expect_error(xlr_n_percent(n = 1, pct = 0.5, dp = -1), "'dp' must be a positive integer.")
})

test_that("is_xlr_n_percent() works", {
  var_n <- 1
  var_pct <- 0.5
  expect_true(is_xlr_n_percent(xlr_n_percent(n = 1, pct = 0.5)))
  expect_true(is_xlr_n_percent(xlr_n_percent(n = 1:10, pct = (1:10)/10)))
  expect_true(is_xlr_n_percent(xlr_n_percent(n = var_n, pct = var_pct)))
  expect_true(is_xlr_n_percent(xlr_n_percent(n = var_n, pct = var_pct, dp = 3)))
  expect_true(is_xlr_n_percent(xlr_n_percent(n = NA, pct = NA, dp = 3)))
  expect_false(is_xlr_n_percent(NA))
  expect_false(is_xlr_n_percent(mtcars))
})

test_that("xlr_n_percent.format prints the way we want it", {
  # verify_output is very cool, it helps us see if it works
  expect_snapshot(xlr_n_percent(n = 1:100, pct = (1:100)/100))
  expect_snapshot(xlr_n_percent(n = 0:99, pct = (0:99)/100, dp = 2))
  expect_snapshot(tibble::tibble(test = xlr_n_percent(n = 0:99, pct = (0:99)/100, dp = 2)))
})

test_that("symmetry for the prototyping (and that vec_c conversion works)", {
  expect_s3_class(vec_c(xlr_n_percent(n = 1, pct = 0.5), xlr_n_percent(n = 1, pct = 0.5)),
                  class = "xlr_n_percent",
                  exact = FALSE)
  expect_s3_class(c(xlr_n_percent(n = 1, pct = 0.5), xlr_n_percent(n = 1, pct = 0.5)),
                  class = "xlr_n_percent",
                  exact = FALSE)
})

test_that("casting works as expected", {
  expect_s3_class(vec_cast(xlr_n_percent(n = 1, pct = 0.5), xlr_n_percent()),
                  class = "xlr_n_percent",
                  exact = FALSE)
  expect_s3_class(vec_cast(xlr_n_percent(n = 1, pct = 0.5), xlr_n_percent(dp = 4)),
                  class = "xlr_n_percent",
                  exact = FALSE)
  expect_s3_class(vec_cast(xlr_n_percent(n = 1, pct = 0.5, dp = 4), xlr_n_percent()),
                  class = "xlr_n_percent",
                  exact = FALSE)
})

# Arithmetic-----------------------------------
test_that("xlr_n_percents should do everything and get back a xlr_n_percent", {
  # test every operation works
  expect_equal(xlr_n_percent(n = 1, pct = 1) + xlr_n_percent(n = 1, pct = 1),
               xlr_n_percent(n = 2, pct = 2))
  expect_error(
    xlr_n_percent(n = 1, pct = 1) - xlr_n_percent(n = 5, pct = 0.5),
    "'n' must only contain positive integers."
  )
  expect_equal(
    xlr_n_percent(n = 1, pct = 1) - xlr_n_percent(n = 1, pct = 0.5),
    xlr_n_percent(n = 0, pct = 0.5)
  )
  expect_equal(xlr_n_percent(n = 2, pct = 0.2) * xlr_n_percent(n = 1, pct = 1),
               xlr_n_percent(n = 2, pct = 0.2))
  expect_equal(xlr_n_percent(n = 1, pct = 1) / xlr_n_percent(n = 1, pct = 1),
               xlr_n_percent(n = 1, pct = 1))
  expect_equal(xlr_n_percent(n = 1, pct = 1) ^ xlr_n_percent(n = 2, pct = 2),
               xlr_n_percent(n = 1, pct = 1))
  expect_equal(xlr_n_percent(n = 3, pct = 3) %% xlr_n_percent(n = 2, pct = 2),
               xlr_n_percent(n = 1, pct = 1))
})

test_that("vec_ptype2.xlr_n_percent.xlr_n_percent raises warning when things don't match", {
  # first check it raises a warning
  expect_snapshot(c(xlr_n_percent(n = 1, pct = 0.5), xlr_n_percent(n = 1, pct = 0.5, dp = 3)))
})

test_that("vec_arith.xlr_n_percent.xlr_n_percent raises warning when things don't match", {
  # first check it raises a warning
  expect_snapshot(xlr_n_percent(n = 1, pct = 0.5) + xlr_n_percent(n = 1, pct = 0.5, dp = 3))
})

test_that("vec_arith.xlr_n_percent.xlr_n_percent raises an error when things don't match", {
  # first check it raises a warning
  expect_error(xlr_n_percent(n = 1, pct = 0.5) + TRUE, class = "vctrs_error_incompatible")
})
