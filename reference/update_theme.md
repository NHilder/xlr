# Update the `xlr_table` theme

This function allows you to update the underlying styling for your
[xlr_table](https://nhilder.github.io/xlr/reference/xlr_table.md). This
changes how the titles, footnotes, columns, and body objects look when
you write you `xlr_table` to `Excel` with
[`write_xlsx()`](https://nhilder.github.io/xlr/reference/write_xlsx.md).

## Usage

``` r
update_theme(
  x,
  title_format = xlr_format(font_size = 12, text_style = "bold"),
  footnote_format = xlr_format(font_size = 9, text_style = "italic"),
  column_heading_format = xlr_format(font_size = 11, text_style = "bold", border =
    c("top", "bottom"), halign = "center", wrap_text = TRUE),
  table_body_format = xlr_format(border = c("top", "left", "right", "bottom"))
)
```

## Arguments

- x:

  a `xlr_table`

- title_format:

  a `xlr_format` object to format the title

- footnote_format:

  a `xlr_format` object to format the footnote

- column_heading_format:

  a `xlr_format` object to format the column heading

- table_body_format:

  a `xlr_format` object to format the body

## Value

Returns a
[xlr_table](https://nhilder.github.io/xlr/reference/xlr_table.md)
object.

## Details

If you want to change the style of the *columns* in the data, you should
convert them to a
[xlr_vector](https://nhilder.github.io/xlr/reference/xlr_vector.md),
[xlr_numeric](https://nhilder.github.io/xlr/reference/xlr_numeric.md),
[xlr_integer](https://nhilder.github.io/xlr/reference/xlr_integer.md) or
[xlr_percent](https://nhilder.github.io/xlr/reference/xlr_percent.md)
type if they are not already, and then update the
[xlr_format](https://nhilder.github.io/xlr/reference/xlr_format.md)
attribute, by setting the `style` parameter.

## Examples

``` r
library(xlr)
# set up a basic table
bt <- xlr_table(mtcars,
                 "A title",
                 "A footnote")
# now we want to update the title
# This changes what it look likes when we print it to `Excel`
bt <- update_theme(bt,
                   xlr_format(font_size = 12,
                               text_style = c("bold","underline")))
# To see the change you must write to an Excel file
write_xlsx(bt,
           "example.xlsx",
           "Test")
```
