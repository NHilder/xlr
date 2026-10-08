#' @title Summarise a multiple response table
#' @description
#' This function can take one or two multiple response responses and generate
#' a summary table with them. You can also cut these columns by other categorical
#' columns by specify the cols parameter.
#'
#' @param x a data frame or tidy object.
#' @param cols the column(s) that we want to calculate the sum/percentage of and
#' the multiple response question.
#' @param mcols the column(s) that are multiple response questions. See
#' the `Details` for more details of how these columns should be structured.
#' @param table_title the title of the table sheet
#' @param use_questions if the data has column labels (was a imported .sav)
#' file, convert the column label to a footnote with the question.
#' @param use_NA logical. whether to include `NA` values in the table. For more complicated
#' `NA` processing post creation, we recommend using filter.
#' @param wt Specify a weighting variable, if `NULL` no weight is applied.
#' @param footnote optional parameter to pass a custom footnote to the question,
#' this parameter overwrites `use_questions`.
#' @param exclude_codes vector. Pass values to this argument if there
#' exists values in the multiple response question but indicate someone saw the
#' question but did not response to the value (e.g. `-99`, `0`).
#' @param exclude_label string. A name for the value of the `seen but answered`
#' response.
#' @inheritParams rlang::args_dots_empty
#'
#' @return a `xlr_table` object. Use [write_xlsx] to write to an `Excel` file.
#' See [xlr_table] for more information.
#'
#' @details
#' A multiple response response is a series of columns with a single unique
#' response that stores survey data where a respondent may have chosen
#' multiple options. This function works if this data is stored in a **wide**
#' format. To have a valid multiple response column all the columns should
#' start with the same text, and each contain a unique value. That is it
#' has the form:
#' ```{r}
#'  data.frame(multi_col_1 = c(1,NA,1),
#'            multi_col_2 = c(1,1,1),
#'            multi_col_3 = c(NA,NA,1)
#'  )
#' ````
#' This is how popular survey platforms such as Qualtrics output this data type. If
#' your data is long, you will need to pivot the data before hand, we recommend
#' using \link[tidyr]{pivot_wider}.
#'
#' By default this function converts \link[haven]{labelled} to a [xlr_vector]
#' by default (and underlying it is a `character()` type).
#'
#' This function and its family ([build_table], [build_qtable]) is designed to
#' work with data with columns of type `haven::labelled`,
#' which is the default format of data read with `haven::read_sav`/has the format
#' of `.sav`. `.sav` is the default file function type of data from `SPSS` and
#' can be exported from popular survey providers such as Qualtrics. When you
#' read in data with `haven::read_sav` it imports data with the questions,
#' labels for the response options etc.
#'
#' See \link[haven]{labelled} and \link[haven]{read_sav} if you would like more
#' details on the importing type.
#'
#' @example inst/examples/build_multiple_response_table.R
#'
#' @export
build_mtable <- function(
    x,
    mcols,
    cols = NULL,
    table_title = "",
    use_questions = FALSE,
    use_NA = FALSE,
    wt = NULL,
    footnote = "",
    exclude_codes = NULL,
    exclude_label = paste0(exclude_codes,collapse="_"),
    ...){

  N <- N_group <- id <- NULL

  # Input validation ----------------------------------------------------------
  # check that dots are empty
  check_dots_empty()

  # Simple validation of arguments, we validate the columns below cause they
  # depend differently
  validate_table_inputs(x,
                        table_title,
                        use_questions,
                        use_NA,
                        footnote)
  # mcols are column prefixes, not a tidyselect selection, so they must be
  # strings
  if (!is_character(mcols) || length(mcols) == 0 ||
      anyNA(mcols) || any(mcols == "")){
    cli_abort(c("i" = "In argument: {.arg mcols}.",
                "!" = "{.arg mcols} must be a character vector of column prefixes, not {.obj_type_friendly {mcols}}.",
                "i" = "For example, use {.code \"Q2\"} for the columns {.code Q2_1}, {.code Q2_2}, ..."))
  }
  # Test that there are at most two mcols specified anything more that
  # is too complicated
  if (length(mcols) > 2){
    cli_abort(c("i" = "In arguments: {.arg mcols}.",
              "x" = "You cannot specify more than two multiple response columns.",
              "i" = "For more complicated counts we recommend using {.fun tidyr::pivot_longer} and {.fun dplyr::left_join}."))
  }
  # validate that the columns are in x
  checked <- check_columns_exist(x,
                                 {{cols}},
                                 mcols,
                                 wt = {{wt}})
  x_selected <- checked$data
  wt <- checked$wt


  # Check that mcols has at most one unique non-missing value
  x_check <-
    x_selected |>
    mutate(across(starts_with(mcols),
                  ~ if_else(.x %in% !!exclude_codes,NA,.x))) |>
    select(starts_with(mcols) & where(\(x) n_distinct(x, na.rm = TRUE) > 1))

  if (ncol(x_check) > 0) {
    names_error <- names(x_check)
    if (ncol(x_check) > 1){
      cli_abort(
        c("x" = "In arguments: {.arg x} and {.arg mcols}.",
          "i" = "Data frame columns {.code {names_error}} must have at most one non-missing value.",
          "i" = "Did you forget to specify a value(s) for {.code exclude_codes}?")
      )
    }
    cli_abort(
      c("x" = "In arguments: {.arg x} and {.arg mcols}.",
        "i" = "Data frame columns {.code {names_error}} must have at most one non-missing value.")
    )
  }

  # Additional information on the questions-------------------------------------
  # lastly if empty title or footnote set it to null
  if (table_title == "") table_title <- character()
  if (footnote == "") footnote <- character()

  # pull out the questions and include them in the footnote if true
  if (use_questions & length(footnote) == 0){
    footnote <- get_question_from_label(x,!!enquo(cols))
    # now lets get the multiple response questions out
    for (start_col in mcols){
      # First lets get the labels from the columns
      q_lab <-
        x |>
        summarise(across(starts_with(start_col), ~ attr(.x,which="label", exact = TRUE)))|>
        unlist(use.names = FALSE, recursive = TRUE)

      # Skip multiple response columns without labels
      if (length(q_lab) == 0) next

      footnote <- unique(c(footnote, common_label_prefix(q_lab)))
    }
  }

  # Aggregation ---------------------------------------------------------------
  # Select all but the last .mcols for pivoting and grouping
  n_mcols <- length(mcols)
  mcols_gp <- mcols[-n_mcols]
  mcols_n <- mcols[n_mcols]

  if (length(mcols) == 1){

    # To use mcols in a mutate we need to make it a symbol
    sym_mcol <- sym(mcols)
    # There is only one so lets remove the s
    mcol <- mcols

    output <-
      x_selected |>
      # Convert haven labels by default
      mutate(across(where(haven::is.labelled),
                    labelled_to_factor)) |>
      apply_NA_rules(use_NA,
                     mcols,
                     {{cols}},
                     exclude_codes,
                     exclude_label) |>
      # Add group count
      group_by(across({{ cols }})) |>
      add_tally(name = "N_group",
                       wt = !!wt) |>
      ungroup() |>
      pivot_longer(starts_with(mcols_n),
                   names_to = NULL,
                   values_to = mcols_n,
                   # the NA indicator columns are character, so the
                   # responses are combined as character
                   values_transform = as.character) |>
      filter(!is.na(!!sym_mcol)) |>
      group_by(across({{ cols }}),!!sym_mcol,N_group) |>
      # uses the weight if it is not null, if NULL, it get's ignored
      tally(wt = !!wt, name = "N") |>
      # now filter the NA in the mcols var
      remove_NA(starts_with(mcols),
                complete = FALSE) |>
      relocate(c(N, N_group), .after = everything())

    # We add the percentage, and fix up the NA columns if we need too
    # We also make the order better
    output <-
      output |>
      # Add proportion to end
      mutate(
        Percent = xlr_percent(N / N_group),
        # add code to convert the NA string to an NA
        "{mcol}" := ifelse((!!sym_mcol) == "NA", NA, vec_cast(!!sym_mcol, character()))
      ) |>
      arrange(across({{cols}}),
              ifelse((!!sym_mcol) == !!exclude_label,1,0),
              !!sym_mcol)


    # now tidy up the table
    final_table <-
      output |>
      xlr_table(table_title,
                 footnote)

    final_table <- format_N(final_table,
                            weighted = !is.null(wt),
                            extra_cols = "N_group")
  } else{

    mcol_RHS <- mcols[1]
    mcol_LHS <- mcols[2]
    # now my sym versions so we can deffuse them when we need too
    sym_mcol_1 <- sym(mcol_RHS)
    sym_mcol_2 <- sym(mcol_LHS)
    # We can gaurentee this is equal to 2

    # First we tidy the x-selected columns to tidy them up
    x_selected <-
      x_selected |>
      mutate(across(where(haven::is.labelled),
                    labelled_to_factor)) |>
      mutate(id = row_number())

    # next we need to create quo names for the columns if required
    cols_quo <- enquo(cols)
    if (quo_is_null(cols_quo)){
      group_col_name <- paste0("N_", mcol_RHS)
      group_col_name_quo <- sym(group_col_name)
    } else{
      # First convert the column names to strings
      group_col_name <- "N_group"
      group_col_name_quo <- sym(group_col_name)
    }


    # Now we get the first multiple response column and count how many things
    # are in it, we are using the same techniques as the 1 column above
    RHS <-
      x_selected |>
      select(id, {{cols}}, !!wt, starts_with(mcol_RHS)) |>
      # add the NA column if we need to
      apply_NA_rules(use_NA,
                     mcol_RHS,
                     {{cols}},
                     exclude_codes,
                     exclude_label) |>
      pivot_longer(starts_with(mcol_RHS),
                   names_to = NULL,
                   values_to = mcol_RHS,
                   # the NA indicator columns are character, so the
                   # responses are combined as character
                   values_transform = as.character) |>
      filter(!is.na(!!sym_mcol_1))

    RHS_1 <- RHS |>
      # Add group count
      group_by(across(c({{cols}}, all_of(mcol_RHS)))) |>
      add_tally(name = group_col_name,
                wt = !!wt)

    LHS <-
      x_selected |>
      select(id, starts_with(mcol_LHS)) |>
      apply_NA_rules(use_NA,
                     mcol_LHS,
                     NULL, # cols must be null because we don't have it selected
                     exclude_codes,
                     exclude_label) |>
      pivot_longer(starts_with(mcol_LHS),
                   names_to = NULL,
                   values_to = mcol_LHS,
                   # the NA indicator columns are character, so the
                   # responses are combined as character
                   values_transform = as.character) |>
      filter(!is.na(!!sym_mcol_2))

    # now join them together
    output <-
      RHS_1 |>
      left_join(LHS,
                by = join_by(id),
                relationship = "many-to-many") |>
      filter(!is.na(!!sym_mcol_2))

    output <-
      output|>
      # Drop the ID
      select(-id) |>
      # Group by everything and then count it
      group_by(across(c({{cols}}, all_of(c(mcol_RHS, group_col_name, mcol_LHS))))) |>
      tally(wt = !!wt, name = "N") |>
      ungroup() |>
      relocate(c(N, all_of(group_col_name)), .after = everything())


    output <-
      output |>
      # Add proportion to end
      mutate(Percent = xlr_percent(N / !!group_col_name_quo),
             # add code to convert the NA string to an NA
             "{mcol_RHS}" := ifelse((!!sym_mcol_1) == "NA",NA,vec_cast(!!sym_mcol_1, character())),
             "{mcol_LHS}" := ifelse((!!sym_mcol_2) == "NA",NA,vec_cast(!!sym_mcol_2, character()))
             ) |>
      arrange(across({{cols}}),!!sym_mcol_1,!!sym_mcol_2)

    # now tidy up the table
    final_table <-
      output |>
      xlr_table(table_title,
                 footnote)

    final_table <- format_N(final_table,
                            weighted = !is.null(wt),
                            extra_cols = group_col_name)
  }
  final_table
}

#' Get the common start of a set of question labels
#'
#' The labels of multiple response columns usually start with the question,
#' followed by the response option. This returns the text up to the first
#' character where the labels differ.
#'
#' @param labels a character vector of labels.
#'
#' @return a string, the common prefix of `labels`.
#'
#' @noRd
common_label_prefix <- function(labels){
  n <- min(nchar(labels))
  for (i in seq_len(n)){
    # When the labels first differ, take the part when they were last the same
    if (length(unique(substr(labels, 1, i))) != 1) {
      return(trimws(substr(labels[1], 1, i - 1)))
    }
  }
  # One label is the start of all the others
  substr(labels[1], 1, n)
}

#' Apply NA handling rules to multiple-response data
#'
#' This internal helper function applies NA-handling rules to a multiple-response
#' dataset. It modifies the input `data.frame` by adding indicator columns or by
#' filtering rows based on missingness. Specifically, it can:
#'
#' - Add a *"seen but answered"* indicator column, if values representing this
#'   state are supplied via `exclude_codes`.
#' - Add an *NA indicator column* (named `"<mcols>_NA"`) when `use_NA = TRUE`,
#'   marking rows where all multiple-response columns are `NA`.
#' - When `use_NA = FALSE`, remove rows that contain only `NA` values across
#'   the relevant columns.
#'
#' This function is intended for internal use and not exported.
#'
#' @param x A `data.frame` containing multiple-response data.
#' @param use_NA Logical; if `TRUE`, adds an indicator column for fully missing
#'   responses. If `FALSE`, removes rows with only missing responses.
#' @param mcols Character string specifying the common prefix for the
#'   multiple-response columns.
#' @param cols Character vector of additional column names to check for
#'   non-missing values when filtering. Defaults to `NULL`.
#' @param exclude_codes Vector of values representing "seen but answered"
#'   responses. If provided, an indicator column is created to capture this
#'   state and corresponding response values are converted to `NA`.
#' @param exclude_label Character string naming the "seen but answered"
#'   indicator column. If `NULL`, it is constructed automatically by
#'   concatenating `exclude_codes` values with underscores.
#' @param call Environment used for error reporting, typically from
#'   [rlang::caller_env()].
#'
#' @return A modified `data.frame` that:
#' \itemize{
#'   \item Includes an additional `"<mcols>_<exclude_label>"` column
#'         if `exclude_codes` values are specified.
#'   \item Includes an additional `"<mcols>_NA"` column if `use_NA = TRUE`.
#'   \item Is filtered to exclude rows containing only `NA` values in relevant
#'         columns if `use_NA = FALSE`.
#' }
#'
#' The returned object preserves the same class as `x`.
#'
#' @noRd
apply_NA_rules <- function(x,
                           use_NA,
                           mcols,
                           cols = NULL,
                           exclude_codes = NULL,
                           exclude_label = NULL,
                           call = caller_env()) {
  tmp_seen_value <- NULL
  # generate name if not provided
  if (is.null(exclude_label)) {
    exclude_label <- paste0(exclude_codes, collapse = "_")
  }

  # Handle 'seen but answered' columns
  if (!is.null(exclude_codes)) {
    seen_col_name <- paste0(mcols, "_", exclude_label)

    x <- x |>
      mutate(
        tmp_seen_value = if_all(starts_with(mcols), ~ .x %in% !!exclude_codes),
        # this is done in this order to avoid overwrite the names
        across(
          starts_with(mcols),
          ~ if_else(.x %in% !!exclude_codes, NA, .x)
        ),
        # lastly write the new column value
        !!seen_col_name := if_else(tmp_seen_value, !!exclude_label, NA)
      ) |>
      select(-tmp_seen_value)
  }

  # Handle NA rules
  if (use_NA) {
    na_var <- paste0(mcols, "_NA")
    x <- x |>
      mutate(
        !!na_var := if_else(
          if_all(starts_with(mcols), ~ is.na(.x)),
          "NA",
          NA
        )
      )
    return(x)
  } else {
    x <- x |>
      # as the structure of a multiple response is usually that one (or more)
      # columns have the value, we use if_any instead of if all.
      remove_NA(starts_with(mcols),complete = FALSE) |>
      remove_NA({{cols}},complete = TRUE)
    return(x)
  }
}



