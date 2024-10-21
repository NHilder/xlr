test_that("new_beta_table() creates an S3 class with the correct types", {

  test_object <- new_beta_table(mtcars,
                                title = "test_title",
                                footnote = "test_footnote")

  expect_s3_class(test_object,"beta_table")
})

test_that("beta_table() does not lose beta_types if they exist already", {


  x <- data.frame(b_int = beta_integer(1:100,beta_format(font_size=11)),
                  b_pct = beta_percent(1:100/100),
                  b_dbl = beta_double(1:100),
                  d_vctr = beta_vector(as.character(1:100)))
  x_beta <- beta_table(x)

  expect_s3_class(x_beta$b_int,"beta_integer")
  expect_s3_class(x_beta$b_pct,"beta_percent")
  expect_s3_class(x_beta$b_dbl,"beta_double")
  expect_s3_class(x_beta$d_vctr,"beta_vector")
})


test_that("beta_table() converts types appropriately", {


  x <- data.frame(test_int = as.integer(1:100),
                  test_dbl = as.double(1:100/100),
                  test_num = as.double(1:100),
                  test_char = as.character(1:100),
                  test_factor = factor(rep(c("a","b","c","d"),25),
                                       levels = c("a","b","c","d"))
                  )
  x_beta <- beta_table(x)

  expect_s3_class(x_beta$test_int,"beta_integer")
  expect_s3_class(x_beta$test_dbl,"beta_double")
  expect_s3_class(x_beta$test_num,"beta_double")
  expect_s3_class(x_beta$test_char,"beta_vector")
  expect_s3_class(x_beta$test_factor,"beta_vector")
})

test_that("beta_table() prints correctly", {

  x <- data.frame(b_int = beta_integer(1:100,beta_format(font_size=11)),
                  b_pct = beta_percent(1:100/100),
                  b_dbl = beta_double(1:100),
                  d_vctr = beta_vector(as.character(1:100)))
  x_beta <- beta_table(x)

  expect_snapshot(print(x_beta))
  # now test that the title prints correctly
  expect_snapshot(print(beta_table(x_beta,title = "test")))
  expect_snapshot(print(beta_table(x_beta,footnote = "test")))
  expect_snapshot(print(beta_table(x_beta,"test_title","test_footnote")))
})


test_that("is_beta_table() correctly identifies the class", {

  x <- data.frame(b_int = beta_integer(1:100,beta_format(font_size=11)),
                  b_pct = beta_percent(1:100/100),
                  b_dbl = beta_double(1:100),
                  d_vctr = beta_vector(as.character(1:100)))
  x_beta <- beta_table(x)

  expect_true(is_beta_table(x_beta))
  expect_false(is_beta_table(x))
  expect_false(is_beta_table(mtcars))
})


test_that("as_beta_table() correctly converts the class", {

  x <- data.frame(b_int = beta_integer(1:100,beta_format(font_size=11)),
                  b_pct = beta_percent(1:100/100),
                  b_dbl = beta_double(1:100),
                  d_vctr = beta_vector(as.character(1:100)))

  expect_s3_class(as_beta_table(x),"beta_table")
  expect_s3_class(as_beta_table(mtcars),"beta_table")
  expect_s3_class(as_beta_table(tibble::tibble(mtcars)),"beta_table")
  expect_s3_class(as_beta_table(data.table::as.data.table(mtcars)),"beta_table")


})


test_that("beta_table and dplyr verbs are compatiable", {

  x <- data.frame(b_int = beta_integer(1:100,beta_format(font_size=11)),
                  b_pct = beta_percent(1:100/100),
                  b_dbl = beta_double(1:100),
                  d_vctr = beta_vector(as.character(1:100)),
                  test_num = as.double(1:100),
                  test_char = as.character(1:100),
                  test_factor = factor(rep(c("a","b","c","d"),25),
                                       levels = c("a","b","c","d"))
  )

  x <- beta_table(x)

  expect_s3_class(dplyr::mutate(x,test_num=as_beta_double(test_num)),"beta_table")
  expect_s3_class(dplyr::arrange(x,dplyr::desc(b_dbl)),"beta_table")
  expect_s3_class(dplyr::filter(x,b_int != 2L),"beta_table")
  expect_s3_class(dplyr::select(x,b_int),"beta_table")
  expect_s3_class(dplyr::rename(x,umm = b_int),"beta_table")
  expect_s3_class(dplyr::slice(x,dplyr::n()),"beta_table")
  expect_s3_class(dplyr::summarise(x,test = dplyr::n()),"beta_table")
  expect_s3_class(dplyr::summarize(x,test = dplyr::n()),"beta_table")
})

test_that("update_theme() updates the theme correctly",{
  x <- data.frame(b_int = beta_integer(1:100,beta_format(font_size=11)),
                  b_pct = beta_percent(1:100/100),
                  b_dbl = beta_double(1:100),
                  d_vctr = beta_vector(as.character(1:100)),
                  test_num = as.double(1:100),
                  test_char = as.character(1:100),
                  test_factor = factor(rep(c("a","b","c","d"),25),
                                       levels = c("a","b","c","d"))
  )

  x <- beta_table(x,"title test","footnote test")
  x <- update_theme(x,
                    beta_format(font_size=11),
                    beta_format(font_size=12,font_colour = "blue"),
                    beta_format(font_size=88,font_colour = "red"))
  # now check update footnotes is correct
  expect_equal(pull_title_format(x), beta_format(font_size=11))
  expect_equal(pull_footnote_format(x), beta_format(font_size=12,
                                                    font_colour = "blue"))
  expect_equal(pull_column_heading_format(x), beta_format(font_size=88,
                                                          font_colour = "red"))
})
