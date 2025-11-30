
test_that("build_multiple_response_table() works for the simplest case", {

  test_df <- create_multi_response_df() |>
    mutate(across(starts_with("enjoy_fruit"),
                  ~ haven::as_factor(.x) |>
                    haven::zap_label()))

  func_output <-
    test_df |>
    # remove other variables before hand
    select(-enjoy_fruit_other) |>
    build_mtable("enjoy_fruit")

  expected_output <-
    data.frame(enjoy_fruit = c("Apple","Banana","Pear"),
               N = xlr_integer(c(3,4,5)),
               N_group = xlr_integer(rep(6,3)),
               Percent = xlr_percent(c(.5,4/6,5/6))) |>
    xlr_table()

  expect_equal(func_output, expected_output)
})


test_that("build_multiple_response_table() works with question labels", {

  test_df <- create_multi_response_df()

  func_output <-
    test_df |>
    # remove other variables before hand
    select(-enjoy_fruit_other) |>
    build_mtable("enjoy_fruit")

  expected_output <-
    data.frame(enjoy_fruit = c("Apple","Banana","Pear"),
               N = xlr_integer(c(3,4,5)),
               N_group = xlr_integer(rep(6,3)),
               Percent = xlr_percent(c(.5,4/6,5/6))) |>
    xlr_table()

  expect_equal(func_output, expected_output)
})

test_that("build_multiple_response_table() works when we add one grouping variable", {

  test_df <- create_multi_response_df()

  func_output <-
    test_df |>
    # remove other variables before hand
    select(-enjoy_fruit_other) |>
    build_mtable("enjoy_fruit",col_1)


  expected_output <-
    data.frame(
      col_1 = c("a","a","a","b","b","c","c","c"),
      enjoy_fruit = c("Apple","Banana","Pear","Banana","Pear","Apple","Banana","Pear"),
               N = xlr_integer(c(2L, 1L, 2L, 2L, 2L, 1L, 1L, 1L)),
               N_group = xlr_integer(c(2,2,2,2,2,2,2,2))) |>
    mutate(Percent = xlr_percent(vec_cast(N,double())/N_group)) |>
    xlr_table()

  expect_equal(func_output,expected_output)

})

test_that("build_multiple_response_table() works when we add two grouping variables", {

  test_df <- create_multi_response_df()

  func_output <-
    test_df |>
    # remove other variables before hand
    select(-enjoy_fruit_other) |>
    build_mtable("enjoy_fruit",c(col_1,col_2))

  expected_output <-
    data.frame(
      col_1 = c("a","a","a","b","b","b","b","c","c","c"),
      col_2 = c(rep("d",5),rep("e",5)),
      enjoy_fruit = c("Apple","Banana","Pear","Banana","Pear","Banana","Pear","Apple","Banana","Pear"),
      N = xlr_integer(c(2L, 1L, 2L, 1L, 1L, 1L, 1L, 1L, 1L, 1L)),
      N_group = xlr_integer(c(2,2,2,1,1,1,1,2,2,2)))  |>
    mutate(Percent = xlr_percent(vec_cast(N,double())/N_group)) |>
    xlr_table()

  expect_equal(func_output,expected_output)

})

test_that("build_multiple_response_table() works when we add two multiple response columns", {

  test_df <- create_multi_response_df()

  func_output <-
    test_df |>
    # remove other variables before hand
    select(-enjoy_fruit_other,-enjoy_veg_other) |>
    build_mtable(c("enjoy_fruit","enjoy_veg"))

  expected_output <-
    data.frame(
      enjoy_fruit = c("Apple", "Apple", "Apple",
                      "Banana", "Banana", "Banana", "Pear", "Pear", "Pear"),
      enjoy_veg = c("Carrot", "Potato", "Tomato",
                    "Carrot", "Potato", "Tomato", "Carrot", "Potato", "Tomato"),
      N = xlr_integer(c(2L, 2L, 2L, 3L, 4L, 3L, 4L, 4L,3L)),
      N_enjoy_fruit = xlr_integer(c(3L, 3L, 3L, 4L, 4L, 4L, 5L, 5L, 5L))
      ) |>
      mutate(Percent = xlr_percent(vec_cast(N,double())/N_enjoy_fruit)) |>
    xlr_table()

  expect_equal(func_output,expected_output)
})

test_that("build_multiple_response_table() works when we add two multiple response columns,
          swap the cases so the NA exists in the 2nd column", {

  test_df <- create_multi_response_df()

  func_output <-
    test_df |>
    # remove other variables before hand
    select(-enjoy_fruit_other,-enjoy_veg_other) |>
    build_mtable(c("enjoy_veg","enjoy_fruit"))

  expected_output <-
    data.frame(
      enjoy_veg = c("Carrot", "Carrot", "Carrot",
                    "Potato", "Potato", "Potato", "Tomato", "Tomato", "Tomato"),
      enjoy_fruit = c("Apple", "Banana",
                      "Pear", "Apple", "Banana", "Pear", "Apple", "Banana", "Pear"),

      N = xlr_integer(c(2L, 3L, 4L, 2L, 4L, 4L, 2L, 3L, 3L)),
      N_enjoy_veg = xlr_integer(c(6L, 6L, 6L, 6L, 6L, 6L, 5L, 5L, 5L))
    ) |>
    mutate(Percent = xlr_percent(vec_cast(N,double())/N_enjoy_veg)) |>
    xlr_table()

  expect_equal(func_output,expected_output)
})


test_that("build_multiple_response_table() works when we add two multiple response columns
          and one grouping columns", {

  test_df <- create_multi_response_df()

  func_output <-
    test_df |>
    # remove other variables before hand
    select(-enjoy_fruit_other,-enjoy_veg_other) |>
    build_mtable(c("enjoy_fruit","enjoy_veg"), col_1)

  expected_output <-
    data.frame(
      col_1 = c("a", "a", "a", "a", "a", "a",
                "a", "a", "b", "b", "b", "b", "b", "b", "c", "c", "c", "c", "c",
                "c", "c", "c", "c"),
      enjoy_fruit = c("Apple", "Apple", "Apple",
                      "Banana", "Banana", "Pear", "Pear", "Pear", "Banana", "Banana",
                      "Banana", "Pear", "Pear", "Pear", "Apple", "Apple", "Apple",
                      "Banana", "Banana", "Banana", "Pear", "Pear", "Pear"),
      enjoy_veg = c("Carrot", "Potato", "Tomato",
                "Potato", "Tomato", "Carrot", "Potato", "Tomato", "Carrot", "Potato",
                "Tomato", "Carrot", "Potato", "Tomato", "Carrot", "Potato", "Tomato",
                "Carrot", "Potato", "Tomato", "Carrot", "Potato", "Tomato"),
      N = xlr_integer(c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
                         2L, 2L, 1L, 2L, 2L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L)),
      N_group = xlr_integer(c(2L, 2L, 2L, 1L, 1L, 2L,
                             2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
                             1L)),
      Percent = xlr_percent(c(0.5, 0.5, 0.5, 1, 1, 0.5,
                          0.5, 0.5, 1, 1, 0.5, 1, 1, 0.5, 1, 1, 1, 1, 1, 1, 1, 1, 1))) |>
    xlr_table()

  expect_equal(func_output,expected_output)
})

test_that("Test arg `x` is a tibble/ data.frame", {
  expect_snapshot(build_mtable(1), error = TRUE)
})

test_that("That when no columns start with the block column we get an error", {
  test_df <- create_multi_response_df()
  expect_snapshot(build_mtable(test_df,"p"),
                  error = TRUE)
})

test_that("that errors from inputting an invalid column is caught correctly", {
  test_df <- create_multi_response_df()
  expect_snapshot(build_mtable(test_df,"enjoy_veg",not_a_col),
                  error = TRUE)
})

test_that("that errors from inputting an invalid column is caught correctly", {
  test_df <- create_multi_response_df()
  expect_snapshot(build_mtable(test_df,"enjoy_veg",c(weight,not_a_col)),
                  error = TRUE)
})

test_that("Test arg `table_title` is a scalar character", {
  expect_snapshot(build_mtable(tibble(x = 1), table_title = 1),
                  error = TRUE)
})

test_that("Test arg `use_questions` is a scalar logical", {
  expect_snapshot(
    build_mtable(tibble(x = 1), table_title = "A", use_questions = 1),
    error = TRUE
  )
})

test_that("test that the adding the title works as expected",{
  df <- create_multi_response_df() |>
    select(-enjoy_veg_other)
  expect_equal(build_mtable(df,"enjoy_veg",table_title = "Test") |>
                 pull_title(),
               "Test")
})

test_that("test that adding a footnote manually is added correctly",{
  df <- create_multi_response_df() |>
    select(-enjoy_veg_other)
  expect_equal(build_mtable(df,
                            "enjoy_veg",
                            table_title = "Test",
                            footnote = "A footnote") |>
                 pull_footnote(),
               "A footnote")
})

test_that("test that adding a footnote manually and adding footnote_question throws an error",{
  df <- create_multi_response_df() |>
    select(-enjoy_veg_other)
  expect_snapshot(build_mtable(df,
                               "enjoy_veg",
                               table_title = "Test",
                               use_questions = TRUE,
                               footnote = "A footnote"),
                  error = TRUE)
})

test_that("use_questions pulls out the column names (the questions) as expected",{
  df <- create_multi_response_df() |>
    select(-enjoy_fruit_other,-enjoy_veg_other)

  # There should be an NA in this output
  expect_equal(build_mtable(df,
                            "enjoy_fruit",
                            col_2,
                            use_questions = TRUE) |>
                 pull_footnote(),
               c("Questions",
                 "What is your favourite letter?",
                  "What fruits do you enjoy eating?"))
  expect_equal(build_mtable(df,
                            c("enjoy_fruit","enjoy_veg"),
                            col_2,
                            use_questions = TRUE) |>
                 pull_footnote(),
               c("Questions",
                 "What is your favourite letter?",
                 "What fruits do you enjoy eating?"))
})

test_that("Test we get an error if you include a column without unique results",{
  test_df <- create_multi_response_df()

  expect_snapshot(build_mtable(test_df,"enjoy_fruit"),
                  error = TRUE)
})

test_that("Test that a non numeric wt column errors",{
  test_df <- create_multi_response_df()

  test_df$weight <- as.character(test_df$weight)
  test_df <-
    test_df |>
    select(-enjoy_fruit_other)
  expect_snapshot(build_mtable(test_df,
                               "enjoy_fruit",
                               wt = weight),
                  error = TRUE)
})

test_that("Test that when there are multiple mcols we through an error",{
  test_df <-
    create_multi_response_df() |>
    select(-ends_with("_other"))
  expect_snapshot(build_mtable(test_df,
                               c("enjoy_fruit","enjoy_veg","enjoy_food")),
                  error = TRUE)
})

test_that("Test that dots must be empty",{
  test_df <-
    create_multi_response_df() |>
    select(-ends_with("_other"))
  expect_snapshot(build_mtable(test_df,
                               c("enjoy_fruit","enjoy_veg","enjoy_food"),
                               a=7),
                  error = TRUE)
})

#- NA Tests -------------------------------------------------------------------

test_that("build_multiple_response_table() works for a simple NA case", {
  test_df <- create_multi_response_df()

  func_output <-
    test_df |>
    # remove other variables before hand
    select(-enjoy_fruit_other) |>
    build_mtable("enjoy_fruit",
                 use_NA = TRUE)

  expected_output <-
    data.frame(enjoy_fruit = c("Apple","Banana","Pear",NA),
               N = xlr_integer(c(3,4,5,1)),
               N_group = xlr_integer(rep(7,4))) |>
    mutate(Percent = xlr_percent(vec_cast(N,double())/N_group)) |>
    xlr_table()

  expect_equal(func_output, expected_output)
})


test_that("build_multiple_response_table() works for NA case and a column group", {
  test_df <- create_multi_response_df()

  func_output <-
    test_df |>
    # remove other variables before hand
    select(-enjoy_fruit_other) |>
    build_mtable("enjoy_fruit",
                 col_1,
                 use_NA = TRUE)

  expected_output <-
    data.frame(
      col_1 = c("a","a","a","b","b","c","c","c","c"),
      enjoy_fruit = c("Apple","Banana","Pear","Banana","Pear","Apple","Banana","Pear",NA),
      N = xlr_integer(c(2L, 1L, 2L, 2L, 2L, 1L, 1L, 1L,1L)),
      N_group = xlr_integer(c(2,2,2,2,2,3,3,3,3))) |>
    mutate(Percent = xlr_percent(vec_cast(N,double())/N_group)) |>
    xlr_table()

  expect_equal(func_output, expected_output)
})

test_that("build_multiple_response_table() works for NA for a group and multiple response column", {
  test_df <- create_multi_response_df()

  # first we make the column data NA
  test_df[1,"col_1"] <- NA

  func_output <-
    test_df |>
    # remove other variables before hand
    select(-enjoy_fruit_other) |>
    build_mtable("enjoy_fruit",
                 col_1,
                 use_NA = TRUE)

  expected_output <-
    data.frame(
      col_1 = c("a", "a", "b", "b", "c", "c",
                "c", "c", NA, NA, NA),
      enjoy_fruit = c("Apple", "Pear", "Banana",
                      "Pear", "Apple", "Banana", "Pear", NA,
                      "Apple", "Banana", "Pear"),
      N = xlr_integer(c(1L, 1L, 2L, 2L, 1L, 1L, 1L, 1L,
                         1L, 1L, 1L)),
      N_group = xlr_integer(c(1L, 1L, 2L, 2L, 3L, 3L,
                               3L, 3L, 1L, 1L, 1L))) |>
    mutate(Percent = xlr_percent(vec_cast(N,double())/N_group)) |>
    xlr_table()

  expect_equal(func_output, expected_output)
})

test_that("build_multiple_response_table() works for NA multiple response, only one
          multiple response column has NA in the first position, the other has none.", {
  test_df <- create_multi_response_df()

  func_output <-
    test_df |>
    # remove other variables before hand
    select(-enjoy_fruit_other, -enjoy_veg_other) |>
    build_mtable(c("enjoy_fruit","enjoy_veg"),
                 use_NA = TRUE)

  expected_output <-
    data.frame(
      enjoy_fruit = c("Apple", "Apple", "Apple",
                      "Banana", "Banana", "Banana", "Pear", "Pear", "Pear",
                      NA, NA, NA),
      enjoy_veg = c("Carrot", "Potato", "Tomato",
                    "Carrot", "Potato", "Tomato", "Carrot", "Potato", "Tomato",
                    "Carrot", "Potato", "Tomato"),
      N = xlr_integer(c(2L, 2L, 2L, 3L, 4L, 3L, 4L, 4L,3L,1,1,1)),
      N_enjoy_fruit = xlr_integer(c(3L, 3L, 3L, 4L, 4L, 4L, 5L, 5L, 5L,1,1,1))
    ) |>
    mutate(Percent = xlr_percent(vec_cast(N,double())/N_enjoy_fruit)) |>
    xlr_table()

  expect_equal(func_output, expected_output)
})

test_that("build_multiple_response_table() works for NA multiple response,
          the first column no NA, the second has NAs", {
    test_df <- create_multi_response_df()

    func_output <-
      test_df |>
      # remove other variables before hand
      select(-enjoy_fruit_other, -enjoy_veg_other) |>
      build_mtable(c("enjoy_veg","enjoy_fruit"),
                   use_NA = TRUE)

    expected_output <-
      data.frame(
        enjoy_veg = c("Carrot", "Carrot", "Carrot",
                        "Carrot", "Potato", "Potato", "Potato", "Potato", "Tomato", "Tomato",
                        "Tomato", "Tomato"),
        enjoy_fruit = c("Apple", "Banana",
                      "Pear", NA, "Apple", "Banana", "Pear", NA, "Apple", "Banana",
                      "Pear", NA),
        N = xlr_integer(c(2L, 3L, 4L, 1L, 2L, 4L, 4L, 1L,
                           2L, 3L, 3L, 1L)),
        N_enjoy_veg = xlr_integer(c(6L, 6L, 6L, 6L, 6L,
                                     6L, 6L, 6L, 5L, 5L, 5L, 5L))
      ) |>
      mutate(Percent = xlr_percent(vec_cast(N,double())/N_enjoy_veg)) |>
      xlr_table()

    expect_equal(func_output, expected_output)
})

test_that("build_multiple_response_table() works for NA multiple response and a column,
          the first column no NA, the second has NAs", {
  test_df <- create_multi_response_df()

  # first we make the column data NA
  test_df[1,"col_1"] <- NA

  func_output <-
    test_df |>
    # remove other variables before hand
    select(-enjoy_fruit_other, -enjoy_veg_other) |>
    build_mtable(c("enjoy_veg","enjoy_fruit"),
                 col_1,
                 use_NA = TRUE)

  expected_output <-
    data.frame(
      col_1 = c("a", "a", "b", "b", "b", "b",
                          "b", "b", "c", "c", "c", "c", "c", "c", "c", "c", "c", "c", "c",
                          "c", NA, NA, NA, NA, NA, NA),
      enjoy_veg = c("Carrot", "Carrot", "Carrot",
                    "Carrot", "Potato", "Potato", "Tomato", "Tomato", "Carrot", "Carrot",
                    "Carrot", "Carrot", "Potato", "Potato", "Potato", "Potato", "Tomato",
                    "Tomato", "Tomato", "Tomato", "Potato", "Potato", "Potato", "Tomato",
                    "Tomato", "Tomato"),
      enjoy_fruit = c("Apple", "Pear", "Banana",
                    "Pear", "Banana", "Pear", "Banana", "Pear", "Apple", "Banana",
                    "Pear", NA, "Apple", "Banana", "Pear", NA, "Apple", "Banana",
                    "Pear", NA, "Apple", "Banana", "Pear", "Apple", "Banana", "Pear"),
      N = xlr_integer(c(1L, 1L, 2L, 2L, 2L, 2L, 1L, 1L,
                      1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
                      1L, 1L)),
      N_group = xlr_integer(c(1L, 1L, 2L, 2L, 2L, 2L,
                            1L, 1L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 1L, 1L,
                            1L, 1L, 1L, 1L))
    ) |>
    mutate(Percent = xlr_percent(vec_cast(N,double())/N_group)) |>
    xlr_table()

  expect_equal(func_output, expected_output)
})

#- Weights----------------------------------------------------------------------

test_that("build_mtable works with weights in the simplest case",{
  test_df <- create_multi_response_df()

  func_output <-
    test_df |>
    # remove other variables before hand
    select(-enjoy_fruit_other, -enjoy_veg_other) |>
    build_mtable(c("enjoy_fruit"),
                 wt = weight)

  expected_output <-
    data.frame(
      enjoy_fruit = c("Apple", "Banana", "Pear"),
      N = xlr_numeric(c(0.7, 0.7, 0.9), dp = 1),
      N_group = xlr_numeric(c(1.2, 1.2, 1.2), dp = 1)
      ) |>
    mutate(Percent = xlr_percent(vec_cast(N,double())/N_group)) |>
    xlr_table()

  expect_equal(func_output, expected_output)
})

test_that("build_mtable works with weights in the simplest case and NA",{
  test_df <- create_multi_response_df()

  func_output <-
    test_df |>
    # remove other variables before hand
    select(-enjoy_fruit_other, -enjoy_veg_other) |>
    build_mtable(c("enjoy_fruit"),
                 wt = weight,
                 use_NA = TRUE)

  expected_output <-
    data.frame(
      enjoy_fruit = c("Apple", "Banana", "Pear", NA),
      N = xlr_numeric(c(0.7, 0.7, 0.9, 0.4), dp = 1),
      N_group = xlr_numeric(c(1.6, 1.6, 1.6, 1.6), dp = 1)
    ) |>
    mutate(Percent = xlr_percent(vec_cast(N,double())/N_group)) |>
    xlr_table()

  expect_equal(func_output, expected_output)
})


test_that("build_mtable works with weights, one multiple response col,
          and cut column",{
  test_df <- create_multi_response_df()

  func_output <-
    test_df |>
    # remove other variables before hand
    select(-enjoy_fruit_other, -enjoy_veg_other) |>
    build_mtable(c("enjoy_fruit"),
                 col_1,
                 wt = weight)

  expected_output <-
    data.frame(
      col_1 = c("a", "a", "a", "b", "b", "c",
                          "c", "c"),
      enjoy_fruit = c("Apple", "Banana",
                    "Pear", "Banana", "Pear", "Apple", "Banana", "Pear"),
      N = xlr_numeric(c(0.4, 0.2, 0.4, 0.2, 0.2, 0.3,
                        0.3, 0.3), dp = 1),
      N_group = xlr_numeric(c(0.4, 0.4, 0.4, 0.2, 0.2,
                              0.6, 0.6, 0.6), dp = 1)
    ) |>
    mutate(Percent = xlr_percent(vec_cast(N,double())/N_group)) |>
    xlr_table()

  expect_equal(func_output, expected_output)
})

test_that("build_mtable works with weights, two multiple response col",{
  test_df <- create_multi_response_df()

  func_output <-
    test_df |>
    # remove other variables before hand
    select(-enjoy_fruit_other, -enjoy_veg_other) |>
    build_mtable(c("enjoy_fruit", "enjoy_veg"),
                 wt = weight)

  expected_output <-
    data.frame(
      enjoy_fruit = c("Apple", "Apple", "Apple",
                      "Banana", "Banana", "Banana", "Pear", "Pear", "Pear"),
      enjoy_veg = c("Carrot", "Potato", "Tomato",
                    "Carrot", "Potato", "Tomato", "Carrot", "Potato", "Tomato"),
      N = xlr_numeric(c(0.5, 0.5, 0.5, 0.5, 0.7, 0.6,
                        0.7, 0.7, 0.6), dp = 1),
      N_enjoy_fruit = xlr_numeric(c(0.7, 0.7, 0.7, 0.7,
                              0.7, 0.7, 0.9, 0.9, 0.9), dp = 1)
    ) |>
    mutate(Percent = xlr_percent(vec_cast(N,double())/N_enjoy_fruit)) |>
    xlr_table()

  expect_equal(func_output, expected_output)
})


test_that("build_mtable works with weights, two multiple response col,
          one cut col",{
  test_df <- create_multi_response_df()

  func_output <-
    test_df |>
    # remove other variables before hand
    select(-enjoy_fruit_other, -enjoy_veg_other) |>
    build_mtable(c("enjoy_fruit", "enjoy_veg"),
                 col_1,
                 wt = weight)

  expected_output <-
    data.frame(
      col_1 = c("a", "a", "a", "a", "a", "a",
                "a", "a", "b", "b", "b", "b", "b", "b", "c", "c", "c", "c", "c",
                "c", "c", "c", "c"),
      enjoy_fruit = c("Apple", "Apple", "Apple",
                      "Banana", "Banana", "Pear", "Pear", "Pear", "Banana", "Banana",
                      "Banana", "Pear", "Pear", "Pear", "Apple", "Apple", "Apple",
                      "Banana", "Banana", "Banana", "Pear", "Pear", "Pear"),
      enjoy_veg = c("Carrot", "Potato", "Tomato",
                    "Potato", "Tomato", "Carrot", "Potato", "Tomato", "Carrot", "Potato",
                    "Tomato", "Carrot", "Potato", "Tomato", "Carrot", "Potato", "Tomato",
                    "Carrot", "Potato", "Tomato", "Carrot", "Potato", "Tomato"),
      N = xlr_numeric(c(0.2, 0.2, 0.2, 0.2, 0.2, 0.2,
                        0.2, 0.2, 0.2, 0.2, 0.1, 0.2, 0.2, 0.1, 0.3, 0.3, 0.3, 0.3, 0.3,
                        0.3, 0.3, 0.3, 0.3), dp = 1),
      N_group = xlr_numeric(c(0.4, 0.4, 0.4, 0.2, 0.2,
                              0.4, 0.4, 0.4, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.3, 0.3, 0.3, 0.3,
                              0.3, 0.3, 0.3, 0.3, 0.3), dp = 1)
    ) |>
    mutate(Percent = xlr_percent(vec_cast(N,double())/N_group)) |>
    xlr_table()

  expect_equal(func_output, expected_output)
})

# Data with seen but answered questions-----------------------------------------

test_that("build_mtable works when you specify seen_but_answered for 0",{
  test_df <-
    create_multi_response_df() |>
    # now convert some of the NA values to 0
    select(-enjoy_fruit_other ) |>
    mutate(across(starts_with("enjoy_fruit"), ~ dplyr::if_else(is.na(.x),0,.x)))
  test_df[7,c("enjoy_fruit_apple","enjoy_fruit_banana","enjoy_fruit_pear")] <- NA

  out <-
    test_df |>
    build_mtable("enjoy_fruit",seen_but_answered = 0)

  expected_output <-
    data.frame(enjoy_fruit = c("Apple","Banana","Pear"),
               N = xlr_integer(c(3,4,5)),
               N_group = xlr_integer(rep(6,3)),
               Percent = xlr_percent(c(.5,4/6,5/6))) |>
    xlr_table()

  expect_equal(out, expected_output)

})

test_that("build_mtable works when you specify seen_but_answered for 0, with NA value",{
  test_df <-
    create_multi_response_df() |>
    # now convert some of the NA values to 0
    select(-enjoy_fruit_other ) |>
    mutate(across(starts_with("enjoy_fruit"), ~ dplyr::if_else(is.na(.x),0,.x)))

  out <-
    test_df |>
    build_mtable("enjoy_fruit",seen_but_answered = 0)

  expected_output <-
    data.frame(enjoy_fruit = c("Apple","Banana","Pear","0"),
               N = xlr_integer(c(3,4,5,1)),
               N_group = xlr_integer(rep(7,4)),
               Percent = xlr_percent(c(3,4,5,1) / 7 )) |>
    xlr_table()

  expect_equal(out, expected_output)

})

test_that("build_mtable works when you specify seen_but_answered for a character value",{
  test_df <-
    create_multi_response_df() |>
    # now convert some of the NA values to 0
    select(-enjoy_fruit_other ) |>
    mutate(across(starts_with("enjoy_fruit"), ~ haven::as_factor(.x) |> as.character()),
           across(starts_with("enjoy_fruit"), ~ dplyr::if_else(is.na(.x),"z",.x)))

  out <-
    test_df |>
    build_mtable("enjoy_fruit",
                 seen_but_answered = "z")

  expected_output <-
    data.frame(enjoy_fruit = c("Apple","Banana","Pear","z"),
               N = xlr_integer(c(3,4,5,1)),
               N_group = xlr_integer(rep(7,4)),
               Percent = xlr_percent(c(3,4,5,1) / 7 )) |>
    xlr_table()

  expect_equal(out, expected_output)

})


test_that("build_mtable allows you to specify the value for seen but answered, and
          that this value is always LAST in the the table",{
 # The case of no cross tables
  # test_df <-
  #   create_multi_response_df() |>
  #   # now convert some of the NA values to 0
  #   select(-enjoy_fruit_other ) |>
  #   mutate(across(starts_with("enjoy_fruit"), ~ dplyr::if_else(is.na(.x),-99,.x)))
  #
  #  out <-
  #   test_df |>
  #   build_mtable("enjoy_fruit",
  #                seen_but_answered = -99,
  #                name_seen_but_answered = "AA seen but answered (-99)")
  #
  # expected_output <
  #   data.frame(enjoy_fruit = c("Apple","Banana","Pear","AA seen but answered (-99)"),
  #              N = xlr_integer(c(1,3,4,5)),
  #              N_group = xlr_integer(rep(7,4)),
  #              Percent = xlr_percent(c(1,3,4,5) / 7 )) |>
  #   xlr_table()
  #
  # expect_equal(out, expected_output)
  #
  # # the case of a cross table
  # out <-
  #   test_df |>
  #   mutate(col_1 = ifelse(col_1 == "c","a","c")) |>
  #   build_mtable("enjoy_fruit",col_1,
  #                seen_but_answered = -99,
  #                name_seen_but_answered = "AA seen but answered (-99)")
  #
  # # expected_output <-
  # #   data.frame(col_1 = c(rep("a",4),rep("c",3)),
  # #              enjoy_fruit = c("Apple","Banana","Pear","AA seen but answered (-99)",
  # #                              "Apple","Banana","Pear"),
  # #              N = xlr_integer(c(rep(1,4),c(2,3,4))),
  # #              N_group = xlr_integer(c(rep(3,4),rep(4,3)))) |>
  # #   mutate(Precent = N/N_group) |>
  # #   xlr_table()
  #
  # expect_equal(out, expected_output)

})

test_that("build_mtable works when you specify seen_but_answered errors if not specified",{
  test_df <-
    create_multi_response_df() |>
    # now convert some of the NA values to 0
    select(-enjoy_fruit_other ) |>
    mutate(across(starts_with("enjoy_fruit"), ~ haven::as_factor(.x) |> as.character()),
           across(starts_with("enjoy_fruit"), ~ dplyr::if_else(is.na(.x),"z",.x)))


  expect_snapshot(build_mtable(test_df,"enjoy_fruit"),
                  error = TRUE)
})





