#' Create a one, two, three,..., n-way table
#'
#' `build_table` creates a one, two, three, ..., n-way table. It should be used
#' to calculate the count and percentage of different categorical variables. It
#' gives the data back in a long format. The percentages calculated are the
#' 'row' percentages.
#'
#' @param x a data frame or tidy object.
#' @param cols <\link[tidyr]{tidyr_tidy_select}> These are the column(s) that we
#' want to calculate the count and percentage of.
#' @param table_title a string. The title of the table sheet.
#' @param use_questions a logical. If the data has column labels convert the
#' column label to a footnote with the question. See details for more information.
#' @param use_NA a logical. Whether to include `NA` values in the table. For more complicated
#' `NA` processing post creation, we recommend using filter.
#' @param wt a quoted or unquote column name. Specify a weighting variable, if
#' `NULL` no weight is applied.
#' @param footnote a character vector. Optional parameter to pass a custom
#' footnote to the question, this parameter overwrites `use_questions`.
#'
#' @return a `xlr_table` object. Use [write_xlsx] to write to an `Excel` file.
#' See [xlr_table] for more information.
#'
#' @details
#' This function and its family ([build_mtable], [build_qtable]) is designed to
#' work with data with columns of type `haven::labelled`,
#' which is the default format of data read with `haven::read_sav`/has the format
#' of `.sav`. `.sav` is the default file function type of data from `SPSS` and
#' can be exported from popular survey providers such as Qualtrics. When you
#' read in data with `haven::read_sav` it imports data with the questions,
#' labels for the response options etc.
#'
#' By default this function converts \link[haven]{labelled} to a [xlr_vector]
#' by default (and underlying it is a `character()` type).
#'
#' See \link[haven]{labelled} and \link[haven]{read_sav} if you would like more
#' details on the importing type.
#'
#' @example inst/examples/build_table.R
#'
#' @export
build_table <- function(
    x,
    cols,
    table_title = "",
    use_questions = FALSE,
    use_NA = FALSE,
    wt = NULL,
    footnote = ""){
  N <- NULL
  # Input validation ----------------------------------------------------------

  # Simple validation of arguments
  validate_table_inputs(x,
                        table_title,
                        use_questions,
                        use_NA,
                        footnote)

  # validate that the columns are in x
  x_selected <- check_columns_exist(x,
                                    c(!!enquo(cols),!!enquo(wt)))

  # Check that wt is numeric, if it exists
  wt_quo <- enquo(wt)
  if (!quo_is_null(wt_quo)){
    wt_string <- rlang::as_name(wt_quo)
    type_abort(x[[wt_string]], is.numeric, 1)

    # convert everything to a string, now wt will work both with a string
    # input and a symbol
    wt <- as.character(enexpr(wt))
    # convert that string into a symbol
    wt <- sym(wt)
  }
  # Additional information on the questions-------------------------------------
  # If empty title or footnote set it to null
  if (table_title == "") table_title <- character()
  if (footnote == "") footnote <- character()

  # pull out the questions and include them in the footnote if true
  if (use_questions & length(footnote) == 0){
    footnote <- get_question_from_label(x,!!enquo(cols))
  }
  # Aggregation ---------------------------------------------------------------
  # Standard aggregation
  final_table <-
    x_selected |>
    remove_NA_opt(use_NA) |>
    mutate(across(where(haven::is.labelled),
                  \(.f) {
                    .f <- haven::as_factor(.f)
                    attr(.f, "label") <- NULL
                    .f
                  })) |>
    group_by(across(!!enquo(cols))) |>
    # uses the weight if it is not null, if NULL, it get's ignored
    tally(wt = {{wt}}, name = "N") |>
    mutate(Percent = xlr_percent(N/sum(N))) |>
    ungroup() |>
    xlr_table(table_title,
               footnote)

  # Now we apply some formatting depending if wts are applied, if the are
  # we can gaurentee N is an integer, if not we treat it as a double to 1 dp
  if (quo_is_null(wt_quo))
    mutate(final_table, N = xlr_integer(N))
  else
    mutate(final_table, N = xlr_numeric(N, dp = 1))
}
