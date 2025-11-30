#' @title Specify formatting options for `xlr_*` types
#' @description
#' This function is a utility to work with `openxlxs`'s \link[openxlsx]{createStyle}, and work
#' with styles between them. [xlr_format_numeric()] is an alias for [xlr_format()] but with different
#' default values.
#'
#' @param font_size A numeric. The font size, must be greater than 0.
#' @param font_colour String. The colour of text in the cell. Must be one of `colours()`
#' or a valid hex colour beginning with `"#"`.
#' @param font String. The name of a font. This is not validated.
#' @param text_style the text styling. You can pass a vector of text
#' decorations or a single string. The options for text style are `"bold"`, `"strikeout"`,
#' `"italic"`, `"underline"`,`"underline2"` (double underline), `"accounting"` (accounting
#' underline), `"accounting2"` (double accounting underline). See Details.
#' @param border the cell border. You can pass a vector of `"top"`, `"bottom"`, `"left"`,
#' `"right"` or a single string to set the borders that you want.
#' @param border_colour Character. The colour of border. Must be the same length as the number of
#' sides specified in `border`. Each element must be one of `colours()`
#' or a valid hex colour beginning with `"#"`.
#' @param border_style Border line style vector the same length as the number of
#'sides specified in `border`. The list of styles are `"none"`, `"thin"`, `"medium"`,
#' `"dashed"`, `"dotted"`, `"thick"`, `"double"`, `"hair"`, "`mediumDashed"`, `"dashDot"`,
#' `"mediumDashDot"`, `"dashDotDot"`, `"mediumDashDot"`, `"dastDotDot"`, `"mediumDashDotDot"`,
#' `"slantDashDosh"`. See \link[openxlsx]{createStyle} for more details.
#' @param background_colour Character. Set the background colour for the cell. Must be one of
#'  `colours()` or a valid hex colour beginning with `"#"`.
#' @param halign the horizontal alignment of cell contents. Must be either
#' `"left"`, `"right"`, `"center"` or "`justify"`.
#' @param valign the vertical alignment of cell contents. Must be either
#' `"top"`, `"center"`, or `"bottom"`.
#' @param wrap_text Logical. If `TRUE` cell contents will rap to fit in the column.
#' @param text_rotation Integer. Rotation of text in degrees. Must be an integer between -90 and
#' 90.
#' @param indent Integer. The number of indent positions, must be an integer between 0 and 250.
#' @param col_width Numeric. The column width.
#' @param ... Dots. For future expansions. Must be empty.
#'
#' @return a `xlr_format` S3 class.
#'
#' @details
#' ## Text styling
#' For text styling you can pass either one of the options or options in a
#' vector. For example if you would like to have text that is \strong{bold} and
#' \emph{italised} then set:
#' ```{r}
#' fmt <- xlr_format(text_style = c("bold", "italic"))
#' ```
#' If you would like to the text to be only \strong{bold} then:
#' ```{r}
#' fmt <- xlr_format(text_style = "bold")
#' ```
#' ## Border styling
#' The three arguments to create border styling are `border`, `border_colour`,
#' and `border_style`. They each take either a vector, where you specify to
#' change what borders to have in each cell and what they look like. To specify
#' that you want a border around a cell, use `border`, you need to pass a vector
#' of what sides you want to have a border (or a single element if it's only one
#' side). For example:
#'  - `"top"` the top border
#'  - `"left"` the left border
#'  - `c("bottom", "right")` the top and bottom border
#'  - `c("left", "right", "bottom")` the left, right and bottom borders
#'  - `c("top","right","bottom","left")` the borders for all sides of the cells
#'
#' Based on this you can use `border_colour` to set the border colours. If you
#' want all the same border colour, just pass a character representing the colour
#' you want (e.g. set `border_colour = "blue"` if you'd like all borders to be
#' blue). Alternatively you can pass a vector the same length as the vector
#' that you passed to `border`, with the location specifying the colour. For example,
#' if you set:
#' ```{r}
#' fmt <- xlr_format(border = c("left", "top"),
#'                     border_colour = c("blue","red"))
#' ```
#' the top border will be red, and the left border will be blue. You set the pattern
#' in the same way for `border_style`. Alternatively if you only wanted it to
#' be dashed with default colours. You'd set:
#' ```{r}
#' fmt <- xlr_format(border = c("left", "top"),
#'                   border_style = "dashed")
#' ```
#' @seealso
#' * [is_xlr_format()] to test if an R object is a `xlr_format`
#' * [xlr_table()] to use xlr formats
#'
#' @example inst/examples/xlr_format.R
#' @export
xlr_format <- function(font_size = 11,
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
                       col_width = 10.00,
                       ...){

  # first we convert the numerics to the right type
  font_size = vec_cast(font_size,double())
  text_rotation = vec_cast(text_rotation,integer())
  indent = vec_cast(indent,integer())
  col_width = vec_cast(col_width, double())
  # first we do a bunch of coersions to null if something
  # is null

  # now validate inputes
  validate_xlr_format(
    font_size,
    font_colour,
    font,
    text_style,
    border,
    border_colour,
    border_style,
    background_colour,
    halign,
    valign,
    wrap_text,
    text_rotation,
    indent,
    col_width,
    ...
  )

  # construct a new object
  new_xlr_format(
    font_size = font_size,
    font_colour = font_colour,
    font = font,
    text_style = text_style,
    border = border,
    border_colour = border_colour,
    border_style = border_style,
    background_colour = background_colour,
    halign = halign,
    valign = valign,
    wrap_text = wrap_text,
    text_rotation = text_rotation,
    indent = indent,
    col_width = col_width
  )
}

#' @export
#' @rdname xlr_format
xlr_format_numeric <-function(font_size = 11,
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
                              col_width = 10.0){

  xlr_format(
    font_size = font_size,
    font_colour = font_colour,
    font = font,
    text_style = text_style,
    border = border,
    border_colour = border_colour,
    border_style = border_style,
    background_colour = background_colour,
    halign = halign,
    valign = valign,
    wrap_text = wrap_text,
    text_rotation = text_rotation,
    indent = indent,
    col_width = col_width
  )
}

#' Test if an object is a `xlr_format`
#' @param x An object to test
#'
#' @export
#'
#' @return a logical.
#' @example inst/examples/xlr_format_utils.R
is_xlr_format <- function(x) inherits(x,"xlr_format")


# now we define a number of generic methods

#' @export
print.xlr_format <- function(x,...){
  # now lets print it nicely
  x <- cli::cli_fmt({
    cli_text("-- Text styling:")
    cli_text("size: {.val {attr(x,which='font_size')}}, colour: {.val {attr(x,which='font_colour')}}, font: {.val {attr(x,which='font')}}, style: {.val {attr(x,which='text_style')}}")
    if (!is.null(attr(x,which='border'))){
      cli_text("-- Border:")
      cli_text("Sides: {.val {attr(x,which='border')}}, Colours: {.val {attr(x,which='border_colour')}}, Styles: {.val {attr(x,which='border_style')}}")
    }
    cli_text("-- Text alignment:")
    cli_text(c("Horizontal: {.val {attr(x,which='halign')}}, ",
               "Vertical: {.val {attr(x,which='valign')}}, ",
               "Indent: {.val {attr(x,which='indent')}}, ",
               "Rotation: {.val {attr(x,which='text_rotation')}}, ",
               "Wrap text: {.val {attr(x,which='wrap_text')}}"))
    cli_text("-- Column Width:")
    cli_text("Col width: {.val {attr(x,which='col_width')}}")
  },
  strip_newline = TRUE)
  cat(paste(x,collapse="\n"))

  # (silently) return x
  invisible(x)
}

# Define a strict equality generic
#' @export
`==.xlr_format` <- function(e1,e2){
  all(
    custom_equality(attr(e1,which="font_size"),
                    attr(e2,which="font_size")),
    custom_equality(attr(e1,which="font_colour"),
                    attr(e2,which="font_colour")),
    custom_equality(attr(e1,which="font"),
                    attr(e2,which="font")),
    custom_equality(attr(e1,which="text_style"),
                    attr(e2,which="text_style")),
    custom_equality(attr(e1,which="border"),
                    attr(e2,which="border")),
    custom_equality(attr(e1,which="border_colour"),
                    attr(e2,which="border_colour")),
    custom_equality(attr(e1,which="border_style"),
                    attr(e2,which="border_style")),
    custom_equality(attr(e1,which="background_colour"),
                    attr(e2,which="background_colour")),
    custom_equality(attr(e1,which="halign"),
                    attr(e2,which="halign")),
    custom_equality(attr(e1,which="valign"),
                    attr(e2,which="valign")),
    custom_equality(attr(e1,which="wrap_text"),
                    attr(e2,which="wrap_text")),
    custom_equality(attr(e1,which="text_rotation"),
                    attr(e2,which="text_rotation")),
    custom_equality(attr(e1,which="indent"),
                    attr(e2,which="indent")),
    custom_equality(attr(e1,which="col_width"),
                    attr(e2,which="col_width")),
    na.rm = TRUE
  )
}

#' @export
`!=.xlr_format` <- function(e1,e2){
  !(`==.xlr_format`(e1,e2))
}


new_xlr_format <- function(font_size = 11,
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
                            col_width = 10.0,
                            call = caller_env()){


  #
  structure(
    # As the .Data has to be filled, a list with formatting data
    # think makes the most sense
    # The attributes are more important than anything else
    list(data ="xlr_FORMAT_OBJECT"),
    class = "xlr_format",
    font_size = font_size,
    font_colour = font_colour,
    font = font,
    text_style = text_style,
    border = border,
    border_colour = border_colour,
    border_style = border_style,
    background_colour = background_colour,
    halign = halign,
    valign = valign,
    wrap_text = wrap_text,
    text_rotation = text_rotation,
    indent = indent,
    col_width = col_width
  )
}

# Validates the xlr_format object, called in construction
validate_xlr_format <- function(
    font_size,
    font_colour,
    font,
    text_style,
    border,
    border_colour,
    border_style,
    background_colour,
    halign,
    valign,
    wrap_text,
    text_rotation,
    indent,
    col_width,
    ...,
    call = caller_env()){

  type_abort(font_size,is_scalar_double,1.1,call=call)
  if (font_size < 1){
    cli_abort(c("i" = "In argument: {.code font_size}.",
                "!" = "{.code font_size} must be greater than or equal to {1}, not {font_size}."),
              call = call)
  } else if (font_size > 409){
    cli_abort(c("i" = "In argument: {.code font_size}.",
                "!" = "{.code font_size} must be less than or equal to {409}, not {font_size}."),
              call = call)
  } else if (font_size %% 0.5 != 0){
    cli_abort(c("i" = "In argument: {.code font_size}.",
                "!" = "{.code font_size} must be multiple of {0.5}, not {font_size}."),
              call = call)
  }

  # run tests for colour
  colour_error(font_colour,
               "font_colour",
               call)

  # tests for font
  type_abort(font,is_scalar_character,"a character",call=call)


  # tests for text_style
  if (!is.null(text_style)){
    arg_match(text_style,
              c("bold", "strikeout", "italic", "underline","underline2",
                "accounting", "accounting2"),
              multiple = TRUE,
              error_call = call)
  }

  # now you can't have different types of underline
  underline_vec <- c("underline","underline2","accounting", "accounting2")
  if (length(intersect(text_style,underline_vec)) > 1){
    cli_abort(c("i" = "In argument: {.code text_style}.",
                "!" = '{.code text_style} can only have one type of underline.',
                "i" = 'Use only one of the underline options: {.val {underline_vec}}'),
              call = call)
  }
  # finally make sure there are no double ups
  if (any(duplicated(c(text_style)))){
    cli_abort(c("i" = "In argument: {.code text_style}.",
                "!" = "You should not pass duplicate values!"),
              call = call)
  }

  # check border is good
  # we don't validate inputs if it is NULL
  if (!is.null(border)){
    arg_match(border,
              c(NA,"top", "bottom", "left", "right"),
              multiple = TRUE,
              error_call = call)

    if (any(duplicated(c(border)))){
      cli_abort(c("i" = "In argument: {.code border}.",
                  "!" = "You should not pass duplicate values!"),
                call = call)
    }
  }
  if (!is.null(border_colour)){
    # check each colour is a valid colours
    sapply(border_colour,function(x) colour_error(x, "border_colour",rlang::caller_env()))

    # check that the length of border_colour is not the same as border or 1
    if (length(border_colour) != 1 && length(border_colour) != length(border)){
      cli_abort(c("i" = "In argument: {.code border_colour}.",
                  "!" = "You can only pass a single colour (to colour all borders the same), or pass a {.cls vector} with the same length as {.code border}."),
                call = call)
    }
  }
  # test border styles
  border_styles_vec <- c("none",
                         "thin",
                         "medium",
                         "dashed",
                         "dotted",
                         "thick",
                         "double",
                         "hair",
                         "mediumDashed",
                         "dashDot",
                         "mediumDashDot",
                         "dashDotDot",
                         "mediumDashDot",
                         "dastDotDot",
                         "mediumDashDotDot",
                         "slantDashDosh")
  if (!is.null(border_colour)){
    arg_match(border_style,
              border_styles_vec,
              multiple = TRUE,
              error_call = call)
    # check that the length of border_style is not the same as border or 1
    if (length(border_style) != 1 && length(border_style) != length(border)){
      cli_abort(c("i" = "In argument: {.code border_style}.",
                  "!" = "You can only pass a single border style (to style all borders the same), or pass a {.cls vector} with the same length as {.code border}."),
                call = call)
    }
  }

  #- Now we validate we all have the
  # if it is not NA, test background colour test
  if (!is.null(background_colour)){
    colour_error(background_colour,"background_colour",call)
  }


  # test that there are only the right align options
  arg_match(halign,
            c("left", "right", "center", "justify"),
            multiple = FALSE,
            error_call = call)
  arg_match(valign,
            c("top", "center", "bottom"),
            multiple = FALSE,
            error_call = call)

  # test if a boolean is a boolean
  type_abort(wrap_text,
             is_true_or_false,
             string_type = "{.val {TRUE}} or {.val {FALSE}}",
             call = call)
  # test text rotation is the right type of variable, and between [-90, 90]
  type_abort(text_rotation,is_scalar_integer,1L,call=call)

  if (text_rotation < -90 || text_rotation > 90){
    cli_abort(c("i" = "In argument: {.code wrap_text}.",
                "!" = "{.code wrap_text} must be between -90 and 90."),
              call = call)
  }

  # test text rotation is the right type of variable, and between [-90, 90]
  type_abort(indent,is_scalar_integer,1L,call=call)
  if (indent < 0 || indent > 250){
    cli_abort(c("i" = "In argument: {.code wrap_text}.",
                "!" = "{.code wrap_text} must be between 0 and 250."),
              call = call)
  }

  # the column width must be between 0 and 255
  type_abort(col_width, is_scalar_double,10.0,call = call)
  if (col_width < 0 || col_width > 255){
    cli_abort(c("i" = "In argument: {.code col_width}.",
                "!" = "{.code col_width} must be between 0 and 255."),
              call = call)
  }

  check_dots_empty(env = caller_env(1),
                   call = call)

  # check that the d
  return(TRUE)
}


colour_error <- function(arg,
                         argName,
                         call){
  # pull out the args nameEE
  if (!is_scalar_character(arg)){
    cli_abort(c("i" = "In argument: {.arg {argName}}.",
                "!"="{.arg {argName}} must be {.type character}, not {.type {arg}}."),
              call = call)
  }
  if (!(arg %in% colours() ||
               grepl('^#[0-9A-Fa-f]{6}',arg) ||
               grepl('^#[0-9A-Fa-f]{8}',arg))){
    cli_abort(c("i" = "In argument: {.arg {argName}}",
                "!" = "{.val {arg}} is not a valid colour or hex code.",
                "i" = "Use {.arg colours()} to see the list of valid colours.",
                "i" = "A valid Hex code will be highlighted by RStudio, if you are using the latest version."),
              call = call)
  }
}


# define custom equality for these objects:
# we want it to handle null different from normal, instead we want it to
# make a decision vs resulting in an empty element
# we also want equality of lists to be if the set of elements is the same
custom_equality <- function(e1,e2){
  if (is.null(e1) && is.null(e2)){
    return(TRUE)
  } else if(is.null(e1) || is.null(e2)){
    return(FALSE)
  } else if (length(e1) > 1 && length(e2) > 1){
    outcome <- setequal(e1,e2)
    return(outcome)
  } else  if (length(e1) > 1 || length(e2) > 1){
    return(FALSE)
  } else{
    outcome <- e1 == e2
    return(outcome)
  }

}


