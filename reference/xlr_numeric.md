# `xlr_numeric` vector

This creates an numeric vector that will be printed neatly and can
easily be exported to `Excel` using it's native format. You can convert
a vector back to its base type with
[`as_base_r()`](https://nhilder.github.io/xlr/reference/as_base_r.md).

## Usage

``` r
xlr_numeric(
  x = numeric(),
  dp = 2L,
  scientific = FALSE,
  style = xlr_format_numeric()
)

is_xlr_numeric(x)

as_xlr_numeric(x, dp = 0L, scientific = FALSE, style = xlr_format_numeric())
```

## Arguments

- x:

  - For `xlr_numeric()`: A numeric vector

  - For `is_xlr_numeric()`: An object to test

  - For `as_xlr_numeric()` : a vector

- dp:

  the number of decimal places to print

- scientific:

  logical. Whether to format the numeric using scientific notation.

- style:

  Additional styling options for the vector. See
  [xlr_format_numeric](https://nhilder.github.io/xlr/reference/xlr_format.md)
  for more details.

## Value

An S3 vector of class `xlr_numeric`

## Details

Internally, `xlr_numeric` uses `vec_cast` to convert numeric types to
integers. Anything that `vec_cast` can handle so can `xlr_numeric`. Read
more about casting at
[vec_cast](https://vctrs.r-lib.org/reference/vec_cast.html).

## See also

[`xlr_percent()`](https://nhilder.github.io/xlr/reference/xlr_percent.md),
[`xlr_integer()`](https://nhilder.github.io/xlr/reference/xlr_integer.md),
[`xlr_vector()`](https://nhilder.github.io/xlr/reference/xlr_vector.md),
[`as_base_r()`](https://nhilder.github.io/xlr/reference/as_base_r.md)

## Examples

``` r
library(xlr)
# Create a variable to represent a double with two decimal places
# The decimal places must be a positive integer
x <- xlr_numeric(2.1134,dp = 2)
# This will print nicely
x
#> <xlr_numeric[1]>
#> [1] 2.11
# You can change the styling, which affects how it looks when we print it
x <- xlr_numeric(x, dp = 3L, style = xlr_format(font_size = 9, font_colour = "red"))
x
#> <xlr_numeric[1]>
#> [1] 2.113
# We can also define a vector of doubles
y <- xlr_numeric(c(22.1055,1.3333333,3.1234567), dp = 2)
y
#> <xlr_numeric[3]>
#> [1] 22.11 1.33  3.12 
# You can convert existing data to a double using dplyr verbs
df <- data.frame(col_1 = c(2,3.2,1.33,4.43251))
df |>
  dplyr::mutate(col_pct = as_xlr_numeric(col_1))
#>     col_1 col_pct
#> 1 2.00000       2
#> 2 3.20000       3
#> 3 1.33000       1
#> 4 4.43251       4
# You can use as_xlr_numeric to convert a string in a double
df <- data.frame(col_str = c("12.22","12.34567","100"))
# now we can convert the string to a double(), internally it uses the same
# logic as as.double()
df |>
  dplyr::mutate(col_double = as_xlr_numeric(col_str,2))
#>    col_str col_double
#> 1    12.22      12.22
#> 2 12.34567      12.35
#> 3      100     100.00
```
