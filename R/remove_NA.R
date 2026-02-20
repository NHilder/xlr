#' Remove rows with NA values
#'
#' @description
#' Removes rows from a data frame based on NA patterns in specified columns.
#' By default, removes rows if ANY of the specified columns contain NA.
#' Can optionally remove only rows where ALL specified columns are NA.
#'
#' @param .data A data frame or tibble
#' @param cols <[`tidy-select`][dplyr::dplyr_tidy_select]> Columns to check for NA values.
#'   If no columns are specified, returns the data unchanged.
#' @param complete Logical. If `TRUE` (default), removes rows where all of the
#'   specified columns contain NA. If `FALSE`, removes only rows where at least
#'   one of the specified columns are NA.
#' @param call The execution environment of a currently running function, e.g.
#'   `caller_env()`. Used for error reporting.
#'
#' @return A data frame with rows removed based on NA patterns
#'
#' @keywords internal

remove_NA <- function(.data,
                      cols,
                      complete = TRUE,
                      call = caller_env()){

  # Check if the selection is empty, if it is return data unchanged
  selection <- eval_select(enquo(cols), .data, error_call = call)
  if (length(selection) == 0){
    return(.data)
  }

  # next grouping can cause unexpected behaviour, lets keep the groups,
  # and restore them if we need to
  # Lets first check if the data is grouped, this will hold the groups
  # if they are
  group_vars <- dplyr::group_vars(.data)
  is_grouped <- dplyr::is_grouped_df(.data)
  if (is_grouped){
    .data <- .data |>
      ungroup()
  }

  if (complete){
    # Remove rows where ANY selected column has NA
    out <-
      .data |>
      filter(if_all(any_of(names(selection)), ~ !is.na(.x)))
  } else {
    # Remove rows where ALL selected columns are NA
    out <-
      .data |>
      filter(if_any(any_of(names(selection)), ~ !is.na(.x)))
  }
  # now we restore the groups if we need to, and output
  if (is_grouped){
    out <- out |>
      grouped_df(vars = group_vars)
    return(out)
  } else{
    return(out)
  }

}
