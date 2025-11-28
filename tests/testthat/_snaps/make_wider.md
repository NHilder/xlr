# that errors from inputting an invalid x is caught correctly

    Code
      make_wider(1)
    Condition
      Error in `as_string()`:
      ! Can't convert a double vector to a string.

---

    Code
      make_wider("not_a_df")
    Condition
      Error in `make_wider()`:
      ! `not_a_df` must be a data.frame, a tibble or a xlr_table.

# that errors from missing N or Percent is caught correctly

    Code
      make_wider(df)
    Condition
      Error in `make_wider()`:
      x `df` must contain the columns `N` and `Percent`.
      i Are you sure that you used `make_wider()` following `build_table()`, `build_mtable()` or `build_qtable()`?

---

    Code
      make_wider(df)
    Condition
      Error in `make_wider()`:
      x `df` must contain the columns `N` and `Percent`.
      i Are you sure that you used `make_wider()` following `build_table()`, `build_mtable()` or `build_qtable()`?

---

    Code
      make_wider(df)
    Condition
      Error in `make_wider()`:
      x `df` must contain the columns `N` and `Percent`.
      i Are you sure that you used `make_wider()` following `build_table()`, `build_mtable()` or `build_qtable()`?

# make_wider errors when only one grouping variable

    Code
      make_wider(df)
    Condition
      Error in `make_wider()`:
      x `df` must contain more than one grouping column.

# that errors from inputting an invalid top_variable is caught correctly

    Code
      make_wider(input, not_a_col)
    Condition
      Error in `make_wider()`:
      x `input` does not contain the column `not_a_col`.

# that errors from inputting an invalid names_prefix

    Code
      make_wider(input, names_prefix = function(x) x)
    Condition
      Error in `make_wider()`:
      ! `names_prefix` must be a single string, not a function.

