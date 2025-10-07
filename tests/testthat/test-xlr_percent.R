


test_that("xlr_percent() empty intialisation works correctly", {
  # it should have class xlr_percent
  expect_s3_class(xlr_percent(),"xlr_percent")
  # it should be length zero
  expect_true(length(xlr_percent())==0)
  # it should have the default attributes
  expect_equal(pull_dp(xlr_percent()),0)
  expect_equal(pull_style(xlr_percent()),xlr_format_numeric())
})

test_that("xlr_percent() initialisation works", {
  # it should have class xlr_percent
  expect_s3_class(xlr_percent(1),"xlr_percent")
  # it should have the correct vector length
  expect_equal(length(xlr_percent(1)),1)
  expect_equal(length(xlr_percent(1:100)),100)
  # we can update the attributes
  expect_equal(pull_dp(xlr_percent(1,3)),3)
  expect_equal(pull_style(xlr_percent(1,3,xlr_format(2))),
               xlr_format(2))
})

test_that("xlr_percent() can be initalised from a xlr_percent, and it only keeps the original data", {
  x <- xlr_percent(0.1)
  expect_s3_class(xlr_percent(x),"xlr_percent")
  expect_equal(xlr_percent(x,2),xlr_percent(0.1,2))
})


test_that("xlr_percent() that dp is always a positive integer", {

  expect_error(xlr_percent(1,dp=-1L))
  expect_error(xlr_percent(1,dp=-1))
  expect_silent(xlr_percent(1,dp=0))
  expect_error(xlr_percent(1,dp=0.1))
  expect_error(xlr_percent(1,dp=0.0001))
  # `Excel` only can maintain up to 15 significant figures
  # this is a bit of an edge case but only allow up to
  # 15-3 = 12 decimal places
  expect_error(xlr_percent(1,dp=110000))
})


test_that("is_xlr_percent() works",{
  var <- 1
  expect_true(is_xlr_percent(xlr_percent(1)))
  expect_true(is_xlr_percent(xlr_percent(1:10)))
  expect_true(is_xlr_percent(xlr_percent(var)))
  expect_true(is_xlr_percent(xlr_percent(var,dp=3)))
  expect_true(is_xlr_percent(xlr_percent(NA,dp=3)))
  expect_false(is_xlr_percent(NA))
  expect_false(is_xlr_percent(mtcars))
})


test_that("as_xlr_percent() converts numerics correctly",{
  expect_s3_class(as_xlr_percent(1),
                  class = "xlr_percent",
                  exact = FALSE)
  expect_s3_class(as_xlr_percent(1L),
                  class = "xlr_percent",
                  exact = FALSE)
  expect_s3_class(as_xlr_percent(1:10),
                  class = "xlr_percent",
                  exact = FALSE)
})

test_that("as_xlr_percent() converts characters() correctly",{
  expect_s3_class(as_xlr_percent("1.1%"),
                  class = "xlr_percent",
                  exact = FALSE)
  expect_s3_class(as_xlr_percent(paste0(1:100/100,"%")),
                  class = "xlr_percent",
                  exact = FALSE)
  expect_warning(as_xlr_percent("a"))
  expect_warning(as_xlr_percent("a%"))
  expect_warning(as_xlr_percent("a1%"))
})

test_that("as_xlr_percent() takes arguements nicely",{
  expect_equal(as_xlr_percent("1.1%",2),
              xlr_percent(0.011,2))
  expect_equal(as_xlr_percent("1.1%",2,xlr_format(8))|>
                 pull_style(),
               xlr_format(8))

  # expect an error
  expect_error(as_xlr_percent("1.1%",2,"wee"))
})


test_that("xlr_percent.format prints the way we want it",{
  # verify_output is very cool, it helps us see if it works
  expect_snapshot(xlr_percent(1:100/100))
  expect_snapshot(xlr_percent(0:99/100,dp=2))
  expect_snapshot(tibble::tibble(test=xlr_percent(0:99/100,dp=2)))
})

test_that("symmetry for the prototyping (and that vec_c conversion works)",{
  expect_s3_class(vec_c(xlr_percent(1),1),
                  class = "xlr_percent",
                  exact = FALSE)
  expect_s3_class(vec_c(1,xlr_percent(1)),
                  class = "xlr_percent",
                  exact = FALSE)
  expect_s3_class(c(xlr_percent(1),1),
                  class = "xlr_percent",
                  exact = FALSE)

})

test_that("casting works as expected",{
  expect_s3_class(vec_cast(xlr_percent(1),xlr_percent()),
                  class = "xlr_percent",
                  exact = FALSE)

  # Not sure about the casting behaviour, it doesn't worry about changing
  # to a lower decimal places
  # to be fare this is just styling so it is probably ok

  expect_s3_class(vec_cast(xlr_percent(1),xlr_percent(dp=4)) |>
                    suppressWarnings(),
                  class = "xlr_percent",
                  exact = FALSE)
  expect_s3_class(vec_cast(xlr_percent(1,dp=4),xlr_percent())|>
                    suppressWarnings(),
                  class = "xlr_percent",
                  exact = FALSE)
  expect_s3_class(vec_cast(1,xlr_percent(1))|>
                    suppressWarnings(),
                  class = "xlr_percent",
                  exact = FALSE)
  expect_type(vec_cast(xlr_percent(1),1)|>
                suppressWarnings(),
                  type = "double")

})


test_that("casting to a xlr_percent pulls the xlr_percent data",{
  expect_equal(vec_cast(xlr_percent(1),xlr_percent(dp=4)) |>
                 suppressWarnings() |>
                 pull_dp(),
              4L)
  expect_equal(vec_cast(xlr_percent(1,dp=4),xlr_percent()) |>
                 suppressWarnings() |>
                    pull_dp(),
                  0L)
  expect_equal(vec_cast(1,xlr_percent(1,style = xlr_format(8))) |>
                 suppressWarnings() |>
                 pull_style(),
               xlr_format(8))
})


test_that("casting works as expected",{
  expect_s3_class(vec_cast(xlr_percent(1),xlr_percent()),
                  class = "xlr_percent",
                  exact = FALSE)

  # Not sure about the casting behaviour, it doesn't worry about changing
  # to a lower decimal places
  # to be fare this is just styling so it is probably ok

  expect_s3_class(vec_cast(xlr_percent(1),xlr_percent(dp=4)) |>
                  suppressWarnings(),
                  class = "xlr_percent",
                  exact = FALSE)
  expect_s3_class(vec_cast(xlr_percent(1,dp=4),xlr_percent())|>
                    suppressWarnings(),
                  class = "xlr_percent",
                  exact = FALSE)
  expect_s3_class(vec_cast(1,xlr_percent(1)),
                  class = "xlr_percent",
                  exact = FALSE)
  expect_type(vec_cast(xlr_percent(1),1),
              type = "double")

})


# Arithmetic-----------------------------------
test_that("percentages arithmetic can work with same percentage",{

  expect_equal(xlr_percent(1)+xlr_percent(1),xlr_percent(2))
  expect_equal(xlr_percent(1)-xlr_percent(.5),xlr_percent(.5))
  expect_equal(xlr_percent(.2)*xlr_percent(1),xlr_percent(.2))
})

test_that("percentages and double multiplication returns a double, divsion returns a xlr_percent",{

    expect_equal(xlr_percent(1)*2,2)
    expect_equal(2*xlr_percent(1),2)
    expect_equal(xlr_percent(1)/2,0.5)
})


test_that("xlr_percent works with vec_math, median and quantile",{

  expect_equal(sum(xlr_percent(c(0.5,0.5))),1)
  expect_equal(median(xlr_percent(c(0.5,0.5))),0.5)

  quant_out <- 0.5
  names(quant_out) <- "50%"
  expect_equal(quantile(xlr_percent(c(0.5,0.5)),0.5),quant_out)
})


test_that("xlr_percent produces a correctly formatted character when casting or using as.character",{
  # first check that vec_cast works as expected
  expect_equal(vec_cast(xlr_percent(1),character()),"100%")
  expect_equal(vec_cast(xlr_percent(0.50),character()),"50%")
  expect_equal(vec_cast(xlr_percent(0.5055),character()),"51%")
  expect_equal(vec_cast(xlr_percent(0.5055,dp = 2),character()),"50.55%")

  # expect that as.character() which is a wrapper around vec_Cast
  # works as expected
  expect_equal(as.character(xlr_percent(1)),"100%")
  expect_equal(as.character(xlr_percent(0.50)),"50%")
  expect_equal(as.character(xlr_percent(0.5055)),"51%")
  expect_equal(as.character(xlr_percent(0.5055,dp = 2)),"50.55%")
})

test_that("vec_ptype2.xlr_percent.xlr_percent raises warning when things don't match",{
  # first check it raises a warning
  expect_snapshot(c(xlr_percent(1),xlr_percent(1,dp =3)))
})

test_that("vec_arith.xlr_percent.xlr_percent raises warning when things don't match",{
  # first check it raises a warning
  expect_snapshot(xlr_percent(1)+xlr_percent(1,dp =3))
})


test_that("vec_arith.xlr_percent.xlr_percent raises an error when things don't match",{
  # first check it raises a warning
  expect_error(xlr_percent(1)+TRUE,class = "vctrs_error_incompatible")
})
