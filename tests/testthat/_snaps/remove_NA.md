# remove_NA errors when the selection renames a column

    Code
      remove_NA(df, c(x = a))
    Condition
      Error:
      ! Can't rename variables in this context.

---

    Code
      remove_NA(df, c(x = a), complete = FALSE)
    Condition
      Error:
      ! Can't rename variables in this context.

