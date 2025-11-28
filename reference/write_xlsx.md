# Write a `xlr_table`, `data.frame`, or `tibble` to an .xlsx (`Excel`) file

This function writes `xlr_table`, `data.frame`, or `tibble` to an .xlsx
(`Excel` file). Like
[write.xlsx](https://rdrr.io/pkg/openxlsx/man/write.xlsx.html) you can
also write a `list` of `xlr_table`'s, `data.frame`'s, and `tibbles`'s to
the one file. The main use of this function is that it uses the
formatting in a `xlr_table` when it writes to the `Excel` sheet. See
[xlr_table](https://nhilder.github.io/xlr/reference/xlr_table.md) for
more information.

## Usage

``` r
write_xlsx(
  x,
  file,
  sheet_name = NULL,
  overwrite = FALSE,
  append = TRUE,
  TOC = FALSE,
  TOC_title = NA_character_,
  overwrite_sheets = TRUE,
  excel_data_table = TRUE
)
```

## Arguments

- x:

  a single or `list` of types `xlr_table`, `data.frame`, or `tibble`.

- file:

  character. A valid file path.

- sheet_name:

  a sheet name (optional). Only valid for when you pass a single object
  to `x`.

- overwrite:

  logical. Whether to overwrite the file/worksheet or not.

- append:

  logical. Whether or not to append a worksheet to an existing file.

- TOC:

  logical. Whether to create a table of contents with the document.
  Works only when you pass a `list` to `x`. To add a table of contents
  to an existing file, use
  [`create_table_of_contents()`](https://nhilder.github.io/xlr/reference/create_table_of_contents.md).

- TOC_title:

  character. To specify the table of contents title (optional).

- overwrite_sheets:

  logical. Whether to overwrite existing sheets in a file.

- excel_data_table:

  logical. Whether to save the data as an `Excel` table in the
  worksheet. These are more accessible than data in the sheet.

## Value

None

## Examples

``` r
library(xlr)
library(tibble)
# we can write a data.frame or tibble with write_xlsx
example_tibble <- tibble(example = c(1:100))

write_xlsx(mtcars,
           "example_file.xlsx",
           sheet_name = "Example sheet")
#> ℹ Appending file: example_file.xlsx

# you must specify a sheet name
write_xlsx(example_tibble,
           "example_file.xlsx",
           sheet_name = "Example sheet")
#> ℹ Appending file: example_file.xlsx

# You can write a xlr_table.
# When you write a xlr_table you can specify the formatting as well as titles
# and footnotes.
example_xlr_table <- xlr_table(mtcars,
                                 "This is a title",
                                 "This is a footnote")

write_xlsx(example_xlr_table,
           "example_file.xlsx",
           "Example sheet")
#> ℹ Appending file: example_file.xlsx

# like openxlsx, you can also pass a list
table_list <- list("Sheet name 1" = xlr_table(mtcars,
                                               "This is a title",
                                               "This is a footnote"),
                   "Sheet name 2" = xlr_table(mtcars,
                                              "This is a title too",
                                              "This is a footnote as well"))

write_xlsx(table_list,
           "example_file.xlsx")
#> ℹ Appending file: example_file.xlsx
```
