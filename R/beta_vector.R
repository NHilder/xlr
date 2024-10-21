#' `beta_vector` vector
#'
#' A general container for including additional styling options with a vector.
#' It adds extra  formatting attribute so that it is
#' can easily be outputted to excel in the correct format.
#'
#' While you can use it with `integer`, and `double` types and specifying the
#' associated Excel format, we recommend using [beta_integer], [beta_double],
#' or [beta_percent] types instead.
#'
#' @param x A vector
#'  * For `beta_vector()`: A vector
#'  * For `is_beta_vector()`: An object to test
#'  * For `as_beta_vector()` : a vector
#' @param excel_format a character, the excel cell format, not validated. See
#' \link[openxlsx]{createStyle} argument numFmt for more details on what
#' you can specify.
#' @param style Additional styling options for the vector. See [beta_format] for
#' more details.
#'
#' @return An S3 vector of class `beta_vector`
#'
#' @seealso [beta_percent()], [beta_integer()], [beta_double()]
#'
#' @example inst/examples/beta_vector.R
#'
#' @export
beta_vector <- function(x = vector(),
                        excel_format = "GENERAL",
                        style = beta_format()){

  # if it is not NULL then check it is a vector
  # a NULL vector is an empty vector and should have length 0
  if (!is.null(x) && !is_vector(x)){
    cli_abort('{x} is not a vector!')
  }
  validate_beta_vector(x = x,
                       excel_format = excel_format,
                       style = style)

  new_beta_vector(x = x,
                  excel_format = excel_format,
                  style = style)
}

validate_beta_vector <- function(
    x = vector(),
    excel_format = "",
    style = beta_format(),
    call = caller_env()){

}

#' Constructor of beta_vector
#' @inheritParams beta_vector
#' @param call the calling environment
new_beta_vector <- function(x = vector(),
                            excel_format = "GENERAL",
                            style = beta_format(),
                            call = caller_env()) {

  type_abort(x,is_vector,string_type = "vector",call = call)
  type_abort(excel_format,is_scalar_character,"character",call = call)
  type_abort(style,is_beta_format,beta_format(),call = call)

  # finally we create our vector
  new_vctr(x,
           excel_format = excel_format,
           style = style,
           class = "beta_vector")
}

#' @export
#' @rdname beta_vector
is_beta_vector <- function(x) {
  inherits(x, "beta_vector")
}

#' @export
#' @rdname beta_vector
as_beta_vector <- function(x,
                           excel_format = "GENERAL",
                           style = beta_format()){
  UseMethod("as_beta_vector")
}

#' @export
as_beta_vector.default <- function(x,
                                   excel_format = "GENERAL",
                                   style = beta_format()){
  beta_vector(x,
              excel_format = excel_format,
              style = style)
}


#' @export
print.beta_vector <- function(x, ...){
  x <- get_beta_vector_data(x)
  print(x)
  # (silently) return x
  invisible(x)
}

# Defines a nice shortening of the name the tibble uses

#' @export
vec_ptype_abbr.beta_vector <- function(x,...){
  "b_vctr"
}

#' Get the data from a beta_vector
#' @param x a beta_vector
#' @return the contents of vector x
#'
#' @export
get_beta_vector_data <- function(x){
  type_abort(x,is_beta_vector,beta_vector())
  attributes(x) <- NULL
  x
}
