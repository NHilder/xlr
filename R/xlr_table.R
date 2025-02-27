

#' @title `xlr_table` object
#'
#' @description
#' Create a `xlr_table` S3 object. This is used to create an object that stores
#' formatting information, as well as a title and footnote. This objects makes it
#' easy to convert to an `Excel` sheet, using [write_xlsx()].
#' To edit underlying formatting options use [update_theme()].
#'
#' A number of `dplyr` methods have been implemented for `xlr_table`, these
#' include `mutate`, `summarise`, `select`, etc. This means you can use these
#' functions on a `xlr_table`, without losing the `xlr_table` attributes. You
#' can check if the `dplyr` function is supported by checking the documentation
#' of the function. Currently, it is not possible to use `group_by` and a `xlr_table`,
#' as this would require the implementation of a new class.
#'
#' You can convert a table back to a data.frame with base type with [as_base_r()].
#'
#' @param x a data object
#'    * for `xlr_table()` : a `data.frame`, or `tibble`. See notes for further details.
#'    * for `is_xlr_table()` : An object
#'    * for `as_xlr_table()` a `data.frame`, or `tibble`.
#' @param title a string that is the title
#' @param footnote a string that is the footnote
#'
#' @return a `xlr_table` S3 class
#'
#' @export
#'
#' @example inst/examples/xlr_table.R
#'
#' @seealso [update_theme()], [as_base_r()]
xlr_table <- function(x,
                       title = character(),
                       footnote = character()) {
  # first we attempt to convert x to a tibble if possible
  x <- as_tibble(x)

  # next we convert all the columns in x to xlr_format version
  x_fmt <- x |>
    mutate(across(everything(), ~ convert_to_xlr_types(.x)))

  validate_xlr_table(x_fmt, title, footnote)

  # now create the xlr_table
  new_xlr_table(x_fmt,
                 title,
                 footnote)
}

#' @export
#' @rdname xlr_table
is_xlr_table <- function(x)
  inherits(x, what = "xlr_table")

#' @export
#' @rdname xlr_table
as_xlr_table <- function(x,
                          title = character(),
                          footnote = character()) {
  UseMethod("as_xlr_table")
}

#' @export
as_xlr_table.default <- function(x,
                                  title = character(),
                                  footnote = character()) {
  xlr_table(x,
             title = title,
             footnote = footnote)
}

#' @export
as_xlr_table.data.frame <- function(x,
                                     title = character(),
                                     footnote = character()) {
  xlr_table(x,
             title = title,
             footnote = footnote)
}

#' Update the `xlr_table` theme
#'
#' This function allows you to update the underlying styling for your [xlr_table].
#' This changes how the titles, footnotes, columns, and body objects look when
#' you write you `xlr_table` to `Excel` with [write_xlsx()].
#'
#' If you want to change the style of the *columns* in the data, you should convert them
#' to a [xlr_vector], [xlr_numeric], [xlr_integer] or [xlr_percent] type if they are
#' not already, and then update the [xlr_format] attribute, by setting
#' the `style` parameter.
#'
#' @param x a `xlr_table`
#' @param title_format a `xlr_format` object to format the title
#' @param footnote_format a `xlr_format` object to format the footnote
#' @param column_heading_format a `xlr_format` object to format the column heading
#' @param table_body_format a `xlr_format` object to format the body
#'
#' @return Returns a [xlr_table] object.
#'
#' @example inst/examples/update_theme.R
#'
#' @export
update_theme <- function(x,
                         title_format = xlr_format(font_size = 12,
                                                    text_style = "bold"),
                         footnote_format = xlr_format(font_size = 9,
                                                       text_style = "italic"),
                         column_heading_format = xlr_format(
                           font_size = 11,
                           text_style = "bold",
                           border = c("top", "bottom"),
                           halign = "center",
                           wrap_text = TRUE
                         ),
                         # having the table body format is temporary like this, a lot of the
                         # elements don't make sense, but we can update it in future
                         table_body_format = xlr_format(border = c("top", "left", "right", "bottom"))) {
  type_abort(x, is_xlr_table, xlr_table())
  type_abort(title_format, is_xlr_format, xlr_format())
  type_abort(footnote_format, is_xlr_format, xlr_format())
  type_abort(column_heading_format, is_xlr_format, xlr_format())
  type_abort(table_body_format, is_xlr_format, xlr_format())

  new_xlr_table(
    x,
    pull_title(x),
    pull_footnote(x),
    title_format,
    footnote_format,
    column_heading_format
  )
}

#' Validate the xlr table
#' currently does nothing
#' @noRd
validate_xlr_table <- function(x,
                                title,
                                footnote,
                                call = caller_env()) {

}

#' Creates the S3 class xlr_table
#'
#' @inheritParams xlr_table
#' @param title_format a `xlr_format` to format the title
#' @param footnote_format a `xlr_format` to format the footnote
#' @param column_heading_format a `xlr_format` to format the column headers
#' @param table_body_format a `xlr_format` to format the body
#' @param call the calling environment
#'
#' @noRd
new_xlr_table <- function(x,
                           title = character(),
                           footnote = character(),
                           title_format = xlr_format(font_size = 12,
                                                      text_style = "bold"),
                           footnote_format = xlr_format(font_size = 9,
                                                         text_style = "italic"),
                           column_heading_format = xlr_format(
                             font_size = 11,
                             font_colour = "black",
                             text_style = "bold",
                             border = c("top", "bottom"),
                             halign = "center",
                             background_colour = "white",
                             wrap_text = TRUE
                           ),
                           # having the table body format is temporary like this, a lot of the
                           # elements don't make sense, but we can update it in future
                           table_body_format = xlr_format(border = c("top", "bottom")),
                           call = caller_env()) {
  # check if x inherits a dataframe
  if (!is.data.frame(x)) {
    cli_abort(
      c("i" = "In argument: {.arg {argname}}.",
        "{.arg x} must be a data frame or tibble, not a {.type {x}}."),
      call = call
    )
  }
  # check title has correct attributes
  type_abort(title, \(x) is_character(x) && (length(x) == 1 || length(x) == 0), " ", call = call)
  type_abort(footnote, is_character, " ", call = call)
  type_abort(title_format, is_xlr_format, xlr_format(), call = call)
  type_abort(footnote_format, is_xlr_format, xlr_format(), call = call)
  type_abort(column_heading_format, is_xlr_format, xlr_format(), call = call)
  type_abort(table_body_format, is_xlr_format, xlr_format(), call = call)


  new_data_frame(
    x,
    class = c("xlr_table", "tbl", "tbl_df"),
    # additional attributes
    title = title,
    footnote = footnote,
    title_format = title_format,
    footnote_format = footnote_format,
    column_heading_format = column_heading_format,
    table_body_format = table_body_format
  )

}

#' This function converts a data.frame or tibble to have
#' xlr_types
#' @param x a data.frame or tibble
#'
#' @noRd
convert_to_xlr_types <- function(x) {

  if (is_xlr_numeric(x) || is_xlr_percent(x) ||
      is_xlr_integer(x) || is_xlr_vector(x)) {
    return(x)
  }
  else if (is.factor(x)) {
    # convert to a xlr_vector
    x <- xlr_vector(as.character(x))
    return(x)
  }
  else if (is(x,"Date") || is(x,"POSIXt")) return(x)
  else if (is.integer(x)) return(xlr_integer(x))
  else if (is.numeric(x)) return(xlr_numeric(x))
  else return(xlr_vector(x))
}



# Both of these are used to print the xlr_table very nicely by default
# it uses pillar to do it nicely

#' @export
tbl_sum.xlr_table <- function(x) {
  title <- pull_title(x)
  size <- paste0(nrow(x)," x ",ncol(x))

  if (length(title) != 0){
    cli_h1(title)
  }

  c("A xlr_table" = size)

}

#' @export
tbl_format_footer.xlr_table <- function(x, setup, ...){
  default_footer <- NextMethod()
  footnote <- pull_footnote(x)
  if (length(footnote) != 0){
    output <- c(default_footer,
                cli::style_italic(footnote))
    return(output)
  } else{
    return(default_footer)
  }
}

#' xlr and dplyr
#' @name xlr_and_dplyr
#'
#' @description
#' `xlr_table()` is designed to work with dplyr verbs by default. This is so you
#' `mutate`, `summarise`, `arrange` etc. your data without losing your `xlr_table`
#' information. Particularly if you have used `build_table` first on your data,
#' which outputs data as a `xlr_table`.
#'
#' The list of currently supported dplyrs verbs are: `arrange`, `distinct`, `filter`,
#' `mutate`, `relocate`, `rename`, `rename_with`, `rowwise`, `select`, `slice`,
#' `slice_head`, `slice_max`, `slice_min`, `slice_sample`, `slice_tail`, `summarise`.
NULL

# A---------------------

#' @export
arrange.xlr_table <- function(.data, ...) {
  dplyr_generic(.data, arrange, ...)
}

# C---------------------
# #' @export
# count.xlr_table <- function(x, ..., wt, sort, name) {
#   dplyr_generic(x, count, ..., wt, sort, name)
# }


# D---------------------
#' @export
distinct.xlr_table <- function(.data, ...) {
  dplyr_generic(.data, distinct, ...)
}

# F---------------------
#' @export
filter.xlr_table <- function(.data, ...) {
  dplyr_generic(.data, filter, ...)
}

# G--------------------

# I--------------------
# Could put in the inner_join

#- M-------------------
#' @export
mutate.xlr_table <- function(.data, ...) {
  dplyr_generic(.data, mutate, ...)
}

#- N-------------------

#- R-------------------
#' @export
relocate.xlr_table <- function(.data, ...) {
  dplyr_generic(.data, relocate, ...)
}

#' @export
rename.xlr_table <- function(.data, ...) {
  dplyr_generic(.data, rename, ...)
}

#' @export
rename_with.xlr_table <- function(.data, ...) {
  dplyr_generic(.data, rename_with, ...)
}

#' @export
rowwise.xlr_table <- function(data, ...) {
  dplyr_generic(data, rowwise, ...)
}

#- S-------------------

#' @export
select.xlr_table <- function(.data, ...) {
  dplyr_generic(.data, select, ...)
}

#' @export
slice.xlr_table <- function(.data, ...) {
  dplyr_generic(.data, slice, ...)
}

#' @export
slice_head.xlr_table <- function(.data, ...) {
  dplyr_generic(.data, slice_head, ...)
}
#' @export
slice_max.xlr_table <- function(.data, ...) {
  dplyr_generic(.data, slice_max, ...)
}
#' @export
slice_min.xlr_table <- function(.data, ...) {
  dplyr_generic(.data, slice_min, ...)
}
#' @export
slice_sample.xlr_table <- function(.data, ...) {
  dplyr_generic(.data, slice_sample, ...)
}
#' @export
slice_tail.xlr_table <- function(.data, ...) {
  dplyr_generic(.data, slice_tail, ...)
}

#' @export
summarise.xlr_table <- function(.data, ...) {
  dplyr_generic(.data, summarise, ...)
}

#' @export
summarize.xlr_table <- function(.data, ...) {
  dplyr_generic(.data, summarize, ...)
}

#- T-------------------

# #' @export
# tally.xlr_table <- function(x, wt, sort, name) {
#   dplyr_generic(x, tally, wt, sort, name)
# }

#- U-------------------
# #' @export
# ungroup.xlr_table <- function(x, ...) {
#  dplyr_generic(x, ungroup, ...)
#}


#' create the dplyr generics for use
#'
#' @param x the data set
#' @param dplyr_function the dplyr function we want to act on
#' @param ... arguments to the dplyr function
#'
#' @noRd
dplyr_generic <- function(x, dplyr_function, ...) {
  out <-
    # tibble(x) |>
    as.data.frame(x) |>
    dplyr_function(...)
  # now we pull out the xlr attributes
  new_xlr_table(
    out,
    pull_title(x),
    pull_footnote(x),
    pull_title_format(x),
    pull_footnote_format(x),
    pull_column_heading_format(x),
    pull_table_body_format(x)
  )
}

# Functions that allow us access to the underlying attributes
pull_title <- function(x)
  attr(x, which = "title")
pull_footnote <- function(x)
  attr(x, which = "footnote")
pull_title_format  <- function(x)
  attr(x, which = "title_format")
pull_footnote_format <-
  function(x)
    attr(x, which = "footnote_format")
pull_column_heading_format <-
  function(x)
    attr(x, which = "column_heading_format")
pull_table_body_format <-
  function(x)
    attr(x, which = "table_body_format")
