# that errors from inputting an invalid column is caught correctly

    Code
      build_table(mtcars, not_a_col)
    Condition
      Error in `build_table()`:
      ! Can't select columns that don't exist.
      x Column `not_a_col` doesn't exist.

---

    Code
      build_table(mtcars, "not_a_col")
    Condition
      Error in `build_table()`:
      ! Can't select columns that don't exist.
      x Column `not_a_col` doesn't exist.

# that errors from inputting an invalid column in a vector is caught correctly

    Code
      build_table(mtcars, c(mpg, not_a_col))
    Condition
      Error in `build_table()`:
      ! Can't select columns that don't exist.
      x Column `not_a_col` doesn't exist.

# test that adding a footnote manually and adding footnote_question throws an erorr

    Code
      build_table(df, "Q1_1", table_title = "Test", use_questions = TRUE, footnote = "A footnote")
    Condition
      Error in `build_table()`:
      x You can't specify `use_question = TRUE` and have a footnote.
      i Either set `use_question = FALSE` or do not have a footnote.

