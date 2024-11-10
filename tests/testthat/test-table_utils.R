test_that("check_columns_exist() returns the corretly selected columns", {
  expect_equal(check_columns_exist(mtcars,c(mpg,wt)), mtcars[,c("mpg","wt")])
  expect_equal(check_columns_exist(mtcars,c("mpg","wt")), mtcars[,c("mpg","wt")])
})

test_that("check_columns_exist() works inside another function", {
  outer_fun <- function(x,
                        cols){
    check_columns_exist(x,
                        !!enquo(cols))
  }

  expect_equal(outer_fun(mtcars,c(mpg,wt)), mtcars[,c("mpg","wt")])
  expect_equal(outer_fun(mtcars,c("mpg","wt")), mtcars[,c("mpg","wt")])
})


test_that("check_columns_exist() selects columns that start with terms correct", {
  expect_equal(check_columns_exist(iris,Species,"Petal"),
               iris[,c("Species","Petal.Length","Petal.Width")])

  expect_equal(check_columns_exist(iris,Species,c("Sepal","Petal")),
               dplyr::select(iris,Species,everything()))
})


test_that("check_columns_exist() selects columns that start with terms correct, inside another func", {

  outer_fun <- function(x,
                        cols,
                        sw){
    check_columns_exist(x,
                        !!enquo(cols),
                        sw)
  }

  expect_equal(outer_fun(iris,Species,"Petal"),
               iris[,c("Species","Petal.Length","Petal.Width")])

  expect_equal(outer_fun(iris,Species,c("Sepal","Petal")),
               dplyr::select(iris,Species,everything()))
})

test_that("check_columns_exist() error looks correct with an incorrect column",{
  test_fun <- function(x,
                       fun_arg_name){
    check_columns_exist(x,
                        !!enquo(fun_arg_name))
  }
  expect_snapshot(test_fun(mtcars,
                           "m"),
                  error = TRUE)
})

test_that("check_columns_exist() error produces an error if the starts_with columns don't exist",{
  test_fun <- function(x,
                       fun_arg_name,
                       sw){
    check_columns_exist(x,
                        !!enquo(fun_arg_name),
                        sw)
  }
  expect_snapshot(test_fun(mtcars,
                           mpg,
                           "cats"),
                  error = TRUE)
})

test_that("my_starts_with() selects from a vector",{
  expect_equal(my_starts_with("a",c("a1","a3","b10","b12")),
               c(1,2))
})

test_that("my_starts_with() selects works with multiple selections at once",{
  expect_equal(my_starts_with(c("a","b"),c("a1","a3","b10","b12","d","B","b")),
               c(1,2,3,4,7))
})


test_that("validate_table_inputs() is silent if all inputs are correct",{
  expect_silent(validate_table_inputs(mtcars,
                                     "test",
                                     FALSE,
                                     TRUE,
                                     c("This is a footnote","terribe")))
})


test_that("validate_table_inputs() produces an error if not a data.frame",{

  my_function <- function(x,
                          table_title,
                          use_questions,
                          use_NA,
                          footnote){
    validate_table_inputs(x,
                          table_title,
                          use_questions,
                          use_NA,
                          footnote)
  }

  expect_snapshot(my_function("hello",
                              "test",
                              TRUE,
                              TRUE,
                              c("This is a footnote","terribe")),
                  error = TRUE)
})

test_that("validate_table_inputs() produces an error if the title is not a scalar character",{

  my_function <- function(x,
                          table_title,
                          use_questions,
                          use_NA,
                          footnote){
    validate_table_inputs(x,
                          table_title,
                          use_questions,
                          use_NA,
                          footnote)
  }

  expect_snapshot(my_function(mtcars,
                              123,
                              TRUE,
                              TRUE,
                              c("This is a footnote","terribe")),
                  error = TRUE)
})

test_that("validate_table_inputs() produces an error if the use question option is not a bool",{

  my_function <- function(x,
                          table_title,
                          use_questions,
                          use_NA,
                          footnote){
    validate_table_inputs(x,
                          table_title,
                          use_questions,
                          use_NA,
                          footnote)
  }

  expect_snapshot(my_function(mtcars,
                              "test",
                              123,
                              TRUE,
                              c("This is a footnote","terribe")),
                  error = TRUE)
})

test_that("validate_table_inputs() produces an error if the use NA is not a bool",{

  my_function <- function(x,
                          table_title,
                          use_questions,
                          use_NA,
                          footnote){
    validate_table_inputs(x,
                          table_title,
                          use_questions,
                          use_NA,
                          footnote)
  }

  expect_snapshot(my_function(mtcars,
                              "test",
                              TRUE,
                              123,
                              c("This is a footnote","terribe")),
                  error = TRUE)

})

test_that("validate_table_inputs() produces an error if the footnote is not a character vector",{

  my_function <- function(x,
                          table_title,
                          use_questions,
                          use_NA,
                          footnote){
    validate_table_inputs(x,
                          table_title,
                          use_questions,
                          use_NA,
                          footnote)
  }

  expect_snapshot(my_function(mtcars,
                              "test",
                              TRUE,
                              TRUE,
                              mtcars),
                  error = TRUE)

})

test_that("validate_table_inputs() produces an error if you specify use_questions and have a footnote",{

  my_function <- function(x,
                          table_title,
                          use_questions,
                          use_NA,
                          footnote){
    validate_table_inputs(x,
                          table_title,
                          use_questions,
                          use_NA,
                          footnote)
  }

  expect_snapshot(my_function(mtcars,
                              "test",
                              TRUE,
                              TRUE,
                              "This is a footnote"),
                  error = TRUE)

})


test_that("get_question_from_label() correctly pulls out the information
          when the data is labelled",{


  df <-create_block_question_df() |>
    # columns that start with Q1 are haven labelled.
    dplyr::select(starts_with("Q1"))

  # now see if the data works
  expect_equal(get_question_from_label(df,c(Q1_1,Q1_2)),
               c("Questions",
                 "Pants are good to wear",
                 "Shirts are good to wear"))

  expect_equal(get_question_from_label(df,c(Q1_1,Q1_2),TRUE),
               c("Questions",
                 "Q1_1: Pants are good to wear",
                 "Q1_2: Shirts are good to wear"))

})

test_that("remove_NA_opt() removes NA from the data if FALSE, i.e.
          use_NA is FALSE => we don't want to use NA",{
  df <- data.frame(A = c(1,2,3,NA),
                   B = c(NA,2,3,4),
                   C = c(1:4))
  # now we remove an entire row if an NA exist in it
  expect_equal(remove_NA_opt(df,TRUE),
               df)
})

test_that("remove_NA_opt() removes nothing from the data if FALSE",{
  df <- data.frame(A = c(1,2,3,NA),
                   B = c(NA,2,3,4),
                   C = c(1:4))
  # now we remove an entire row if an NA exist in it
  expect_equal(remove_NA_opt(df,FALSE),
               data.frame(A = c(2,3),
                          B = c(2,3),
                          C = c(2,3)))
})
