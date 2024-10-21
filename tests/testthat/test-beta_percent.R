


test_that("beta_percent() empty intialisation works correctly", {
  # it should have class beta_percent
  expect_s3_class(beta_percent(),"beta_percent")
  # it should be length zero
  expect_true(length(beta_percent())==0)
  # it should have the default attributes
  expect_equal(pull_dp(beta_percent()),0)
  expect_equal(pull_style(beta_percent()),beta_format())
})

test_that("beta_percent() initialisation works", {
  # it should have class beta_percent
  expect_s3_class(beta_percent(1),"beta_percent")
  # it should have the correct vector length
  expect_equal(length(beta_percent(1)),1)
  expect_equal(length(beta_percent(1:100)),100)
  # we can update the attributes
  expect_equal(pull_dp(beta_percent(1,3)),3)
  expect_equal(pull_style(beta_percent(1,3,beta_format(2))),
               beta_format(2))
})

test_that("beta_percent() can be initalised from a beta_percent, and it only keeps the original data", {
  x <- beta_percent(0.1)
  expect_s3_class(beta_percent(x),"beta_percent")
  expect_equal(beta_percent(x,2),beta_percent(0.1,2))
})


test_that("beta_percent() that dp is always a positive integer", {

  expect_error(beta_percent(1,dp=-1L))
  expect_error(beta_percent(1,dp=-1))
  expect_silent(beta_percent(1,dp=0))
  expect_error(beta_percent(1,dp=0.1))
  expect_error(beta_percent(1,dp=0.0001))
  # excel only can maintain up to 15 significant figures
  # this is a bit of an edge case but only allow up to
  # 15-3 = 12 decimal places
  expect_error(beta_percent(1,dp=110000))
})


test_that("is_beta_percent() works",{
  var <- 1
  expect_true(is_beta_percent(beta_percent(1)))
  expect_true(is_beta_percent(beta_percent(1:10)))
  expect_true(is_beta_percent(beta_percent(var)))
  expect_true(is_beta_percent(beta_percent(var,dp=3)))
  expect_true(is_beta_percent(beta_percent(NA,dp=3)))
  expect_false(is_beta_percent(NA))
  expect_false(is_beta_percent(mtcars))
})


test_that("as_beta_percent() converts numerics correctly",{
  expect_s3_class(as_beta_percent(1),
                  class = "beta_percent",
                  exact = FALSE)
  expect_s3_class(as_beta_percent(1L),
                  class = "beta_percent",
                  exact = FALSE)
  expect_s3_class(as_beta_percent(1:10),
                  class = "beta_percent",
                  exact = FALSE)
})

test_that("as_beta_percent() converts characters() correctly",{
  expect_s3_class(as_beta_percent("1.1%"),
                  class = "beta_percent",
                  exact = FALSE)
  expect_s3_class(as_beta_percent(paste0(1:100/100,"%")),
                  class = "beta_percent",
                  exact = FALSE)
  expect_warning(as_beta_percent("a"))
  expect_warning(as_beta_percent("a%"))
  expect_warning(as_beta_percent("a1%"))
})

test_that("as_beta_percent() takes arguements nicely",{
  expect_equal(as_beta_percent("1.1%",2),
              beta_percent(0.011,2))
  expect_equal(as_beta_percent("1.1%",2,beta_format(8))|>
                 pull_style(),
               beta_format(8))

  # expect an error
  expect_error(as_beta_percent("1.1%",2,"wee"))
})


test_that("beta_percent.format prints the way we want it",{
  # verify_output is very cool, it helps us see if it works
  expect_snapshot(beta_percent(1:100/100))
  expect_snapshot(beta_percent(0:99/100,dp=2))
  expect_snapshot(tibble::tibble(test=beta_percent(0:99/100,dp=2)))
})

test_that("symmetry for the prototyping (and that vec_c conversion works)",{
  expect_s3_class(vec_c(beta_percent(1),1),
                  class = "beta_percent",
                  exact = FALSE)
  expect_s3_class(vec_c(1,beta_percent(1)),
                  class = "beta_percent",
                  exact = FALSE)
  expect_s3_class(c(beta_percent(1),1),
                  class = "beta_percent",
                  exact = FALSE)

})

test_that("casting works as expected",{
  expect_s3_class(vec_cast(beta_percent(1),beta_percent()),
                  class = "beta_percent",
                  exact = FALSE)

  # Not sure about the casting behaviour, it doesn't worry about changing
  # to a lower decimal places
  # to be fare this is just styling so it is probably ok

  expect_s3_class(vec_cast(beta_percent(1),beta_percent(dp=4)),
                  class = "beta_percent",
                  exact = FALSE)
  expect_s3_class(vec_cast(beta_percent(1,dp=4),beta_percent()),
                  class = "beta_percent",
                  exact = FALSE)
  expect_s3_class(vec_cast(1,beta_percent(1)),
                  class = "beta_percent",
                  exact = FALSE)
  expect_type(vec_cast(beta_percent(1),1),
                  type = "double")

})


test_that("casting to a beta_percent pulls the beta_percent data",{
  expect_equal(vec_cast(beta_percent(1),beta_percent(dp=4)) |>
                 pull_dp(),
              4L)
  expect_equal(vec_cast(beta_percent(1,dp=4),beta_percent()) |>
                    pull_dp(),
                  0L)
  expect_equal(vec_cast(1,beta_percent(1,style = beta_format(8))) |>
                 pull_style(),
               beta_format(8))
})


test_that("casting works as expected",{
  expect_s3_class(vec_cast(beta_percent(1),beta_percent()),
                  class = "beta_percent",
                  exact = FALSE)

  # Not sure about the casting behaviour, it doesn't worry about changing
  # to a lower decimal places
  # to be fare this is just styling so it is probably ok

  expect_s3_class(vec_cast(beta_percent(1),beta_percent(dp=4)),
                  class = "beta_percent",
                  exact = FALSE)
  expect_s3_class(vec_cast(beta_percent(1,dp=4),beta_percent()),
                  class = "beta_percent",
                  exact = FALSE)
  expect_s3_class(vec_cast(1,beta_percent(1)),
                  class = "beta_percent",
                  exact = FALSE)
  expect_type(vec_cast(beta_percent(1),1),
              type = "double")

})

# Arithmetic-----------------------------------
test_that("percentages only define add, subtract and multiplication
          for beta_percent beta_percent operations",{

  expect_equal(beta_percent(1)+beta_percent(1),beta_percent(2))
  expect_equal(beta_percent(1)-beta_percent(.5),beta_percent(.5))
  expect_equal(beta_percent(.2)*beta_percent(1),beta_percent(.2))

  # now we want to expect errors
  expect_error(beta_percent(1)/beta_percent(1),
               class = "vctrs_error_incompatible_op")
  expect_error(beta_percent(1)^beta_percent(.5),
               class = "vctrs_error_incompatible_op")
  expect_error(beta_percent(.2)%%beta_percent(1),
               class = "vctrs_error_incompatible_op")
})

test_that("percentages and double multiplication returns a double, divsion returns a beta_percent",{

            expect_equal(beta_percent(1)*2,2)
            expect_equal(2*beta_percent(1),2)
            expect_equal(beta_percent(1)/2,beta_percent(0.5))

            # now we want to expect errors
            expect_error(1/beta_percent(1),
                         class = "vctrs_error_incompatible_op")
            expect_error(1^beta_percent(.5),
                         class = "vctrs_error_incompatible_op")
            expect_error(1%%beta_percent(1),
                         class = "vctrs_error_incompatible_op")
          })
