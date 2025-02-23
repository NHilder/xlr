

# Compatibility with S4 system
methods::setOldClass(c("xlr_integer","vctrs_vctr"))

#' `xlr_integer` vector
#'
#' This creates an integer vector that will be printed neatly and can easily be
#' exported to Excel using it's native format.You can
#' convert a vector back to its base type with [as_base_r()].
#'
#' Internally, `xlr_integer` uses `vec_cast` to convert numeric types
#' to integers. Anything that `vec_cast` can handle so can `xlr_integer`. Read
#' more about casting at \link[vctrs]{vec_cast}.
#'
#' @param x A numeric vector
#'  * For `xlr_integer()`: A numeric vector
#'  * For `is_xlr_integer()`: An object to test
#'  * For `as_xlr_integer()` : a vector
#' @param style Additional styling options for the vector. See [xlr_format_numeric] for more details.
#'
#' @return An S3 vector of class `xlr_integer`
#'
#' @example inst/examples/xlr_integer.R
#'
#' @seealso [xlr_vector()], [xlr_percent()], [xlr_numeric()]
#'
#' @export
xlr_integer <- function(x = integer(),
                         style = xlr_format_numeric()){

  # first we try and cast everything to the right type
  x <- vec_cast(x, integer())

  validate_xlr_integer(x,
                        style)

  new_xlr_integer(x,style)
}


validate_xlr_integer <- function(x = integer(),
                                  style = xlr_format_numeric(),
                                  call = caller_env()){

}


#' Constructor of xlr_integer
#' @inheritParams xlr_integer
#' @param call the calling environment
#' @noRd
new_xlr_integer <- function(x = integer(),
                             style = xlr_format_numeric(),
                             call = caller_env()) {
  type_abort(x,is_integer,1L,call = call)
  type_abort(style,is_xlr_format,xlr_format_numeric(),call = call)

  # finally we create our vector
  new_vctr(x,
           style = style,
           class = "xlr_integer")
}


#' @export
#' @rdname xlr_integer
is_xlr_integer <- function(x) {
  inherits(x, "xlr_integer")
}

#' @export
#' @rdname xlr_integer
as_xlr_integer <- function(x,
                            style = xlr_format_numeric()){
  UseMethod("as_xlr_integer")
}

#' @export
as_xlr_integer.default <- function(x,
                                    style = xlr_format_numeric()){
  vec_cast(x,xlr_integer(style = style))
}

#' @export
as_xlr_integer.character <- function(x,
                                      style = xlr_format_numeric()){
  # if R can work it out, cast it to a xlr_integer with default settings
  value <- as.integer(x)
  xlr_integer(value, style = style)
}


pull_style <-function(x) attr(x,which = "style")

#' @export
format.xlr_integer <- function(x, ...){
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
vec_ptype_abbr.xlr_integer <- function(x,...){
  "x_int"
}

# now define some casting--------------------------------------------

#' @export
vec_ptype2.xlr_integer.xlr_integer <- function(x,y,...){
  if (pull_style(x) != pull_style(y)){
    rlang::warn('Percent attributes ("style) do not match, taking the attributes from the left-hand side.')
  }
  # come back an implement what happens with size and face
  new_xlr_integer(style = pull_style(x))
}
#' @export
vec_cast.xlr_integer.xlr_integer <- function(x,to,...){
  new_xlr_integer(vec_data(x),
                   style = pull_style(to))
}

#' @export
vec_ptype2.xlr_integer.double <- function(x,y,...) y
#' @export
vec_ptype2.double.xlr_integer <- function(x,y,...) x

#' @export
vec_cast.xlr_integer.double <- function(x,to,...) xlr_integer(x,pull_style(to))
#' @export
vec_cast.double.xlr_integer <- function(x,to,...) vec_cast(vec_data(x),double())

#' @export
vec_ptype2.xlr_integer.integer <- function(x,y,...) x
#' @export
vec_ptype2.integer.xlr_integer <- function(x,y,...) y
#' @export
vec_cast.xlr_integer.integer <- function(x,to,...) xlr_integer(x,pull_style(to))
#' @export
vec_cast.integer.xlr_integer <- function(x,to,...) vec_data(x)


#-----------
# Now we define arithmetic
# The first two functions are boiler plate
#

#' @export
#' @method vec_arith xlr_integer
vec_arith.xlr_integer <- function(op, x, y, ...){
  UseMethod("vec_arith.xlr_integer",y)
}
#' @export
#' @method vec_arith.xlr_integer default
vec_arith.xlr_integer.default <- function(op, x, y, ...){
  stop_incompatible_op(op,x,y)
}

# next we define a list of generics for arithmetic
#' @export
#' @method vec_arith.xlr_integer xlr_integer
vec_arith.xlr_integer.xlr_integer <- function(op, x, y, ...){

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
    "%%" = new_xlr_integer(vec_cast(vec_arith_base(op,x,y),integer()),
                            style = pull_style(x)),
    stop_incompatible_op(op,x,y)
  )
}

# next we define a list of generics for arithmetic
#' @export
#' @method vec_arith.xlr_integer numeric
vec_arith.xlr_integer.numeric <- function(op, x, y, ...){
  vec_arith_base(op,x,y)
}

# next we define a list of generics for arithmetic
#' @export
#' @method vec_arith.numeric xlr_integer
vec_arith.numeric.xlr_integer <- function(op, x, y, ...){
  vec_arith_base(op,x,y)
}
