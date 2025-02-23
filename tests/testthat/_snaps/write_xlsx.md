# write_xlsx() gives an error when append and overwrite is true

    Code
      write_xlsx(mtcars, tmp_file, sheet_name = "Test", TOC = FALSE, overwrite = TRUE,
        append = TRUE)
    Condition
      Error in `write_xlsx()`:
      ! You can only overwrite or append a file, not both.

# write_xlsx() sends a message when it appends a file

    Code
      write_xlsx(mtcars, tmp_file, sheet_name = "Test", overwrite = FALSE, append = TRUE)
    Message
      i Appending file:

# write_xlsx() sends a message when it overwrites a file

    Code
      write_xlsx(mtcars, tmp_file, sheet_name = "Test", overwrite = TRUE, append = FALSE)
    Message
      i Overwriting file:

# write_xlsx() sends an error when it is not allowed to modify a file

    Code
      write_xlsx(mtcars, tmp_file, sheet_name = "Test", overwrite = FALSE, append = FALSE)
    Condition
      Error in `write_xlsx()`:
      ! Cannot write file, already exists!

