# Changelog

## xlr (development version)

## xlr 1.1.0

### New Features

- Added
  [`make_wider()`](https://nhilder.github.io/xlr/reference/make_wider.md)
  function to easily pivot outputs from
  [`build_table()`](https://nhilder.github.io/xlr/reference/build_table.md)
  and related functions for creating wider table formats.
- Added support for `exclude_codes` parameter in multiple response
  questions for the function
  [`build_mtable()`](https://nhilder.github.io/xlr/reference/build_mtable.md).
  This parameter supports passing values like `-99` that should be
  excluded from the analysis. See the documentation for
  [`build_mtable()`](https://nhilder.github.io/xlr/reference/build_mtable.md).
- Added column width support to
  [`xlr_format()`](https://nhilder.github.io/xlr/reference/xlr_format.md),
  instead of `xlr` trying to guess the width.
- Created a new type `xlr_n_percent`, which combines a count and a
  percentage. Like all other `xlr` types, it can be written to Excel.

### Vector Arithmetic & Type System Improvements

- Added vector arithmetic support
  ([`vctrs::vec_math()`](https://vctrs.r-lib.org/reference/vec_math.html))
  for `xlr` types. Most base R vector operations are now supported
  (e.g., [`sum()`](https://rdrr.io/r/base/sum.html),
  [`mean()`](https://rdrr.io/r/base/mean.html),
  [`median()`](https://rdrr.io/r/stats/median.html)). See
  [`vctrs::vec_math()`](https://vctrs.r-lib.org/reference/vec_math.html)
  for more details on supported operations.
- `xlr_integer` now supports division and conversion to numeric (returns
  `xlr_numeric`).
- Added support for type conversion between all `xlr` types. You can now
  convert all `xlr` types to each other, e.g., `xlr_numeric` to
  `xlr_integer`, `xlr_percent` to `xlr_integer`.
- `xlr_percent` now works with ggplot2 without errors.
- [`as.character()`](https://rdrr.io/r/base/character.html) on
  `xlr_percent` now returns formatted percentage strings.
- Refactored xlr classes to inherit from base types for better
  compatibility.

### Bug Fixes

- Fixed a bug in
  [`build_qtable()`](https://nhilder.github.io/xlr/reference/build_qtable.md)
  where an `NA` value in one column resulted in the entire row being
  removed.
- Improved error handling in internal tidyr function calls.

### Documentation & Testing

- Relaxed restrictions on column value requirements for
  [`build_qtable()`](https://nhilder.github.io/xlr/reference/build_qtable.md).
  Response values for each column in the block only need to be a subset
  of the first column.
- Improved documentation for question-related functions.
- Added tests for ggplot2 compatibility.
- Updated snapshots for remote tests.
- Updated DESCRIPTION file for latest roxygen2 version.

## xlr 1.0.3

CRAN release: 2025-03-07

- CRAN re-submission:
  - Fixed title and description to follow CRAN’s standards (moved from
    back-ticks to single quotes)!

## xlr 1.0.2

- CRAN re-submission:
  - Fixed title to follow CRAN’s standards.

## xlr 1.0.1

- CRAN re-submission. Fix issues:
  - Made `Excel` referenced in back-ticks \`\`.
  - Removed externally facing documentation for internal package
    functions.
  - Changed examples so that they no longer use `\dontrun` but instead
    create a temporary working directory following `readr` examples. We
    instead use `\dontshow` to hide setting this working directory.
  - Fixed typos in the vignette.
  - Fixed line spacing issues with the Description due to inconsistent
    space sizing.

## xlr 1.0.0

- Initial CRAN submission.
