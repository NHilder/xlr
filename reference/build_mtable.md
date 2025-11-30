# Summarise a multiple response table

This function can take one or two multiple response responses and
generate a summary table with them. You can also cut these columns by
other categorical columns by specify the cols parameter.

## Usage

``` r
build_mtable(
  x,
  mcols,
  cols = NULL,
  table_title = "",
  use_questions = FALSE,
  use_NA = FALSE,
  wt = NULL,
  footnote = "",
  seen_but_answered = NULL,
  name_seen_but_answered = paste0(seen_but_answered, collapse = "_"),
  ...
)
```

## Arguments

- x:

  a data frame or tidy object.

- mcols:

  the column(s) that are multiple response questions. See the `Details`
  for more details of how these columns should be structured.

- cols:

  the column(s) that we want to calculate the sum/percentage of and the
  multiple response question.

- table_title:

  the title of the table sheet

- use_questions:

  if the data has column labels (was a imported .sav) file, convert the
  column label to a footnote with the question.

- use_NA:

  logical. whether to include `NA` values in the table. For more
  complicated `NA` processing post creation, we recommend using filter.

- wt:

  Specify a weighting variable, if `NULL` no weight is applied.

- footnote:

  optional parameter to pass a custom footnote to the question, this
  parameter overwrites `use_questions`.

- seen_but_answered:

  vector. Pass values to this argument if there exists values in the
  multiple response question but indicate someone saw the question but
  did not response to the value (e.g. `-99`, `0`).

- name_seen_but_answered:

  string. A name for the value of the `seen but answered` response.

- ...:

  These dots are for future extensions and must be empty.

## Value

a `xlr_table` object. Use
[write_xlsx](https://nhilder.github.io/xlr/reference/write_xlsx.md) to
write to an `Excel` file. See
[xlr_table](https://nhilder.github.io/xlr/reference/xlr_table.md) for
more information.

## Details

A multiple response response is a series of columns with a single unique
response that stores survey data where a respondent may have chosen
multiple options. This function works if this data is stored in a
**wide** format. To have a valid multiple response column all the
columns should start with the same text, and each contain a unique
value. That is it has the form:

     data.frame(multi_col_1 = c(1,NA,1),
               multi_col_2 = c(1,1,1),
               multi_col_3 = c(NA,NA,1)
     )
    #>   multi_col_1 multi_col_2 multi_col_3
    #> 1           1           1          NA
    #> 2          NA           1          NA
    #> 3           1           1           1

This is how popular survey platforms such as Qualtrics output this data
type. If your data is long, you will need to pivot the data before hand,
we recommend using
[pivot_wider](https://tidyr.tidyverse.org/reference/pivot_wider.html).

By default this function converts
[labelled](https://haven.tidyverse.org/reference/labelled.html) to a
[xlr_vector](https://nhilder.github.io/xlr/reference/xlr_vector.md) by
default (and underlying it is a
[`character()`](https://rdrr.io/r/base/character.html) type).

This function and its family
([build_table](https://nhilder.github.io/xlr/reference/build_table.md),
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

See [labelled](https://haven.tidyverse.org/reference/labelled.html) and
[read_sav](https://haven.tidyverse.org/reference/read_spss.html) if you
would like more details on the importing type.

## Examples

``` r
library(xlr)
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union

# You can use this function to calculate the number of people that have
# responded to the question `What is your favourite colour`
build_mtable(clothes_opinions,
             "Q2",
             table_title = "What is your favourite colour?")
#> 
#> ── What is your favourite colour? ──────────────────────────────────────────────
#> # A xlr_table: 6 x 4
#>   Q2             N N_group Percent
#>   <x_vctr> <x_int> <x_int> <x_pct>
#> 1 Black        897     995     90%
#> 2 Blue         192     995     19%
#> 3 Green        323     995     32%
#> 4 Grey         494     995     50%
#> 5 Red          792     995     80%
#> 6 Yellow       208     995     21%

# The function also lets you to see the number of NA questions (this is
# where someone doesn't answer any option)
build_mtable(clothes_opinions,
             "Q2",
             table_title = "What is your favourite colour?",
             use_NA = TRUE)
#> 
#> ── What is your favourite colour? ──────────────────────────────────────────────
#> # A xlr_table: 7 x 4
#>   Q2             N N_group Percent
#>   <x_vctr> <x_int> <x_int> <x_pct>
#> 1 Black        897   1,000     90%
#> 2 Blue         192   1,000     19%
#> 3 Green        323   1,000     32%
#> 4 Grey         494   1,000     49%
#> 5 Red          792   1,000     79%
#> 6 Yellow       208   1,000     21%
#> 7 NA             5   1,000      0%

# You can also cut all questions in the multiple response functions by another
# column
build_mtable(clothes_opinions,
             "Q2",
             gender2,
             table_title = "Your favourite colour by gender")
#> 
#> ── Your favourite colour by gender ─────────────────────────────────────────────
#> # A xlr_table: 18 x 5
#>    gender2    Q2             N N_group Percent
#>    <x_vctr>   <x_vctr> <x_int> <x_int> <x_pct>
#>  1 male       Black        413     460     90%
#>  2 male       Blue          82     460     18%
#>  3 male       Green        144     460     31%
#>  4 male       Grey         225     460     49%
#>  5 male       Red          371     460     81%
#>  6 male       Yellow        95     460     21%
#>  7 female     Black        413     460     90%
#>  8 female     Blue          97     460     21%
#>  9 female     Green        158     460     34%
#> 10 female     Grey         237     460     52%
#> 11 female     Red          356     460     77%
#> 12 female     Yellow        94     460     20%
#> 13 non-binary Black         71      75     95%
#> 14 non-binary Blue          13      75     17%
#> 15 non-binary Green         21      75     28%
#> 16 non-binary Grey          32      75     43%
#> 17 non-binary Red           65      75     87%
#> 18 non-binary Yellow        19      75     25%

# By setting `use_questions=TRUE` then the footnote will be the questions
# labels. This is useful to see what the question is.
# The function will try to pull out this based on the question label, and
# will manipulate try and get the correct label.
build_mtable(clothes_opinions,
             "Q2",
             gender2,
             table_title = "Your favourite colour by gender",
             use_questions = TRUE)
#> 
#> ── Your favourite colour by gender ─────────────────────────────────────────────
#> # A xlr_table: 18 x 5
#>    gender2    Q2             N N_group Percent
#>    <x_vctr>   <x_vctr> <x_int> <x_int> <x_pct>
#>  1 male       Black        413     460     90%
#>  2 male       Blue          82     460     18%
#>  3 male       Green        144     460     31%
#>  4 male       Grey         225     460     49%
#>  5 male       Red          371     460     81%
#>  6 male       Yellow        95     460     21%
#>  7 female     Black        413     460     90%
#>  8 female     Blue          97     460     21%
#>  9 female     Green        158     460     34%
#> 10 female     Grey         237     460     52%
#> 11 female     Red          356     460     77%
#> 12 female     Yellow        94     460     20%
#> 13 non-binary Black         71      75     95%
#> 14 non-binary Blue          13      75     17%
#> 15 non-binary Green         21      75     28%
#> 16 non-binary Grey          32      75     43%
#> 17 non-binary Red           65      75     87%
#> 18 non-binary Yellow        19      75     25%
#> Questions
#> The gender of the participant

# It is common for your data to include 'other' responses in a multiple
# response column. You should remove the column before running build_mtable
clothes_opinions |>
  select(-Q3_other) |>
  build_mtable("Q3")
#> # A xlr_table: 3 x 4
#>   Q3              N N_group Percent
#>   <x_vctr>  <x_int> <x_int> <x_pct>
#> 1 Earrings      290     869     33%
#> 2 Necklaces     201     869     23%
#> 3 Rings         783     869     90%

# You can also specify up to a maxium of two different multiple response
# columns.
clothes_opinions |>
  select(-Q3_other) |>
  build_mtable(c("Q2", "Q3"))
#> # A xlr_table: 18 x 5
#>    Q2       Q3              N    N_Q2 Percent
#>    <x_vctr> <x_vctr>  <x_int> <x_int> <x_pct>
#>  1 Black    Earrings      264     897     29%
#>  2 Black    Necklaces     180     897     20%
#>  3 Black    Rings         693     897     77%
#>  4 Blue     Earrings       59     192     31%
#>  5 Blue     Necklaces      49     192     26%
#>  6 Blue     Rings         145     192     76%
#>  7 Green    Earrings       98     323     30%
#>  8 Green    Necklaces      73     323     23%
#>  9 Green    Rings         247     323     76%
#> 10 Grey     Earrings      143     494     29%
#> 11 Grey     Necklaces      96     494     19%
#> 12 Grey     Rings         391     494     79%
#> 13 Red      Earrings      228     792     29%
#> 14 Red      Necklaces     160     792     20%
#> 15 Red      Rings         620     792     78%
#> 16 Yellow   Earrings       52     208     25%
#> 17 Yellow   Necklaces      35     208     17%
#> 18 Yellow   Rings         161     208     77%

# These cam also be cut by other columns.
clothes_opinions |>
  select(-Q3_other) |>
  build_mtable(c("Q2", "Q3"),
               gender2)
#> # A xlr_table: 54 x 6
#>    gender2  Q2       Q3              N N_group Percent
#>    <x_vctr> <x_vctr> <x_vctr>  <x_int> <x_int> <x_pct>
#>  1 male     Black    Earrings      127     413     31%
#>  2 male     Black    Necklaces      78     413     19%
#>  3 male     Black    Rings         315     413     76%
#>  4 male     Blue     Earrings       23      82     28%
#>  5 male     Blue     Necklaces      21      82     26%
#>  6 male     Blue     Rings          61      82     74%
#>  7 male     Green    Earrings       43     144     30%
#>  8 male     Green    Necklaces      31     144     22%
#>  9 male     Green    Rings         108     144     75%
#> 10 male     Grey     Earrings       72     225     32%
#> # ℹ 44 more rows

# This function also supports weights and manual footnotes
clothes_opinions |>
  select(-Q3_other) |>
  build_mtable(c("Q2", "Q3"),
               gender2,
               wt = weight,
               footnote = "This is an example footnote.")
#> # A xlr_table: 54 x 6
#>    gender2  Q2       Q3                N   N_group Percent
#>    <x_vctr> <x_vctr> <x_vctr>    <x_num>   <x_num> <x_pct>
#>  1 male     Black    Earrings  127,605.0 422,100.0     30%
#>  2 male     Black    Necklaces  73,623.0 422,100.0     17%
#>  3 male     Black    Rings     326,852.0 422,100.0     77%
#>  4 male     Blue     Earrings   20,749.0  78,108.0     27%
#>  5 male     Blue     Necklaces  15,806.0  78,108.0     20%
#>  6 male     Blue     Rings      54,686.0  78,108.0     70%
#>  7 male     Green    Earrings   44,326.0 146,440.0     30%
#>  8 male     Green    Necklaces  29,053.0 146,440.0     20%
#>  9 male     Green    Rings     110,288.0 146,440.0     75%
#> 10 male     Grey     Earrings   76,754.0 232,228.0     33%
#> # ℹ 44 more rows
#> This is an example footnote.
```
