# Create a one, two, three,..., n-way table

`build_table` creates a one, two, three, ..., n-way table. It should be
used to calculate the count and percentage of different categorical
variables. It gives the data back in a long format. The percentages
calculated are the 'row' percentages.

## Usage

``` r
build_table(
  x,
  cols,
  table_title = "",
  use_questions = FALSE,
  use_NA = FALSE,
  wt = NULL,
  footnote = ""
)
```

## Arguments

- x:

  a data frame or tidy object.

- cols:

  \<[tidyr_tidy_select](https://tidyr.tidyverse.org/reference/tidyr_tidy_select.html)\>
  These are the column(s) that we want to calculate the count and
  percentage of.

- table_title:

  a string. The title of the table sheet.

- use_questions:

  a logical. If the data has column labels convert the column label to a
  footnote with the question. See details for more information.

- use_NA:

  a logical. Whether to include `NA` values in the table. For more
  complicated `NA` processing post creation, we recommend using filter.

- wt:

  a quoted or unquote column name. Specify a weighting variable, if
  `NULL` no weight is applied.

- footnote:

  a character vector. Optional parameter to pass a custom footnote to
  the question, this parameter overwrites `use_questions`.

## Value

a `xlr_table` object. Use
[write_xlsx](https://nhilder.github.io/xlr/reference/write_xlsx.md) to
write to an `Excel` file. See
[xlr_table](https://nhilder.github.io/xlr/reference/xlr_table.md) for
more information.

## Details

This function and its family
([build_mtable](https://nhilder.github.io/xlr/reference/build_mtable.md),
[build_qtable](https://nhilder.github.io/xlr/reference/build_qtable.md))
is designed to work with data with columns of type
[`haven::labelled`](https://haven.tidyverse.org/reference/labelled.html),
which is the default format of data read with
[`haven::read_sav`](https://haven.tidyverse.org/reference/read_spss.html)/has
the format of `.sav`. `.sav` is the default file function type of data
from `SPSS` and can be exported from popular survey providers such as
Qualtrics. When you read in data with
[`haven::read_sav`](https://haven.tidyverse.org/reference/read_spss.html)
it imports data with the questions, labels for the response options etc.

By default this function converts
[labelled](https://haven.tidyverse.org/reference/labelled.html) to a
[xlr_vector](https://nhilder.github.io/xlr/reference/xlr_vector.md) by
default (and underlying it is a
[`character()`](https://rdrr.io/r/base/character.html) type).

See [labelled](https://haven.tidyverse.org/reference/labelled.html) and
[read_sav](https://haven.tidyverse.org/reference/read_spss.html) if you
would like more details on the importing type.

## Examples

``` r
library(xlr)

# You can use this function to calculate the number count and percentage
# of a categorical variable
build_table(
  clothes_opinions,
  gender,
  table_title = "The count of the gender groups")
#> 
#> ── The count of the gender groups ──────────────────────────────────────────────
#> # A xlr_table: 3 x 3
#>   gender           N Percent
#>   <x_vctr>   <x_int> <x_pct>
#> 1 female         464     46%
#> 2 male           461     46%
#> 3 non-binary      75      8%

# You must use a `tidyselect` statement, to select the columns that you wish to
# calculate the count, and group percentage.
# This will calculate the number of observations in each group of age and
# gender.
# The percentage will be the percentage of each age_group in each gender
# group (the row percentage).
build_table(
  clothes_opinions,
  c(gender,age_group),
  table_title = "This is the second example table")
#> 
#> ── This is the second example table ────────────────────────────────────────────
#> # A xlr_table: 12 x 4
#>    gender     age_group       N Percent
#>    <x_vctr>   <x_vctr>  <x_int> <x_pct>
#>  1 female     18-30         118     27%
#>  2 female     31-40          87     20%
#>  3 female     41-50          95     22%
#>  4 female     51-65         139     32%
#>  5 male       18-30         116     26%
#>  6 male       31-40          96     22%
#>  7 male       41-50          82     19%
#>  8 male       51-65         146     33%
#>  9 non-binary 18-30          18     25%
#> 10 non-binary 31-40          19     27%
#> 11 non-binary 41-50          18     25%
#> 12 non-binary 51-65          16     23%

# You can use more complicated tidy select statements if you have a large number
# of columns, but this is probably not recommended
#
# Using use_questions, if you have labelled data, it will take the label and
# include it as a footnote.
# This is useful for when you have exported data from survey platforms
# as a .sav, use `haven::read_sav` to load it into your R environment.
build_table(
  clothes_opinions,
  c(group:gender,Q1_1),
  table_title = "This is the third example table",
  use_questions = TRUE)
#> 
#> ── This is the third example table ─────────────────────────────────────────────
#> # A xlr_table: 30 x 5
#>    group    gender   Q1_1                    N Percent
#>    <x_vctr> <x_vctr> <x_vctr>          <x_int> <x_pct>
#>  1 a        female   Strongly Disagree      40     18%
#>  2 a        female   Disagree               39     18%
#>  3 a        female   Neutral                46     21%
#>  4 a        female   Agree                  53     24%
#>  5 a        female   Strongly Agree         41     19%
#>  6 a        male     Strongly Disagree      38     17%
#>  7 a        male     Disagree               44     20%
#>  8 a        male     Neutral                46     21%
#>  9 a        male     Agree                  44     20%
#> 10 a        male     Strongly Agree         46     21%
#> # ℹ 20 more rows
#> Questions
#> Pants are good to wear

# You can also use weights, these weights can be either doubles or integers
# based weights
# You can also set a footnote manually
build_table(
  clothes_opinions,
  age_group,
  table_title = "This is the fourth example table",
  wt = weight,
  footnote = paste0("This is a footnote, you can use it if you want",
                    "more detail in your table."))
#> 
#> ── This is the fourth example table ────────────────────────────────────────────
#> # A xlr_table: 4 x 3
#>   age_group         N Percent
#>   <x_vctr>    <x_num> <x_pct>
#> 1 18-30     260,187.0     27%
#> 2 31-40     202,597.0     21%
#> 3 41-50     207,621.0     21%
#> 4 51-65     302,365.0     31%
#> This is a footnote, you can use it if you wantmore detail in your table.

```
