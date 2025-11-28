# `xlr_n_percent` vector

This creates a record vector combining counts (`N`) and percentages
(`pct`) that will be printed with appropriate formatting and exported to
`Excel` using its native formats. You can convert a vector back to its
base type with
[`as_base_r()`](https://nhilder.github.io/xlr/reference/as_base_r.md).

## Usage

``` r
xlr_n_percent(
  n = integer(),
  pct = xlr_percent(),
  dp = 0L,
  style = xlr_format_numeric()
)

is_xlr_n_percent(x)
```

## Arguments

- n:

  A positive integer vector of counts

- pct:

  A numeric vector of proportions

- dp:

  The number of decimal places to print for the percentage.

- style:

  Additional styling options for the vector. See
  [xlr_format_numeric](https://nhilder.github.io/xlr/reference/xlr_format.md)
  for more details.

- x:

  For `is_xlr_n_percent()`: An object to test

## Value

An S3 record vector of class `xlr_n_percent`.

## See also

[`xlr_vector()`](https://nhilder.github.io/xlr/reference/xlr_vector.md),
[`xlr_integer()`](https://nhilder.github.io/xlr/reference/xlr_integer.md),
[`xlr_numeric()`](https://nhilder.github.io/xlr/reference/xlr_numeric.md),
[`xlr_percent()`](https://nhilder.github.io/xlr/reference/xlr_percent.md),
[`as_base_r()`](https://nhilder.github.io/xlr/reference/as_base_r.md)

## Examples

``` r
library(xlr)
# lets define a xlr_n_percent, which combines counts (N) and proportions (pct between 0-1)
#
# Create a variable to represent count 10 with 50%
x <- xlr_n_percent(n = 10L, pct = 0.5)
# This will print nicely
x
#> <xlr_n_percent[1]>
#> [1] 10 (50%)
# Now we can increase the number of decimal places to display
# The decimal places must be a positive integer
x <- xlr_n_percent(n = 10L, pct = 0.5, dp = 3L)
x
#> <xlr_n_percent[1]>
#> [1] 10 (50.000%)
# We can also define a vector of xlr_n_percents
y <- xlr_n_percent(n = c(10L, 20L, 30L), pct = c(0.1055, 0.3333333, 0.1234567), dp = 2)
y
#> <xlr_n_percent[3]>
#> [1] 10 (10.55%) 20 (33.33%) 30 (12.35%)
# You can convert existing data to a xlr_n_percent using dplyr verbs
df <- data.frame(N = c(0L, 20L, 33L, 43L), pct = c(0, 0.2, 0.33, 0.43251))
df |>
  dplyr::mutate(col_np = xlr_n_percent(N, pct))
#>    N     pct   col_np
#> 1  0 0.00000   0 (0%)
#> 2 20 0.20000 20 (20%)
#> 3 33 0.33000 33 (33%)
#> 4 43 0.43251 43 (43%)
# You can also change the styling of a xlr_n_percent column, this is only relevant
# if you print it to `Excel` with write_xlsx
df |>
  dplyr::mutate(col_np = xlr_n_percent(N,
                                       pct,
                                       dp = 2,
                                       style = xlr_format_numeric(font_size = 8)))
#>    N     pct      col_np
#> 1  0 0.00000   0 (0.00%)
#> 2 20 0.20000 20 (20.00%)
#> 3 33 0.33000 33 (33.00%)
#> 4 43 0.43251 43 (43.25%)

# You can also convert it to a neat formatted character with as.character()
xlr_n_percent(n = c(10L, 20L, 30L), pct = c(0.1055, 0.3333333, 0.1234567),
              dp = 2) |>
  as.character()
#> [1] "10 (10.55%)" "20 (33.33%)" "30 (12.35%)"
# if you change the number of percentages it changes in the character
xlr_n_percent(n = c(10L, 20L, 30L), pct = c(0.1055, 0.3333333, 0.1234567),
              dp = 0) |>
  as.character()
#> [1] "10 (11%)" "20 (33%)" "30 (12%)"
```
