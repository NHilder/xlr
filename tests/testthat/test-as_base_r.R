test_that("check that as_base_r works for an xlr_numeric", {
  expect_equal(xlr_numeric(1:10) |>
                 as_base_r(),
               1:10)

  expect_equal(xlr_numeric(mtcars$mpg) |>
                 as_base_r(),
               mtcars$mpg)
})

test_that("check that as_base_r works for an xlr_integer", {
  expect_equal(xlr_integer(1:10) |>
                 as_base_r(),
               1L:10L)
})

test_that("check that as_base_r works for an xlr_percent", {
  expect_equal(xlr_percent(1:10/10) |>
                 as_base_r(),
               1:10/10)
})


test_that("check that as_base_r works for an xlr_vector", {
  expect_equal(xlr_vector(names(mtcars)) |>
                 as_base_r(),
               names(mtcars))
})

test_that("check that as_base_r works for an xlr_table", {
  out <- mtcars
  row.names(out) <- NULL
  expect_equal(xlr_table(mtcars,"test","test") |>
                 as_base_r(),
               out)
})

test_that("check that as_base_r does nothing when a vector or data.frame is already a base type", {
  expect_equal(as_base_r(1:10),1:10)
  expect_equal(as_base_r(mtcars),mtcars)
  expect_equal(as_base_r(mtcars$mpg),mtcars$mpg)
})
