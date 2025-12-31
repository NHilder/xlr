# Apply NA handling rules to multiple-response data

This internal helper function applies NA-handling rules to a
multiple-response dataset. It modifies the input `data.frame` by adding
indicator columns or by filtering rows based on missingness.
Specifically, it can:

## Usage

``` r
apply_NA_rules(
  x,
  use_NA,
  mcols,
  cols = NULL,
  exclude_codes = NULL,
  exclude_label = NULL,
  call = caller_env()
)
```

## Arguments

- x:

  A `data.frame` containing multiple-response data.

- use_NA:

  Logical; if `TRUE`, adds an indicator column for fully missing
  responses. If `FALSE`, removes rows with only missing responses.

- mcols:

  Character string specifying the common prefix for the
  multiple-response columns.

- cols:

  Character vector of additional column names to check for non-missing
  values when filtering. Defaults to `NULL`.

- exclude_codes:

  Vector of values representing "seen but answered" responses. If
  provided, an indicator column is created to capture this state and
  corresponding response values are converted to `NA`.

- exclude_label:

  Character string naming the "seen but answered" indicator column. If
  `NULL`, it is constructed automatically by concatenating
  `exclude_codes` values with underscores.

- call:

  Environment used for error reporting, typically from
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A modified `data.frame` that:

- Includes an additional `"<mcols>_<exclude_label>"` column if
  `exclude_codes` values are specified.

- Includes an additional `"<mcols>_NA"` column if `use_NA = TRUE`.

- Is filtered to exclude rows containing only `NA` values in relevant
  columns if `use_NA = FALSE`.

The returned object preserves the same class as `x`.

## Details

- Add a *"seen but answered"* indicator column, if values representing
  this state are supplied via `exclude_codes`.

- Add an *NA indicator column* (named `"<mcols>_NA"`) when
  `use_NA = TRUE`, marking rows where all multiple-response columns are
  `NA`.

- When `use_NA = FALSE`, remove rows that contain only `NA` values
  across the relevant columns.

This function is intended for internal use and not exported.
