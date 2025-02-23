
#' Convert xlr types to their base R type
#'
#' `as_base_r` converts xlr objects, [xlr_table], [xlr_numeric], [xlr_integer],
#' [xlr_percent], and [xlr_format] to their base R type.
#'
#' @param x a xlr object
#'
#' @details
#' [as_base_r] is a generic. It is a wrapper around \link[vctrs]{vec_data} but will convert
#' every object to its base type.
#'
#' @return The base type of the base R object.
#'
#' @example inst/examples/as_base_r.R
#'
#' @export
as_base_r <- function(x){
  UseMethod("as_base_r")
}

#' @export
as_base_r.default <- function(x){
  vec_data(x)
}

#' @export
as_base_r.xlr_table <- function(x){
  # first remove all the data from the data.frame
  x <- vec_data(x)
  # next remove all the data from the individual columns
  x[] <- lapply(x,vec_data)
  x
}
