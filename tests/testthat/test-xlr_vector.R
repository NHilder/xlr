


test_that("xlr_vector() empty intialisation works correctly", {
  # it should have class xlr_vector
  expect_s3_class(xlr_vector(),"xlr_vector")
  # it should be length zero
  expect_true(length(xlr_vector())==0)
  # it should have the default attributes
  expect_equal(pull_style(xlr_vector()),xlr_format())
})

test_that("xlr_vector() initialisation works with different types", {
  # all these should have class xlr_vector
  expect_s3_class(xlr_vector("1"),"xlr_vector")
  expect_s3_class(suppressWarnings(xlr_vector(1)),"xlr_vector")
  expect_s3_class(suppressWarnings(xlr_vector(1L)),"xlr_vector")
  expect_s3_class(xlr_vector(1i),"xlr_vector")
  expect_s3_class(xlr_vector(TRUE),"xlr_vector")
  expect_s3_class(xlr_vector(raw(1)),"xlr_vector")

  # it should have the correct vector length
  expect_equal(length(xlr_vector("1")),1)
  expect_equal(length(suppressWarnings(xlr_vector(1:100))),100)
  # we can update the attributes
  expect_equal(pull_style(xlr_vector(1,"0.0",xlr_format(12))),
               xlr_format(12))
})

test_that("is_xlr_vector() works",{
  var <- 1
  expect_true(is_xlr_vector(xlr_vector("1")))
  expect_true(is_xlr_vector(suppressWarnings(xlr_vector(1:10))))
  expect_true(is_xlr_vector(suppressWarnings(xlr_vector(var))))
  expect_true(is_xlr_vector(xlr_vector(NA)))
  expect_false(is_xlr_vector(NA))
  expect_false(is_xlr_vector(mtcars))
})


test_that("as_xlr_vector() converts numerics correctly",{
  expect_s3_class(suppressWarnings(as_xlr_vector(1)),
                  class = "xlr_vector",
                  exact = FALSE)
  expect_s3_class(suppressWarnings(as_xlr_vector(1L)),
                  class = "xlr_vector",
                  exact = FALSE)
  expect_s3_class(suppressWarnings(as_xlr_vector(1:10)),
                  class = "xlr_vector",
                  exact = FALSE)
  expect_s3_class(as_xlr_vector("A"),
                  class = "xlr_vector",
                  exact = FALSE)
  expect_s3_class(as_xlr_vector(FALSE),
                  class = "xlr_vector",
                  exact = FALSE)
})

test_that("xlr_vector.format prints all the types (we don't put rules on it)",{
  expect_output(print(xlr_vector("a")))
  expect_output(print(xlr_vector(TRUE)))
  expect_output(print(xlr_vector(2+1i)))
  expect_output(print(xlr_vector(raw(1))))
  expect_output(print(suppressWarnings(xlr_vector(1))))
  expect_output(print(suppressWarnings(xlr_vector(1L))))
})

