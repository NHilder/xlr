is_true_or_false <- function(x) {
  is_scalar_logical(x) && !is.na(x)
}


#' A type error, for internal use
#'
#' This was created so that error messages are consistent through-out the package
#' @param x the parameter to test
#' @param type_test a function. The test we want to apply to x
#' @param type an object. This is the type we want.
#' @param string_type a string for the type we want, if we can't get `cli`'s `{.type }`
#' to work out something we want.
#' @param call the calling environment
#'
#' @noRd
type_abort <- function(x,
                       type_test,
                       type = NULL,
                       string_type = NULL,
                       call = caller_env()){
  argname <- caller_arg(x)
  if (!type_test(x)){
    if (is.null(string_type)){
      cli_abort(c("i" = "In argument: {.arg {argname}}.",
                  "!"="{.arg {argname}} must be {.type {type}}, not {.type {x}}."),
                call = call)
    }
    else{
      cli_abort(c("i" = "In argument: {.arg {argname}}.",
                  "!"=paste0("{.arg {argname}} must be ", string_type,", not {.type {x}}.")),
                call = call)
    }
  }
}
