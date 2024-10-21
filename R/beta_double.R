
# Compatibility with S4 system
methods::setOldClass(c("beta_double","vctrs_vctr"))

#' `beta_double` vector
#'
#' This creates a double vector that represent doubles nicely, so that it is
#' both printed nicely, and can easily be outputted to excel in the correct format
#'
#'
#' @param x
#'  * For `beta_double()`: A numeric vector
#'  * For `is_beta_double()`: An object to test
#'  * For `as_beta_double()` : a vector
#' @param dp the number of decimal places to print
#' @param style Additional styling options for the vector. See [beta_format] for more details.
#'
#' @return An S3 vector of class `beta_double`
#'
#' @example inst/examples/beta_double.R
#'
#' @seealso [beta_percent()], [beta_integer()], [beta_vector()]
#'
#' @export
beta_double <- function(x = double(),
                        dp = 2L,
                        style = beta_format()){

  # first we try and cast everything to the right type
  x <- vec_cast(x, double())
  dp <- vec_recycle(vec_cast(dp,integer()), 1L)

  validate_beta_double(x,
                       dp,
                       style)

  new_beta_double(x,dp,style)
}


validate_beta_double <- function(x = double(),
                                 dp = integer(),
                                 style = beta_format(),
                                 call = caller_env()){
  if (dp < 0){
    cli_abort("'dp' must be greater than zero not equal to {dp}.",
              call = call)
  } else if (dp > 12){
    cli_abort("'dp' must be less than or equal to 12 not equal to {dp}. Risk loss of precision when exporting to Microsoft Excel.",
              call = call)
  }
}


#' Constructor of beta_double
#' @inheritParams beta_double
#' @param call the calling environment
new_beta_double <- function(x = double(),
                            dp = 0L,
                            style = beta_format(),
                            call = caller_env()) {

  type_abort(x,is_double,1.1,call = call)
  type_abort(dp,is_integer,1L,call = call)
  # check it is non empty
  vec_check_size(dp,size = 1L,call = call)
  type_abort(style,is_beta_format,beta_format(),call = call)

  # finally we create our vector
  new_vctr(x,
           dp = dp,
           style = style,
           class = "beta_double")
}


#' Check if it is a percentage
#' @export
#' @rdname beta_double
is_beta_double <- function(x) {
  inherits(x, "beta_double")
}


#' now we can define a as_beta_double function
#' @export
#' @rdname beta_double
as_beta_double <- function(x,
                           dp = 0L,
                           style = beta_format()){
  UseMethod("as_beta_double")
}

#' @export
as_beta_double.default <- function(x,
                                   dp = 0L,
                                   style = beta_format()){
  vec_cast(x,beta_double(dp = dp,
                         style = style))
}

#' @export
as_beta_double.character <- function(x,
                                     dp = 0L,
                                     style = beta_format()){
  # if R can work it out, cast it to a beta_double with default settings
  value <- as.double(x)
  beta_double(value,
              dp = dp,
              style = style)
}



pull_dp <- function(x) attr(x,which = "dp")
pull_style <-function(x) attr(x,which = "style")

#' @export
format.beta_double <- function(x, ...){
  dp <- pull_dp(x)
  out <- formatC(round(vec_data(x),dp),
                 format='f',
                 digits=dp,
                 # additionally it should have nice commas between numbers
                 big.mark = ',',
                 big.interval = 3L)
  out[is.na(x)] <- NA
  out
}

# Defines a nice shortening of the name the tibble uses

#' @export
vec_ptype_abbr.beta_double <- function(x,...){
  "b_dbl"
}

# now define some casting

#' @export
vec_ptype2.beta_double.beta_double <- function(x,y,...){
  if (pull_dp(x) != pull_dp(y) ||
      pull_style(x) != pull_style(y)){
    rlang::warn('Percent attributes ("dp", or "style) do not match, taking the attributes from the left-hand side.')
  }
  # come back an implement what happens with size and face
  new_beta_double(dp = pull_dp(x),
                  style = pull_style(x))
}
#' @export
vec_cast.beta_double.beta_double <- function(x,to,...){
  new_beta_double(vec_data(x),
                  dp = pull_dp(to),
                  style = pull_style(to))
}
#' @export
vec_ptype2.beta_double.double <- function(x,y,...) x
#' @export
vec_ptype2.double.beta_double <- function(x,y,...) y
#' @export
vec_cast.beta_double.double <- function(x,to,...) beta_double(x, pull_dp(to),pull_style(to))
#' @export
vec_cast.double.beta_double <- function(x,to,...) vec_data(x)
#' @export
vec_ptype2.beta_double.integer <- function(x,y,...) x
#' @export
vec_ptype2.integer.beta_double <- function(x,y,...) y
#' @export
vec_cast.beta_double.integer <- function(x,to,...) beta_double(x, pull_dp(to),pull_style(to))
#' @export
vec_cast.integer.beta_double <- function(x,to,...){
  vec_cast(vec_data(x),integer())
}



#-----------
# Now we define arithmetic
# The first two functions are boiler plate
#

#' @export
#' @method vec_arith beta_double
vec_arith.beta_double <- function(op, x, y, ...){
  UseMethod("vec_arith.beta_double",y)
}
#' @export
#' @method vec_arith.beta_double default
vec_arith.beta_double.default <- function(op, x, y, ...){
  stop_incompatible_op(op,x,y)
}

# next we define a list of generics for arithmetic

#' @export
#' @method vec_arith.beta_double beta_double
vec_arith.beta_double.beta_double <- function(op, x, y, ...){
  if (pull_dp(x) != pull_dp(y) ||
      pull_style(x) != pull_style(y)){
    rlang::warn('Percent attributes ("dp", or "style") do not match, taking the attributes from the left-hand side.')
  }

  new_beta_double(vec_arith_base(op,x,y),
                  dp = pull_dp(x),
                  style = pull_style(x))
}

# next we define a list of generics for arithmetic

#' @export
#' @method vec_arith.beta_double numeric
vec_arith.beta_double.numeric <- function(op, x, y, ...){

  new_beta_double(vec_arith_base(op,x,y),
                  dp = pull_dp(x),
                  style = pull_style(x))
}

# next we define a list of generics for arithmetic
#' @export
#' @method vec_arith.numeric beta_double
vec_arith.numeric.beta_double <- function(op, x, y, ...){

  new_beta_double(vec_arith_base(op,x,y),
                  dp = pull_dp(y),
                  style = pull_style(y))
}
