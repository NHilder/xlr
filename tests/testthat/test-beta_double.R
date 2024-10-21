


test_that("beta_double() empty intialisation works correctly", {
  # it should have class beta_double
  expect_s3_class(beta_double(),"beta_double")
  # it should be length zero
  expect_true(length(beta_double())==0)
  # it should have the default attributes
  expect_equal(pull_dp(beta_double()),2)
  expect_equal(pull_style(beta_double()),beta_format())
})

test_that("beta_double() initialisation works", {
  # it should have class beta_double
  expect_s3_class(beta_double(1),"beta_double")
  # it should have the correct vector length
  expect_equal(length(beta_double(1)),1)
  expect_equal(length(beta_double(1:100)),100)
  # we can update the attributes
  expect_equal(pull_dp(beta_double(1,3)),3)
  expect_equal(pull_style(beta_double(1,3,beta_format(font_size = 8))),
               beta_format(font_size = 8))
})

test_that("beta_double() that dp is always a positive integer", {

  expect_error(beta_double(1,dp=-1L))
  expect_error(beta_double(1,dp=-1))
  expect_silent(beta_double(1,dp=0))
  expect_error(beta_double(1,dp=0.1))
  expect_error(beta_double(1,dp=0.0001))
  # excel only can maintain up to 15 significant figures
  # this is a bit of an edge case but only allow up to
  # 15-3 = 12 decimal places
  expect_error(beta_double(1,dp=110000))
})


test_that("is_beta_double() works",{
  var <- 1
  expect_true(is_beta_double(beta_double(1)))
  expect_true(is_beta_double(beta_double(1:10)))
  expect_true(is_beta_double(beta_double(var)))
  expect_true(is_beta_double(beta_double(var,dp=3)))
  expect_true(is_beta_double(beta_double(NA,dp=3)))
  expect_false(is_beta_double(NA))
  expect_false(is_beta_double(mtcars))
})


test_that("as_beta_double() converts numerics correctly",{
  expect_s3_class(as_beta_double(1),
                  class = "beta_double",
                  exact = FALSE)
  expect_s3_class(as_beta_double(1L),
                  class = "beta_double",
                  exact = FALSE)
  expect_s3_class(as_beta_double(1:10),
                  class = "beta_double",
                  exact = FALSE)
})

test_that("as_beta_double() converts characters() correctly",{
  expect_s3_class(as_beta_double("1.1"),
                  class = "beta_double",
                  exact = FALSE)
  expect_s3_class(as_beta_double(paste0(1:100/100)),
                  class = "beta_double",
                  exact = FALSE)
  expect_warning(as_beta_double("a"))
  expect_warning(as_beta_double("a"))
  expect_warning(as_beta_double("a1"))
})


test_that("beta_double.format prints the way we want it",{
  # verify_output is very cool, it helps us see if it works
  expect_snapshot(beta_double(1:100/100))
  expect_snapshot(beta_double(0:99/100,dp=2))
  expect_snapshot(tibble::tibble(test=beta_double(0:99/100,dp=2)))
})

test_that("symmetry for the prototyping (and that vec_c conversion works)",{
  expect_s3_class(vec_c(beta_double(1),1),
                  class = "beta_double",
                  exact = FALSE)
  expect_s3_class(vec_c(1,beta_double(1)),
                  class = "beta_double",
                  exact = FALSE)
  expect_s3_class(c(beta_double(1),1),
                  class = "beta_double",
                  exact = FALSE)

})

test_that("casting works as expected",{
  expect_s3_class(vec_cast(beta_double(1),beta_double()),
                  class = "beta_double",
                  exact = FALSE)

  # Not sure about the casting behaviour, it doesn't worry about changing
  # to a lower decimal places
  # to be fare this is just styling so it is probably ok

  expect_s3_class(vec_cast(beta_double(1),beta_double(dp=4)),
                  class = "beta_double",
                  exact = FALSE)
  expect_s3_class(vec_cast(beta_double(1,dp=4),beta_double()),
                  class = "beta_double",
                  exact = FALSE)
  expect_s3_class(vec_cast(1,beta_double(1)),
                  class = "beta_double",
                  exact = FALSE)
  expect_type(vec_cast(beta_double(1),1),
              type = "double")

})

# Arithmetic-----------------------------------
test_that("beta_doubles should do everything and get back a beta double",{
  # test every operation works
  expect_equal(beta_double(1)+beta_double(1),beta_double(2))
  expect_equal(beta_double(1)-beta_double(.5),beta_double(.5))
  expect_equal(beta_double(.2)*beta_double(1),beta_double(.2))
  expect_equal(beta_double(1)/beta_double(1),beta_double(1))
  expect_equal(beta_double(1)^beta_double(2),beta_double(1))
  expect_equal(beta_double(3)%%beta_double(2),beta_double(1))
})

test_that("beta_doubles should work with all numerics and
          return a beta_double",{

  expect_equal(1+beta_double(1),beta_double(2))
  expect_equal(beta_double(1)+1,beta_double(2))

  expect_equal(1-beta_double(.5),beta_double(.5))
  expect_equal(beta_double(.5)-1,beta_double(-.5))

  expect_equal(1*beta_double(1),beta_double(1))
  expect_equal(beta_double(1)*1,beta_double(1))

  expect_equal(1/beta_double(1),beta_double(1))
  expect_equal(beta_double(1)/1,beta_double(1))

  expect_equal(1^beta_double(2),beta_double(1))
  expect_equal(beta_double(2)^1,beta_double(2))

  expect_equal(3%%beta_double(2),beta_double(1))
  expect_equal(beta_double(3)%%2,beta_double(1))
})
