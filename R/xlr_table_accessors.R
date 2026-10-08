#' Get and set `xlr_table` attributes
#'
#' @description
#' These functions get and set the title, footnote and formats of a
#' [xlr_table]. The `set_*()` functions return a new `xlr_table`, so they can
#' be used in a pipe.
#'
#' * `get_title()` / `set_title()`: the title of the table.
#' * `get_footnote()` / `set_footnote()`: the footnote of the table, with one
#'   element per line.
#' * `get_title_format()` / `set_title_format()`,
#'   `get_footnote_format()` / `set_footnote_format()`,
#'   `get_column_heading_format()` / `set_column_heading_format()`,
#'   `get_table_body_format()` / `set_table_body_format()`: the [xlr_format]
#'   used for each part of the table when it is written with [write_xlsx()].
#'   To change several formats at once use [update_theme()].
#'
#' @param x a `xlr_table`.
#' @param value the new value:
#'   * for `set_title()`: a string, or `NULL` to remove the title.
#'   * for `set_footnote()`: a character vector, or `NULL` to remove the
#'     footnote. Use `""` for an empty line.
#'   * for the format setters: a [xlr_format].
#'
#' @return
#' * `get_title()` and `get_footnote()` return a character vector, which is
#'   `character()` if there is no title or footnote.
#' * The format getters return a [xlr_format].
#' * The `set_*()` functions return a `xlr_table`.
#'
#' @seealso [xlr_table()], [update_theme()]
#'
#' @example inst/examples/xlr_table_accessors.R
#'
#' @name xlr_table_accessors
NULL

#' @export
#' @rdname xlr_table_accessors
get_title <- function(x) {
  type_abort(x, is_xlr_table, string_type = "a {.cls xlr_table}")
  pull_title(x)
}

#' @export
#' @rdname xlr_table_accessors
set_title <- function(x, value) {
  type_abort(x, is_xlr_table, string_type = "a {.cls xlr_table}")
  value <- value %||% character()
  type_abort(value,
             \(x) is_scalar_character(x) || identical(x, character()),
             string_type = "a string or {.code NULL}")
  modify_xlr_table(x, title = value)
}

#' @export
#' @rdname xlr_table_accessors
get_footnote <- function(x) {
  type_abort(x, is_xlr_table, string_type = "a {.cls xlr_table}")
  pull_footnote(x)
}

#' @export
#' @rdname xlr_table_accessors
set_footnote <- function(x, value) {
  type_abort(x, is_xlr_table, string_type = "a {.cls xlr_table}")
  value <- value %||% character()
  type_abort(value,
             is_character,
             string_type = "a character vector or {.code NULL}")
  modify_xlr_table(x, footnote = value)
}

#' @export
#' @rdname xlr_table_accessors
get_title_format <- function(x) {
  type_abort(x, is_xlr_table, string_type = "a {.cls xlr_table}")
  pull_title_format(x)
}

#' @export
#' @rdname xlr_table_accessors
set_title_format <- function(x, value) {
  type_abort(x, is_xlr_table, string_type = "a {.cls xlr_table}")
  type_abort(value, is_xlr_format, xlr_format())
  modify_xlr_table(x, title_format = value)
}

#' @export
#' @rdname xlr_table_accessors
get_footnote_format <- function(x) {
  type_abort(x, is_xlr_table, string_type = "a {.cls xlr_table}")
  pull_footnote_format(x)
}

#' @export
#' @rdname xlr_table_accessors
set_footnote_format <- function(x, value) {
  type_abort(x, is_xlr_table, string_type = "a {.cls xlr_table}")
  type_abort(value, is_xlr_format, xlr_format())
  modify_xlr_table(x, footnote_format = value)
}

#' @export
#' @rdname xlr_table_accessors
get_column_heading_format <- function(x) {
  type_abort(x, is_xlr_table, string_type = "a {.cls xlr_table}")
  pull_column_heading_format(x)
}

#' @export
#' @rdname xlr_table_accessors
set_column_heading_format <- function(x, value) {
  type_abort(x, is_xlr_table, string_type = "a {.cls xlr_table}")
  type_abort(value, is_xlr_format, xlr_format())
  modify_xlr_table(x, column_heading_format = value)
}

#' @export
#' @rdname xlr_table_accessors
get_table_body_format <- function(x) {
  type_abort(x, is_xlr_table, string_type = "a {.cls xlr_table}")
  pull_table_body_format(x)
}

#' @export
#' @rdname xlr_table_accessors
set_table_body_format <- function(x, value) {
  type_abort(x, is_xlr_table, string_type = "a {.cls xlr_table}")
  type_abort(value, is_xlr_format, xlr_format())
  modify_xlr_table(x, table_body_format = value)
}

#' Re-create a `xlr_table` with some of its attributes replaced
#'
#' @param x a `xlr_table`.
#' @param title,footnote,title_format,footnote_format,column_heading_format,table_body_format
#' the new attributes, by default the current attributes of `x`.
#' @param call the caller environment.
#'
#' @noRd
modify_xlr_table <- function(x,
                             title = pull_title(x),
                             footnote = pull_footnote(x),
                             title_format = pull_title_format(x),
                             footnote_format = pull_footnote_format(x),
                             column_heading_format = pull_column_heading_format(x),
                             table_body_format = pull_table_body_format(x),
                             call = caller_env()) {
  new_xlr_table(x,
                title,
                footnote,
                title_format,
                footnote_format,
                column_heading_format,
                table_body_format,
                call = call)
}
