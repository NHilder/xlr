

# Compatibility with S4 system
methods::setOldClass(c("beta_integer","vctrs_vctr"))

#' `beta_integer` vector
#'
#' This creates a double vector that represent doubles nicely, so that it is
#' both printed nicely, and can easily be outputted to excel in the correct format
#'
#' Internally, `beta_integer` uses `vec_cast` to convert numeric types
#' to integers. Anything that `vec_cast` can handle so can `beta_integer`. Read
#' more about casting at \link[vctrs]{vec_cast}.
#'
#' @param x A numeric vector
#'  * For `beta_integer()`: A numeric vector
#'  * For `is_beta_integer()`: An object to test
#'  * For `as_beta_integer()` : a vector
#' @param style Additional styling options for the vector. See [beta_format] for more details.
#'
#' @return An S3 vector of class `beta_integer`
#'
#' @example inst/examples/beta_integer.R
#'
#' @seealso [beta_vector()], [beta_percent()], [beta_double()]
#'
#' @export
beta_integer <- function(x = integer(),
                         style = beta_format()){

  # first we try and cast everything to the right type
  x <- vec_cast(x, integer())

  validate_beta_integer(x,
                        style)

  new_beta_integer(x,style)
}


validate_beta_integer <- function(x = integer(),
                                  style = beta_format(),
                                  call = caller_env()){

}


#' Constructor of beta_integer
#' @inheritParams beta_integer
#' @param call the calling environment
new_beta_integer <- function(x = integer(),
                             style = beta_format(),
                             call = caller_env()) {
  type_abort(x,is_integer,1L,call = call)
  type_abort(style,is_beta_format,beta_format(),call = call)

  # finally we create our vector
  new_vctr(x,
           style = style,
           class = "beta_integer")
}


#' @export
#' @rdname beta_integer
is_beta_integer <- function(x) {
  inherits(x, "beta_integer")
}

#' @export
#' @rdname beta_integer
as_beta_integer <- function(x,
                            style = beta_format()){
  UseMethod("as_beta_integer")
}

#' @export
as_beta_integer.default <- function(x,
                                    style = beta_format()){
  vec_cast(x,beta_integer(style = style))
}

#' @export
as_beta_integer.character <- function(x,
                                      style = beta_format()){
  # if R can work it out, cast it to a beta_integer with default settings
  value <- as.integer(x)
  beta_integer(value, style = style)
}


pull_style <-function(x) attr(x,which = "style")

#' @export
format.beta_integer <- function(x, ...){
  out <- formatC(vec_data(x),
                 format='f',
                 digits=0,
                 # additionally it should have nice commas between numbers
                 big.mark = ',',
                 big.interval = 3L)
  out[is.na(x)] <- NA
  out
}

# Defines a nice shortening of the name the tibble uses

#' @export
vec_ptype_abbr.beta_integer <- function(x,...){
  "b_int"
}

# now define some casting--------------------------------------------

#' @export
vec_ptype2.beta_integer.beta_integer <- function(x,y,...){
  if (pull_style(x) != pull_style(y)){
    rlang::warn('Percent attributes ("style) do not match, taking the attributes from the left-hand side.')
  }
  # come back an implement what happens with size and face
  new_beta_integer(style = pull_style(x))
}
#' @export
vec_cast.beta_integer.beta_integer <- function(x,to,...){
  new_beta_integer(vec_data(x),
                   style = pull_style(to))
}

#' @export
vec_ptype2.beta_integer.double <- function(x,y,...) y
#' @export
vec_ptype2.double.beta_integer <- function(x,y,...) x

#' @export
vec_cast.beta_integer.double <- function(x,to,...) beta_integer(x,pull_style(to))
#' @export
vec_cast.double.beta_integer <- function(x,to,...) vec_cast(vec_data(x),double())

#' @export
vec_ptype2.beta_integer.integer <- function(x,y,...) x
#' @export
vec_ptype2.integer.beta_integer <- function(x,y,...) y
#' @export
vec_cast.beta_integer.integer <- function(x,to,...) beta_integer(x,pull_style(to))
#' @export
vec_cast.integer.beta_integer <- function(x,to,...) vec_data(x)


#-----------
# Now we define arithmetic
# The first two functions are boiler plate
#

#' @export
#' @method vec_arith beta_integer
vec_arith.beta_integer <- function(op, x, y, ...){
  UseMethod("vec_arith.beta_integer",y)
}
#' @export
#' @method vec_arith.beta_integer default
vec_arith.beta_integer.default <- function(op, x, y, ...){
  stop_incompatible_op(op,x,y)
}

# next we define a list of generics for arithmetic
#' @export
#' @method vec_arith.beta_integer beta_integer
vec_arith.beta_integer.beta_integer <- function(op, x, y, ...){

  if (pull_style(x) != pull_style(y)){
    rlang::warn('Percent attributes ("style") do not match, taking the attributes from the left-hand side.')
  }
  switch(
    op,
    "+" = ,
    "-" = ,
    "*" = ,
    "^" = ,
    "%/%" = ,
    "%%" = new_beta_integer(vec_cast(vec_arith_base(op,x,y),integer()),
                            style = pull_style(x)),
    stop_incompatible_op(op,x,y)
  )
}

# next we define a list of generics for arithmetic
#' @export
#' @method vec_arith.beta_integer numeric
vec_arith.beta_integer.numeric <- function(op, x, y, ...){
  vec_arith_base(op,x,y)
}

# next we define a list of generics for arithmetic
#' @export
#' @method vec_arith.numeric beta_integer
vec_arith.numeric.beta_integer <- function(op, x, y, ...){
  vec_arith_base(op,x,y)
}
