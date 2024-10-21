

#' `beta_percent` vector
#'
#' This creates a double vector that represent percentages, so that it is
#' both printed nicely, and can easily be outputted to excel in the correct format
#'
#' @param x
#'  * For `beta_percent()`: A numeric vector
#'  * For `is_beta_percent()`: An object to test
#'  * For `as_beta_percent()` : a numeric or character vector. For a character
#'  vector, the data must be in the format `"XXX.YYY...%"`.
#' @param dp the number of decimal places to print
#' @param style Additional styling options for the vector. See [beta_format] for more details.
#'
#' @return An S3 vector of class `beta_percent`
#'
#' @example inst/examples/beta_percent.R
#'
#' @seealso [beta_vector()], [beta_integer()], [beta_double()]
#'
#' @export
beta_percent <- function(x = double(),
                          dp = 0L,
                          style = beta_format()){

  # first we try and cast everything to the right type
  x <- vec_cast(x, double())
  dp <- vec_recycle(vec_cast(dp,integer()), 1L)

  validate_beta_percent(x,
                        dp,
                        style)

  new_beta_percent(x,dp,style)
}


validate_beta_percent <- function(x = double(),
                                  dp = integer(),
                                  style = beta_format(),
                                  call = caller_env()){
  # optionally check if percent is bounded by [-1,1]

  if (dp < 0){
    cli_abort("'dp' must be greater than zero not equal to {dp}.",
          call = call)
  } else if (dp > 12){
    cli_abort("'dp' must be less than or equal to 12 not equal to {dp}. Risk loss of precision when exporting to Microsoft Excel.",
          call = call)
  }
}


#' Constructor of percent
#' @inheritParams beta_double
#' @param call the calling environment
new_beta_percent <- function(x = double(),
                             dp = 0L,
                             style = beta_format(),
                             call = caller_env()) {
  type_abort(x,is_double,1.1,call = call)
  type_abort(dp,is_scalar_integer,1L,call = call)
  # check it is non empty
  vec_check_size(dp,size = 1L,call = call)
  type_abort(style,is_beta_format,beta_format(),call = call)

  # finally we create our vector
  new_vctr(x,
           dp = dp,
           style = style,
           class = "beta_percent")
}


# Compatibility with S4 system
methods::setOldClass(c("beta_percent","vctrs_vctr"))

#' @export
#' @rdname beta_percent
is_beta_percent <- function(x) {
  inherits(x, "beta_percent")
}

#' @export
#' @rdname beta_percent
as_beta_percent <- function(x,
                       dp = 0L,
                       style = beta_format()){
  UseMethod("as_beta_percent")
}

#' @export
as_beta_percent.default <- function(x,
                               dp = 0L,
                               style = beta_format()){
  vec_cast(x,beta_percent(dp = dp,
                     style = style))
}

#' @export
as_beta_percent.character <- function(x,
                                 dp = 0L,
                                 style = beta_format()){
  # this needs fixing
  value <- as.numeric(gsub(" *% *$","",x)) / 100
  beta_percent(value,
          dp = dp,
          style = style)
}

# Helpful functions to pull out the attributes in
# percent
pull_dp <- function(x) attr(x,which = "dp")
pull_style <-function(x) attr(x,which = "style")

#' @export
format.beta_percent <- function(x, ...){
  dp <- pull_dp(x)
  out <- formatC(round(vec_data(x) * 100,dp),
                 format='f',
                 digits=dp)
  out[is.na(x)] <- NA
  out[!is.na(x)] <- paste0(out[!is.na(x)],"%")
  out
}

#' @export
vec_ptype_abbr.beta_percent <- function(x,...){
  "pct"
}


# now define some casting

#' @export
vec_ptype2.beta_percent.beta_percent <- function(x,y,...){
  if (pull_dp(x) != pull_dp(y) ||
      pull_style(x) != pull_style(y)){
    rlang::warn('Percent attributes ("dp", or "style) do not match, taking the attributes from the left-hand side.')
  }
  # come back an implement what happens with size and face
  new_beta_percent(dp = pull_dp(x),
                   style = pull_style(x))
}
# Define casting between two beta_percent

#' @export
vec_cast.beta_percent.beta_percent <- function(x,to,...){
  new_beta_percent(vec_data(x),
                   dp = pull_dp(to),
                   style = pull_style(to))
}

# Define the double() & beta_percent()

#' @export
vec_ptype2.beta_percent.double <- function(x,y,...) x
#' @export
vec_ptype2.double.beta_percent <- function(x,y,...) y

#' @export
vec_cast.beta_percent.double <- function(x,to,...) beta_percent(x,pull_dp(to),pull_style(to))
#' @export
vec_cast.double.beta_percent <- function(x,to,...) vec_data(x)

# Define the integer() & beta_percent()

#' @export
vec_ptype2.beta_percent.integer <- function(x,y,...) x
#' @export
vec_ptype2.integer.beta_percent <- function(x,y,...) y
#' @export
vec_cast.beta_percent.integer <- function(x,to,...) beta_percent(x,pull_dp(to),pull_style(to))
#' @export
vec_cast.integer.beta_percent <- function(x,to,...) vec_data(x)


#-----------
# Now we define arithmetic
# The first two functions are boiler plate

#' @export
#' @method vec_arith beta_percent
vec_arith.beta_percent <- function(op, x, y, ...){
  UseMethod("vec_arith.beta_percent",y)
}
#' @export
#' @method vec_arith.beta_percent default
vec_arith.beta_percent.default <- function(op, x, y, ...){
  stop_incompatible_op(op,x,y)
}

# next we define a list of generics for arithmetic

#' @export
#' @method vec_arith.beta_percent beta_percent
vec_arith.beta_percent.beta_percent <- function(op, x, y, ...){
  if (pull_dp(x) != pull_dp(y) ||
      pull_style(x) != pull_style(y)){
    rlang::warn('Percent attributes ("dp", or "style") do not match, taking the attributes from the left-hand side.')
  }
  switch(
    op,
    "+" = ,
    "-" = ,
    "*" = new_beta_percent(vec_arith_base(op,x,y),
                           dp = pull_dp(x),
                           style = pull_style(x)),
    stop_incompatible_op(op,x,y)
  )
}

# next we define a list of generics for arithmetic

#' @export
#' @method vec_arith.beta_percent numeric
vec_arith.beta_percent.numeric <- function(op, x, y, ...){

  switch(
    op,
    "*" = vec_arith_base(op,x,y),
    "/" = new_beta_percent(vec_arith_base(op,x,y),
                           dp = pull_dp(x),
                           style = pull_style(x)),
    stop_incompatible_op(op,x,y)
  )
}

# next we define a list of generics for arithmetic

#' @export
#' @method vec_arith.numeric beta_percent
vec_arith.numeric.beta_percent <- function(op, x, y, ...){

  switch(
    op,
    "*" = vec_arith_base(op,x,y),
    stop_incompatible_op(op,x,y)
  )
}
