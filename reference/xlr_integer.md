# `xlr_integer` vector

This creates an integer vector that will be printed neatly and can
easily be exported to `Excel` using it's native format.You can convert a
vector back to its base type with
[`as_base_r()`](https://nhilder.github.io/xlr/reference/as_base_r.md).

## Usage

``` r
xlr_integer(x = integer(), style = xlr_format_numeric())

is_xlr_integer(x)

as_xlr_integer(x, style = xlr_format_numeric())
```

## Arguments

- x:

  A numeric vector

  - For `xlr_integer()`: A numeric vector

  - For `is_xlr_integer()`: An object to test

  - For `as_xlr_integer()` : a vector

- style:

  Additional styling options for the vector. See
  [xlr_format_numeric](https://nhilder.github.io/xlr/reference/xlr_format.md)
  for more details.

## Value

An S3 vector of class `xlr_integer`

## Details

Internally, `xlr_integer` uses `vec_cast` to convert numeric types to
integers. Anything that `vec_cast` can handle so can `xlr_integer`. Read
more about casting at
[vec_cast](https://vctrs.r-lib.org/reference/vec_cast.html).

## See also

[`xlr_vector()`](https://nhilder.github.io/xlr/reference/xlr_vector.md),
[`xlr_percent()`](https://nhilder.github.io/xlr/reference/xlr_percent.md),
[`xlr_numeric()`](https://nhilder.github.io/xlr/reference/xlr_numeric.md)

## Examples

``` r
library(xlr)
# Create a variable to represent an integer
x <- xlr_integer(2)
# This will print nicely
x
#> <xlr_integer[1]>
#> [1] 2
# You can change the styling, which affects how it looks when we save it as an
# `Excel` document
x <- xlr_integer(x, style = xlr_format(font_size = 9, font_colour = "red"))
x
#> <xlr_integer[1]>
#> [1] 2
# We can also define a vector of integers
y <- xlr_integer(c(1,2,3))
y
#> <xlr_integer[3]>
#> [1] 1 2 3
# You can convert existing data to a integer using dplyr verbs
# It formats large numbers nicely
df <- data.frame(col_1 = c(1:100*100))
df |>
  dplyr::mutate(col_pct = as_xlr_integer(col_1))
#>     col_1 col_pct
#> 1     100     100
#> 2     200     200
#> 3     300     300
#> 4     400     400
#> 5     500     500
#> 6     600     600
#> 7     700     700
#> 8     800     800
#> 9     900     900
#> 10   1000   1,000
#> 11   1100   1,100
#> 12   1200   1,200
#> 13   1300   1,300
#> 14   1400   1,400
#> 15   1500   1,500
#> 16   1600   1,600
#> 17   1700   1,700
#> 18   1800   1,800
#> 19   1900   1,900
#> 20   2000   2,000
#> 21   2100   2,100
#> 22   2200   2,200
#> 23   2300   2,300
#> 24   2400   2,400
#> 25   2500   2,500
#> 26   2600   2,600
#> 27   2700   2,700
#> 28   2800   2,800
#> 29   2900   2,900
#> 30   3000   3,000
#> 31   3100   3,100
#> 32   3200   3,200
#> 33   3300   3,300
#> 34   3400   3,400
#> 35   3500   3,500
#> 36   3600   3,600
#> 37   3700   3,700
#> 38   3800   3,800
#> 39   3900   3,900
#> 40   4000   4,000
#> 41   4100   4,100
#> 42   4200   4,200
#> 43   4300   4,300
#> 44   4400   4,400
#> 45   4500   4,500
#> 46   4600   4,600
#> 47   4700   4,700
#> 48   4800   4,800
#> 49   4900   4,900
#> 50   5000   5,000
#> 51   5100   5,100
#> 52   5200   5,200
#> 53   5300   5,300
#> 54   5400   5,400
#> 55   5500   5,500
#> 56   5600   5,600
#> 57   5700   5,700
#> 58   5800   5,800
#> 59   5900   5,900
#> 60   6000   6,000
#> 61   6100   6,100
#> 62   6200   6,200
#> 63   6300   6,300
#> 64   6400   6,400
#> 65   6500   6,500
#> 66   6600   6,600
#> 67   6700   6,700
#> 68   6800   6,800
#> 69   6900   6,900
#> 70   7000   7,000
#> 71   7100   7,100
#> 72   7200   7,200
#> 73   7300   7,300
#> 74   7400   7,400
#> 75   7500   7,500
#> 76   7600   7,600
#> 77   7700   7,700
#> 78   7800   7,800
#> 79   7900   7,900
#> 80   8000   8,000
#> 81   8100   8,100
#> 82   8200   8,200
#> 83   8300   8,300
#> 84   8400   8,400
#> 85   8500   8,500
#> 86   8600   8,600
#> 87   8700   8,700
#> 88   8800   8,800
#> 89   8900   8,900
#> 90   9000   9,000
#> 91   9100   9,100
#> 92   9200   9,200
#> 93   9300   9,300
#> 94   9400   9,400
#> 95   9500   9,500
#> 96   9600   9,600
#> 97   9700   9,700
#> 98   9800   9,800
#> 99   9900   9,900
#> 100 10000  10,000
# You can use as_xlr_integer to convert a string in a integer
df <- data.frame(col_str = c("12","13","14"))
# now we can convert the string to a integer(), internally it uses the same
# logic as as.integer()
df |>
  dplyr::mutate(col_percent = as_xlr_integer(col_str))
#>   col_str col_percent
#> 1      12          12
#> 2      13          13
#> 3      14          14
```
