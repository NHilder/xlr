# Remove rows with NA values

Removes rows from a data frame based on NA patterns in specified
columns. By default, removes rows if ANY of the specified columns
contain NA. Can optionally remove only rows where ALL specified columns
are NA.

## Usage

``` r
remove_NA(.data, cols, complete = TRUE, call = caller_env())
```

## Arguments

- .data:

  A data frame or tibble

- cols:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to check for NA values. If no columns are specified, returns
  the data unchanged.

- complete:

  Logical. If `TRUE` (default), removes rows where all of the specified
  columns contain NA. If `FALSE`, removes only rows where at least one
  of the specified columns are NA.

- call:

  The execution environment of a currently running function, e.g.
  `caller_env()`. Used for error reporting.

## Value

A data frame with rows removed based on NA patterns
