test_that("check that this is false for a R types ", {
  expect_false(is_xlr_type("a"))
  expect_false(is_xlr_type(1))
  expect_false(is_xlr_type(1L))
  expect_false(is_xlr_type(1.1))
})

test_that("check that this is true for the xlr format type", {
  expect_true(is_xlr_type(xlr_format()))
})

test_that("check that this is true for the xlr integer type", {
  expect_true(is_xlr_type(xlr_integer(1)))
})

test_that("check that this is true for the xlr numeric type", {
  expect_true(is_xlr_type(xlr_numeric(1)))
})

test_that("check that this is true for the xlr percent type", {
  expect_true(is_xlr_type(xlr_percent(1.1)))
})

test_that("check that this is true for the xlr table type", {
  expect_true(is_xlr_type(xlr_table(mtcars)))
})

test_that("check that this is true for the xlr vector type", {
  expect_true(is_xlr_type(xlr_vector("a")))
})

