
# Compatibility with S4 system
methods::setOldClass(c("xlr_double","vctrs_vctr"))

#' `xlr_double` vector
#'
#' This creates a double vector that represent doubles nicely, so that it is
#' both printed nicely, and can easily be outputted to excel in the correct format
#'
#'
#' @param x
#'  * For `xlr_double()`: A numeric vector
#'  * For `is_xlr_double()`: An object to test
#'  * For `as_xlr_double()` : a vector
#' @param dp the number of decimal places to print
#' @param style Additional styling options for the vector. See [xlr_format] for more details.
#'
#' @return An S3 vector of class `xlr_double`
#'
#' @example inst/examples/xlr_double.R
#'
#' @seealso [xlr_percent()], [xlr_integer()], [xlr_vector()]
#'
#' @export
xlr_double <- function(x = double(),
                        dp = 2L,
                        style = xlr_format()){

  # first we try and cast everything to the right type
  x <- vec_cast(x, double())
  dp <- vec_recycle(vec_cast(dp,integer()), 1L)

  validate_xlr_double(x,
                       dp,
                       style)

  new_xlr_double(x,dp,style)
}


validate_xlr_double <- function(x = double(),
                                 dp = integer(),
                                 style = xlr_format(),
                                 call = caller_env()){
  if (dp < 0){
    cli_abort("'dp' must be greater than zero not equal to {dp}.",
              call = call)
  } else if (dp > 12){
    cli_abort("'dp' must be less than or equal to 12 not equal to {dp}. Risk loss of precision when exporting to Microsoft Excel.",
              call = call)
  }
}


#' Constructor of xlr_double
#' @inheritParams xlr_double
#' @param call the calling environment
new_xlr_double <- function(x = double(),
                            dp = 0L,
                            style = xlr_format(),
                            call = caller_env()) {

  type_abort(x,is_double,1.1,call = call)
  type_abort(dp,is_integer,1L,call = call)
  # check it is non empty
  vec_check_size(dp,size = 1L,call = call)
  type_abort(style,is_xlr_format,xlr_format(),call = call)

  # finally we create our vector
  new_vctr(x,
           dp = dp,
           style = style,
           class = "xlr_double")
}


#' Check if it is a percentage
#' @export
#' @rdname xlr_double
is_xlr_double <- function(x) {
  inherits(x, "xlr_double")
}


#' now we can define a as_xlr_double function
#' @export
#' @rdname xlr_double
as_xlr_double <- function(x,
                           dp = 0L,
                           style = xlr_format()){
  UseMethod("as_xlr_double")
}

#' @export
as_xlr_double.default <- function(x,
                                   dp = 0L,
                                   style = xlr_format()){
  vec_cast(x,xlr_double(dp = dp,
                         style = style))
}

#' @export
as_xlr_double.character <- function(x,
                                     dp = 0L,
                                     style = xlr_format()){
  # if R can work it out, cast it to a xlr_double with default settings
  value <- as.double(x)
  xlr_double(value,
              dp = dp,
              style = style)
}



pull_dp <- function(x) attr(x,which = "dp")
pull_style <-function(x) attr(x,which = "style")

#' @export
format.xlr_double <- function(x, ...){
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
vec_ptype_abbr.xlr_double <- function(x,...){
  "b_dbl"
}

# now define some casting

#' @export
vec_ptype2.xlr_double.xlr_double <- function(x,y,...){
  if (pull_dp(x) != pull_dp(y) ||
      pull_style(x) != pull_style(y)){
    rlang::warn('Percent attributes ("dp", or "style) do not match, taking the attributes from the left-hand side.')
  }
  # come back an implement what happens with size and face
  new_xlr_double(dp = pull_dp(x),
                  style = pull_style(x))
}
#' @export
vec_cast.xlr_double.xlr_double <- function(x,to,...){
  new_xlr_double(vec_data(x),
                  dp = pull_dp(to),
                  style = pull_style(to))
}
#' @export
vec_ptype2.xlr_double.double <- function(x,y,...) x
#' @export
vec_ptype2.double.xlr_double <- function(x,y,...) y
#' @export
vec_cast.xlr_double.double <- function(x,to,...) xlr_double(x, pull_dp(to),pull_style(to))
#' @export
vec_cast.double.xlr_double <- function(x,to,...) vec_data(x)
#' @export
vec_ptype2.xlr_double.integer <- function(x,y,...) x
#' @export
vec_ptype2.integer.xlr_double <- function(x,y,...) y
#' @export
vec_cast.xlr_double.integer <- function(x,to,...) xlr_double(x, pull_dp(to),pull_style(to))
#' @export
vec_cast.integer.xlr_double <- function(x,to,...){
  vec_cast(vec_data(x),integer())
}



#-----------
# Now we define arithmetic
# The first two functions are boiler plate
#

#' @export
#' @method vec_arith xlr_double
vec_arith.xlr_double <- function(op, x, y, ...){
  UseMethod("vec_arith.xlr_double",y)
}
#' @export
#' @method vec_arith.xlr_double default
vec_arith.xlr_double.default <- function(op, x, y, ...){
  stop_incompatible_op(op,x,y)
}

# next we define a list of generics for arithmetic

#' @export
#' @method vec_arith.xlr_double xlr_double
vec_arith.xlr_double.xlr_double <- function(op, x, y, ...){
  if (pull_dp(x) != pull_dp(y) ||
      pull_style(x) != pull_style(y)){
    rlang::warn('Percent attributes ("dp", or "style") do not match, taking the attributes from the left-hand side.')
  }

  new_xlr_double(vec_arith_base(op,x,y),
                  dp = pull_dp(x),
                  style = pull_style(x))
}

# next we define a list of generics for arithmetic

#' @export
#' @method vec_arith.xlr_double numeric
vec_arith.xlr_double.numeric <- function(op, x, y, ...){

  new_xlr_double(vec_arith_base(op,x,y),
                  dp = pull_dp(x),
                  style = pull_style(x))
}

# next we define a list of generics for arithmetic
#' @export
#' @method vec_arith.numeric xlr_double
vec_arith.numeric.xlr_double <- function(op, x, y, ...){

  new_xlr_double(vec_arith_base(op,x,y),
                  dp = pull_dp(y),
                  style = pull_style(y))
}
