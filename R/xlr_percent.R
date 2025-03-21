

#' `xlr_percent` vector
#'
#' This creates a numeric vector that will be printed as a percentage and
#' exported to `Excel` using it's native format.You can convert a vector back to
#' its base type with [as_base_r()].
#'
#' @param x
#'  * For `xlr_percent()`: A numeric vector
#'  * For `is_xlr_percent()`: An object to test
#'  * For `as_xlr_percent()` : a numeric or character vector. For a character
#'  vector, the data must be in the format `"XXX.YYY...%"`.
#' @param dp the number of decimal places to print
#' @param style Additional styling options for the vector. See [xlr_format_numeric] for more details.
#'
#' @return An S3 vector of class `xlr_percent`
#'
#' @example inst/examples/xlr_percent.R
#'
#' @seealso [xlr_vector()], [xlr_integer()], [xlr_numeric()], [as_base_r()]
#'
#' @export
xlr_percent <- function(x = double(),
                          dp = 0L,
                          style = xlr_format_numeric()){

  # first we try and cast everything to the right type
  x <- vec_cast(x, double())
  dp <- vec_recycle(vec_cast(dp,integer()), 1L)

  validate_xlr_percent(x,
                        dp,
                        style)

  new_xlr_percent(x,dp,style)
}


validate_xlr_percent <- function(x = double(),
                                  dp = integer(),
                                  style = xlr_format_numeric(),
                                  call = caller_env()){
  # optionally check if percent is bounded by [-1,1]

  if (dp < 0){
    cli_abort("'dp' must be greater than zero not equal to {dp}.",
          call = call)
  } else if (dp > 12){
    cli_abort("'dp' must be less than or equal to 12 not equal to {dp}. Risk loss of precision when exporting to Microsoft `Excel`.",
          call = call)
  }
}


#' Constructor of percent
#' @inheritParams xlr_numeric
#' @param call the calling environment
#' @noRd
new_xlr_percent <- function(x = double(),
                             dp = 0L,
                             style = xlr_format_numeric(),
                             call = caller_env()) {
  type_abort(x,is_double,1.1,call = call)
  type_abort(dp,is_scalar_integer,1L,call = call)
  # check it is non empty
  vec_check_size(dp,size = 1L,call = call)
  type_abort(style,is_xlr_format,xlr_format_numeric(),call = call)

  # finally we create our vector
  new_vctr(x,
           dp = dp,
           style = style,
           class = "xlr_percent")
}


# Compatibility with S4 system
methods::setOldClass(c("xlr_percent","vctrs_vctr"))

#' @export
#' @rdname xlr_percent
is_xlr_percent <- function(x) {
  inherits(x, "xlr_percent")
}

#' @export
#' @rdname xlr_percent
as_xlr_percent <- function(x,
                       dp = 0L,
                       style = xlr_format_numeric()){
  UseMethod("as_xlr_percent")
}

#' @export
as_xlr_percent.default <- function(x,
                               dp = 0L,
                               style = xlr_format_numeric()){
  vec_cast(x,xlr_percent(dp = dp,
                     style = style))
}

#' @export
as_xlr_percent.character <- function(x,
                                 dp = 0L,
                                 style = xlr_format_numeric()){
  # this needs fixing
  value <- as.numeric(gsub(" *% *$","",x)) / 100
  xlr_percent(value,
          dp = dp,
          style = style)
}

# Helpful functions to pull out the attributes in
# percent
pull_dp <- function(x) attr(x,which = "dp")
pull_style <-function(x) attr(x,which = "style")

#' @export
format.xlr_percent <- function(x, ...){
  dp <- pull_dp(x)
  out <- formatC(round(vec_data(x) * 100,dp),
                 format='f',
                 digits=dp)
  out[is.na(x)] <- NA
  out[!is.na(x)] <- paste0(out[!is.na(x)],"%")
  out
}

#' @export
vec_ptype_abbr.xlr_percent <- function(x,...){
  "x_pct"
}


# now define some casting

#' @export
vec_ptype2.xlr_percent.xlr_percent <- function(x,y,...){
  if (pull_dp(x) != pull_dp(y) ||
      pull_style(x) != pull_style(y)){
    rlang::warn('Percent attributes ("dp", or "style) do not match, taking the attributes from the left-hand side.')
  }
  # come back an implement what happens with size and face
  new_xlr_percent(dp = pull_dp(x),
                   style = pull_style(x))
}
# Define casting between two xlr_percent

#' @export
vec_cast.xlr_percent.xlr_percent <- function(x,to,...){
  new_xlr_percent(vec_data(x),
                   dp = pull_dp(to),
                   style = pull_style(to))
}

# Define the double() & xlr_percent()

#' @export
vec_ptype2.xlr_percent.double <- function(x,y,...) x
#' @export
vec_ptype2.double.xlr_percent <- function(x,y,...) y

#' @export
vec_cast.xlr_percent.double <- function(x,to,...) xlr_percent(x,pull_dp(to),pull_style(to))
#' @export
vec_cast.double.xlr_percent <- function(x,to,...) vec_data(x)

# Define the integer() & xlr_percent()

#' @export
vec_ptype2.xlr_percent.integer <- function(x,y,...) x
#' @export
vec_ptype2.integer.xlr_percent <- function(x,y,...) y
#' @export
vec_cast.xlr_percent.integer <- function(x,to,...) xlr_percent(x,pull_dp(to),pull_style(to))
#' @export
vec_cast.integer.xlr_percent <- function(x,to,...) vec_data(x)


#-----------
# Now we define arithmetic
# The first two functions are boiler plate

#' @export
#' @method vec_arith xlr_percent
vec_arith.xlr_percent <- function(op, x, y, ...){
  UseMethod("vec_arith.xlr_percent",y)
}
#' @export
#' @method vec_arith.xlr_percent default
vec_arith.xlr_percent.default <- function(op, x, y, ...){
  stop_incompatible_op(op,x,y)
}

# next we define a list of generics for arithmetic

#' @export
#' @method vec_arith.xlr_percent xlr_percent
vec_arith.xlr_percent.xlr_percent <- function(op, x, y, ...){
  if (pull_dp(x) != pull_dp(y) ||
      pull_style(x) != pull_style(y)){
    rlang::warn('Percent attributes ("dp", or "style") do not match, taking the attributes from the left-hand side.')
  }
  switch(
    op,
    "+" = ,
    "-" = ,
    "*" = new_xlr_percent(vec_arith_base(op,x,y),
                           dp = pull_dp(x),
                           style = pull_style(x)),
    stop_incompatible_op(op,x,y)
  )
}

# next we define a list of generics for arithmetic

#' @export
#' @method vec_arith.xlr_percent numeric
vec_arith.xlr_percent.numeric <- function(op, x, y, ...){

  switch(
    op,
    "*" = vec_arith_base(op,x,y),
    "/" = new_xlr_percent(vec_arith_base(op,x,y),
                           dp = pull_dp(x),
                           style = pull_style(x)),
    stop_incompatible_op(op,x,y)
  )
}

# next we define a list of generics for arithmetic

#' @export
#' @method vec_arith.numeric xlr_percent
vec_arith.numeric.xlr_percent <- function(op, x, y, ...){

  switch(
    op,
    "*" = vec_arith_base(op,x,y),
    stop_incompatible_op(op,x,y)
  )
}
