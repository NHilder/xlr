test_that("new_xlr_table() creates an S3 class with the correct types", {

  test_object <- new_xlr_table(mtcars,
                                title = "test_title",
                                footnote = "test_footnote")

  expect_s3_class(test_object,"xlr_table")
})

test_that("xlr_table() does not lose xlr_types if they exist already", {


  x <- data.frame(b_int = xlr_integer(1:100,xlr_format(font_size=11)),
                  b_pct = xlr_percent(1:100/100),
                  b_dbl = xlr_numeric(1:100),
                  d_vctr = xlr_vector(as.character(1:100)))
  x_xlr <- xlr_table(x)

  expect_s3_class(x_xlr$b_int,"xlr_integer")
  expect_s3_class(x_xlr$b_pct,"xlr_percent")
  expect_s3_class(x_xlr$b_dbl,"xlr_numeric")
  expect_s3_class(x_xlr$d_vctr,"xlr_vector")
})


test_that("xlr_table() converts types appropriately", {


  x <- data.frame(test_int = as.integer(1:100),
                  test_dbl = as.double(1:100/100),
                  test_num = as.double(1:100),
                  test_char = as.character(1:100),
                  test_factor = factor(rep(c("a","b","c","d"),25),
                                       levels = c("a","b","c","d"))
                  )
  x_xlr <- xlr_table(x)

  expect_s3_class(x_xlr$test_int,"xlr_integer")
  expect_s3_class(x_xlr$test_dbl,"xlr_numeric")
  expect_s3_class(x_xlr$test_num,"xlr_numeric")
  expect_s3_class(x_xlr$test_char,"xlr_vector")
  expect_s3_class(x_xlr$test_factor,"xlr_vector")
})

test_that("xlr_table() prints correctly", {

  x <- data.frame(b_int = xlr_integer(1:100,xlr_format(font_size=11)),
                  b_pct = xlr_percent(1:100/100),
                  b_dbl = xlr_numeric(1:100),
                  d_vctr = xlr_vector(as.character(1:100)))
  x_xlr <- xlr_table(x)

  expect_snapshot(print(x_xlr))
  # now test that the title prints correctly
  expect_snapshot(print(xlr_table(x_xlr,title = "test")))
  expect_snapshot(print(xlr_table(x_xlr,footnote = "test")))
  expect_snapshot(print(xlr_table(x_xlr,"test_title","test_footnote")))
})


test_that("is_xlr_table() correctly identifies the class", {

  x <- data.frame(b_int = xlr_integer(1:100,xlr_format(font_size=11)),
                  b_pct = xlr_percent(1:100/100),
                  b_dbl = xlr_numeric(1:100),
                  d_vctr = xlr_vector(as.character(1:100)))
  x_xlr <- xlr_table(x)

  expect_true(is_xlr_table(x_xlr))
  expect_false(is_xlr_table(x))
  expect_false(is_xlr_table(mtcars))
})


test_that("as_xlr_table() correctly converts the class", {

  x <- data.frame(b_int = xlr_integer(1:100,xlr_format(font_size=11)),
                  b_pct = xlr_percent(1:100/100),
                  b_dbl = xlr_numeric(1:100),
                  d_vctr = xlr_vector(as.character(1:100)))

  expect_s3_class(as_xlr_table(x),"xlr_table")
  expect_s3_class(as_xlr_table(mtcars),"xlr_table")
  expect_s3_class(as_xlr_table(tibble::tibble(mtcars)),"xlr_table")
  expect_s3_class(as_xlr_table(data.table::as.data.table(mtcars)),"xlr_table")


})


test_that("xlr_table and dplyr verbs are compatiable", {

  x <- data.frame(b_int = xlr_integer(1:100,xlr_format(font_size=11)),
                  b_pct = xlr_percent(1:100/100),
                  b_dbl = xlr_numeric(1:100),
                  d_vctr = xlr_vector(as.character(1:100)),
                  test_num = as.double(1:100),
                  test_char = as.character(1:100),
                  test_factor = factor(rep(c("a","b","c","d"),25),
                                       levels = c("a","b","c","d"))
  )

  x <- xlr_table(x)

  expect_s3_class(dplyr::mutate(x,test_num=as_xlr_numeric(test_num)),"xlr_table")
  expect_s3_class(dplyr::arrange(x,dplyr::desc(b_dbl)),"xlr_table")
  expect_s3_class(dplyr::filter(x,b_int != 2L),"xlr_table")
  expect_s3_class(dplyr::select(x,b_int),"xlr_table")
  expect_s3_class(dplyr::rename(x,umm = b_int),"xlr_table")
  expect_s3_class(dplyr::slice(x,dplyr::n()),"xlr_table")
  expect_s3_class(dplyr::summarise(x,test = dplyr::n()),"xlr_table")
  expect_s3_class(dplyr::summarize(x,test = dplyr::n()),"xlr_table")
})

test_that("update_theme() updates the theme correctly",{
  x <- data.frame(b_int = xlr_integer(1:100,xlr_format(font_size=11)),
                  b_pct = xlr_percent(1:100/100),
                  b_dbl = xlr_numeric(1:100),
                  d_vctr = xlr_vector(as.character(1:100)),
                  test_num = as.double(1:100),
                  test_char = as.character(1:100),
                  test_factor = factor(rep(c("a","b","c","d"),25),
                                       levels = c("a","b","c","d"))
  )

  x <- xlr_table(x,"title test","footnote test")
  x <- update_theme(x,
                    xlr_format(font_size=11),
                    xlr_format(font_size=12,font_colour = "blue"),
                    xlr_format(font_size=88,font_colour = "red"))
  # now check update footnotes is correct
  expect_equal(pull_title_format(x), xlr_format(font_size=11))
  expect_equal(pull_footnote_format(x), xlr_format(font_size=12,
                                                    font_colour = "blue"))
  expect_equal(pull_column_heading_format(x), xlr_format(font_size=88,
                                                          font_colour = "red"))
})
