


test_that("beta_integer() empty intialisation works correctly", {
  # it should have class beta_integer
  expect_s3_class(beta_integer(),"beta_integer")
  # it should be length zero
  expect_true(length(beta_integer())==0)
  # it should have the default attributes
  expect_equal(pull_style(beta_integer()),beta_format())
})

test_that("beta_integer() initialisation works", {
  # it should have class beta_integer
  expect_s3_class(beta_integer(1),"beta_integer")
  # it should have the correct vector length
  expect_equal(length(beta_integer(1)),1)
  expect_equal(length(beta_integer(1:100)),100)
  # we can update the attributes
  expect_equal(pull_style(beta_integer(1,beta_format(font_size=11))),
               beta_format(font_size=11))
})

test_that("is_beta_integer() works",{
  var <- 1
  expect_true(is_beta_integer(beta_integer(1)))
  expect_true(is_beta_integer(beta_integer(1:10)))
  expect_true(is_beta_integer(beta_integer(var)))
  expect_true(is_beta_integer(beta_integer(NA)))
  expect_false(is_beta_integer(NA))
  expect_false(is_beta_integer(mtcars))
})


test_that("as_beta_integer() converts numerics correctly",{
  expect_s3_class(as_beta_integer(1),
                  class = "beta_integer",
                  exact = FALSE)
  expect_s3_class(as_beta_integer(1L),
                  class = "beta_integer",
                  exact = FALSE)
  expect_s3_class(as_beta_integer(1:10),
                  class = "beta_integer",
                  exact = FALSE)
})

test_that("as_beta_integer() converts characters() correctly",{
  expect_s3_class(as_beta_integer("1"),
                  class = "beta_integer",
                  exact = FALSE)
  expect_s3_class(as_beta_integer(paste0(1:100)),
                  class = "beta_integer",
                  exact = FALSE)
  expect_warning(as_beta_integer("a"))
  expect_warning(as_beta_integer("a"))
  expect_warning(as_beta_integer("a1"))
})


test_that("beta_integer.format prints the way we want it",{
  # verify_output is very cool, it helps us see if it works
  expect_snapshot(beta_integer(1:100))
  expect_snapshot(tibble::tibble(test=beta_integer(0:99)))
})

test_that("symmetry for the prototyping (and that vec_c conversion works)",{
  expect_s3_class(vec_c(beta_integer(1),1L),
                  class = "beta_integer",
                  exact = FALSE)
  expect_s3_class(vec_c(1L,beta_integer(1)),
                  class = "beta_integer",
                  exact = FALSE)
})

test_that("casting works as expected",{
  expect_s3_class(vec_cast(beta_integer(1),beta_integer()),
                  class = "beta_integer",
                  exact = FALSE)

  # Not sure about the casting behaviour, it doesn't worry about changing
  # to a lower decimal places
  # to be fare this is just styling so it is probably ok

  expect_s3_class(vec_cast(beta_integer(1),beta_integer()),
                  class = "beta_integer",
                  exact = FALSE)
  expect_s3_class(vec_cast(beta_integer(1),beta_integer()),
                  class = "beta_integer",
                  exact = FALSE)
  expect_s3_class(vec_cast(1,beta_integer(1)),
                  class = "beta_integer",
                  exact = FALSE)
  expect_type(vec_cast(beta_integer(1),1L),
              type = "integer")

})

test_that("Casting within a function works as expected, when casting from a
          beta_integer to a double()",{
  foo <- function(x){
    new_x <- vec_cast(x, double())
    class(new_x)
  }
  expect_equal(foo(beta_integer(100)),
               "numeric")
})

# Arithmetic-----------------------------------
test_that("beta_integers should not calculate division",{
  # test every operation works
  expect_equal(beta_integer(1)+beta_integer(1),beta_integer(2))
  expect_equal(beta_integer(1)-beta_integer(0),beta_integer(1))
  expect_equal(beta_integer(2)*beta_integer(1),beta_integer(2))
  expect_equal(beta_integer(1)^beta_integer(2),beta_integer(1))
  expect_equal(beta_integer(3)%%beta_integer(2),beta_integer(1))

  expect_error(beta_integer(1)/beta_integer(1))
})

test_that("beta_integers should work with all numerics and
          return it's type (we lose the other info)",{

  expect_equal(1+beta_integer(1),2)
  expect_equal(beta_integer(1)+1,2)
#
#   expect_equal(1-beta_integer(.5),beta_integer(.5))
#   expect_equal(beta_integer(.5)-1,beta_integer(-.5))
#
#   expect_equal(1*beta_integer(1),beta_integer(1))
#   expect_equal(beta_integer(1)*1,beta_integer(1))
#
#   expect_equal(1/beta_integer(1),beta_integer(1))
#   expect_equal(beta_integer(1)/1,beta_integer(1))
#
#   expect_equal(1^beta_integer(2),beta_integer(1))
#   expect_equal(beta_integer(2)^1,beta_integer(2))
#
#   expect_equal(3%%beta_integer(2),beta_integer(1))
#   expect_equal(beta_integer(3)%%2,beta_integer(1))
})
