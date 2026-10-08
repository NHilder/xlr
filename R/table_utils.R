
#' Checks the selected columns exist in a data.frame
#'
#' Validates every column argument of the table functions in one place. The
#' columns are selected with tidyselect, renaming is not allowed (the callers
#' re-use the original selection afterwards).
#'
#' @param x a data.frame/tibble
#' @param cols <tidy-select> the columns we wish to select.
#' @param start_with_cols a character vector of column prefixes (for multiple
#' response columns), or `NULL`.
#' @param wt <tidy-select> the weight column, or `NULL`. Must select exactly
#' one numeric column.
#' @param call the caller environment.
#'
#' @details
#' Forward the column arguments from a higher function with `{{ }}`.
#'
#' @return a list with:
#'   * `data`: `x` with only the selected (and weight) columns.
#'   * `wt`: `NULL` if there is no weight, otherwise a symbol of the weight
#'     column name.
#'
#' @noRd
check_columns_exist <- function(x,
                                cols,
                                start_with_cols = NULL,
                                wt = NULL,
                                call = caller_env()){

  pos <-
    if (is.null(start_with_cols)){
      tidyselect::eval_select(enquo(cols),
                              x,
                              allow_rename = FALSE,
                              error_call = call)
    }
    else{
      # if there is no column that exists throw an error
      if (length(my_starts_with(start_with_cols,names(x))) == 0)
        cli_abort("There are no columns that exist that start with {.var {start_with_cols}}.",
                  call = call)
      tidyselect::eval_select(expr(c({{cols}},starts_with(!!start_with_cols))),
                              x,
                              allow_rename = FALSE,
                              error_call = call)
    }

  wt_pos <- tidyselect::eval_select(enquo(wt),
                                    x,
                                    allow_rename = FALSE,
                                    error_call = call)
  wt_sym <- NULL
  if (length(wt_pos) > 1){
    cli_abort(c("i" = "In argument: {.arg wt}.",
                "!" = "{.arg wt} must select a single column, not {length(wt_pos)}."),
              call = call)
  }
  if (length(wt_pos) == 1){
    wt_col <- x[[wt_pos]]
    if (!is.numeric(wt_col)){
      cli_abort(c("i" = "In argument: {.arg wt}.",
                  "!" = "{.arg wt} must be {.type {1}}, not {.type {wt_col}}."),
                call = call)
    }
    wt_sym <- sym(names(wt_pos))
  }

  list(data = x[unique(c(pos, wt_pos))],
       wt = wt_sym)
}

#' Format the count columns of a table
#'
#' Without weights the counts are guaranteed to be integers, with weights we
#' treat them as doubles to 1 dp.
#'
#' @param x a `xlr_table`
#' @param weighted logical. Whether weights were applied.
#' @param extra_cols character vector. Other count columns to format when
#' weighted.
#'
#' @noRd
format_N <- function(x, weighted, extra_cols = character()){
  N <- NULL
  if (!weighted) return(mutate(x, N = xlr_integer(N)))

  mutate(x, across(all_of(c("N", extra_cols)), \(.x) xlr_numeric(.x, dp = 1)))
}

#' Convert a haven labelled vector to a factor without the question label
#'
#' @param x a `haven_labelled` vector.
#'
#' @noRd
labelled_to_factor <- function(x){
  x <- haven::as_factor(x)
  attr(x, "label") <- NULL
  x
}

my_starts_with <- function(pattern,vars){
  lapply(pattern, \(x) grep(paste0("^",x),vars)) |>
    unlist(use.names = FALSE)
}

#' validate inputs table functions
#' @param x the data set we want to validate
#' @param table_title the table title
#' @param use_questions the use question option
#' @param use_NA the use_NA option
#' @param footnote the footnote to test
#' @param call the caller environment
#'
#' @noRd
validate_table_inputs <- function(x,
                                  table_title,
                                  use_questions,
                                  use_NA,
                                  footnote,
                                  call = caller_env()){
  type_abort(x,
             \(x) is_tibble(x) | is.data.frame(x),
             string_type = "a data frame or tibble",
             call = call)
  type_abort(table_title, is_scalar_character,
             "character",
             call = call)
  type_abort(use_questions,
             is_true_or_false,
             string_type = "TRUE or FALSE",
             call = call)
  type_abort(use_NA,
             is_true_or_false,
             string_type = "TRUE or FALSE",
             call = call)
  type_abort(footnote, is_character, "",
             call = call)

  # throw an error if the use_question is true and the footnote is not ""
  if (use_questions && is_scalar_character(footnote) && footnote != ""){
    cli_abort(c("x" = "You can't specify {.code use_question = TRUE} and have a footnote.",
                "i" = "Either set {.code use_question = FALSE} or do not have a footnote."),
              call = call)
  }
}

#' Get the question labels from a series of columns and return it as a
#' vector
#' @param x the data set we want to pull questions from
#' @param cols the columns we want the labels for
#' @param question_map functionality currently not used, it adds some extra
#' information to the question label.
#'
#' @noRd
get_question_from_label <- function(x, cols, question_map = FALSE){
  name <- value <- output_str <- NULL

  question_labels <-
    x |>
    select({{cols}}) |>
    summarise(across(everything(), ~ attr(.x,which="label", exact = TRUE)))

  # not sure about this feature, if we want the question map to be included
  # we can add it as an option, setting false to now but have the code
  if (question_map){
    question_labels <-
      question_labels |>
      pivot_longer(everything()) |>
      mutate(output_str = paste0(name,": ",value)) |>
      select(output_str) |>
      unlist(use.names = FALSE)
  }
  else{
    question_labels <-
      question_labels |>
      unlist(use.names = FALSE)
  }

  return(c("Questions", question_labels))
}

#' this function is a neat way to remove all the NA's from the dplyr chain
#' @param x the dataset we want to remove na's from.
#' @param use_NA boolean. TRUE is that we keep the NA's, FALSE we remove the NAs.
#'
#' @noRd
remove_NA_opt <- function(x, use_NA){
  # next remove the NA's if we need too
  if (!use_NA) {
    x <- filter(x, if_all(everything(),~!is.na(.x)))
    return(x)
  }
  # if we don't do anything return x
  x
}
