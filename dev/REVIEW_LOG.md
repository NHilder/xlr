# Review log

Items found during code review that were deferred to be revisited.

## `make_wider()` picks the wrong column for `build_mtable()` output

With no `top_variable`, `make_wider()` uses the column at position
`length(cols) - 3` after moving `N` and `Percent` to the end. For
`build_mtable()` output the columns are `<cols>, <mcol>, N_group, N, Percent`,
so the heuristic picks the multiple response column rather than the cut
variable, and `N_group` is left in the pivoted data.

Repro:

```r
clothes_opinions |>
  build_mtable("Q2", gender2) |>
  make_wider()
```

Candidate fixes:

- Drop `N_group` (or fold it into the header) before pivoting when present.
- Detect `build_mtable()` output and choose the first grouping column instead.
- Require `top_variable` when the input has an `N_group` column.

## Session option for default decimal places

Considered `dp = getOption("xlr.dp", 2L)` for `xlr_numeric()` /
`as_xlr_numeric()`. Deferred: it makes output depend on session state and
would need the same treatment for every numeric type. Defaults are `2L` for now.

## `build_mtable(use_questions = TRUE)` label prefix can cut into an option

The question label is taken as the common prefix of the column labels, so
options that share a first letter leave part of the option in the footnote.
For example `"What food do you enjoy? Sweet"` and `"... Savoury"` give
`"What food do you enjoy? S"`. A fix could cut back to the last space or
punctuation mark when the prefix ends mid-word.

## `text_rotation` stays between -90 and 90

openxlsx also accepts `textRotation = 255` for vertical text. Kept at -90 to 90
on purpose: tested manually and vertical text isn't wanted.

## Replace openxlsx

openxlsx is no longer maintained, so xlr will move to another `Excel` package.
Code that depends on openxlsx:

- styles: `xlr_format_to_openxlsx_format()`, `get_border_styles()`,
  `column_to_style()` and `generate_dp()` in `R/xlr_to_workbook.R`;
- workbook creation and writing: `xlr_to_workbook()`, `xlr_table_to_sheet()`,
  `dataframe_to_sheet()`, `data_to_worksheet()` and `write_xlsx()`;
- the table of contents and its hyperlinks: `R/create_table_of_contents.R` and
  `add_TOC_to_workbook()`;
- test helpers in `R/openxlsx_utils.R`.

See `dev/S7_DESIGN.md` for converting `xlr_format` to S7 at the same time.

## Commented-out `equal_workbook_data()` checks

Several `equal_workbook_data()` / `equal_openxlsx_workbook()` checks in
`tests/testthat/test-xlr_to_workbook.R` are commented out. They fail because
openxlsx doesn't update some workbook content until the file is first opened
in `Excel`. They need updating, probably as part of replacing openxlsx.
