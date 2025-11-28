# Specify formatting options for `xlr_*` types

This function is a utility to work with `openxlxs`'s
[createStyle](https://rdrr.io/pkg/openxlsx/man/createStyle.html), and
work with styles between them. `xlr_format_numeric()` is an alias for
`xlr_format()` but with different default values.

## Usage

``` r
xlr_format(
  font_size = 11,
  font_colour = "black",
  font = "calibri",
  text_style = NULL,
  border = NULL,
  border_colour = "black",
  border_style = "thin",
  background_colour = NULL,
  halign = "left",
  valign = "top",
  wrap_text = FALSE,
  text_rotation = 0L,
  indent = 0L,
  col_width = 10,
  ...
)

xlr_format_numeric(
  font_size = 11,
  font_colour = "black",
  font = "calibri",
  text_style = NULL,
  border = NULL,
  border_colour = "black",
  border_style = "thin",
  background_colour = NULL,
  halign = "right",
  valign = "bottom",
  wrap_text = FALSE,
  text_rotation = 0L,
  indent = 0L,
  col_width = 10
)
```

## Arguments

- font_size:

  A numeric. The font size, must be greater than 0.

- font_colour:

  String. The colour of text in the cell. Must be one of
  [`colours()`](https://rdrr.io/r/grDevices/colors.html) or a valid hex
  colour beginning with `"#"`.

- font:

  String. The name of a font. This is not validated.

- text_style:

  the text styling. You can pass a vector of text decorations or a
  single string. The options for text style are `"bold"`, `"strikeout"`,
  `"italic"`, `"underline"`,`"underline2"` (double underline),
  `"accounting"` (accounting underline), `"accounting2"` (double
  accounting underline). See Details.

- border:

  the cell border. You can pass a vector of `"top"`, `"bottom"`,
  `"left"`, `"right"` or a single string to set the borders that you
  want.

- border_colour:

  Character. The colour of border. Must be the same length as the number
  of sides specified in `border`. Each element must be one of
  [`colours()`](https://rdrr.io/r/grDevices/colors.html) or a valid hex
  colour beginning with `"#"`.

- border_style:

  Border line style vector the same length as the number of sides
  specified in `border`. The list of styles are `"none"`, `"thin"`,
  `"medium"`, `"dashed"`, `"dotted"`, `"thick"`, `"double"`, `"hair"`,
  "`mediumDashed"`, `"dashDot"`, `"mediumDashDot"`, `"dashDotDot"`,
  `"mediumDashDot"`, `"dastDotDot"`, `"mediumDashDotDot"`,
  `"slantDashDosh"`. See
  [createStyle](https://rdrr.io/pkg/openxlsx/man/createStyle.html) for
  more details.

- background_colour:

  Character. Set the background colour for the cell. Must be one of
  [`colours()`](https://rdrr.io/r/grDevices/colors.html) or a valid hex
  colour beginning with `"#"`.

- halign:

  the horizontal alignment of cell contents. Must be either `"left"`,
  `"right"`, `"center"` or "`justify"`.

- valign:

  the vertical alignment of cell contents. Must be either `"top"`,
  `"center"`, or `"bottom"`.

- wrap_text:

  Logical. If `TRUE` cell contents will rap to fit in the column.

- text_rotation:

  Integer. Rotation of text in degrees. Must be an integer between -90
  and 90.

- indent:

  Integer. The number of indent positions, must be an integer between 0
  and 250.

- col_width:

  Numeric. The column width.

- ...:

  Dots. For future expansions. Must be empty.

## Value

a `xlr_format` S3 class.

## Details

### Text styling

For text styling you can pass either one of the options or options in a
vector. For example if you would like to have text that is **bold** and
*italised* then set:

    fmt <- xlr_format(text_style = c("bold", "italic"))

If you would like to the text to be only **bold** then:

    fmt <- xlr_format(text_style = "bold")

### Border styling

The three arguments to create border styling are `border`,
`border_colour`, and `border_style`. They each take either a vector,
where you specify to change what borders to have in each cell and what
they look like. To specify that you want a border around a cell, use
`border`, you need to pass a vector of what sides you want to have a
border (or a single element if it's only one side). For example:

- `"top"` the top border

- `"left"` the left border

- `c("bottom", "right")` the top and bottom border

- `c("left", "right", "bottom")` the left, right and bottom borders

- `c("top","right","bottom","left")` the borders for all sides of the
  cells

Based on this you can use `border_colour` to set the border colours. If
you want all the same border colour, just pass a character representing
the colour you want (e.g. set `border_colour = "blue"` if you'd like all
borders to be blue). Alternatively you can pass a vector the same length
as the vector that you passed to `border`, with the location specifying
the colour. For example, if you set:

    fmt <- xlr_format(border = c("left", "top"),
                        border_colour = c("blue","red"))

the top border will be red, and the left border will be blue. You set
the pattern in the same way for `border_style`. Alternatively if you
only wanted it to be dashed with default colours. You'd set:

    fmt <- xlr_format(border = c("left", "top"),
                      border_style = "dashed")

## See also

- [`is_xlr_format()`](https://nhilder.github.io/xlr/reference/is_xlr_format.md)
  to test if an R object is a `xlr_format`

- [`xlr_table()`](https://nhilder.github.io/xlr/reference/xlr_table.md)
  to use xlr formats

## Examples

``` r
library(xlr)
# You can initialise a xlr_format, it comes with a list of defaults
bf <- xlr_format()
# It outputs what the style looks like
bf
#> -- Text styling:
#> size: 11, colour: "black", font: "calibri", style:
#> -- Text alignment:
#> Horizontal: "left", Vertical: "top", Indent: 0, Rotation: 0, Wrap text: FALSE
#> -- Column Width:
#> Col width: 10
# You can update the format by defining a new format
bf <- xlr_format(font_size = 11,
                  # not that font is not validated
                  font = "helvetica")
# The main use of xlr_format is to change the format of a vector of
# a xlr type
bd <- xlr_numeric(1:200,
                  dp = 1,
                  style = bf)
# You can also use it to change the styles of an xlr_table, this only
# affect the format in `Excel`
bt <- xlr_table(mtcars, "A clever title", "A useful footnote")
bt <- bt |>
      update_theme(footnote_format = xlr_format(font_size = 7))
```
