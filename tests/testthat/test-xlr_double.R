


test_that("xlr_double() empty intialisation works correctly", {
  # it should have class xlr_double
  expect_s3_class(xlr_double(),"xlr_double")
  # it should be length zero
  expect_true(length(xlr_double())==0)
  # it should have the default attributes
  expect_equal(pull_dp(xlr_double()),2)
  expect_equal(pull_style(xlr_double()),xlr_format())
})

test_that("xlr_double() initialisation works", {
  # it should have class xlr_double
  expect_s3_class(xlr_double(1),"xlr_double")
  # it should have the correct vector length
  expect_equal(length(xlr_double(1)),1)
  expect_equal(length(xlr_double(1:100)),100)
  # we can update the attributes
  expect_equal(pull_dp(xlr_double(1,3)),3)
  expect_equal(pull_style(xlr_double(1,3,xlr_format(font_size = 8))),
               xlr_format(font_size = 8))
})

test_that("xlr_double() that dp is always a positive integer", {

  expect_error(xlr_double(1,dp=-1L))
  expect_error(xlr_double(1,dp=-1))
  expect_silent(xlr_double(1,dp=0))
  expect_error(xlr_double(1,dp=0.1))
  expect_error(xlr_double(1,dp=0.0001))
  # excel only can maintain up to 15 significant figures
  # this is a bit of an edge case but only allow up to
  # 15-3 = 12 decimal places
  expect_error(xlr_double(1,dp=110000))
})


test_that("is_xlr_double() works",{
  var <- 1
  expect_true(is_xlr_double(xlr_double(1)))
  expect_true(is_xlr_double(xlr_double(1:10)))
  expect_true(is_xlr_double(xlr_double(var)))
  expect_true(is_xlr_double(xlr_double(var,dp=3)))
  expect_true(is_xlr_double(xlr_double(NA,dp=3)))
  expect_false(is_xlr_double(NA))
  expect_false(is_xlr_double(mtcars))
})


test_that("as_xlr_double() converts numerics correctly",{
  expect_s3_class(as_xlr_double(1),
                  class = "xlr_double",
                  exact = FALSE)
  expect_s3_class(as_xlr_double(1L),
                  class = "xlr_double",
                  exact = FALSE)
  expect_s3_class(as_xlr_double(1:10),
                  class = "xlr_double",
                  exact = FALSE)
})

test_that("as_xlr_double() converts characters() correctly",{
  expect_s3_class(as_xlr_double("1.1"),
                  class = "xlr_double",
                  exact = FALSE)
  expect_s3_class(as_xlr_double(paste0(1:100/100)),
                  class = "xlr_double",
                  exact = FALSE)
  expect_warning(as_xlr_double("a"))
  expect_warning(as_xlr_double("a"))
  expect_warning(as_xlr_double("a1"))
})


test_that("xlr_double.format prints the way we want it",{
  # verify_output is very cool, it helps us see if it works
  expect_snapshot(xlr_double(1:100/100))
  expect_snapshot(xlr_double(0:99/100,dp=2))
  expect_snapshot(tibble::tibble(test=xlr_double(0:99/100,dp=2)))
})

test_that("symmetry for the prototyping (and that vec_c conversion works)",{
  expect_s3_class(vec_c(xlr_double(1),1),
                  class = "xlr_double",
                  exact = FALSE)
  expect_s3_class(vec_c(1,xlr_double(1)),
                  class = "xlr_double",
                  exact = FALSE)
  expect_s3_class(c(xlr_double(1),1),
                  class = "xlr_double",
                  exact = FALSE)

})

test_that("casting works as expected",{
  expect_s3_class(vec_cast(xlr_double(1),xlr_double()),
                  class = "xlr_double",
                  exact = FALSE)

  # Not sure about the casting behaviour, it doesn't worry about changing
  # to a lower decimal places
  # to be fare this is just styling so it is probably ok

  expect_s3_class(vec_cast(xlr_double(1),xlr_double(dp=4)),
                  class = "xlr_double",
                  exact = FALSE)
  expect_s3_class(vec_cast(xlr_double(1,dp=4),xlr_double()),
                  class = "xlr_double",
                  exact = FALSE)
  expect_s3_class(vec_cast(1,xlr_double(1)),
                  class = "xlr_double",
                  exact = FALSE)
  expect_type(vec_cast(xlr_double(1),1),
              type = "double")

})

# Arithmetic-----------------------------------
test_that("xlr_doubles should do everything and get back a xlr double",{
  # test every operation works
  expect_equal(xlr_double(1)+xlr_double(1),xlr_double(2))
  expect_equal(xlr_double(1)-xlr_double(.5),xlr_double(.5))
  expect_equal(xlr_double(.2)*xlr_double(1),xlr_double(.2))
  expect_equal(xlr_double(1)/xlr_double(1),xlr_double(1))
  expect_equal(xlr_double(1)^xlr_double(2),xlr_double(1))
  expect_equal(xlr_double(3)%%xlr_double(2),xlr_double(1))
})

test_that("xlr_doubles should work with all numerics and
          return a xlr_double",{

  expect_equal(1+xlr_double(1),xlr_double(2))
  expect_equal(xlr_double(1)+1,xlr_double(2))

  expect_equal(1-xlr_double(.5),xlr_double(.5))
  expect_equal(xlr_double(.5)-1,xlr_double(-.5))

  expect_equal(1*xlr_double(1),xlr_double(1))
  expect_equal(xlr_double(1)*1,xlr_double(1))

  expect_equal(1/xlr_double(1),xlr_double(1))
  expect_equal(xlr_double(1)/1,xlr_double(1))

  expect_equal(1^xlr_double(2),xlr_double(1))
  expect_equal(xlr_double(2)^1,xlr_double(2))

  expect_equal(3%%xlr_double(2),xlr_double(1))
  expect_equal(xlr_double(3)%%2,xlr_double(1))
})
