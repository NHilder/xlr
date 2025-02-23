# type_abort() works correctly

    Code
      type_abort(x, is_double, 1.1)
    Condition
      Error:
      i In argument: `x`.
      ! `x` must be a number, not a string.

---

    Code
      type_abort(x, is_double, 1.1, "a test type")
    Condition
      Error:
      i In argument: `x`.
      ! `x` must be a test type, not a string.

