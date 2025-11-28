
#' Check if a variable is an xlr type
#' This function tests whether an R variable has a xlr type.
#'
#' @param x a variable you wish to test
#'
#' @return a logical.
#' @export
is_xlr_type <- function(x){
  is_xlr_integer(x) | is_xlr_percent(x) | is_xlr_numeric(x) |
    is_xlr_vector(x) | is_xlr_table(x) | is_xlr_vector(x) |
    is_xlr_format(x) |
    is_xlr_n_percent(x)
}
