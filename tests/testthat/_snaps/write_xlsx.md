# write_xlsx() appends a file with if_exists = 'append'

    Code
      write_xlsx(mtcars, tmp_file, sheet_name = "Test", if_exists = "append")
    Message
      i Appending file:

# write_xlsx() overwrites a file with if_exists = 'overwrite'

    Code
      write_xlsx(mtcars, tmp_file, sheet_name = "Test", if_exists = "overwrite")
    Message
      i Overwriting file:

# write_xlsx() errors with if_exists = 'error' and leaves the file

    Code
      write_xlsx(mtcars, tmp_file, sheet_name = "Test", if_exists = "error")
    Condition
      Error in `write_xlsx()`:
      ! Cannot write file, already exists!

# write_xlsx() errors outside an interactive session if if_exists is not set

    Code
      write_xlsx(mtcars, tmp_file, sheet_name = "Test")
    Condition
      Error in `write_xlsx()`:
      ! already exists.
      i Set `if_exists = "overwrite"` or `if_exists = "append"` to write to it.

# write_xlsx() asks what to do in an interactive session

    Code
      write_xlsx(mtcars, tmp_file, sheet_name = "Cancelled")
    Condition
      Error in `write_xlsx()`:
      ! Cancelled, was not changed.

# write_xlsx() validates if_exists

    Code
      write_xlsx(mtcars, tmp_file, "Test", if_exists = "replace")
    Condition
      Error in `write_xlsx()`:
      ! `if_exists` must be one of "overwrite", "append", or "error", not "replace".

---

    Code
      write_xlsx(mtcars, tmp_file, "Test", TRUE)
    Condition
      Error in `write_xlsx()`:
      i In argument: `if_exists`.
      ! `if_exists` must be a string, not `TRUE`.
      i Did you mean to pass `overwrite` or `append`? Name the argument, or use `if_exists = "overwrite"`.

# write_xlsx() gives an error when append and overwrite is true

    Code
      write_xlsx(mtcars, tmp_file, sheet_name = "Test", TOC = FALSE, overwrite = TRUE,
        append = TRUE)
    Condition
      Error in `write_xlsx()`:
      ! You can only overwrite or append a file, not both.

# write_xlsx() maps the deprecated arguments to if_exists with a warning

    Code
      write_xlsx(mtcars, tmp_file, "Appended", overwrite = FALSE)
    Condition
      Warning in `write_xlsx()`:
      ! The `overwrite` and `append` arguments of `write_xlsx()` are deprecated.
      i Use `if_exists = "append"` instead.
    Message
      i Appending file:

---

    Code
      write_xlsx(mtcars, tmp_file, "Overwritten", overwrite = TRUE)
    Condition
      Warning in `write_xlsx()`:
      ! The `overwrite` and `append` arguments of `write_xlsx()` are deprecated.
      i Use `if_exists = "overwrite"` instead.
    Message
      i Overwriting file:

---

    Code
      write_xlsx(mtcars, tmp_file, "Test", overwrite = FALSE, append = FALSE)
    Condition
      Warning in `write_xlsx()`:
      ! The `overwrite` and `append` arguments of `write_xlsx()` are deprecated.
      i Use `if_exists = "error"` instead.
      Error in `write_xlsx()`:
      ! Cannot write file, already exists!

# write_xlsx() errors when if_exists is used with the deprecated arguments

    Code
      write_xlsx(mtcars, tmp_file, "Test", if_exists = "overwrite", overwrite = TRUE)
    Condition
      Error in `write_xlsx()`:
      ! You can't use `if_exists` with the deprecated `overwrite` or `append` arguments.
      i Use only `if_exists`.

# write_xlsx() reports sheet errors against write_xlsx()

    Code
      write_xlsx(data.frame(), tmp_file, "Empty")
    Condition
      Error in `write_xlsx()`:
      i In argument: `x`.
      ! Your data frame or tibble must contain columns.

# write_xlsx() errors for duplicate sheet names in a list

    Code
      write_xlsx(list(a = mtcars, A = mtcars), tmp_file)
    Condition
      Error in `write_xlsx()`:
      ! Sheet names must be unique, these names clash: "a" and "A".
      i Sheet names are not case sensitive in `Excel`.

