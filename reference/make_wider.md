# Pivot a table wider combining counts and percentages

This function takes a data frame produced by functions like
[build_table](https://nhilder.github.io/xlr/reference/build_table.md),
[build_mtable](https://nhilder.github.io/xlr/reference/build_mtable.md),
or
[build_qtable](https://nhilder.github.io/xlr/reference/build_qtable.md),
which contains columns `N` and `Percent`, and pivots it into a wider
format. It combines the `N` and `Percent` columns into a single
[xlr_n_percent](https://nhilder.github.io/xlr/reference/xlr_n_percent.md)
vector for each pivoted column. If `top_variable` is not specified, it
infers the variable to use for column names from the structure of the
data frame.

## Usage

``` r
make_wider(x, top_variable = NULL, names_prefix = "")
```

## Arguments

- x:

  A data frame or tibble containing at least the columns `N` and
  `Percent`. Typically the output of
  [build_table](https://nhilder.github.io/xlr/reference/build_table.md),
  [build_mtable](https://nhilder.github.io/xlr/reference/build_mtable.md),
  or
  [build_qtable](https://nhilder.github.io/xlr/reference/build_qtable.md),.

- top_variable:

  Optional. A bare column name to use for the `names_from` argument in
  `pivot_wider`. If `NULL` (default), the function infers the column
  based the default position.

- names_prefix:

  String added to the start of every variable name. This is particularly
  useful if `top_variable` is a numeric vector and you want to create
  syntactic variable names.

## Value

A [xlr_table](https://nhilder.github.io/xlr/reference/xlr_table.md) (if
x is a
[xlr_table](https://nhilder.github.io/xlr/reference/xlr_table.md)) or
[tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html) (if
[tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html) or
`data.frame`) in a wider format with columns containing `xlr_n_percent`
vectors.

## See also

[`xlr_n_percent`](https://nhilder.github.io/xlr/reference/xlr_n_percent.md),
[`pivot_wider`](https://tidyr.tidyverse.org/reference/pivot_wider.html)

## Examples

``` r
library(xlr)
# Assuming example data from build_table or similar
table <- clothes_opinions |>
            build_table(c(gender,age_group))
make_wider(table)
#> # A xlr_table: 4 x 4
#>   age_group    female      male `non-binary`
#>   <x_vctr>  <x_n_pct> <x_n_pct>    <x_n_pct>
#> 1 18-30     118 (27%) 116 (26%)     18 (25%)
#> 2 31-40      87 (20%)  96 (22%)     19 (27%)
#> 3 41-50      95 (22%)  82 (19%)     18 (25%)
#> 4 51-65     139 (32%) 146 (33%)     16 (23%)

# use top_variable to specify that we have gender as out selection column
make_wider(table, top_variable = age_group)
#> # A xlr_table: 3 x 5
#>   gender       `18-30`   `31-40`   `41-50`   `51-65`
#>   <x_vctr>   <x_n_pct> <x_n_pct> <x_n_pct> <x_n_pct>
#> 1 female     118 (27%)  87 (20%)  95 (22%) 139 (32%)
#> 2 male       116 (26%)  96 (22%)  82 (19%) 146 (33%)
#> 3 non-binary  18 (25%)  19 (27%)  18 (25%)  16 (23%)
```
