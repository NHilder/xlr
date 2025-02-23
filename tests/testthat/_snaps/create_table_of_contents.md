# create_table_of_contents() creates an error when you don't pass a character title

    Code
      create_table_of_contents(tmp_file, title = 1)
    Condition
      Error:
      i In argument: `title`.
      ! `title` must be a string, not a number.

# create_table_of_contents() creates an error when you don't pass a boolean overwrite

    Code
      create_table_of_contents(tmp_file, overwrite = 1)
    Condition
      Error:
      i In argument: `overwrite`.
      ! `overwrite` must be TRUE or FALSE, not a number.

# create_table_of_contents() creates an error when you don't pass a boolean pull_titles

    Code
      create_table_of_contents(tmp_file, pull_titles = 1)
    Condition
      Error:
      i In argument: `pull_titles`.
      ! `pull_titles` must be TRUE or FALSE, not a number.

# create_table_of_contents() creates an error when you don't pass a TOC_sheet_name is not a character

    Code
      create_table_of_contents(tmp_file, TOC_sheet_name = 1)
    Condition
      Error:
      i In argument: `TOC_sheet_name`.
      ! `TOC_sheet_name` must be a string, not a number.

# create_table_of_contents() creates an error when an overwrite is FALSE

    Code
      create_table_of_contents(tmp_file, overwrite = FALSE)
    Condition
      Error in `create_table_of_contents()`:
      ! The sheet "Table of Contents" already exists in the workbook.
      i Set `overwrite = TRUE` if you wish to overwrite it.

# create_table_of_contents() creates an error when there is only a sheet called Table of Contents

    Code
      create_table_of_contents(tmp_file, overwrite = TRUE)
    Condition
      Error in `create_table_of_contents()`:
      ! Your workbook does not contain any sheets! Nothing to make a table of contents for.
      i Add data to your workbook and then call create_table_of_contents().
      i If you are exporting data from R, consider using `xlr::write_xlsx()` instead.

