test_that("xlr_numeric() empty intialisation works correctly", {
  # it should have class xlr_numeric
  expect_s3_class(xlr_numeric(),"xlr_numeric")
  # it should be length zero
  expect_true(length(xlr_numeric())==0)
  # it should have the default attributes
  expect_equal(pull_dp(xlr_numeric()),2)
  expect_equal(pull_style(xlr_numeric()),xlr_format_numeric())
})

test_that("xlr_numeric() initialisation works", {
  # it should have class xlr_numeric
  expect_s3_class(xlr_numeric(1),"xlr_numeric")
  # it should have the correct vector length
  expect_equal(length(xlr_numeric(1)),1)
  expect_equal(length(xlr_numeric(1:100)),100)
  # we can update the attributes
  expect_equal(pull_dp(xlr_numeric(1,3)),3)
  expect_equal(pull_style(xlr_numeric(1,3,FALSE,xlr_format(font_size = 8))),
               xlr_format(font_size = 8))
})

test_that("xlr_numeric() that dp is always a positive integer", {

  expect_error(xlr_numeric(1,dp=-1L))
  expect_error(xlr_numeric(1,dp=-1))
  expect_silent(xlr_numeric(1,dp=0))
  expect_error(xlr_numeric(1,dp=0.1))
  expect_error(xlr_numeric(1,dp=0.0001))
  # `Excel` only can maintain up to 15 significant figures
  # this is a bit of an edge case but only allow up to
  # 15-3 = 12 decimal places
  expect_error(xlr_numeric(1,dp=110000))
})


test_that("is_xlr_numeric() works",{
  var <- 1
  expect_true(is_xlr_numeric(xlr_numeric(1)))
  expect_true(is_xlr_numeric(xlr_numeric(1:10)))
  expect_true(is_xlr_numeric(xlr_numeric(var)))
  expect_true(is_xlr_numeric(xlr_numeric(var,dp=3)))
  expect_true(is_xlr_numeric(xlr_numeric(NA,dp=3)))
  expect_false(is_xlr_numeric(NA))
  expect_false(is_xlr_numeric(mtcars))
})


test_that("as_xlr_numeric() converts numerics correctly",{
  expect_s3_class(as_xlr_numeric(1),
                  class = "xlr_numeric",
                  exact = FALSE)
  expect_s3_class(as_xlr_numeric(1L),
                  class = "xlr_numeric",
                  exact = FALSE)
  expect_s3_class(as_xlr_numeric(1:10),
                  class = "xlr_numeric",
                  exact = FALSE)
})

test_that("as_xlr_numeric() converts characters() correctly",{
  expect_s3_class(as_xlr_numeric("1.1"),
                  class = "xlr_numeric",
                  exact = FALSE)
  expect_s3_class(as_xlr_numeric(paste0(1:100/100)),
                  class = "xlr_numeric",
                  exact = FALSE)
  expect_warning(as_xlr_numeric("a"))
  expect_warning(as_xlr_numeric("a"))
  expect_warning(as_xlr_numeric("a1"))
})

test_that("xlr_numeric.format prints the way we want it",{
  # verify_output is very cool, it helps us see if it works
  expect_snapshot(xlr_numeric(1:100/100))
  expect_snapshot(xlr_numeric(0:99/100,dp=2))
  expect_snapshot(tibble::tibble(test=xlr_numeric(0:99/100,dp=2)))
})

test_that("xlr_numeric.format prints using scientific notation like we want it",{
  # verify_output is very cool, it helps us see if it works
  expect_snapshot(xlr_numeric(1:100/100,dp = 0, scientific = TRUE))
  expect_snapshot(xlr_numeric(0:99/100,dp=2, scientific = TRUE))
  expect_snapshot(tibble::tibble(test=xlr_numeric(0:99/100,dp=4, scientific = TRUE)))
})

test_that("symmetry for the prototyping (and that vec_c conversion works)",{
  expect_s3_class(vec_c(xlr_numeric(1),1),
                  class = "xlr_numeric",
                  exact = FALSE)
  expect_s3_class(vec_c(1,xlr_numeric(1)),
                  class = "xlr_numeric",
                  exact = FALSE)
  expect_s3_class(c(xlr_numeric(1),1),
                  class = "xlr_numeric",
                  exact = FALSE)

})

test_that("casting works as expected",{
  expect_s3_class(vec_cast(xlr_numeric(1),xlr_numeric()),
                  class = "xlr_numeric",
                  exact = FALSE)

  # Not sure about the casting behaviour, it doesn't worry about changing
  # to a lower decimal places
  # to be fare this is just styling so it is probably ok

  expect_s3_class(vec_cast(xlr_numeric(1),xlr_numeric(dp=4)),
                  class = "xlr_numeric",
                  exact = FALSE)
  expect_s3_class(vec_cast(xlr_numeric(1,dp=4),xlr_numeric()),
                  class = "xlr_numeric",
                  exact = FALSE)
  expect_s3_class(vec_cast(1,xlr_numeric(1)),
                  class = "xlr_numeric",
                  exact = FALSE)
  expect_type(vec_cast(xlr_numeric(1),1),
              type = "double")

})

# Arithmetic-----------------------------------
test_that("xlr_numerics should do everything and get back a xlr double",{
  # test every operation works
  expect_equal(xlr_numeric(1)+xlr_numeric(1),xlr_numeric(2))
  expect_equal(xlr_numeric(1)-xlr_numeric(.5),xlr_numeric(.5))
  expect_equal(xlr_numeric(.2)*xlr_numeric(1),xlr_numeric(.2))
  expect_equal(xlr_numeric(1)/xlr_numeric(1),xlr_numeric(1))
  expect_equal(xlr_numeric(1)^xlr_numeric(2),xlr_numeric(1))
  expect_equal(xlr_numeric(3)%%xlr_numeric(2),xlr_numeric(1))
})

test_that("xlr_numerics should work with all numerics and
          return a xlr_numeric",{

  expect_equal(1+xlr_numeric(1),xlr_numeric(2))
  expect_equal(xlr_numeric(1)+1,xlr_numeric(2))

  expect_equal(1-xlr_numeric(.5),xlr_numeric(.5))
  expect_equal(xlr_numeric(.5)-1,xlr_numeric(-.5))

  expect_equal(1*xlr_numeric(1),xlr_numeric(1))
  expect_equal(xlr_numeric(1)*1,xlr_numeric(1))

  expect_equal(1/xlr_numeric(1),xlr_numeric(1))
  expect_equal(xlr_numeric(1)/1,xlr_numeric(1))

  expect_equal(1^xlr_numeric(2),xlr_numeric(1))
  expect_equal(xlr_numeric(2)^1,xlr_numeric(2))

  expect_equal(3%%xlr_numeric(2),xlr_numeric(1))
  expect_equal(xlr_numeric(3)%%2,xlr_numeric(1))
})


test_that("vec_ptype2.xlr_percent.xlr_percent raises warning when things don't match",{
  # first check it raises a warning
  expect_snapshot(c(xlr_numeric(1),xlr_numeric(1,dp =3)))
})

test_that("vec_arith.xlr_percent.xlr_percent raises warning when things don't match",{
  # first check it raises a warning
  expect_snapshot(xlr_numeric(1)+xlr_numeric(1,dp =3))
})


test_that("vec_arith.xlr_percent.xlr_percent raises an error when things don't match",{
  # first check it raises a warning
  expect_error(xlr_numeric(1)+TRUE,class = "vctrs_error_incompatible")
})

test_that("we can create a ggplot silently",{
  df <- mtcars
  df$test <- xlr_numeric(df$mpg)
  expect_silent(ggplot2::ggplot(df,ggplot2::aes(x = test,y=test)))
})

test_that("xlr_numeric works with vec_math, median and quantile",{

  expect_equal(sum(xlr_numeric(c(0.5,0.5))),1)
  expect_equal(median(xlr_numeric(c(0.5,0.5))),0.5)

  quant_out <- 0.5
  names(quant_out) <- "50%"
  expect_equal(quantile(xlr_numeric(c(0.5,0.5)),0.5),quant_out)
})

