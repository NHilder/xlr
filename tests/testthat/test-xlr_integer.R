


test_that("xlr_integer() empty intialisation works correctly", {
  # it should have class xlr_integer
  expect_s3_class(xlr_integer(),"xlr_integer")
  # it should be length zero
  expect_true(length(xlr_integer())==0)
  # it should have the default attributes
  expect_equal(pull_style(xlr_integer()),xlr_format_numeric())
})

test_that("xlr_integer() initialisation works", {
  # it should have class xlr_integer
  expect_s3_class(xlr_integer(1),"xlr_integer")
  # it should have the correct vector length
  expect_equal(length(xlr_integer(1)),1)
  expect_equal(length(xlr_integer(1:100)),100)
  # we can update the attributes
  expect_equal(pull_style(xlr_integer(1,xlr_format(font_size=11))),
               xlr_format(font_size=11))
})

test_that("is_xlr_integer() works",{
  var <- 1
  expect_true(is_xlr_integer(xlr_integer(1)))
  expect_true(is_xlr_integer(xlr_integer(1:10)))
  expect_true(is_xlr_integer(xlr_integer(var)))
  expect_true(is_xlr_integer(xlr_integer(NA)))
  expect_false(is_xlr_integer(NA))
  expect_false(is_xlr_integer(mtcars))
})


test_that("as_xlr_integer() converts numerics correctly",{
  expect_s3_class(as_xlr_integer(1),
                  class = "xlr_integer",
                  exact = FALSE)
  expect_s3_class(as_xlr_integer(1L),
                  class = "xlr_integer",
                  exact = FALSE)
  expect_s3_class(as_xlr_integer(1:10),
                  class = "xlr_integer",
                  exact = FALSE)
})

test_that("as_xlr_integer() converts characters() correctly",{
  expect_s3_class(as_xlr_integer("1"),
                  class = "xlr_integer",
                  exact = FALSE)
  expect_s3_class(as_xlr_integer(paste0(1:100)),
                  class = "xlr_integer",
                  exact = FALSE)
  expect_warning(as_xlr_integer("a"))
  expect_warning(as_xlr_integer("a"))
  expect_warning(as_xlr_integer("a1"))
})


test_that("xlr_integer.format prints the way we want it",{
  # verify_output is very cool, it helps us see if it works
  expect_snapshot(xlr_integer(1:100))
  expect_snapshot(tibble::tibble(test=xlr_integer(0:99)))
})

test_that("symmetry for the prototyping (and that vec_c conversion works)",{
  expect_s3_class(vec_c(xlr_integer(1),1L),
                  class = "xlr_integer",
                  exact = FALSE)
  expect_s3_class(vec_c(1L,xlr_integer(1)),
                  class = "xlr_integer",
                  exact = FALSE)
})

test_that("casting works as expected",{
  expect_s3_class(vec_cast(xlr_integer(1),xlr_integer()),
                  class = "xlr_integer",
                  exact = FALSE)

  # Not sure about the casting behaviour, it doesn't worry about changing
  # to a lower decimal places
  # to be fare this is just styling so it is probably ok

  expect_s3_class(vec_cast(xlr_integer(1),xlr_integer()),
                  class = "xlr_integer",
                  exact = FALSE)
  expect_s3_class(vec_cast(xlr_integer(1),xlr_integer()),
                  class = "xlr_integer",
                  exact = FALSE)
  expect_s3_class(vec_cast(1,xlr_integer(1)),
                  class = "xlr_integer",
                  exact = FALSE)
  expect_type(vec_cast(xlr_integer(1),1L),
              type = "integer")

})

test_that("Casting within a function works as expected, when casting from a
          xlr_integer to a double()",{
  foo <- function(x){
    new_x <- vec_cast(x, double())
    class(new_x)
  }
  expect_equal(foo(xlr_integer(100)),
               "numeric")
})

# Arithmetic-----------------------------------
test_that("xlr_integers should not calculate division",{
  # test every operation works
  expect_equal(xlr_integer(1)+xlr_integer(1),xlr_integer(2))
  expect_equal(xlr_integer(1)-xlr_integer(0),xlr_integer(1))
  expect_equal(xlr_integer(2)*xlr_integer(1),xlr_integer(2))
  expect_equal(xlr_integer(1)^xlr_integer(2),xlr_integer(1))
  expect_equal(xlr_integer(3)%%xlr_integer(2),xlr_integer(1))

  expect_error(xlr_integer(1)/xlr_integer(1))
})

test_that("xlr_integers should work with all numerics and
          return it's type (we lose the other info)",{

  expect_equal(1+xlr_integer(1),2)
  expect_equal(xlr_integer(1)+1,2)
#
#   expect_equal(1-xlr_integer(.5),xlr_integer(.5))
#   expect_equal(xlr_integer(.5)-1,xlr_integer(-.5))
#
#   expect_equal(1*xlr_integer(1),xlr_integer(1))
#   expect_equal(xlr_integer(1)*1,xlr_integer(1))
#
#   expect_equal(1/xlr_integer(1),xlr_integer(1))
#   expect_equal(xlr_integer(1)/1,xlr_integer(1))
#
#   expect_equal(1^xlr_integer(2),xlr_integer(1))
#   expect_equal(xlr_integer(2)^1,xlr_integer(2))
#
#   expect_equal(3%%xlr_integer(2),xlr_integer(1))
#   expect_equal(xlr_integer(3)%%2,xlr_integer(1))
})
