

#' @title `beta_table` object
#'
#' @description
#' Create a `beta_table` S3 object. This is used to create an object that stores
#' formatting information, as well as a title and footnote. This objects makes it
#' easy to convert to an Excel sheet, using [write_xlsx()].
#' To edit underlying formatting options use [update_theme()].
#'
#' A number of `dplyr` methods have been implemented for `beta_table`, these
#' include `mutate`, `summarise`, `select`, etc. This means you can use these
#' functions on a `beta_table`, without losing the `beta_table` attributes. You
#' can check if the `dplyr` function is supported by checking the documentation
#' of the function. Currently, it is not possible to use `group_by` and a `beta_table`,
#' as this would require the implementation of a new class.
#'
#' @param x a data object
#'    * for `beta_table()` : a `data.frame`, or `tibble`. See notes for further details.
#'    * for `is_beta_table()` : An object
#'    * for `as_beta_table()` a `data.frame`, or `tibble`.
#' @param title a string that is the title
#' @param footnote a string that is the footnote
#'
#' @return a `beta_table` S3 class
#'
#' @export
#'
#' @example inst/examples/beta_table.R
#'
#' @seealso [update_theme()]
beta_table <- function(x,
                       title = character(),
                       footnote = character()) {
  # first we attempt to convert x to a tibble if possible
  x <- as_tibble(x)

  # next we convert all the columns in x to beta_format version
  x_fmt <- x |>
    mutate(across(everything(), ~ convert_to_beta_types(.x)))

  validate_beta_table(x_fmt, title, footnote)

  # now create the beta_table
  new_beta_table(x_fmt,
                 title,
                 footnote)
}

#' @export
#' @rdname beta_table
is_beta_table <- function(x)
  inherits(x, what = "beta_table")

#' @export
#' @rdname beta_table
as_beta_table <- function(x,
                          title = character(),
                          footnote = character()) {
  UseMethod("as_beta_table")
}

#' @export
as_beta_table.default <- function(x,
                                  title = character(),
                                  footnote = character()) {
  beta_table(x,
             title = title,
             footnote = footnote)
}

#' @export
as_beta_table.data.frame <- function(x,
                                     title = character(),
                                     footnote = character()) {
  beta_table(x,
             title = title,
             footnote = footnote)
}

#' Update the `beta_table` theme
#'
#' This function allows you to update the underlying styling for your [beta_table].
#' This changes how the titles, footnotes, columns, and body objects look when
#' you write you `beta_table` to excel with [write_xlsx()].
#'
#' If you want to change the style of the *columns* in the data, you should convert them
#' to a [beta_vector], [beta_double], [beta_integer] or [beta_percent] type if they are
#' not already, and then update the [beta_format] attribute, by setting
#' the `style` parameter.
#'
#' @param x a `beta_table`
#' @param title_format a `beta_format` object to format the title
#' @param footnote_format a `beta_format` object to format the footnote
#' @param column_heading_format a `beta_format` object to format the column heading
#' @param table_body_format a `beta_format` object to format the body
#'
#' @return Returns a [beta_table] object.
#'
#' @example inst/examples/update_theme.R
#'
#' @export
update_theme <- function(x,
                         title_format = beta_format(font_size = 12,
                                                    text_style = "bold"),
                         footnote_format = beta_format(font_size = 9,
                                                       text_style = "italic"),
                         column_heading_format = beta_format(
                           font_size = 11,
                           text_style = "bold",
                           border = c("top", "bottom"),
                           halign = "center",
                           wrap_text = TRUE
                         ),
                         # having the table body format is temporary like this, a lot of the
                         # elements don't make sense, but we can update it in future
                         table_body_format = beta_format(border = c("top", "left", "right", "bottom"))) {
  type_abort(x, is_beta_table, beta_table())
  type_abort(title_format, is_beta_format, beta_format())
  type_abort(footnote_format, is_beta_format, beta_format())
  type_abort(column_heading_format, is_beta_format, beta_format())
  type_abort(table_body_format, is_beta_format, beta_format())

  new_beta_table(
    x,
    pull_title(x),
    pull_footnote(x),
    title_format,
    footnote_format,
    column_heading_format
  )
}

#' Validate the beta table
#' currently does nothing
#' @noRd
validate_beta_table <- function(x,
                                title,
                                footnote,
                                call = caller_env()) {

}

#' Creates the S3 class beta_table
#'
#' @inheritParams beta_table
#' @param title_format a `beta_format` to format the title
#' @param footnote_format a `beta_format` to format the footnote
#' @param column_heading_format a `beta_format` to format the column headers
#' @param table_body_format a `beta_format` to format the body
#' @param call the calling environment
#'
#' @noRd
new_beta_table <- function(x,
                           title = character(),
                           footnote = character(),
                           title_format = beta_format(font_size = 12,
                                                      text_style = "bold"),
                           footnote_format = beta_format(font_size = 9,
                                                         text_style = "italic"),
                           column_heading_format = beta_format(
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
                           table_body_format = beta_format(border = c("top", "bottom")),
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
  type_abort(title_format, is_beta_format, beta_format(), call = call)
  type_abort(footnote_format, is_beta_format, beta_format(), call = call)
  type_abort(column_heading_format, is_beta_format, beta_format(), call = call)
  type_abort(table_body_format, is_beta_format, beta_format(), call = call)


  new_data_frame(
    x,
    class = c("beta_table", "tbl", "tbl_df"),
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
#' BETA_types
#' @param x a data.frame or tibble
#'
#' @noRd
convert_to_beta_types <- function(x) {
  # save the beta_type information
  if (is_beta_double(x) || is_beta_percent(x) ||
      is_beta_integer(x) || is_beta_vector(x)) {
    return(x)
  }
  else if (is.factor(x)) {
    # convert to a beta_vector
    x <- beta_vector(as.character(x))
    return(x)
  }
  else{
    # first we need to work out if something is a
    x
    # convert to beta_types if it is a general type
    x <- switch(typeof(x),
                "double" = beta_double(x),
                "integer" = beta_integer(x),
                beta_vector(x))
    return(x)
  }
}



# Both of these are used to print the beta_table very nicely by default
# it uses pillar to do it nicely

#' @export
tbl_sum.beta_table <- function(x) {
  title <- pull_title(x)
  size <- paste0(nrow(x)," x ",ncol(x))

  if (length(title) != 0){
    cli_h1(title)
  }

  c("A beta_table" = size)

}

#' @export
tbl_format_footer.beta_table <- function(x, setup, ...){
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

#' BETAExcel and dplyr
#' @name betaexcel_and_dplyr
#'
#' @description
#' `beta_table()` is designed to work with dplyr verbs by default. This is so you
#' `mutate`, `summarise`, `arrange` etc. your data without losing your `beta_table`
#' information. Particularly if you have used `build_table` first on your data,
#' which outputs data as a `beta_table`.
#'
#' The list of currently supported dplyrs verbs are: `arrange`, `distinct`, `filter`,
#' `mutate`, `relocate`, `rename`, `rename_with`, `rowwise`, `select`, `slice`,
#' `slice_head`, `slice_max`, `slice_min`, `slice_sample`, `slice_tail`, `summarise`.
NULL

# A---------------------

#' @export
arrange.beta_table <- function(.data, ...) {
  dplyr_generic(.data, arrange, ...)
}

# C---------------------
# #' @export
# count.beta_table <- function(x, ..., wt, sort, name) {
#   dplyr_generic(x, count, ..., wt, sort, name)
# }


# D---------------------
#' @export
distinct.beta_table <- function(.data, ...) {
  dplyr_generic(.data, distinct, ...)
}

# F---------------------
#' @export
filter.beta_table <- function(.data, ...) {
  dplyr_generic(.data, filter, ...)
}

# G--------------------

# I--------------------
# Could put in the inner_join

#- M-------------------
#' @export
mutate.beta_table <- function(.data, ...) {
  dplyr_generic(.data, mutate, ...)
}

#- N-------------------

#- R-------------------
#' @export
relocate.beta_table <- function(.data, ...) {
  dplyr_generic(.data, relocate, ...)
}

#' @export
rename.beta_table <- function(.data, ...) {
  dplyr_generic(.data, rename, ...)
}

#' @export
rename_with.beta_table <- function(.data, ...) {
  dplyr_generic(.data, rename_with, ...)
}

#' @export
rowwise.beta_table <- function(data, ...) {
  dplyr_generic(data, rowwise, ...)
}

#- S-------------------

#' @export
select.beta_table <- function(.data, ...) {
  dplyr_generic(.data, select, ...)
}

#' @export
slice.beta_table <- function(.data, ...) {
  dplyr_generic(.data, slice, ...)
}

#' @export
slice_head.beta_table <- function(.data, ...) {
  dplyr_generic(.data, slice_head, ...)
}
#' @export
slice_max.beta_table <- function(.data, ...) {
  dplyr_generic(.data, slice_max, ...)
}
#' @export
slice_min.beta_table <- function(.data, ...) {
  dplyr_generic(.data, slice_min, ...)
}
#' @export
slice_sample.beta_table <- function(.data, ...) {
  dplyr_generic(.data, slice_sample, ...)
}
#' @export
slice_tail.beta_table <- function(.data, ...) {
  dplyr_generic(.data, slice_tail, ...)
}

#' @export
summarise.beta_table <- function(.data, ...) {
  dplyr_generic(.data, summarise, ...)
}

#' @export
summarize.beta_table <- function(.data, ...) {
  dplyr_generic(.data, summarize, ...)
}

#- T-------------------

# #' @export
# tally.beta_table <- function(x, wt, sort, name) {
#   dplyr_generic(x, tally, wt, sort, name)
# }

#- U-------------------
# #' @export
# ungroup.beta_table <- function(x, ...) {
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
  # now we pull out the beta attributes
  new_beta_table(
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
