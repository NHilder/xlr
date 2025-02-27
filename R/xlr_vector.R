#' `xlr_vector` vector
#'
#' A general container for including additional styling options within a vector
#' so that it can easily be exported to `Excel`. This vector type should be used
#' for characters, factors, Booleans, complex numbers, etc. It does
#' not support dates.
#'
#' While you can use it with `integer`, and `double` types and specifying the
#' associated `Excel` format, we recommend using [xlr_integer], [xlr_numeric],
#' or [xlr_percent] types instead.
#'
#' You can convert a vector back to its base type with [as_base_r()].
#'
#' @param x A vector
#'  * For `xlr_vector()`: A vector
#'  * For `is_xlr_vector()`: An object to test
#'  * For `as_xlr_vector()` : a vector
#' @param excel_format a character, the `Excel` cell format, not validated. See
#' \link[openxlsx]{createStyle} argument numFmt for more details on what
#' you can specify.
#' @param style Additional styling options for the vector. See [xlr_format] for
#' more details.
#'
#' @return An S3 vector of class `xlr_vector`
#'
#' @seealso [xlr_percent()], [xlr_integer()], [xlr_numeric()], [as_base_r()]
#'
#' @example inst/examples/xlr_vector.R
#'
#' @export
xlr_vector <- function(x = vector(),
                        excel_format = "GENERAL",
                        style = xlr_format()){

  # if it is not NULL then check it is a vector
  # a NULL vector is an empty vector and should have length 0
  if (!is.null(x) && !is_vector(x)){
    cli_abort('{x} is not a vector!')
  }
  validate_xlr_vector(x = x,
                       excel_format = excel_format,
                       style = style)

  new_xlr_vector(x = x,
                  excel_format = excel_format,
                  style = style)
}

validate_xlr_vector <- function(
    x = vector(),
    excel_format = "",
    style = xlr_format(),
    call = caller_env()){

}

#' Constructor of xlr_vector
#' @inheritParams xlr_vector
#' @param call the calling environment
#' @noRd
new_xlr_vector <- function(x = vector(),
                            excel_format = "GENERAL",
                            style = xlr_format(),
                            call = caller_env()) {

  type_abort(x,is_vector,string_type = "vector",call = call)
  type_abort(excel_format,is_scalar_character,"character",call = call)
  type_abort(style,is_xlr_format,xlr_format(),call = call)

  # finally we create our vector
  new_vctr(x,
           excel_format = excel_format,
           style = style,
           class = "xlr_vector")
}

#' @export
#' @rdname xlr_vector
is_xlr_vector <- function(x) {
  inherits(x, "xlr_vector")
}

#' @export
#' @rdname xlr_vector
as_xlr_vector <- function(x,
                           excel_format = "GENERAL",
                           style = xlr_format()){
  UseMethod("as_xlr_vector")
}

#' @export
as_xlr_vector.default <- function(x,
                                   excel_format = "GENERAL",
                                   style = xlr_format()){
  xlr_vector(x,
            excel_format = excel_format,
            style = style)
}
#' @importFrom pillar pillar_shaft
#' @export
pillar_shaft.xlr_vector <- function(x, ...) {
  # lets first pull out the vector style data
  style <- pull_style(x)
  data <- vec_data(x)
  out <- format(data,
                justify = attr(style,which = "halign"))
  pillar::new_pillar_shaft_simple(out,
                                  align = attr(style,which = "halign"),
                                  min_width = 10,
                                  width = 50,
                                  shorten = "back"
                                  )
}

#' @export
format.xlr_vector <- function(x,...){
  format(vec_data(x))
}

# Defines a nice shortening of the name the tibble uses
#' @export
vec_ptype_abbr.xlr_vector <- function(x,...){
  "x_vctr"
}

# Define generics needed by vctrs to have a well maintained class
#' @export
vec_ptype2.xlr_vector.xlr_vector <- function(x,y,...){
  if (pull_style(x) != pull_style(y)){
    cli_warn('Attribute {.var style} does not match, taking the attributes from the left-hand side.')
  }
  if (attr(x,which = "excel_format") != attr(y,which = "excel_format")){
    cli_warn('Attribute {.var excel_format} does not match, taking the attributes from the left-hand side.')
  }
  new_xlr_vector(x,
                 excel_format = attr(x,which = "excel_format"),
                 style = pull_style(x))
}
#' @export
vec_cast.xlr_vector.xlr_vector <- function(x,to,...){
  new_xlr_vector(vec_data(x),
                  style = pull_style(to))
}

# Define generics needed by vctrs to have a well maintained class
# Define for character
#' @export
vec_ptype2.character.xlr_vector <- function(x,y,...) x
#' @export
vec_ptype2.xlr_vector.character <- function(x,y,...) y
#' @export
vec_cast.character.xlr_vector <- function(x,to,...){
  vec_data(x) |>
    as.character()
}
#' @export
vec_ptype2.numeric.xlr_vector <- function(x,y,...) x
#' @export
vec_ptype2.xlr_vector.numeric <- function(x,y,...){
  if(!is.numeric(vec_data(x))){
    cli_abort("Can't combime `x` <xlr_vector> and `y` {.type y}, `x` must contain numeric data!")
  }
  y
}
#' @export
vec_cast.numeric.xlr_vector <- function(x,to,...){
  if(!is.numeric(vec_data(x))){
    cli_abort(c("!" = "Can't convert `x` <xlr_vector> to {.type {to}}, `x` must contain numeric data!",
                "i" = "You may want to convert your <xlr_vector> to a native R type with `as_base_r()`."))
  }
  vec_cast(vec_data(x), to)
}

#' @export
vec_ptype2.double.xlr_vector <- function(x,y,...) x
#' @export
vec_ptype2.xlr_vector.double <- function(x,y,...){
  if(!is.numeric(vec_data(x))){
    cli_abort("Can't combime `x` <xlr_vector> and `y` {.type y}, `x` must contain numeric data!")
  }
  y
}
#' @export
vec_cast.double.xlr_vector <- function(x,to,...){
  if(!is.numeric(vec_data(x))){
    cli_abort(c("!" = "Can't convert `x` <xlr_vector> to {.type {to}}, `x` must contain numeric data!",
                "i" = "You may want to convert your <xlr_vector> to a native R type with `as_base_r()`."))
  }
  vec_cast(vec_data(x), to)
}
#' @export
vec_ptype2.integer.xlr_vector <- function(x,y,...) x
#' @export
vec_ptype2.xlr_vector.integer <- function(x,y,...){
  if(!is.numeric(vec_data(x))){
    cli_abort("Can't combime `x` <xlr_vector> and `y` {.type y}, `x` must contain numeric data!")
  }
  y
}
#' @export
vec_cast.integer.xlr_vector <- function(x,to,...){
  if(!is.numeric(vec_data(x))){
    cli_abort(c("!" = "Can't convert `x` <xlr_vector> to {.type {to}}, `x` must contain numeric data!",
                "i" = "You may want to convert your <xlr_vector> to a native R type with `as_base_r()`."))
  }
  vec_cast(vec_data(x), to)
}
#' @export
vec_ptype2.complex.xlr_vector <- function(x,y,...) x
#' @export
vec_ptype2.xlr_vector.complex <- function(x,y,...){
  if(!is.numeric(vec_data(x)) & !is.complex(vec_data(x))){
    cli_abort("Can't combime <xlr_vector> which has {.type {vec_data(x)}} type, <xlr_vector> must contain numeric data!")
  }
  y
}
#' @export
vec_cast.complex.xlr_vector <- function(x,to,...){
  if(!is.numeric(vec_data(x)) & !is.complex(vec_data(x))){
    cli_abort(c("!" = "Can't convert `x` <xlr_vector> to {.type {to}}, `x` must contain complex data!",
                "i" = "You may want to convert your <xlr_vector> to a native R type with `as_base_r()`."))
  }
  vec_cast(vec_data(x), to)
}
