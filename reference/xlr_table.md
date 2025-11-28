# `xlr_table` object

Create a `xlr_table` S3 object. This is used to create an object that
stores formatting information, as well as a title and footnote. This
objects makes it easy to convert to an `Excel` sheet, using
[`write_xlsx()`](https://nhilder.github.io/xlr/reference/write_xlsx.md).
To edit underlying formatting options use
[`update_theme()`](https://nhilder.github.io/xlr/reference/update_theme.md).

A number of `dplyr` methods have been implemented for `xlr_table`, these
include `mutate`, `summarise`, `select`, etc. This means you can use
these functions on a `xlr_table`, without losing the `xlr_table`
attributes. You can check if the `dplyr` function is supported by
checking the documentation of the function. Currently, it is not
possible to use `group_by` and a `xlr_table`, as this would require the
implementation of a new class.

You can convert a table back to a data.frame with base type with
[`as_base_r()`](https://nhilder.github.io/xlr/reference/as_base_r.md).

## Usage

``` r
xlr_table(x, title = character(), footnote = character())

is_xlr_table(x)

as_xlr_table(x, title = character(), footnote = character())
```

## Arguments

- x:

  a data object

  - for `xlr_table()` : a `data.frame`, or `tibble`. See notes for
    further details.

  - for `is_xlr_table()` : An object

  - for `as_xlr_table()` a `data.frame`, or `tibble`.

- title:

  a string that is the title

- footnote:

  a string that is the footnote

## Value

a `xlr_table` S3 class

## See also

[`update_theme()`](https://nhilder.github.io/xlr/reference/update_theme.md),
[`as_base_r()`](https://nhilder.github.io/xlr/reference/as_base_r.md)

## Examples

``` r
library(xlr)
library(dplyr)
# Create a xlr_table, we set the footnotes and the title
# It converts to the xlr types by default
x <- xlr_table(mtcars,
                title = "mtcars is a fun data set",
                footnote = "mtcars is a data set that comes with base R")
# The title and the footnote print to console
x
#> 
#> ── mtcars is a fun data set ────────────────────────────────────────────────────
#> # A xlr_table: 32 x 11
#>        mpg     cyl    disp      hp    drat      wt  qsec    vs    am  gear  carb
#>    <x_num> <x_num> <x_num> <x_num> <x_num> <x_num> <x_n> <x_n> <x_n> <x_n> <x_n>
#>  1   21.00    6.00  160.00  110.00    3.90    2.62 16.46  0.00  1.00  4.00  4.00
#>  2   21.00    6.00  160.00  110.00    3.90    2.88 17.02  0.00  1.00  4.00  4.00
#>  3   22.80    4.00  108.00   93.00    3.85    2.32 18.61  1.00  1.00  4.00  1.00
#>  4   21.40    6.00  258.00  110.00    3.08    3.21 19.44  1.00  0.00  3.00  1.00
#>  5   18.70    8.00  360.00  175.00    3.15    3.44 17.02  0.00  0.00  3.00  2.00
#>  6   18.10    6.00  225.00  105.00    2.76    3.46 20.22  1.00  0.00  3.00  1.00
#>  7   14.30    8.00  360.00  245.00    3.21    3.57 15.84  0.00  0.00  3.00  4.00
#>  8   24.40    4.00  146.70   62.00    3.69    3.19 20.00  1.00  0.00  4.00  2.00
#>  9   22.80    4.00  140.80   95.00    3.92    3.15 22.90  1.00  0.00  4.00  2.00
#> 10   19.20    6.00  167.60  123.00    3.92    3.44 18.30  1.00  0.00  4.00  4.00
#> # ℹ 22 more rows
#> mtcars is a data set that comes with base R
# You can use mutate and summarise with xlr_tables and they are preserved
x |>
  summarise(mean_mpg = sum(mpg))
#> 
#> ── mtcars is a fun data set ────────────────────────────────────────────────────
#> # A xlr_table: 1 x 1
#>   mean_mpg
#>      <dbl>
#> 1     643.
#> mtcars is a data set that comes with base R
# Rename a column
x |>
  rename(new_name = mpg)
#> 
#> ── mtcars is a fun data set ────────────────────────────────────────────────────
#> # A xlr_table: 32 x 11
#>    new_name     cyl    disp      hp    drat     wt  qsec    vs    am  gear  carb
#>     <x_num> <x_num> <x_num> <x_num> <x_num> <x_nu> <x_n> <x_n> <x_n> <x_n> <x_n>
#>  1    21.00    6.00  160.00  110.00    3.90   2.62 16.46  0.00  1.00  4.00  4.00
#>  2    21.00    6.00  160.00  110.00    3.90   2.88 17.02  0.00  1.00  4.00  4.00
#>  3    22.80    4.00  108.00   93.00    3.85   2.32 18.61  1.00  1.00  4.00  1.00
#>  4    21.40    6.00  258.00  110.00    3.08   3.21 19.44  1.00  0.00  3.00  1.00
#>  5    18.70    8.00  360.00  175.00    3.15   3.44 17.02  0.00  0.00  3.00  2.00
#>  6    18.10    6.00  225.00  105.00    2.76   3.46 20.22  1.00  0.00  3.00  1.00
#>  7    14.30    8.00  360.00  245.00    3.21   3.57 15.84  0.00  0.00  3.00  4.00
#>  8    24.40    4.00  146.70   62.00    3.69   3.19 20.00  1.00  0.00  4.00  2.00
#>  9    22.80    4.00  140.80   95.00    3.92   3.15 22.90  1.00  0.00  4.00  2.00
#> 10    19.20    6.00  167.60  123.00    3.92   3.44 18.30  1.00  0.00  4.00  4.00
#> # ℹ 22 more rows
#> mtcars is a data set that comes with base R
# When you want to change how elements of the table look when written using
# write_xlsx, you can update it with update them
x <- x |>
  # make the font bigger
  update_theme(title_format = xlr_format(font_size = 14))
# you must write it in order to see the formatting changes
write_xlsx(x,
             "example.xlsx",
             "A example sheet",
             TOC = FALSE)
#> ℹ Appending file: example.xlsx
```
