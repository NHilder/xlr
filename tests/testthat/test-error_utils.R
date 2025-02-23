test_that("type_abort() works correctly", {
  x <- "test"
  expect_error(type_abort(x,is_double,1.1))
  x <- 1.1
  expect_silent(type_abort(x,is_double,1.1))

  x <- "test"
  expect_error(type_abort(x,is_double,NULL,'test type'))

  expect_snapshot(type_abort(x,is_double,1.1),
                  error = TRUE)
  expect_snapshot(type_abort(x,is_double,1.1,"a test type"),
                  error = TRUE)

})

test_that("is_true_or_false() works correctly", {
  expect_true(is_true_or_false(TRUE))
  expect_true(is_true_or_false(FALSE))
  expect_false(is_true_or_false(NA))
  expect_false(is_true_or_false(rep(TRUE, 2)))
  expect_false(is_true_or_false(1))
  expect_false(is_true_or_false(c(TRUE, "a")))
})
