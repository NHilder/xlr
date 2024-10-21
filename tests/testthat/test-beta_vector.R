


test_that("beta_vector() empty intialisation works correctly", {
  # it should have class beta_vector
  expect_s3_class(beta_vector(),"beta_vector")
  # it should be length zero
  expect_true(length(beta_vector())==0)
  # it should have the default attributes
  expect_equal(pull_style(beta_vector()),beta_format())
})

test_that("beta_vector() initialisation works with different types", {
  # all these should have class beta_vector
  expect_s3_class(beta_vector("1"),"beta_vector")
  expect_s3_class(suppressWarnings(beta_vector(1)),"beta_vector")
  expect_s3_class(suppressWarnings(beta_vector(1L)),"beta_vector")
  expect_s3_class(beta_vector(1i),"beta_vector")
  expect_s3_class(beta_vector(TRUE),"beta_vector")
  expect_s3_class(beta_vector(raw(1)),"beta_vector")

  # it should have the correct vector length
  expect_equal(length(beta_vector("1")),1)
  expect_equal(length(suppressWarnings(beta_vector(1:100))),100)
  # we can update the attributes
  expect_equal(pull_style(beta_vector(1,"0.0",beta_format(12))),
               beta_format(12))
})

test_that("is_beta_vector() works",{
  var <- 1
  expect_true(is_beta_vector(beta_vector("1")))
  expect_true(is_beta_vector(suppressWarnings(beta_vector(1:10))))
  expect_true(is_beta_vector(suppressWarnings(beta_vector(var))))
  expect_true(is_beta_vector(beta_vector(NA)))
  expect_false(is_beta_vector(NA))
  expect_false(is_beta_vector(mtcars))
})


test_that("as_beta_vector() converts numerics correctly",{
  expect_s3_class(suppressWarnings(as_beta_vector(1)),
                  class = "beta_vector",
                  exact = FALSE)
  expect_s3_class(suppressWarnings(as_beta_vector(1L)),
                  class = "beta_vector",
                  exact = FALSE)
  expect_s3_class(suppressWarnings(as_beta_vector(1:10)),
                  class = "beta_vector",
                  exact = FALSE)
  expect_s3_class(as_beta_vector("A"),
                  class = "beta_vector",
                  exact = FALSE)
  expect_s3_class(as_beta_vector(FALSE),
                  class = "beta_vector",
                  exact = FALSE)
})

test_that("beta_vector.format prints all the types (we don't put rules on it)",{
  expect_output(print(beta_vector("a")))
  expect_output(print(beta_vector(TRUE)))
  expect_output(print(beta_vector(2+1i)))
  expect_output(print(beta_vector(raw(1))))
  expect_output(print(suppressWarnings(beta_vector(1))))
  expect_output(print(suppressWarnings(beta_vector(1L))))
})

