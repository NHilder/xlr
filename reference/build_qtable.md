# Summarise a question block

This function helps analyse a block of questions or matrix questions
into a single table. It also lets the user cut these questions by other
questions in the data. The block of questions mush have the same
response options.

## Usage

``` r
build_qtable(
  x,
  block_cols,
  cols = NULL,
  table_title = "",
  use_questions = FALSE,
  use_NA = FALSE,
  wt = NULL,
  footnote = ""
)
```

## Arguments

- x:

  a data frame or tidy object

- block_cols:

  \<[tidyr_tidy_select](https://tidyr.tidyverse.org/reference/tidyr_tidy_select.html)\>
  statement. These are the columns that make up the question block, they
  must have the same response option. Most question block columns start
  with the same piece of text, so you should use
  `starts_with('column_text')`. See the Examples below.

- cols:

  \<[tidyr_tidy_select](https://tidyr.tidyverse.org/reference/tidyr_tidy_select.html)\>
  statement. These are the column(s) that we want to cut the questions
  in the question block by.

- table_title:

  a string. The title of the table sheet

- use_questions:

  a logical. If the data has column labels (was a imported .sav) file,
  convert the column label to a footnote with the question.

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
([build_table](https://nhilder.github.io/xlr/reference/build_table.md),
build_qtable) is designed to work with data with columns of type
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

# You can use this function to get a block of questions
build_qtable(
  clothes_opinions,
  starts_with("Q1"),
  table_title = "This is an example table")
#> 
#> ── This is an example table ────────────────────────────────────────────────────
#> # A xlr_table: 20 x 4
#>    `Question Block`        value                   N Percent
#>    <x_vctr>                <x_vctr>          <x_int> <x_pct>
#>  1 Pants are good to wear  Strongly Disagree     187     19%
#>  2 Pants are good to wear  Disagree              200     20%
#>  3 Pants are good to wear  Neutral               210     21%
#>  4 Pants are good to wear  Agree                 208     21%
#>  5 Pants are good to wear  Strongly Agree        195     20%
#>  6 Shirts are good to wear Strongly Disagree     198     20%
#>  7 Shirts are good to wear Disagree              177     18%
#>  8 Shirts are good to wear Neutral               230     23%
#>  9 Shirts are good to wear Agree                 197     20%
#> 10 Shirts are good to wear Strongly Agree        198     20%
#> 11 Shoes are good to wear  Strongly Disagree     210     22%
#> 12 Shoes are good to wear  Disagree              191     20%
#> 13 Shoes are good to wear  Neutral               188     19%
#> 14 Shoes are good to wear  Agree                 211     22%
#> 15 Shoes are good to wear  Strongly Agree        175     18%
#> 16 Q1_4                    Strongly Disagree     201     21%
#> 17 Q1_4                    Disagree              190     19%
#> 18 Q1_4                    Neutral               183     19%
#> 19 Q1_4                    Agree                 203     21%
#> 20 Q1_4                    Strongly Agree        198     20%

# Another way you could select the same columns
build_qtable(
  clothes_opinions,
  c(Q1_1,Q1_2,Q1_3,Q1_4),
  table_title = "This is an example table")
#> 
#> ── This is an example table ────────────────────────────────────────────────────
#> # A xlr_table: 20 x 4
#>    `Question Block`        value                   N Percent
#>    <x_vctr>                <x_vctr>          <x_int> <x_pct>
#>  1 Pants are good to wear  Strongly Disagree     187     19%
#>  2 Pants are good to wear  Disagree              200     20%
#>  3 Pants are good to wear  Neutral               210     21%
#>  4 Pants are good to wear  Agree                 208     21%
#>  5 Pants are good to wear  Strongly Agree        195     20%
#>  6 Shirts are good to wear Strongly Disagree     198     20%
#>  7 Shirts are good to wear Disagree              177     18%
#>  8 Shirts are good to wear Neutral               230     23%
#>  9 Shirts are good to wear Agree                 197     20%
#> 10 Shirts are good to wear Strongly Agree        198     20%
#> 11 Shoes are good to wear  Strongly Disagree     210     22%
#> 12 Shoes are good to wear  Disagree              191     20%
#> 13 Shoes are good to wear  Neutral               188     19%
#> 14 Shoes are good to wear  Agree                 211     22%
#> 15 Shoes are good to wear  Strongly Agree        175     18%
#> 16 Q1_4                    Strongly Disagree     201     21%
#> 17 Q1_4                    Disagree              190     19%
#> 18 Q1_4                    Neutral               183     19%
#> 19 Q1_4                    Agree                 203     21%
#> 20 Q1_4                    Strongly Agree        198     20%

# Yet another way to select the same columns
build_qtable(
  clothes_opinions,
  all_of(c("Q1_1","Q1_2","Q1_3","Q1_4")),
  table_title = "This is an example table")
#> 
#> ── This is an example table ────────────────────────────────────────────────────
#> # A xlr_table: 20 x 4
#>    `Question Block`        value                   N Percent
#>    <x_vctr>                <x_vctr>          <x_int> <x_pct>
#>  1 Pants are good to wear  Strongly Disagree     187     19%
#>  2 Pants are good to wear  Disagree              200     20%
#>  3 Pants are good to wear  Neutral               210     21%
#>  4 Pants are good to wear  Agree                 208     21%
#>  5 Pants are good to wear  Strongly Agree        195     20%
#>  6 Shirts are good to wear Strongly Disagree     198     20%
#>  7 Shirts are good to wear Disagree              177     18%
#>  8 Shirts are good to wear Neutral               230     23%
#>  9 Shirts are good to wear Agree                 197     20%
#> 10 Shirts are good to wear Strongly Agree        198     20%
#> 11 Shoes are good to wear  Strongly Disagree     210     22%
#> 12 Shoes are good to wear  Disagree              191     20%
#> 13 Shoes are good to wear  Neutral               188     19%
#> 14 Shoes are good to wear  Agree                 211     22%
#> 15 Shoes are good to wear  Strongly Agree        175     18%
#> 16 Q1_4                    Strongly Disagree     201     21%
#> 17 Q1_4                    Disagree              190     19%
#> 18 Q1_4                    Neutral               183     19%
#> 19 Q1_4                    Agree                 203     21%
#> 20 Q1_4                    Strongly Agree        198     20%
# You can also cut all questions in the block by a single column
build_qtable(
  clothes_opinions,
  starts_with("Q1"),
  gender2,
  table_title = "This is the second example table")
#> 
#> ── This is the second example table ────────────────────────────────────────────
#> # A xlr_table: 60 x 5
#>    gender2  `Question Block`        value                   N Percent
#>    <x_vctr> <x_vctr>                <x_vctr>          <x_int> <x_pct>
#>  1 male     Pants are good to wear  Strongly Disagree      79     17%
#>  2 male     Pants are good to wear  Disagree               99     21%
#>  3 male     Pants are good to wear  Neutral                99     21%
#>  4 male     Pants are good to wear  Agree                  89     19%
#>  5 male     Pants are good to wear  Strongly Agree         95     21%
#>  6 male     Shirts are good to wear Strongly Disagree      87     19%
#>  7 male     Shirts are good to wear Disagree               84     18%
#>  8 male     Shirts are good to wear Neutral                96     21%
#>  9 male     Shirts are good to wear Agree                  91     20%
#> 10 male     Shirts are good to wear Strongly Agree        103     22%
#> # ℹ 50 more rows

# You can also cut all questions in the block by a multiple columns
# By setting `use_questions=TRUE` then the footnote will be the questions
# labels, for the cut questions
build_qtable(
  clothes_opinions,
  starts_with("Q1"),
  c(gender2,age_group),
  table_title = "This is the third example table",
  use_questions = TRUE)
#> 
#> ── This is the third example table ─────────────────────────────────────────────
#> # A xlr_table: 240 x 6
#>    gender2  age_group `Question Block`        value                   N Percent
#>    <x_vctr> <x_vctr>  <x_vctr>                <x_vctr>          <x_int> <x_pct>
#>  1 male     18-30     Pants are good to wear  Strongly Disagree      18     16%
#>  2 male     18-30     Pants are good to wear  Disagree               21     18%
#>  3 male     18-30     Pants are good to wear  Neutral                26     22%
#>  4 male     18-30     Pants are good to wear  Agree                  22     19%
#>  5 male     18-30     Pants are good to wear  Strongly Agree         29     25%
#>  6 male     18-30     Shirts are good to wear Strongly Disagree      18     16%
#>  7 male     18-30     Shirts are good to wear Disagree               23     20%
#>  8 male     18-30     Shirts are good to wear Neutral                26     22%
#>  9 male     18-30     Shirts are good to wear Agree                  19     16%
#> 10 male     18-30     Shirts are good to wear Strongly Agree         30     26%
#> # ℹ 230 more rows
#> Questions
#> The gender of the participant

# You can also use weights, these weights can be either doubles or integers
# based weights
# You can also set a footnote
build_qtable(
  clothes_opinions,
  starts_with("Q1"),
  age_group,
  table_title = "This is the fourth example table",
  wt = weight,
  footnote = paste0("This is a footnote, you can use it if you want ",
                    "more detail in your table."))
#> 
#> ── This is the fourth example table ────────────────────────────────────────────
#> # A xlr_table: 80 x 5
#>    age_group `Question Block`        value                    N Percent
#>    <x_vctr>  <x_vctr>                <x_vctr>           <x_num> <x_pct>
#>  1 18-30     Pants are good to wear  Strongly Disagree 41,311.0     16%
#>  2 18-30     Pants are good to wear  Disagree          48,447.0     19%
#>  3 18-30     Pants are good to wear  Neutral           61,475.0     24%
#>  4 18-30     Pants are good to wear  Agree             48,797.0     19%
#>  5 18-30     Pants are good to wear  Strongly Agree    60,157.0     23%
#>  6 18-30     Shirts are good to wear Strongly Disagree 49,258.0     19%
#>  7 18-30     Shirts are good to wear Disagree          50,382.0     19%
#>  8 18-30     Shirts are good to wear Neutral           56,225.0     22%
#>  9 18-30     Shirts are good to wear Agree             49,329.0     19%
#> 10 18-30     Shirts are good to wear Strongly Agree    54,993.0     21%
#> # ℹ 70 more rows
#> This is a footnote, you can use it if you want more detail in your table.
```
