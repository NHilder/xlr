
# Compatibility with S4 system
methods::setOldClass(c("xlr_numeric","vctrs_vctr"))

#' `xlr_numeric` vector
#'
#' This creates an numeric vector that will be printed neatly and can easily be
#' exported to `Excel` using it's native format. You can
#' convert a vector back to its base type with [as_base_r()].
#'
#' Internally, `xlr_numeric` uses `vec_cast` to convert numeric types
#' to integers. Anything that `vec_cast` can handle so can `xlr_numeric`. Read
#' more about casting at \link[vctrs]{vec_cast}.
#'
#'
#' @param x
#'  * For `xlr_numeric()`: A numeric vector
#'  * For `is_xlr_numeric()`: An object to test
#'  * For `as_xlr_numeric()` : a vector
#' @param dp the number of decimal places to print
#' @param scientific logical. Whether to format the numeric using scientific notation.
#' @param style Additional styling options for the vector. See [xlr_format_numeric] for more details.
#'
#' @return An S3 vector of class `xlr_numeric`
#'
#' @example inst/examples/xlr_numeric.R
#'
#' @seealso [xlr_percent()], [xlr_integer()], [xlr_vector()], [as_base_r()]
#'
#' @export
xlr_numeric <- function(x = numeric(),
                        dp = 2L,
                        scientific = FALSE,
                        style = xlr_format_numeric()){

  # first we try and cast everything to the right type
  x <- vec_cast(x, numeric())
  dp <- vec_recycle(vec_cast(dp,integer()), 1L)

  validate_xlr_numeric(x,
                       dp,
                       scientific,
                       style)

  new_xlr_numeric(x,dp,scientific,style)
}


validate_xlr_numeric <- function(x = double(),
                                 dp = integer(),
                                 style = xlr_format_numeric(),
                                 call = caller_env()){
  if (dp < 0){
    cli_abort("'dp' must be greater than zero not equal to {dp}.",
              call = call)
  } else if (dp > 12){
    cli_abort("'dp' must be less than or equal to 12 not equal to {dp}. Risk loss of precision when exporting to Microsoft `Excel`.",
              call = call)
  }

}

#' Constructor of xlr_numeric
#' @inheritParams xlr_numeric
#' @param call the calling environment
#' @noRd
new_xlr_numeric <- function(x = double(),
                            dp = 0L,
                            scientific = FALSE,
                            style = xlr_format_numeric(),
                            call = caller_env()) {

  type_abort(x,is_double,1.1,call = call)
  type_abort(dp,is_integer,1L,call = call)
  # check it is non empty
  vec_check_size(dp,size = 1L,call = call)

  type_abort(scientific,is_logical,FALSE,call = call)
  type_abort(style,is_xlr_format,xlr_format_numeric(),call = call)

  # finally we create our vector
  new_vctr(x,
           dp = dp,
           scientific = scientific,
           style = style,
           class = "xlr_numeric")
}


#' Check if it is a percentage
#' @export
#' @rdname xlr_numeric
is_xlr_numeric <- function(x) {
  inherits(x, "xlr_numeric")
}


#' now we can define a as_xlr_numeric function
#' @export
#' @rdname xlr_numeric
as_xlr_numeric <- function(x,
                           dp = 0L,
                           scientific = FALSE,
                           style = xlr_format_numeric()){
  UseMethod("as_xlr_numeric")
}

#' @export
as_xlr_numeric.default <- function(x,
                                   dp = 0L,
                                   scientific = FALSE,
                                   style = xlr_format_numeric()){
  vec_cast(x,xlr_numeric(dp = dp,
                         scientific = scientific,
                         style = style))
}

#' @export
as_xlr_numeric.character <- function(x,
                                     dp = 0L,
                                     scientific = FALSE,
                                     style = xlr_format_numeric()){
  # if R can work it out, cast it to a xlr_numeric with default settings
  value <- as.double(x)
  xlr_numeric(value,
              dp = dp,
              scientific = scientific,
              style = style)
}

#' @export
as.numeric.xlr_numeric <- function(x,...){
  vec_data(x)
}

pull_attr <- function(x,attr) attr(x,which = attr)

pull_dp <- function(x) attr(x,which = "dp")
pull_style <-function(x) attr(x,which = "style")

#' @export
format.xlr_numeric <- function(x, ...){
  dp <- pull_dp(x)

  # Lets pass the right options to formatC
  if (pull_attr(x,"scientific")){
    f <- 'e'
    out_vec <- signif(vec_data(x),
                      digits = dp)
  }
  else{
    f <- 'f'
    out_vec <- round(vec_data(x),
                     digits = dp)
  }
  out <- formatC(out_vec,
                 digits=dp,
                 format=f,
                # additionally it should have nice commas between numbers
                 big.mark = ',',
                 big.interval = 3L)
  out[is.na(x)] <- NA
  out
}

# Defines a nice shortening of the name the tibble uses

#' @export
vec_ptype_abbr.xlr_numeric <- function(x,...){
  "x_dbl"
}

# now define some casting

#' @export
vec_ptype2.xlr_numeric.xlr_numeric <- function(x,y,...){
  if (pull_dp(x) != pull_dp(y) ||
      pull_style(x) != pull_style(y) ||
      pull_attr(x,"scientific") != pull_attr(y,"scientific")){
    rlang::warn('Percent attributes ("dp", or "style) do not match, taking the attributes from the left-hand side.')
  }
  # come back an implement what happens with size and face
  new_xlr_numeric(dp = pull_dp(x),
                  scientific = pull_attr(x,"scientific"),
                  style = pull_style(x))
}
#' @export
vec_cast.xlr_numeric.xlr_numeric <- function(x,to,...){
  new_xlr_numeric(vec_data(x),
                  dp = pull_dp(to),
                  scientific = pull_attr(x,"scientific"),
                  style = pull_style(to))
}
#' @export
vec_ptype2.xlr_numeric.numeric <- function(x,y,...) x
#' @export
vec_ptype2.numeric.xlr_numeric <- function(x,y,...) y
#' @export
vec_cast.xlr_numeric.numeric <- function(x,to,...) xlr_numeric(x,
                                                              pull_dp(to),
                                                              pull_attr(to,"scientific"),
                                                              pull_style(to))
#' @export
vec_ptype2.xlr_numeric.double <- function(x,y,...) x
#' @export
vec_ptype2.double.xlr_numeric <- function(x,y,...) y
#' @export
vec_cast.xlr_numeric.double <- function(x,to,...) xlr_numeric(x,
                                                               pull_dp(to),
                                                               pull_attr(to,"scientific"),
                                                               pull_style(to))
#' @export
vec_cast.double.xlr_numeric <- function(x,to,...) vec_data(x)
#' @export
vec_cast.numeric.xlr_numeric <- function(x,to,...) vec_data(x)
#' @export
vec_ptype2.xlr_numeric.integer <- function(x,y,...) x
#' @export
vec_ptype2.integer.xlr_numeric <- function(x,y,...) y
#' @export
vec_cast.xlr_numeric.integer <- function(x,to,...) xlr_numeric(x, pull_dp(to),
                                                               pull_attr(to,"scientific"),
                                                               pull_style(to))
#' @export
vec_cast.integer.xlr_numeric <- function(x,to,...){
  vec_cast(vec_data(x),integer())
}



#-----------
# Now we define arithmetic
# The first two functions are boiler plate
#

#' @export
#' @method vec_arith xlr_numeric
vec_arith.xlr_numeric <- function(op, x, y, ...){
  UseMethod("vec_arith.xlr_numeric",y)
}
#' @export
#' @method vec_arith.xlr_numeric default
vec_arith.xlr_numeric.default <- function(op, x, y, ...){
  stop_incompatible_op(op,x,y)
}

# next we define a list of generics for arithmetic
#' @export
#' @method vec_arith.xlr_numeric xlr_numeric
vec_arith.xlr_numeric.xlr_numeric <- function(op, x, y, ...){
  if (pull_dp(x) != pull_dp(y) ||
      pull_style(x) != pull_style(y) ||
      pull_attr(x,"scientific") != pull_attr(y,"scientific")){
    rlang::warn('Percent attributes ("dp", or "style") do not match, taking the attributes from the left-hand side.')
  }
  new_xlr_numeric(vec_arith_base(op,x,y),
                  dp = pull_dp(x),
                  style = pull_style(x))
}

# next we define a list of generics for arithmetic

#' @export
#' @method vec_arith.xlr_numeric numeric
vec_arith.xlr_numeric.numeric <- function(op, x, y, ...){
  new_xlr_numeric(vec_arith_base(op,x,y),
                  dp = pull_dp(x),
                  scientific = pull_attr(x,'scientific'),
                  style = pull_style(x))
}

# next we define a list of generics for arithmetic
#' @export
#' @method vec_arith.numeric xlr_numeric
vec_arith.numeric.xlr_numeric <- function(op, x, y, ...){

  new_xlr_numeric(vec_arith_base(op,x,y),
                  dp = pull_dp(y),
                  scientific = pull_attr(y,'scientific'),
                  style = pull_style(y))
}

#' @export
vec_math.xlr_numeric <- function(f, x, ...){
  vec_math_base(f, x, ...) |>
    xlr_numeric(dp = pull_dp(x),
                scientific = pull_attr(y,'scientific'),
                style = pull_style(x))
}

#' @export
median.xlr_numeric <- function(x, na.rm = FALSE, ....){
  median(vec_data(x), na.rm = na.rm) |>
    xlr_numeric(dp = pull_dp(x),
                scientific = pull_attr(y,'scientific'),
                style = pull_style(x))
}
