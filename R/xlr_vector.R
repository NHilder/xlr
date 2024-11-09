#' `xlr_vector` vector
#'
#' A general container for including additional styling options with a vector.
#' It adds extra  formatting attribute so that it is
#' can easily be outputted to excel in the correct format.
#'
#' While you can use it with `integer`, and `double` types and specifying the
#' associated Excel format, we recommend using [xlr_integer], [xlr_numeric],
#' or [xlr_percent] types instead.
#'
#' @param x A vector
#'  * For `xlr_vector()`: A vector
#'  * For `is_xlr_vector()`: An object to test
#'  * For `as_xlr_vector()` : a vector
#' @param excel_format a character, the excel cell format, not validated. See
#' \link[openxlsx]{createStyle} argument numFmt for more details on what
#' you can specify.
#' @param style Additional styling options for the vector. See [xlr_format] for
#' more details.
#'
#' @return An S3 vector of class `xlr_vector`
#'
#' @seealso [xlr_percent()], [xlr_integer()], [xlr_numeric()]
#'
#' @example inst/examples/xlr_vector.R
#'
#' @export
xlr_vector <- function(x = vector(),
                        excel_format = "GENERAL",
                        style = xlr_format()){

  # if it is not NULL then check it is a vector
  # a NULL vector is an empty vector and should have length 0
  if (!is.null(x) && !is_vector(x)){
    cli_abort('{x} is not a vector!')
  }
  validate_xlr_vector(x = x,
                       excel_format = excel_format,
                       style = style)

  new_xlr_vector(x = x,
                  excel_format = excel_format,
                  style = style)
}

validate_xlr_vector <- function(
    x = vector(),
    excel_format = "",
    style = xlr_format(),
    call = caller_env()){

}

#' Constructor of xlr_vector
#' @inheritParams xlr_vector
#' @param call the calling environment
new_xlr_vector <- function(x = vector(),
                            excel_format = "GENERAL",
                            style = xlr_format(),
                            call = caller_env()) {

  type_abort(x,is_vector,string_type = "vector",call = call)
  type_abort(excel_format,is_scalar_character,"character",call = call)
  type_abort(style,is_xlr_format,xlr_format(),call = call)

  # finally we create our vector
  new_vctr(x,
           excel_format = excel_format,
           style = style,
           class = "xlr_vector")
}

#' @export
#' @rdname xlr_vector
is_xlr_vector <- function(x) {
  inherits(x, "xlr_vector")
}

#' @export
#' @rdname xlr_vector
as_xlr_vector <- function(x,
                           excel_format = "GENERAL",
                           style = xlr_format()){
  UseMethod("as_xlr_vector")
}

#' @export
as_xlr_vector.default <- function(x,
                                   excel_format = "GENERAL",
                                   style = xlr_format()){
  xlr_vector(x,
              excel_format = excel_format,
              style = style)
}


#' @export
print.xlr_vector <- function(x, ...){
  x <- get_xlr_vector_data(x)
  print(x)
  # (silently) return x
  invisible(x)
}

# Defines a nice shortening of the name the tibble uses

#' @export
vec_ptype_abbr.xlr_vector <- function(x,...){
  "b_vctr"
}

#' Get the data from a xlr_vector
#' @param x a xlr_vector
#' @return the contents of vector x
#'
#' @export
get_xlr_vector_data <- function(x){
  type_abort(x,is_xlr_vector,xlr_vector())
  attributes(x) <- NULL
  x
}
