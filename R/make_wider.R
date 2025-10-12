#' Pivot a table wider combining counts and percentages
#'
#' This function takes a data frame produced by functions like [build_table],
#' [build_mtable], or [build_qtable], which contains columns `N` and `Percent`,
#' and pivots it into a wider format. It combines the `N` and `Percent` columns into
#' a single [xlr_n_percent] vector for each pivoted column. If `top_variable` is not
#' specified, it infers the variable to use for column names from the structure of the data frame.
#'
#' @param x A data frame or tibble containing at least the columns `N` and `Percent`.
#'   Typically the output of [build_table], [build_mtable], or [build_qtable],.
#' @param top_variable Optional. A bare column name to use for the `names_from` argument
#'   in `pivot_wider`. If `NULL` (default), the function infers the column
#'   based the default position.
#'
#' @return A [xlr_table] (if x is a [xlr_table]) or [tibble] (if [tibble] or
#' `data.frame`) in a wider format with columns containing
#' `xlr_n_percent` vectors.
#'
#' @examples
#' library(xlr)
#' # Assuming example data from build_table or similar
#' table <- clothes_opinions |>
#'             build_table(c(gender,age_group))
#' make_wider(table)
#'
#' # use top_variable to specify that we have gender as out selection column
#' make_wider(table, top_variable = age_group)
#'
#' @seealso \code{\link{xlr_n_percent}}, \code{\link[tidyr]{pivot_wider}}
#'
#' @export
make_wider <- function(x,
                       top_variable = NULL){

  var_name <- enquo(x) |> as_name()

  # fix bindings
  N <- Percent <- N_Percent <- NULL

  # first check that that x is a data.frame or
  if (isFALSE(inherits(x,"data.frame"))){
    cli_abort("{.arg {var_name}} must be a data.frame, a tibble or a xlr_table.")
  }
  # validate it has the correct columns
  if (isFALSE(all(c("N","Percent") %in% colnames(x)))){
    cli_abort(c(
      "x" = "{.arg {var_name}} must contain the columns `N` and `Percent`.",
      "i" = "Are you sure that you used {.fn make_wider} following {.fn build_table}, {.fn build_mtable} or {.fn build_qtable}?")
    )
  }

  # Create an error if there is only one grouping variable
  if (length(symdiff(c("N","Percent"),colnames(x))) <= 1){
    cli_abort(c("x" = "{.arg {var_name}} must contain more than one grouping column."))
  }

  # Re-order the columns so that if possible, N and percent are at the end
  x_order <- x |>
    relocate(N,Percent, .after = everything())

  # now lets get the column names
  x_cols <- colnames(x_order)

  # take the DP and style from percent
  dp_out <- pull_dp(x$Percent)
  style_out <- pull_style(x$Percent)

  # we first defuse the expression and if it is not NULL we use as the
  # variable we will pull the names from
  quo_top_variable <- enquo(top_variable)
  if (quo_is_null(quo_top_variable)){
    # rely on the position to capture the column
    get_col <- x_cols[length(x_cols) - 3]
  } else {
    get_col <- as_name(quo_top_variable)

    # now check that the column exists if it doesn't error
    if (isFALSE(get_col %in% x_cols)){
      cli_abort(c("x" = "{.arg {var_name}} does not contain the column {.code {get_col}}."))
    }
  }

  x_order |>
    mutate(N_Percent = xlr_n_percent(N,Percent,dp = dp_out,style_out)) |>
    select(-N,-Percent) |>
    pivot_wider(names_from = all_of(get_col), values_from = N_Percent)
}

