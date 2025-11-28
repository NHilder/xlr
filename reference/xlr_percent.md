# `xlr_percent` vector

This creates a numeric vector that will be printed as a percentage and
exported to `Excel` using it's native format.You can convert a vector
back to its base type with
[`as_base_r()`](https://nhilder.github.io/xlr/reference/as_base_r.md).

## Usage

``` r
xlr_percent(x = double(), dp = 0L, style = xlr_format_numeric())

is_xlr_percent(x)

as_xlr_percent(x, dp = 0L, style = xlr_format_numeric())
```

## Arguments

- x:

  - For `xlr_percent()`: A numeric vector

  - For `is_xlr_percent()`: An object to test

  - For `as_xlr_percent()` : a numeric or character vector. For a
    character vector, the data must be in the format `"XXX.YYY...%"`.

- dp:

  the number of decimal places to print

- style:

  Additional styling options for the vector. See
  [xlr_format_numeric](https://nhilder.github.io/xlr/reference/xlr_format.md)
  for more details.

## Value

An S3 vector of class `xlr_percent`

## See also

[`xlr_vector()`](https://nhilder.github.io/xlr/reference/xlr_vector.md),
[`xlr_integer()`](https://nhilder.github.io/xlr/reference/xlr_integer.md),
[`xlr_numeric()`](https://nhilder.github.io/xlr/reference/xlr_numeric.md),
[`as_base_r()`](https://nhilder.github.io/xlr/reference/as_base_r.md)

## Examples

``` r
library(xlr)
# lets define a xlr_percent, a xlr_percent is between a number between [0-1], not
# between 1-100
#
# Create a variable to represent 10%
x <- xlr_percent(0.1)
# This will print nicely
x
#> <xlr_percent[1]>
#> [1] 10%
# Now we can increase the number of decimal places to display
# The decimal places must be a positive integer
x <- xlr_percent(x, dp = 3L)
x
#> <xlr_percent[1]>
#> [1] 10.000%
# We can also define a vector of xlr_percents
y <- xlr_percent(c(0.1055,0.3333333,0.1234567), dp = 2)
y
#> <xlr_percent[3]>
#> [1] 10.55% 33.33% 12.35%
# You can convert existing data to a xlr_percentage using dplyr verbs
df <- data.frame(col_1 = c(0,0.2,0.33,0.43251))
df |>
  dplyr::mutate(col_pct = as_xlr_percent(col_1))
#>     col_1 col_pct
#> 1 0.00000      0%
#> 2 0.20000     20%
#> 3 0.33000     33%
#> 4 0.43251     43%
# You can also change the styling of a xlr_percent column, this is only relevant
# if you print it to `Excel` with write_xlsx
df |>
  dplyr::mutate(col_pct = xlr_percent(col_1,
                                  dp = 2,
                                  style = xlr_format(font_size = 8)))
#>     col_1 col_pct
#> 1 0.00000   0.00%
#> 2 0.20000  20.00%
#> 3 0.33000  33.00%
#> 4 0.43251  43.25%
# You can use as_xlr_percent to convert a string in a xlr_percentage format to a
# xlr_percent
df <- data.frame(col_str = c("12.22%","12.34567%","100%"))
# now we can convert the string to a xlr_xlr_percent()
df |>
  dplyr::mutate(col_xlr_percent = as_xlr_percent(col_str,2))
#>     col_str col_xlr_percent
#> 1    12.22%          12.22%
#> 2 12.34567%          12.35%
#> 3      100%         100.00%
```
