# That when no columns start with the block column we get an error

    Code
      build_qtable(mtcars, "p")
    Condition
      Error in `build_qtable()`:
      ! Can't select columns that don't exist.
      x Column `p` doesn't exist.

# that errors from inputting an invalid column is caught correctly

    Code
      build_qtable(mtcars, "mpg", not_a_col)
    Condition
      Error in `build_qtable()`:
      ! Can't select columns that don't exist.
      x Column `not_a_col` doesn't exist.

---

    Code
      build_qtable(mtcars, "mpg", c(wt, not_a_col))
    Condition
      Error in `build_qtable()`:
      ! Can't select columns that don't exist.
      x Column `not_a_col` doesn't exist.

# When we select data that has two different types, we get a error

    Code
      build_qtable(df, c(x1, x2))
    Condition
      Error in `build_qtable()`:
      ! Error in your block column selection.
      ! The columns you selected as your question block do not have the same type!
      i Check the type of column `x2`?

# When we select data that is a factor with two different levels then we get an error.

    Code
      build_qtable(df, c(x1, x2))
    Condition
      Error in `build_qtable()`:
      ! Error in your block column selection.
      ! The columns you selected have different elements.
      i Consider converting your columns to factors before using `build_qtable()`.
      i Or start by checking the levels of column `x2`?

# When we select data that is a character that when converted to a factor have different levels then we get an error

    Code
      build_qtable(df, c(x1, x2))
    Condition
      Error in `build_qtable()`:
      ! Error in your block column selection.
      ! The columns you selected have different elements.
      i Consider converting your columns to factors before using `build_qtable()`.
      i Or start by checking the levels of column `x2`?

# test that adding a footnote manually and adding footnote_question throws an erorr

    Code
      build_qtable(df, starts_with("Q1"), table_title = "Test", use_questions = TRUE,
      footnote = "A footnote")
    Condition
      Error in `build_qtable()`:
      x You can't specify `use_question = TRUE` and have a footnote.
      i Either set `use_question = FALSE` or do not have a footnote.

