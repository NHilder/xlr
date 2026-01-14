# Getting started with xlr

xlr is designed to help with the analysis of survey data and conduct
modelling, and then export this information to `Excel` in an easy and
consistent way.

It is designed to help people with little R experience analyse survey
data quickly and easily. This includes functions to quickly analyse
multiple-response questions and block questions.

This package also provides a simple and easy to use interface with
`Excel`, building on the excellent work of the \[openxlsx\] package. It
is designed with ease of use in mind, at the expense of some
functionality of `openxlsx`.

This package relies extensively on the
[tidyverse](https://tidyverse.org/) and so we use many of the same terms
and concepts here.

There are three aspects to this package:

1.  Functions to help with the analysis of survey complex survey data.

2.  Functions to help export this data to `Excel`.

3.  New `R` types to support consistent formatting in `Excel`.

### Data: clothes_opinions

To explore how to analyse complex data we’ll use the dataset
`clothes_opinions`. This dataset contains fake survey data with peoples
opinions on clothes as well as a series of demographic characteristics.
It is documented in
[`?clothes_opinions`](https://nhilder.github.io/xlr/reference/clothes_opinions.md).

``` r
dim(clothes_opinions)
#> [1] 1000   20
clothes_opinions
#> # A tibble: 1,000 × 20
#>   weight group gender gender2      age age_group Q1_1    Q1_2    Q1_3    Q1_4   
#>    <int> <chr> <chr>  <dbl+lbl>  <int> <chr>     <int+l> <int+l> <int+l> <int+l>
#> 1   1072 a     female 2 [female]    25 18-30     1 [Str… 5 [Str… 5 [Str… 2 [Dis…
#> 2    219 a     female 2 [female]    64 51-65     3 [Neu… 1 [Str… 2 [Dis… 2 [Dis…
#> 3   1187 a     male   1 [male]      35 31-40     4 [Agr… 3 [Neu… 5 [Str… 1 [Str…
#> 4   1860 a     male   1 [male]      55 51-65     4 [Agr… 1 [Str… 2 [Dis… 2 [Dis…
#> # ℹ 996 more rows
#> # ℹ 10 more variables: Q2_1 <chr>, Q2_2 <chr>, Q2_3 <chr>, Q2_4 <chr>,
#> #   Q2_5 <chr>, Q2_6 <chr>, Q3_1 <dbl+lbl>, Q3_2 <dbl+lbl>, Q3_3 <dbl+lbl>,
#> #   Q3_other <chr>
```

`clothes_opinions` is a `tibble` a adapted type of `data.frame`. You can
learn more about tibbles at
[https://tibble.tidyverse.org](https://tibble.tidyverse.org/).

It was designed to mimic data initially saved as a `.sav` file and
imported with `haven::import_spss()`. Data with this form can easily be
exported from major survey platforms such as
[Qualtrics](https://www.qualtrics.com/), and includes useful information
such as question labels which xlr functions can utilise automatically.

### Analysing survey data

There are three main functions to analyse survey data:

- [`build_table()`](https://nhilder.github.io/xlr/reference/build_table.md)
  which creates 1, 2, 3, … -way tables.

- [`build_mtable()`](https://nhilder.github.io/xlr/reference/build_mtable.md)
  which creates 1, 2, 3, … -way tables for multiple response questions.

- [`build_qtable()`](https://nhilder.github.io/xlr/reference/build_qtable.md)
  which creates 1, 2, 3, … -way tables for a **block** of questions.

We will start by introducing
[`xlr_table()`](https://nhilder.github.io/xlr/reference/xlr_table.md)
and go through all of its functionality. This functionality is similar
for
[`build_mtable()`](https://nhilder.github.io/xlr/reference/build_mtable.md)
and
[`build_qtable()`](https://nhilder.github.io/xlr/reference/build_qtable.md).

#### build_table()

This function provides roughly the same functionality as base R’s
[`table()`](https://rdrr.io/r/base/table.html) except it provides a lot
more support for easy use. Like all functions in this package, we follow
the convention of the first argument is the data.frame (or tibble) that
you want to work on. The second argument are the columns we want to
build a table with, and the remainder are options for
[`build_table()`](https://nhilder.github.io/xlr/reference/build_table.md).

Let’s first calculate the number of people of each gender in
`clothes_opinions`:

``` r
clothes_opinions |>
  build_table(gender2)
#> # A xlr_table: 3 x 3
#>   gender2          N Percent
#>   <x_vctr>   <x_int> <x_pct>
#> 1 male           461     46%
#> 2 female         464     46%
#> 3 non-binary      75      8%
```

You can see that we have outputted a table which shows the number of
people and the percentage of each gender in our data set.

You can easily create two or three way tables by passing additional
columns to the `cols` argument:

``` r
clothes_opinions |> 
  build_table(c(age_group, gender2),
              table_title = "Gender by age make up of clothing opinion data")
#> 
#> ── Gender by age make up of clothing opinion data ──────────────────────────────
#> # A xlr_table: 12 x 4
#>   age_group gender2          N Percent
#>   <x_vctr>  <x_vctr>   <x_int> <x_pct>
#> 1 18-30     male           116     46%
#> 2 18-30     female         118     47%
#> 3 18-30     non-binary      18      7%
#> 4 31-40     male            96     48%
#> # ℹ 8 more rows

clothes_opinions |> 
  build_table(c(age_group, gender2, Q1_1),
              table_title = "Responses to Q1_1 by age and gender")
#> 
#> ── Responses to Q1_1 by age and gender ─────────────────────────────────────────
#> # A xlr_table: 60 x 5
#>   age_group gender2  Q1_1                    N Percent
#>   <x_vctr>  <x_vctr> <x_vctr>          <x_int> <x_pct>
#> 1 18-30     male     Strongly Disagree      18     16%
#> 2 18-30     male     Disagree               21     18%
#> 3 18-30     male     Neutral                26     22%
#> 4 18-30     male     Agree                  22     19%
#> # ℹ 56 more rows
```

The `cols` argument uses **tidy selections** to select the columns we
want to make a table with. See
[\<tidy-select\>](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)
for more details on the selectors. This should be familiar for people
who use dplyr verbs.

The data returns has a **long format** by default. Currently wide table
table is unsupported but may be included in a future update.

##### Introduction to xlr_table()

You can also see that it has a special type
[`xlr_table()`](https://nhilder.github.io/xlr/reference/xlr_table.md).
This is a S3 class defined by xlr to help output the data to `Excel`. It
contains the table data, a table title and a footnote, as well as hidden
data to help format the table in `Excel`. You can learn more about
[`xlr_table()`](https://nhilder.github.io/xlr/reference/xlr_table.md) in
the vignette `to do`.

You can directly pass a title and a footnote to
[`build_table()`](https://nhilder.github.io/xlr/reference/build_table.md)
by passing them as arguments to
[`build_table()`](https://nhilder.github.io/xlr/reference/build_table.md):

``` r
clothes_opinions |>
  build_table(gender2,
              table_title = "Gender make up of clothing opinion data",
              footnote = "This shows that the data has a representative sample.")
#> 
#> ── Gender make up of clothing opinion data ─────────────────────────────────────
#> # A xlr_table: 3 x 3
#>   gender2          N Percent
#>   <x_vctr>   <x_int> <x_pct>
#> 1 male           461     46%
#> 2 female         464     46%
#> 3 non-binary      75      8%
#> This shows that the data has a representative sample.
```

##### Labels in xlr

Now if you were paying close attention, you may have noticed that
`clothes_opinions$gender2` went from being `haven_labelled` to a
[`xlr_vector()`](https://nhilder.github.io/xlr/reference/xlr_vector.md).
A `xlr_vector` is a wrapper around other types (see below for more
details), and the base type is
[`character()`](https://rdrr.io/r/base/character.html). All `build_*`
functions will convert this data automatically, as well as pull
information on the labels. See `haven`’s documentation for more details
about the labelled type:
<https://haven.tidyverse.org/reference/labelled.html>.

Additionally, if your data is labelled, you can pull out the question
label metadata automatically and include it in the footnote by
specifying `use_questions = TRUE`. Columns that don’t have a label are
ignored.

``` r
clothes_opinions |>
  build_table(c(age_group, gender2),
              table_title = "Gender by age make up of clothing opinion data",
              use_question = TRUE)
#> 
#> ── Gender by age make up of clothing opinion data ──────────────────────────────
#> # A xlr_table: 12 x 4
#>   age_group gender2          N Percent
#>   <x_vctr>  <x_vctr>   <x_int> <x_pct>
#> 1 18-30     male           116     46%
#> 2 18-30     female         118     47%
#> 3 18-30     non-binary      18      7%
#> 4 31-40     male            96     48%
#> # ℹ 8 more rows
#> Questions
#> The gender of the participant
```

##### Weights

Weights are supported, you only need to pass the column name for the
weights to the `wt` argument:

``` r
clothes_opinions |>
  build_table(c(age_group, gender2),
              table_title = "Gender by age make up of clothing opinion data (weighted)",
              wt = weight)
#> 
#> ── Gender by age make up of clothing opinion data (weighted) ───────────────────
#> # A xlr_table: 12 x 4
#>   age_group gender2            N Percent
#>   <x_vctr>  <x_vctr>     <x_num> <x_pct>
#> 1 18-30     male       122,277.0     47%
#> 2 18-30     female     118,532.0     46%
#> 3 18-30     non-binary  19,378.0      7%
#> 4 31-40     male        94,487.0     47%
#> # ℹ 8 more rows
```

##### Missing data

[`build_table()`](https://nhilder.github.io/xlr/reference/build_table.md)
uses only complete cases by default, that is for one of the columns we
are if a row includes a single `NA` it is removed from the table
calculation. To include `NA` values set `use_NA = TRUE`. This will mean
that **ALL** `NA`’s will be included in the calculation of the table:

``` r
clothes_opinions |>
  build_table(c(group, age_group),
              table_title = "Survey group by age make up of clothing opinion data",
              use_NA = TRUE)
#> 
#> ── Survey group by age make up of clothing opinion data ────────────────────────
#> # A xlr_table: 15 x 4
#>   group    age_group       N Percent
#>   <x_vctr> <x_vctr>  <x_int> <x_pct>
#> 1 a        18-30         125     27%
#> 2 a        31-40          82     17%
#> 3 a        41-50         106     23%
#> 4 a        51-65         135     29%
#> # ℹ 11 more rows
```

If you would like to include the `NA` values of only one or some of the
columns we recommend using
[`dplyr::filter()`](https://dplyr.tidyverse.org/reference/filter.html)
as demonstrated below.

``` r
clothes_opinions |>
  # remove all the rows where group is missing
  dplyr::filter(!is.na(group)) |>
  # by setting use_NA to true we keep the NA's from the age_group column
  build_table(c(group, age_group),
              table_title = "Survey group by age make up of clothing opinion data",
              use_NA = TRUE)
#> 
#> ── Survey group by age make up of clothing opinion data ────────────────────────
#> # A xlr_table: 10 x 4
#>   group    age_group       N Percent
#>   <x_vctr> <x_vctr>  <x_int> <x_pct>
#> 1 a        18-30         125     27%
#> 2 a        31-40          82     17%
#> 3 a        41-50         106     23%
#> 4 a        51-65         135     29%
#> # ℹ 6 more rows
```

#### build_mtable()

This function is design to analyse multiple response questions in survey
data. To do so the data must be **wide data** with *one* response per
column (and the remaining responses NA). This is how Qualtrics exports
this data by default. The format is shown below:

``` r
clothes_opinions |>
  dplyr::select(starts_with("Q2"))
#> # A tibble: 1,000 × 6
#>   Q2_1  Q2_2  Q2_3  Q2_4  Q2_5  Q2_6 
#>   <chr> <chr> <chr> <chr> <chr> <chr>
#> 1 Red   NA    NA    Blue  Black Grey 
#> 2 Red   NA    NA    NA    Black NA   
#> 3 Red   NA    Green NA    Black Grey 
#> 4 Red   NA    NA    NA    Black NA   
#> # ℹ 996 more rows
```

To create a table using the `mcol` argument to specify the mutliple
response columns you would like to create a table with:

``` r
clothes_opinions |>
  build_mtable("Q2")
#> # A xlr_table: 6 x 4
#>   Q2             N N_group Percent
#>   <x_vctr> <x_int> <x_int> <x_pct>
#> 1 Black        897     995     90%
#> 2 Blue         192     995     19%
#> 3 Green        323     995     32%
#> 4 Grey         494     995     50%
#> # ℹ 2 more rows
```

The output `N` count is the number of people that responded to each
multiple response option, the `N_group` is the total number of people
that responded to this question. The `Percent` is the percentage of
people that responded to each of the options. As you can respond to
multiple options this percentage will likely not add up to 100.

Note, internally
[`build_mtable()`](https://nhilder.github.io/xlr/reference/build_mtable.md)
uses
[`tidyselect::starts_with()`](https://tidyselect.r-lib.org/reference/starts_with.html)
to select the columns that you would like to build a table with, because
of this you need to pass a string to `mcol`.

You can cut your multiple response column by other data by passing
columns to the `cols` argument. As with
[`build_table()`](https://nhilder.github.io/xlr/reference/build_table.md)
it uses `<tidy-eval>` to select the columns.

``` r
clothes_opinions |>
  build_mtable(mcol = "Q2",
               cols = age_group)
#> # A xlr_table: 24 x 5
#>   age_group Q2             N N_group Percent
#>   <x_vctr>  <x_vctr> <x_int> <x_int> <x_pct>
#> 1 18-30     Black        228     250     91%
#> 2 18-30     Blue          38     250     15%
#> 3 18-30     Green         83     250     33%
#> 4 18-30     Grey         113     250     45%
#> # ℹ 20 more rows
```

The `N_group` for this question is the number of people in each age
group that responded to the multiple response question.

It is common that a mulitple response column will include an *other*
response in a survey. This column needs to be removed *before* you
analyse the data with
[`build_mtable()`](https://nhilder.github.io/xlr/reference/build_mtable.md).
We recommend using
[`dplyr::select`](https://dplyr.tidyverse.org/reference/select.html) as
demonstrated below:

``` r
clothes_opinions |>
  dplyr::select(-Q3_other) |>
  build_mtable(mcol = "Q3",
               cols = age_group)
#> # A xlr_table: 12 x 5
#>   age_group Q3              N N_group Percent
#>   <x_vctr>  <x_vctr>  <x_int> <x_int> <x_pct>
#> 1 18-30     Earrings       77     216     36%
#> 2 18-30     Necklaces      54     216     25%
#> 3 18-30     Rings         193     216     89%
#> 4 31-40     Earrings       55     176     31%
#> # ℹ 8 more rows
```

As above you can see the
[`build_mtable()`](https://nhilder.github.io/xlr/reference/build_mtable.md)
automatically converts haven labelled data to a
[`xlr_vector()`](https://nhilder.github.io/xlr/reference/xlr_vector.md).

##### Multiple multiple response columns

You can pass up to **two** multiple response columns to
[`build_mtable()`](https://nhilder.github.io/xlr/reference/build_mtable.md),
any more and we recommend filtering before hand.

``` r
clothes_opinions |>
  dplyr::select(-Q3_other) |>
  build_mtable(mcol = c("Q2","Q3"))
#> # A xlr_table: 18 x 5
#>   Q2       Q3              N    N_Q2 Percent
#>   <x_vctr> <x_vctr>  <x_int> <x_int> <x_pct>
#> 1 Black    Earrings      264     897     29%
#> 2 Black    Necklaces     180     897     20%
#> 3 Black    Rings         693     897     77%
#> 4 Blue     Earrings       59     192     31%
#> # ℹ 14 more rows
```

The `N_group` is the number of people in each age_group that responded
to one of the options in age_group. `N` is the number of people that
responded to the multiple response question in each group.

#### build_qtable()

This function is designed to help analyse a block of questions. A block
of questions is where all the responses use the same scale (it is
usually a matrix question). The data should have the form:

``` r
clothes_opinions |>
  dplyr::select(starts_with("Q1"))
#> # A tibble: 1,000 × 4
#>   Q1_1                  Q1_2                  Q1_3               Q1_4           
#>   <int+lbl>             <int+lbl>             <int+lbl>          <int+lbl>      
#> 1 1 [Strongly Disagree] 5 [Strongly Agree]    5 [Strongly Agree] 2 [Disagree]   
#> 2 3 [Neutral]           1 [Strongly Disagree] 2 [Disagree]       2 [Disagree]   
#> 3 4 [Agree]             3 [Neutral]           5 [Strongly Agree] 1 [Strongly Di…
#> 4 4 [Agree]             1 [Strongly Disagree] 2 [Disagree]       2 [Disagree]   
#> # ℹ 996 more rows
```

To analyse a question block, you need to pass a `<tidy-eval>` selection
to the function to select all columns in the question block. See we pass
the same statement we made in the select statement above.

``` r
clothes_opinions |>
  build_qtable(starts_with("Q1"))
#> # A xlr_table: 20 x 4
#>   `Question Block`       value                   N Percent
#>   <x_vctr>               <x_vctr>          <x_int> <x_pct>
#> 1 Pants are good to wear Strongly Disagree     187     19%
#> 2 Pants are good to wear Disagree              200     20%
#> 3 Pants are good to wear Neutral               210     21%
#> 4 Pants are good to wear Agree                 208     21%
#> # ℹ 16 more rows

# You can also select the columns directly
clothes_opinions |>
  build_qtable(c(Q1_1,Q1_2,Q1_3,Q1_4))
#> # A xlr_table: 20 x 4
#>   `Question Block`       value                   N Percent
#>   <x_vctr>               <x_vctr>          <x_int> <x_pct>
#> 1 Pants are good to wear Strongly Disagree     187     19%
#> 2 Pants are good to wear Disagree              200     20%
#> 3 Pants are good to wear Neutral               210     21%
#> 4 Pants are good to wear Agree                 208     21%
#> # ℹ 16 more rows
```

You can cut all the columns in the question block by another column(s)
by specifying the `cols` argument. As with
[`build_table()`](https://nhilder.github.io/xlr/reference/build_table.md)
it uses `<tidy-eval>` to select the columns.

``` r
clothes_opinions |>
  build_qtable(starts_with("Q1"),
               gender2)
#> # A xlr_table: 60 x 5
#>   gender2  `Question Block`       value                   N Percent
#>   <x_vctr> <x_vctr>               <x_vctr>          <x_int> <x_pct>
#> 1 male     Pants are good to wear Strongly Disagree      79     17%
#> 2 male     Pants are good to wear Disagree               99     21%
#> 3 male     Pants are good to wear Neutral                99     21%
#> 4 male     Pants are good to wear Agree                  89     19%
#> # ℹ 56 more rows
```

### xlr_table(), xlr types and writing to `Excel`

A key part of the xlr is to export data to `Excel` in an easy, and user
friendly way. The workhorse function in this scenario is
[`xlr_table()`](https://nhilder.github.io/xlr/reference/xlr_table.md),
and if you like the default options is meant to be the function that you
will mostly use.

A [`xlr_table()`](https://nhilder.github.io/xlr/reference/xlr_table.md)
is a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with an optional title, and footnote, as well as a number of formatting
options.

``` r
clothes_opinions |>
  xlr_table("This is a title",
             "this is a footnote with extra information")
#> 
#> ── This is a title ─────────────────────────────────────────────────────────────
#> # A xlr_table: 1000 x 20
#>    weight group    gender   gender2     age age_group    Q1_1   Q1_2  Q1_3  Q1_4
#>   <x_int> <x_vctr> <x_vctr> <x_num> <x_int> <x_vctr>  <x_int> <x_in> <x_i> <x_i>
#> 1   1,072 a        female      2.00      25 18-30           1      5     5     2
#> 2     219 a        female      2.00      64 51-65           3      1     2     2
#> 3   1,187 a        male        1.00      35 31-40           4      3     5     1
#> 4   1,860 a        male        1.00      55 51-65           4      1     2     2
#> # ℹ 996 more rows
#> # ℹ 10 more variables: Q2_1 <x_vctr>, Q2_2 <x_vctr>, Q2_3 <x_vctr>,
#> #   Q2_4 <x_vctr>, Q2_5 <x_vctr>, Q2_6 <x_vctr>, Q3_1 <x_num>, Q3_2 <x_num>,
#> #   Q3_3 <x_num>, Q3_other <x_vctr>
#> this is a footnote with extra information
```

When you call
[`xlr_table()`](https://nhilder.github.io/xlr/reference/xlr_table.md) it
converts the elements of your table to different `xlr` types.

#### Types

xlr types are defined to help with the formatting of columns when they
are output to `Excel`. There are four difference types defined in xlr:

- [`xlr_numeric()`](https://nhilder.github.io/xlr/reference/xlr_numeric.md)
  to format doubles neatly.

- [`xlr_integer()`](https://nhilder.github.io/xlr/reference/xlr_integer.md)
  to format integer data neatly.

- [`xlr_percent()`](https://nhilder.github.io/xlr/reference/xlr_percent.md)
  to format numeric data as a percentage.

- [`xlr_vector()`](https://nhilder.github.io/xlr/reference/xlr_vector.md)
  a general type to format data nicely without specific rules.

All of the above variables contain the argument `xlr_format` which only
takes a
[`xlr_format()`](https://nhilder.github.io/xlr/reference/xlr_format.md)
object.
[`xlr_format()`](https://nhilder.github.io/xlr/reference/xlr_format.md)
allows you to control different formatting options when the data is
outputted to `Excel`, it currently does not change how the data looks in
console. You can change the font size, colour, text position etc. with
[`xlr_format()`](https://nhilder.github.io/xlr/reference/xlr_format.md).
See
[`?xlr_format`](https://nhilder.github.io/xlr/reference/xlr_format.md)
for the full range of options.

For
[`xlr_numeric()`](https://nhilder.github.io/xlr/reference/xlr_numeric.md)
and
[`xlr_percent()`](https://nhilder.github.io/xlr/reference/xlr_percent.md)
you can also set the number of decimal places through setting `dp=x`.

#### Updating/Formatting columns

You can update the format of individual columns by using
[`dplyr::mutate`](https://dplyr.tidyverse.org/reference/mutate.html) or
base R by setting the column with new formatting options:

``` r
table <- xlr_table(mtcars, "A clever title", "A useful footnote")
             
# Lets update the format of the mpg column so that it displays using 0 decimal places
table$mpg <- xlr_numeric(table$mpg, dp = 0)

# You can also use mutate to achieve the same thing, this is useful for
# updating multiple columns either by using across or in a single statement
table <- table |>
  dplyr::mutate(
    mpg = xlr_numeric(mpg, dp = 0),
    # convert columns that are integers to xlr_integer type
    across(vs:carb, ~ xlr_integer(.x))
  )
```

#### dplyr verbs

The
[`xlr_table()`](https://nhilder.github.io/xlr/reference/xlr_table.md)
type is implemented to work with most `dplyr` verbs to make working with
the data as seamless as possible. To find out more see
[`?xlr_and_dplyr`](https://nhilder.github.io/xlr/reference/xlr_and_dplyr.md).

### Writing data to `Excel`

xlr makes writing data to `Excel` easy using the
[`write_xlsx()`](https://nhilder.github.io/xlr/reference/write_xlsx.md)
function. This function takes either a `xlr_table`, `tibble` or
`data.frame`. Note when you output a single object you need to specify

``` r
write_xlsx(mtcars,
           file = "example.xlsx",
           sheet_name = "example_sheet")
```

The output looks like this in `Excel`:

![Example of exporting a data.frame with write_xlsx, it shows a simple
table in Excel.](img/data.frame_example.png)

Example of exporting a data.frame with write_xlsx, it shows a simple
table in `Excel`.

When you output a `xlr_table` with this function additional formatting
will be applied to the data as well as the title and a footnote.

``` r
write_xlsx(table,
           file = "example.xlsx",
           sheet_name = "example_sheet")
#> ℹ Appending file: example.xlsx
```

The output looks like this in `Excel`:

![Example of using a xlr_table with write_xlsx, the table now has a
table, footnote and formatting!](img/xlr_table_example.png)

Example of using a xlr_table with write_xlsx, the table now has a table,
footnote and formatting!

To update this formatting you either need to update the styles of the
columns using the above, or if you want to modify the style of the table
use `update_theme`. You can modify the the format of the title,
footnote, column heading or table body. The below example shows how to
update title colour to be red and the underlined:

``` r
table <- update_theme(table,
                      title_format = xlr_format(font_colour = "red",
                                                 text_style = "underline"))
write_xlsx(table,
           file = "example.xlsx",
           sheet_name = "example_sheet")
#> ℹ Appending file: example.xlsx
```

The output looks like this:

![Example of update theme in use, the title is red and
underlined](img/update_theme_example.png)

Example of update theme in use, the title is red and underlined

See
[`?update_theme`](https://nhilder.github.io/xlr/reference/update_theme.md)
for more details.

#### `write_xlsx()` and `list()`

Like
[`openxlsx::write.xlsx()`](https://rdrr.io/pkg/openxlsx/man/write.xlsx.html)
you can also pass a **named list** to
[`write_xlsx()`](https://nhilder.github.io/xlr/reference/write_xlsx.md)
and these will be automatically created as sheets in the `Excel` file.
If you have a [`list()`](https://rdrr.io/r/base/list.html) of tables,
set `TOC = TRUE` in order to generate a table of contents for the
`Excel` file. This is particularly useful when you have a large number
of tables.

## Putting it all together

Example of how you can use xlr to analyse a survey is below:

``` r
output_list <- list()

output_list[["gender"]] <- build_table(clothes_opinions,
                                       gender2,
                                       "Gender in clothes opinions survey")


output_list[["gender age"]] <- build_table(clothes_opinions,
                                       c(gender2, age_group),
                                       "Gender by age in clothes opinions survey")

output_list[["gender age"]] <- build_table(clothes_opinions,
                                       c(gender2, age_group),
                                       "Gender by age in clothes opinions survey")

output_list[["opinions"]] <- build_qtable(clothes_opinions,
                                        starts_with("Q1"),
                                       table_title = "Opinions on different clothing items")

# Sometimes it is neater to use the pipe operator on the data
# This also allows auto completion in RStudio for variable names
output_list[["opinions gender"]] <- 
  clothes_opinions |>
    build_qtable(starts_with("Q1"),
                  gender2,
                 table_title = "Opinions on different clothing items by gender2",
                 use_questions = TRUE)

# now output the data, we turn on the option to generate a table of contents
write_xlsx(output_list,
           file = "example2.xlsx",
           TOC = TRUE)
```
