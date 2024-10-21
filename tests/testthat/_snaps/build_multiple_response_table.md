# Test arg `x` is a tibble/ data.frame

    Code
      build_mtable(1)
    Condition
      Error in `build_mtable()`:
      i In argument: `x`.
      ! `x` must be a data frame or tibble, not a number.

# That when no columns start with the block column we get an error

    Code
      build_mtable(test_df, "p")
    Condition
      Error in `build_mtable()`:
      ! There are no columns that exist that start with `p`.

# that errors from inputting an invalid column is caught correctly

    Code
      build_mtable(test_df, "enjoy_veg", not_a_col)
    Condition
      Error in `build_mtable()`:
      ! Can't select columns that don't exist.
      x Column `not_a_col` doesn't exist.

---

    Code
      build_mtable(test_df, "enjoy_veg", c(weight, not_a_col))
    Condition
      Error in `build_mtable()`:
      ! Can't select columns that don't exist.
      x Column `not_a_col` doesn't exist.

# Test arg `table_title` is a scalar character

    Code
      build_mtable(tibble(x = 1), table_title = 1)
    Condition
      Error in `build_mtable()`:
      i In argument: `table_title`.
      ! `table_title` must be a string, not a number.

# Test arg `use_questions` is a scalar logical

    Code
      build_mtable(tibble(x = 1), table_title = "A", use_questions = 1)
    Condition
      Error in `build_mtable()`:
      i In argument: `use_questions`.
      ! `use_questions` must be TRUE or FALSE, not a number.

# test that adding a footnote manually and adding footnote_question throws an error

    Code
      build_mtable(df, "enjoy_veg", table_title = "Test", use_questions = TRUE,
        footnote = "A footnote")
    Condition
      Error in `build_mtable()`:
      x You can't specify `use_question = TRUE` and have a footnote.
      i Either set `use_question = FALSE` or do not have a footnote.

# Test we get an error if you include a column without unique results

    Code
      build_mtable(test_df, "enjoy_fruit")
    Condition
      Error in `build_mtable()`:
      i In arguments: `x` and `mcols`.
      Data frame columns `enjoy_fruit_other` must have at most one non-missing value.

# Test that a non numeric wt column errors

    Code
      build_mtable(test_df, "enjoy_fruit", wt = weight)
    Condition
      Error in `build_mtable()`:
      i In argument: `wt`.
      ! `wt` must be a number, not a character vector.

# Test that when there are multiple mcols we through an error

    Code
      build_mtable(test_df, c("enjoy_fruit", "enjoy_veg", "enjoy_food"))
    Condition
      Error in `build_mtable()`:
      i In arguments: `mcols`.
      x You cannot specify more than two multiple response columns.
      i For more complicated counts we recommend using `tidyr::pivot_longer()` and `dplyr::left_join()`.

