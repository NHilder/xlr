# the getters and setters error for a non xlr_table

    Code
      get_title(mtcars)
    Condition
      Error in `get_title()`:
      i In argument: `x`.
      ! `x` must be a <xlr_table>, not a data frame.

---

    Code
      set_footnote(mtcars, "a")
    Condition
      Error in `set_footnote()`:
      i In argument: `x`.
      ! `x` must be a <xlr_table>, not a data frame.

---

    Code
      get_table_body_format(1)
    Condition
      Error in `get_table_body_format()`:
      i In argument: `x`.
      ! `x` must be a <xlr_table>, not a number.

# the setters error for invalid values

    Code
      set_title(x, c("a", "b"))
    Condition
      Error in `set_title()`:
      i In argument: `value`.
      ! `value` must be a string or `NULL`, not a character vector.

---

    Code
      set_title(x, 1)
    Condition
      Error in `set_title()`:
      i In argument: `value`.
      ! `value` must be a string or `NULL`, not a number.

---

    Code
      set_footnote(x, 1)
    Condition
      Error in `set_footnote()`:
      i In argument: `value`.
      ! `value` must be a character vector or `NULL`, not a number.

---

    Code
      set_title_format(x, "bold")
    Condition
      Error in `set_title_format()`:
      i In argument: `value`.
      ! `value` must be a <xlr_format> object, not a string.

