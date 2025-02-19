


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

test_that("Strings longer than 50 are reduced, when needed to",{
  greater_10 <- paste0(rep("a",60),collapse = "")
  greater_10 <- xlr_vector(rep(greater_10,10))
  test <- xlr_table(data.frame("a" = rep(1,10),
                               "greater_10_1" = greater_10,
                               "greater_10_2" = greater_10,
                               "greater_10_3" = greater_10,
                               "greater_10_4" = greater_10))
  expect_snapshot(test)
})

test_that("Strings are at a minimum 10 elements",{
  over_10 <- paste0(rep("a",100),collapse = "")
  over_10 <- xlr_vector(rep(over_10,10))

  under_10 <- paste0(rep("a",8),collapse = "")
  under_10 <- xlr_vector(rep(under_10,10))

  test <- xlr_table(data.frame("a" = rep(1,10),

                               under_10,over_10,under_10,over_10))
  expect_snapshot(test)
})

test_that("Implicit conversion works for two xlr_vectors",{
  expect_silent(c(xlr_vector("a"),xlr_vector("a")))
  # Expect we get a warning when the attributes differ
  expect_snapshot(c(xlr_vector("a"),xlr_vector("a","test")))
  expect_snapshot(c(xlr_vector("a"),xlr_vector("a",style = xlr_format(font_size = 12))))
})

test_that("Implicit conversion works for xlr_vector to character",{
  expect_equal(c(xlr_vector("a"),"a"),c("a","a"))
  expect_equal(c("a",xlr_vector("a")),c("a","a"))
})

test_that("Explicit conversion works for xlr_vector to character",{
  expect_equal(xlr_vector("a") |> as.character(),"a")
  expect_equal(vec_cast(xlr_vector("a"),"a"),"a")
})

test_that("Implicit conversion works for xlr_vector to numeric",{
  expect_equal(c(xlr_vector(as.numeric(1)),as.numeric(1)),as.numeric(c(1,1)))
  expect_equal(c(1,xlr_vector(as.numeric(1))),as.numeric(c(1,1)))
})

test_that("Explicit conversion works for xlr_vector to numeric",{
  expect_equal(xlr_vector(1) |> as.numeric(),as.numeric(1))
  expect_equal(vec_cast(xlr_vector(1),as.numeric(1)),as.numeric(1))
})

test_that("Implicit conversion works for xlr_vector to double",{
  expect_equal(c(xlr_vector(as.double(1)),as.double(1)),as.double(c(1,1)))
  expect_equal(c(1,xlr_vector(as.double(1))),as.double(c(1,1)))
})

test_that("Explicit conversion works for xlr_vector to double",{
  expect_equal(xlr_vector(1) |> as.double(),as.double(1))
  expect_equal(vec_cast(xlr_vector(1),as.double(1)),as.double(1))
})

test_that("Implicit conversion works for xlr_vector to integer",{
  expect_equal(c(xlr_vector(as.integer(1)),as.integer(1)),as.integer(c(1,1)))
  expect_equal(c(1,xlr_vector(as.integer(1))),as.integer(c(1,1)))
})

test_that("Explicit conversion works for xlr_vector to integer",{
  expect_equal(xlr_vector(1) |> as.integer(),as.integer(1))
  expect_equal(vec_cast(xlr_vector(1),as.integer(1)),as.integer(1))
})

