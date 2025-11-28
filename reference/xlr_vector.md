# `xlr_vector` vector

A general container for including additional styling options within a
vector so that it can easily be exported to `Excel`. This vector type
should be used for characters, factors, Booleans, complex numbers, etc.
It does not support dates.

## Usage

``` r
xlr_vector(x = vector(), excel_format = "GENERAL", style = xlr_format())

is_xlr_vector(x)

as_xlr_vector(x, excel_format = "GENERAL", style = xlr_format())
```

## Arguments

- x:

  A vector

  - For `xlr_vector()`: A vector

  - For `is_xlr_vector()`: An object to test

  - For `as_xlr_vector()` : a vector

- excel_format:

  a character, the `Excel` cell format, not validated. See
  [createStyle](https://rdrr.io/pkg/openxlsx/man/createStyle.html)
  argument numFmt for more details on what you can specify.

- style:

  Additional styling options for the vector. See
  [xlr_format](https://nhilder.github.io/xlr/reference/xlr_format.md)
  for more details.

## Value

An S3 vector of class `xlr_vector`

## Details

While you can use it with `integer`, and `double` types and specifying
the associated `Excel` format, we recommend using
[xlr_integer](https://nhilder.github.io/xlr/reference/xlr_integer.md),
[xlr_numeric](https://nhilder.github.io/xlr/reference/xlr_numeric.md),
or [xlr_percent](https://nhilder.github.io/xlr/reference/xlr_percent.md)
types instead.

You can convert a vector back to its base type with
[`as_base_r()`](https://nhilder.github.io/xlr/reference/as_base_r.md).

## See also

[`xlr_percent()`](https://nhilder.github.io/xlr/reference/xlr_percent.md),
[`xlr_integer()`](https://nhilder.github.io/xlr/reference/xlr_integer.md),
[`xlr_numeric()`](https://nhilder.github.io/xlr/reference/xlr_numeric.md),
[`as_base_r()`](https://nhilder.github.io/xlr/reference/as_base_r.md)

## Examples

``` r
library(xlr)
# Create a xlr_vector object, this is used so we can add styling to an existing
# vector so that it prints nicely in `Excel`
#
# Note currently the style will not change the style in the console
x <- xlr_vector(1:100,
                 excel_format = "00.0##",
                 style = xlr_format(font_size = 8))

# You can also use it so that dates are nicely printed in `Excel`
dates <- c("02/27/92", "02/27/92", "01/14/92", "02/28/92", "02/01/92")
dates <- as.Date(dates, "%m/%d/%y")
x <- xlr_vector(dates,
                 # Print it as a long date in `Excel`
                 excel_format = "LONGDATE")
# You can convert existing data to a xlr_vectors using dplyr verbs
iris |>
  dplyr::mutate(iris_format = as_xlr_vector(Species,
                                             "TEXT",
                                             xlr_format(text_style = "italic")))
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species iris_format
#> 1            5.1         3.5          1.4         0.2     setosa           1
#> 2            4.9         3.0          1.4         0.2     setosa           1
#> 3            4.7         3.2          1.3         0.2     setosa           1
#> 4            4.6         3.1          1.5         0.2     setosa           1
#> 5            5.0         3.6          1.4         0.2     setosa           1
#> 6            5.4         3.9          1.7         0.4     setosa           1
#> 7            4.6         3.4          1.4         0.3     setosa           1
#> 8            5.0         3.4          1.5         0.2     setosa           1
#> 9            4.4         2.9          1.4         0.2     setosa           1
#> 10           4.9         3.1          1.5         0.1     setosa           1
#> 11           5.4         3.7          1.5         0.2     setosa           1
#> 12           4.8         3.4          1.6         0.2     setosa           1
#> 13           4.8         3.0          1.4         0.1     setosa           1
#> 14           4.3         3.0          1.1         0.1     setosa           1
#> 15           5.8         4.0          1.2         0.2     setosa           1
#> 16           5.7         4.4          1.5         0.4     setosa           1
#> 17           5.4         3.9          1.3         0.4     setosa           1
#> 18           5.1         3.5          1.4         0.3     setosa           1
#> 19           5.7         3.8          1.7         0.3     setosa           1
#> 20           5.1         3.8          1.5         0.3     setosa           1
#> 21           5.4         3.4          1.7         0.2     setosa           1
#> 22           5.1         3.7          1.5         0.4     setosa           1
#> 23           4.6         3.6          1.0         0.2     setosa           1
#> 24           5.1         3.3          1.7         0.5     setosa           1
#> 25           4.8         3.4          1.9         0.2     setosa           1
#> 26           5.0         3.0          1.6         0.2     setosa           1
#> 27           5.0         3.4          1.6         0.4     setosa           1
#> 28           5.2         3.5          1.5         0.2     setosa           1
#> 29           5.2         3.4          1.4         0.2     setosa           1
#> 30           4.7         3.2          1.6         0.2     setosa           1
#> 31           4.8         3.1          1.6         0.2     setosa           1
#> 32           5.4         3.4          1.5         0.4     setosa           1
#> 33           5.2         4.1          1.5         0.1     setosa           1
#> 34           5.5         4.2          1.4         0.2     setosa           1
#> 35           4.9         3.1          1.5         0.2     setosa           1
#> 36           5.0         3.2          1.2         0.2     setosa           1
#> 37           5.5         3.5          1.3         0.2     setosa           1
#> 38           4.9         3.6          1.4         0.1     setosa           1
#> 39           4.4         3.0          1.3         0.2     setosa           1
#> 40           5.1         3.4          1.5         0.2     setosa           1
#> 41           5.0         3.5          1.3         0.3     setosa           1
#> 42           4.5         2.3          1.3         0.3     setosa           1
#> 43           4.4         3.2          1.3         0.2     setosa           1
#> 44           5.0         3.5          1.6         0.6     setosa           1
#> 45           5.1         3.8          1.9         0.4     setosa           1
#> 46           4.8         3.0          1.4         0.3     setosa           1
#> 47           5.1         3.8          1.6         0.2     setosa           1
#> 48           4.6         3.2          1.4         0.2     setosa           1
#> 49           5.3         3.7          1.5         0.2     setosa           1
#> 50           5.0         3.3          1.4         0.2     setosa           1
#> 51           7.0         3.2          4.7         1.4 versicolor           2
#> 52           6.4         3.2          4.5         1.5 versicolor           2
#> 53           6.9         3.1          4.9         1.5 versicolor           2
#> 54           5.5         2.3          4.0         1.3 versicolor           2
#> 55           6.5         2.8          4.6         1.5 versicolor           2
#> 56           5.7         2.8          4.5         1.3 versicolor           2
#> 57           6.3         3.3          4.7         1.6 versicolor           2
#> 58           4.9         2.4          3.3         1.0 versicolor           2
#> 59           6.6         2.9          4.6         1.3 versicolor           2
#> 60           5.2         2.7          3.9         1.4 versicolor           2
#> 61           5.0         2.0          3.5         1.0 versicolor           2
#> 62           5.9         3.0          4.2         1.5 versicolor           2
#> 63           6.0         2.2          4.0         1.0 versicolor           2
#> 64           6.1         2.9          4.7         1.4 versicolor           2
#> 65           5.6         2.9          3.6         1.3 versicolor           2
#> 66           6.7         3.1          4.4         1.4 versicolor           2
#> 67           5.6         3.0          4.5         1.5 versicolor           2
#> 68           5.8         2.7          4.1         1.0 versicolor           2
#> 69           6.2         2.2          4.5         1.5 versicolor           2
#> 70           5.6         2.5          3.9         1.1 versicolor           2
#> 71           5.9         3.2          4.8         1.8 versicolor           2
#> 72           6.1         2.8          4.0         1.3 versicolor           2
#> 73           6.3         2.5          4.9         1.5 versicolor           2
#> 74           6.1         2.8          4.7         1.2 versicolor           2
#> 75           6.4         2.9          4.3         1.3 versicolor           2
#> 76           6.6         3.0          4.4         1.4 versicolor           2
#> 77           6.8         2.8          4.8         1.4 versicolor           2
#> 78           6.7         3.0          5.0         1.7 versicolor           2
#> 79           6.0         2.9          4.5         1.5 versicolor           2
#> 80           5.7         2.6          3.5         1.0 versicolor           2
#> 81           5.5         2.4          3.8         1.1 versicolor           2
#> 82           5.5         2.4          3.7         1.0 versicolor           2
#> 83           5.8         2.7          3.9         1.2 versicolor           2
#> 84           6.0         2.7          5.1         1.6 versicolor           2
#> 85           5.4         3.0          4.5         1.5 versicolor           2
#> 86           6.0         3.4          4.5         1.6 versicolor           2
#> 87           6.7         3.1          4.7         1.5 versicolor           2
#> 88           6.3         2.3          4.4         1.3 versicolor           2
#> 89           5.6         3.0          4.1         1.3 versicolor           2
#> 90           5.5         2.5          4.0         1.3 versicolor           2
#> 91           5.5         2.6          4.4         1.2 versicolor           2
#> 92           6.1         3.0          4.6         1.4 versicolor           2
#> 93           5.8         2.6          4.0         1.2 versicolor           2
#> 94           5.0         2.3          3.3         1.0 versicolor           2
#> 95           5.6         2.7          4.2         1.3 versicolor           2
#> 96           5.7         3.0          4.2         1.2 versicolor           2
#> 97           5.7         2.9          4.2         1.3 versicolor           2
#> 98           6.2         2.9          4.3         1.3 versicolor           2
#> 99           5.1         2.5          3.0         1.1 versicolor           2
#> 100          5.7         2.8          4.1         1.3 versicolor           2
#> 101          6.3         3.3          6.0         2.5  virginica           3
#> 102          5.8         2.7          5.1         1.9  virginica           3
#> 103          7.1         3.0          5.9         2.1  virginica           3
#> 104          6.3         2.9          5.6         1.8  virginica           3
#> 105          6.5         3.0          5.8         2.2  virginica           3
#> 106          7.6         3.0          6.6         2.1  virginica           3
#> 107          4.9         2.5          4.5         1.7  virginica           3
#> 108          7.3         2.9          6.3         1.8  virginica           3
#> 109          6.7         2.5          5.8         1.8  virginica           3
#> 110          7.2         3.6          6.1         2.5  virginica           3
#> 111          6.5         3.2          5.1         2.0  virginica           3
#> 112          6.4         2.7          5.3         1.9  virginica           3
#> 113          6.8         3.0          5.5         2.1  virginica           3
#> 114          5.7         2.5          5.0         2.0  virginica           3
#> 115          5.8         2.8          5.1         2.4  virginica           3
#> 116          6.4         3.2          5.3         2.3  virginica           3
#> 117          6.5         3.0          5.5         1.8  virginica           3
#> 118          7.7         3.8          6.7         2.2  virginica           3
#> 119          7.7         2.6          6.9         2.3  virginica           3
#> 120          6.0         2.2          5.0         1.5  virginica           3
#> 121          6.9         3.2          5.7         2.3  virginica           3
#> 122          5.6         2.8          4.9         2.0  virginica           3
#> 123          7.7         2.8          6.7         2.0  virginica           3
#> 124          6.3         2.7          4.9         1.8  virginica           3
#> 125          6.7         3.3          5.7         2.1  virginica           3
#> 126          7.2         3.2          6.0         1.8  virginica           3
#> 127          6.2         2.8          4.8         1.8  virginica           3
#> 128          6.1         3.0          4.9         1.8  virginica           3
#> 129          6.4         2.8          5.6         2.1  virginica           3
#> 130          7.2         3.0          5.8         1.6  virginica           3
#> 131          7.4         2.8          6.1         1.9  virginica           3
#> 132          7.9         3.8          6.4         2.0  virginica           3
#> 133          6.4         2.8          5.6         2.2  virginica           3
#> 134          6.3         2.8          5.1         1.5  virginica           3
#> 135          6.1         2.6          5.6         1.4  virginica           3
#> 136          7.7         3.0          6.1         2.3  virginica           3
#> 137          6.3         3.4          5.6         2.4  virginica           3
#> 138          6.4         3.1          5.5         1.8  virginica           3
#> 139          6.0         3.0          4.8         1.8  virginica           3
#> 140          6.9         3.1          5.4         2.1  virginica           3
#> 141          6.7         3.1          5.6         2.4  virginica           3
#> 142          6.9         3.1          5.1         2.3  virginica           3
#> 143          5.8         2.7          5.1         1.9  virginica           3
#> 144          6.8         3.2          5.9         2.3  virginica           3
#> 145          6.7         3.3          5.7         2.5  virginica           3
#> 146          6.7         3.0          5.2         2.3  virginica           3
#> 147          6.3         2.5          5.0         1.9  virginica           3
#> 148          6.5         3.0          5.2         2.0  virginica           3
#> 149          6.2         3.4          5.4         2.3  virginica           3
#> 150          5.9         3.0          5.1         1.8  virginica           3
```
