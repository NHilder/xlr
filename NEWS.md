# xlr (development version)

## Breaking changes

* `write_xlsx()` has a new `if_exists` argument (`"overwrite"`, `"append"` or
  `"error"`) to choose what happens when the file already exists. If it isn't
  set and the file exists, you are asked what to do in an interactive
  session, and an error is thrown otherwise. Previously the file was appended
  to by default. The `overwrite` and `append` arguments are deprecated and
  give a warning. `if_exists` takes the position of `overwrite`, so pass the
  deprecated arguments by name.
* `write_xlsx()` no longer deletes the existing file before saving, so a failed
  save leaves the original file in place.
* `as_xlr_numeric()` now defaults to `dp = 2L`, the same as `xlr_numeric()`
  (it was `0L`).
* Casting between xlr types (e.g. `vec_cast(x, xlr_numeric(dp = 3))`) now keeps
  the `dp`, `scientific`, `style` and `excel_format` of the target, instead of
  using the defaults or the attributes of `x`.

## Bug fixes

* `xlr_format()` now accepts the openxlsx border style `"slantDashDot"`, and
  no longer accepts the misspelt `"dastDotDot"` and `"slantDashDosh"` (which
  openxlsx doesn't support). `border_style` is now validated even when
  `border_colour = NULL`.

# xlr 1.1.2
* Updated code to fix a bug caused by `dplyr` dependency.

# xlr 1.1.1
## Bugs
* Refactored some internal code for NA handling to handle changes in `dplyr`
  code


# xlr 1.1.0

## New Features

* Added `make_wider()` function to easily pivot outputs from `build_table()` and related functions for creating wider table formats.
* Added support for `exclude_codes` parameter in multiple response questions for the
function `build_mtable()`. This parameter supports passing values like `-99` that
should be excluded from the analysis. See the documentation for `build_mtable()`.
* Added column width support to `xlr_format()`, instead of `xlr` trying to guess
the width.
* Created a new type `xlr_n_percent`, which combines a count and a percentage. Like all
other `xlr` types, it can be written to Excel. 

## Vector Arithmetic & Type System Improvements

* Added vector arithmetic support (`vctrs::vec_math()`) for `xlr` types. Most base R
vector operations are now supported (e.g., `sum()`, `mean()`, `median()`). See `vctrs::vec_math()` 
for more details on supported operations.
* `xlr_integer` now supports division and conversion to numeric (returns `xlr_numeric`).
* Added support for type conversion between all `xlr` types. You can now convert
all `xlr` types to each other, e.g., `xlr_numeric` to `xlr_integer`, `xlr_percent` to
`xlr_integer`.
* `xlr_percent` now works with ggplot2 without errors.
* `as.character()` on `xlr_percent` now returns formatted percentage strings.
* Refactored xlr classes to inherit from base types for better compatibility.

## Bug Fixes

* Fixed a bug in `build_qtable()` where an `NA` value in one column resulted
in the entire row being removed.
* Improved error handling in internal tidyr function calls.

## Documentation & Testing

* Relaxed restrictions on column value requirements for `build_qtable()`. Response
values for each column in the block only need to be a subset of the first column.
* Improved documentation for question-related functions.
* Added tests for ggplot2 compatibility.
* Updated snapshots for remote tests.
* Updated DESCRIPTION file for latest roxygen2 version.

# xlr 1.0.3

- CRAN re-submission:
    - Fixed title and description to follow CRAN's standards (moved from 
    back-ticks to single quotes)!
    
# xlr 1.0.2

- CRAN re-submission:
    - Fixed title to follow CRAN's standards.
    
# xlr 1.0.1

-   CRAN re-submission. Fix issues:
    -   Made `Excel` referenced in back-ticks \`\`.
    -   Removed externally facing documentation for internal package functions.
    -   Changed examples so that they no longer use `\dontrun` but instead create a temporary working directory following `readr` examples. We instead use `\dontshow` to hide setting this working directory.
    -   Fixed typos in the vignette.
    -   Fixed line spacing issues with the Description due to inconsistent space sizing.

# xlr 1.0.0

-   Initial CRAN submission.
