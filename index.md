# xlr or ‘Exceller’

# xlr

xlr is designed to help build summary tables with complex survey data,
and export data to `Excel`. It includes functions to easily make
cross-tabulations, work with multiple response data, and question
blocks. It supports labelled data that can be generated from the popular
survey platform Qualtrics.

It makes exporting data from `Excel` easier. It is a easier to use
wrapper around [openxlsx](https://ycphs.github.io/openxlsx/). It
supports tables with footnotes, headers, and generating table of
contents in `Excel` documents. It is not fully featured, but designed to
be used when you are moving either statistical summaries or tables from
R into `Excel`.

This package is designed to work seamlessly with
[tidyverse](https://tidyverse.org/) family of functions.

It is currently experimental and subject to change based on peoples
feedback.

## Installation

``` r
# To install via CRAN
install.packages("xlr")
```

You can install the development version of xlr from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("NHilder/xlr")
```

## Example

This is a example of how to create a two-way table, fix the formatting
for that table, and then export that table to `Excel`.

``` r
library(xlr)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

# create a summary table
two_way_table <- build_table(mtcars,c(cyl,gear))
two_way_table
#> # A xlr_table: 8 x 4
#>       cyl    gear       N Percent
#>   <x_num> <x_num> <x_int> <x_pct>
#> 1    4.00    3.00       1      9%
#> 2    4.00    4.00       8     73%
#> 3    4.00    5.00       2     18%
#> 4    6.00    3.00       2     29%
#> 5    6.00    4.00       4     57%
#> 6    6.00    5.00       1     14%
#> 7    8.00    3.00      12     86%
#> 8    8.00    5.00       2     14%

# make the percentage have two decimal places using dplyr
two_way_table <- two_way_table |> 
  mutate(Percent = xlr_percent(Percent, dp = 2))

# write the data to an xlsx file
write_xlsx(two_way_table,
           "example.xlsx",
           "an example")
```

Check out the vignettes for more information on how to use the package.
