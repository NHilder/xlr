# check_columns_exist() error looks correct with an incorrect column

    Code
      test_fun(mtcars, "m")
    Condition
      Error in `test_fun()`:
      ! Can't select columns that don't exist.
      x Column `m` doesn't exist.

# check_columns_exist() error produces an error if the starts_with columns don't exist

    Code
      test_fun(mtcars, mpg, "cats")
    Condition
      Error in `test_fun()`:
      ! There are no columns that exist that start with `cats`.

# validate_table_inputs() produces an error if not a data.frame

    Code
      my_function("hello", "test", TRUE, TRUE, c("This is a footnote", "terribe"))
    Condition
      Error in `my_function()`:
      i In argument: `x`.
      ! `x` must be a data frame or tibble, not a string.

# validate_table_inputs() produces an error if the title is not a scalar character

    Code
      my_function(mtcars, 123, TRUE, TRUE, c("This is a footnote", "terribe"))
    Condition
      Error in `my_function()`:
      i In argument: `table_title`.
      ! `table_title` must be a string, not a number.

# validate_table_inputs() produces an error if the use question option is not a bool

    Code
      my_function(mtcars, "test", 123, TRUE, c("This is a footnote", "terribe"))
    Condition
      Error in `my_function()`:
      i In argument: `use_questions`.
      ! `use_questions` must be TRUE or FALSE, not a number.

# validate_table_inputs() produces an error if the use NA is not a bool

    Code
      my_function(mtcars, "test", TRUE, 123, c("This is a footnote", "terribe"))
    Condition
      Error in `my_function()`:
      i In argument: `use_NA`.
      ! `use_NA` must be TRUE or FALSE, not a number.

# validate_table_inputs() produces an error if the footnote is not a character vector

    Code
      my_function(mtcars, "test", TRUE, TRUE, mtcars)
    Condition
      Error in `my_function()`:
      i In argument: `footnote`.
      ! `footnote` must be `""`, not a data frame.

# validate_table_inputs() produces an error if you specify use_questions and have a footnote

    Code
      my_function(mtcars, "test", TRUE, TRUE, "This is a footnote")
    Condition
      Error in `my_function()`:
      x You can't specify `use_question = TRUE` and have a footnote.
      i Either set `use_question = FALSE` or do not have a footnote.

