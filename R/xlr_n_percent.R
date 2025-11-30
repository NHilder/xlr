#' `xlr_n_percent` vector
#'
#' This creates a record vector combining counts (`N`) and percentages (`pct`) that will be printed
#' with appropriate formatting and exported to `Excel` using its native formats. You can convert a
#' vector back to its base type with [as_base_r()].
#'
#' @param n A positive integer vector of counts
#' @param pct A numeric vector of proportions
#' @param dp The number of decimal places to print for the percentage.
#' @param style Additional styling options for the vector. See [xlr_format_numeric] for more details.
#'
#' @param x For `is_xlr_n_percent()`: An object to test

#' @return An S3 record vector of class `xlr_n_percent`.
#'
#' @example inst/examples/xlr_n_percent.R
#'
#' @seealso [xlr_vector()], [xlr_integer()], [xlr_numeric()], [xlr_percent()], [as_base_r()]
#'
#' @export
xlr_n_percent <- function(n = integer(),
                      pct = xlr_percent(),
                      dp = 0L,
                      style = xlr_format_numeric()) {

  # first we try and cast everything to the right type
  vec_n <- vec_cast(n, integer())
  vec_pct <- vec_cast(pct,numeric())
  dp <- vec_recycle(vec_cast(dp, integer()), 1L)

  # do some additional checks on the style and decimal places

  validate_xlr_n_percent(vec_n,
                         vec_pct,
                         dp,
                         style)

  new_xlr_n_percent(vec_n, vec_pct, dp, style)
}

#' @importFrom dplyr symdiff
validate_xlr_n_percent <- function(n = integer(),
                               pct = xlr_percent(),
                               dp = integer(),
                               style = xlr_format_numeric(),
                               call = caller_env()) {

  if (length(n) != length(pct)) {
    cli_abort(c(
      "Lengths of `n` and `pct` do not match.",
      i = "Length of `n`: {length(n)}",
      i = "Length of `pct`: {length(pct)}"
    ))
  }

  if (dp > 12) {
    cli_abort("'dp' must be less than or equal to 12, not {dp}. Risk loss of precision when exporting to Microsoft `Excel`.",
              call = call)
  }

  if (dp < 0) {
    cli_abort("'dp' must be a positive integer.",
              call = call)
  }


  if (isTRUE(any(n < 0))) {
    cli_abort("'n' must only contain positive integers.",
              call = call)
  }

  # check that all of the NA positions match
  na_pos_n <- which(is.na(n))
  na_pos_pct <- which(is.na(pct))
  if (isFALSE(identical(na_pos_n,na_pos_pct))){
    cli_abort(c("!"="'NA' positions in both vectors must match.",
                "i" = "They differ at positions: {.val {symdiff(na_pos_n,na_pos_pct)}}",
                 "i"="Are you sure that {.arg n} and {.arg pct} reflect the same vector?"),
              call = call)
  }
}

#' Constructor for `xlr_n_percent`
#' @inheritParams xlr_n_percent
#' @param call The calling environment.
#' @noRd
new_xlr_n_percent <- function(n = integer(),
                          pct = xlr_percent(),
                          dp = 0L,
                          style = xlr_format_numeric(),
                          call = caller_env()) {

  type_abort(n, is_integer, 1L, call = call)
  type_abort(pct, is_double, xlr_percent(1), call = call)
  # attribute check
  type_abort(dp, is_scalar_integer, 1L, call = call)
  # check it is non empty
  vec_check_size(dp, size = 1L, call = call)
  type_abort(style, is_xlr_format, xlr_format_numeric(), call = call)

  # finally we create our vector
  new_rcrd(list(N = n, Percent = pct),
           dp = dp,
           style = style,
           class = "xlr_n_percent")
}

#' @export
#' @rdname xlr_n_percent
is_xlr_n_percent <- function(x) {
  inherits(x, "xlr_n_percent")
}

#' @export
as.character.xlr_n_percent <- function(x,...){
  format.xlr_n_percent(x)
}

#- Formatting-------------------------------------------------------------------
# Helpful functions to pull out the attributes in
# percent
#' @export
format.xlr_n_percent <- function(x, ...){
  n <- field(x,"N")
  pct <- field(x,"Percent")

  # format N first
  out_N <- formatC(n,
                 format='f',
                 digits=0,
                 # additionally it should have nice commas between numbers
                 big.mark = ',',
                 big.interval = 3L)

  dp <- pull_dp(x)
  out_pct <- formatC(round(pct * 100,dp),
                 format='f',
                 digits=dp)

  out <- paste0(out_N, " (",out_pct,"%)")

  out[is.na(n)] <- NA

  out
}

#' @export
vec_ptype_abbr.xlr_n_percent <- function(x,...){
  "x_n_pct"
}

#- Typing-----------------------------------------------------------------------
# now define some casting

# Compatibility with S4 system
methods::setOldClass(c("xlr_n_percent","vctrs_vctr"))

#' @export
vec_ptype2.xlr_n_percent.xlr_n_percent <- function(x,y,..., x_arg = "", y_arg = ""){
  if (!identical(attributes(x),attributes(y))){
    rlang::warn('Percent attributes ("dp", or "style) do not match, taking the attributes from the left-hand side.')
  }
  out_N <- field(x,"N")
  out_Percent <- field(x,"Percent")
  out_dp <- pull_dp(x)
  out_style <- pull_style(x)

  # revalidate the inputs
  # we don't call xlr_n_percent so that we get better call information
  validate_xlr_n_percent(out_N, out_Percent, out_dp, out_style)
  new_xlr_n_percent(out_N, out_Percent, out_dp, out_style)

}
# Define casting between two xlr_n_percent
#' @export
vec_cast.xlr_n_percent.xlr_n_percent <- function(x,to,..., x_arg = caller_arg(x), to_arg = "", call = caller_env()){
  if (identical(attributes(x),attributes(to))){
    return(x)
  }
  out_N <- field(x,"N")
  out_Percent <- field(x,"Percent")
  out_dp <- pull_dp(x)
  out_style <- pull_style(x)

  # revalidate the inputs
  # we don't call xlr_n_percent so that we get better call information
  validate_xlr_n_percent(out_N, out_Percent, out_dp, out_style, call)
  new_xlr_n_percent(out_N, out_Percent, out_dp, out_style, call)
}

#' @export
vec_cast.character.xlr_n_percent <- function(x,to,...){
  format.xlr_n_percent(x)
}

# ARITHMETIC--------------------------------------------------------------------
# Now we define arithmetic
# The first two functions are boiler plate
#' @method vec_arith xlr_n_percent
#' @export
vec_arith.xlr_n_percent <- function(op, x, y, ...){
  UseMethod("vec_arith.xlr_n_percent",y)
}
#' @export
#' @method vec_arith.xlr_n_percent default
vec_arith.xlr_n_percent.default <- function(op, x, y, ...){
  stop_incompatible_op(op,x,y)
}
#' @method vec_arith.xlr_n_percent xlr_n_percent
#' @export
vec_arith.xlr_n_percent.xlr_n_percent <- function(op, x, y, ...){
  if (!identical(attributes(x),attributes(y))){
    rlang::warn('Percent attributes ("dp", or "style) do not match, taking the attributes from the left-hand side.')
  }
  # we take out the two fields and then combine them together
  out_N <- vec_cast(vec_arith_base(op, field(x,"N"), field(y,"N")),
                    integer())
  out_Percent <- vec_cast(vec_arith_base(op, field(x,"Percent"), field(y,"Percent")),
                          double())
  # revalidate the inputs
  # we don't call xlr_n_percent so that we get better call information
  validate_xlr_n_percent(out_N, out_Percent, pull_dp(x), pull_style(x))
  new_xlr_n_percent(out_N, out_Percent, pull_dp(x), pull_style(x))
}

#' @export
vec_math.xlr_n_percent <- function(.fn, .x, ...){
  # we take out the two fields and then combine them together
  out_N <- vec_math_base(.fn, field(.x,"N"), ...)
  out_Percent <- vec_math_base(.fn, field(.x,"Percent"), ...)

  new_xlr_n_percent(out_N,
                    out_Percent,
                    dp = pull_dp(.x),
                    style = pull_style(.x))
}
