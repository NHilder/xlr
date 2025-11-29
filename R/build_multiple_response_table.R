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
#' @inheritParams rlang::args_dots_empty
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
    seen_but_answered = NULL,
    name_seen_but_answered = paste0(seen_but_answered,collapse="_"),
    ...){

  N <- N_group <- id <- NULL
  # Input validation ----------------------------------------------------------
  # Simple validation of arguments, we validate the columns below cause they
  # depend differently
  validate_table_inputs(x,
                        table_title,
                        use_questions,
                        use_NA,
                        footnote)
  # validate that the columns are in x
  x_selected <- check_columns_exist(x,
                                    c(!!enquo(cols),!!enquo(wt)),
                                    mcols)

  # check that dots are empty
  check_dots_empty()

# # Check that mcols has at most one unique non-missing value
#   x_check <- x_selected |>
#     select(starts_with(mcols) & where(\(x) n_distinct(x, na.rm = TRUE) > 1))
#
#   if (ncol(x_check) > 0) {
#     names_error <- names(x_check)
#
#     cli_abort(
#       c("i" = "In arguments: {.arg x} and {.arg mcols}.",
#         "Data frame columns {.code {names_error}} must have at most one non-missing value.")
#     )
#   }

  # Check that wt is numeric, if it exists
  wt_quo <- enquo(wt)
  if (!quo_is_null(wt_quo)){
    # Check that weight is numeric
    wt_string <- rlang::as_name(wt_quo)

    wt_col <- x_selected[[wt_string]]

    if (!is.numeric(wt_col)){
      cli_abort(c("i" = "In argument: {.arg wt}.",
                "!"="{.arg wt} must be {.type {1}}, not {.type {wt_col}}."))
    }

    # convert everything to a string, now wt will work both with a string
    # input and a symbol
    wt <- as.character(enexpr(wt))
    # convert that string into a symbol
    wt <- sym(wt)
  }

  # Next test that there are at most two mcols specified anything more that
  # is too complicated
  if (length(mcols) > 2){
    cli_abort(c("i" = "In arguments: {.arg mcols}.",
              "x" = "You cannot specify more than two multiple response columns.",
              "i" = "For more complicated counts we recommend using {.fun tidyr::pivot_longer} and {.fun dplyr::left_join}."))
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

      # Check that there are labels, if not quit
      if (length(q_lab) == 0) break

      # Find the first time that the labels are different, return the previous
      # iteration, this will likely be the question label, can be edited by
      # the user
      for (i in 1:min(nchar(q_lab))){
        q_lab_final <- substr(q_lab,1,i)
        # If the strings are not identical, then stop, go back one
        # (when it was last identical) and take that string
        if (length(unique(q_lab_final)) != 1) {
          q_lab_final <- substr(q_lab,1,i-1) |>
            unique() |>
            # next strip out the whitespace
            trimws()
          break
        }
      }
      # add it if we exit
      footnote <- unique(c(footnote,q_lab_final))
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
                    \(.f) {
                      .f <- haven::as_factor(.f)
                      attr(.f, "label") <- NULL
                      .f
                    })) |>
      apply_NA_rules(use_NA,
                     {{mcols}},
                     {{cols}},
                     seen_but_answered,
                     name_seen_but_answered) |>
      # Add group count
      group_by(across({{ cols }})) |>
      add_tally(name = "N_group",
                       wt = {{wt}}) |>
      ungroup() |>
      pivot_longer(starts_with(mcols_n),
                   names_to = NULL,
                   values_to = mcols_n) |>
      filter(!is.na({{sym_mcol}})) |>
      group_by(across({{ cols }}),{{sym_mcol}},N_group) |>
      # uses the weight if it is not null, if NULL, it get's ignored
      tally(wt = {{wt}}, name = "N") |>
      # now filter the NA in the mcols var
      filter(if_any(starts_with(mcols), ~ !is.na(.x))) |>
      relocate(c(N, N_group), .after = everything())

    # We add the percentage, and fix up the NA columns if we need too
    # We also make the order better
    output <-
      output |>
      # Add proportion to end
      mutate(
        Percent = xlr_percent(N / N_group),
        # add code to convert the NA string to an NA
        "{sym_mcol}" := ifelse({{ sym_mcol }} == "NA", NA, vec_cast({{ sym_mcol }}, character()))
      ) |>
      arrange(across({{cols}}),
              ifelse({{sym_mcol}} == name_seen_but_answered,1,0),
              {{sym_mcol}})


    # now tidy up the table
    final_table <-
      output |>
      xlr_table(table_title,
                 footnote)

    # Now we apply some formatting depending if wts are applied, if the are
    # we can gaurentee N is an integer, if not we treat it as a double to 1 dp
    final_table <-
      if (quo_is_null(wt_quo))
        mutate(final_table, N = xlr_integer(N))
    else
      mutate(final_table,
             N = xlr_numeric(N, dp = 1),
             N_group = xlr_numeric(N_group, dp = 1))
  } else{

    mcol_1 <- mcols[1]
    mcol_2 <- mcols[2]
    # now my sym versions so we can deffuse them when we need too
    sym_mcol_1 <- sym(mcol_1)
    sym_mcol_2 <- sym(mcol_2)
    # We can gaurentee this is equal to 2

    # First we tidy the x-selected columns to tidy them up
    x_selected <-
      x_selected |>
      mutate(across(where(haven::is.labelled),
                    \(.f) {
                      .f <- haven::as_factor(.f)
                      attr(.f, "label") <- NULL
                      .f
                    })) |>
      mutate(id = row_number())

    # next we need to create quo names for the columns if required
    cols_quo <- enquo(cols)
    if (quo_is_null(cols_quo)){
      group_col_name <- paste0("N_", mcol_1)
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
      select(id, {{cols}}, {{wt}}, starts_with(mcol_1)) |>
      # add the NA column if we need to
      apply_NA_rules(use_NA,{{mcol_1}},{{cols}}) |>
      pivot_longer(starts_with(mcol_1),
                   names_to = NULL,
                   values_to = mcol_1) |>
      filter(!is.na({{sym_mcol_1}}))

    RHS_1 <- RHS |>
      # Add group count
      group_by(across(c({{cols}}, {{mcol_1}}))) |>
      add_tally(name = {{group_col_name}},
                wt = {{wt}})

    LHS <-
      x_selected |>
      select(id, starts_with(mcol_2)) |>
      apply_NA_rules(use_NA,{{mcol_2}}) |>
      pivot_longer(starts_with(mcol_2),
                   names_to = NULL,
                   values_to = mcol_2) |>
      filter(!is.na({{sym_mcol_2}}))

    # now join them together
    output <-
      RHS_1 |>
      left_join(LHS,
                by = join_by(id),
                relationship = "many-to-many") |>
      filter(!(is.na({{sym_mcol_2}})))

    output <-
      output|>
      # Drop the ID
      select(-id) |>
      # Group by everything and then count it
      group_by(across(c({{cols}}, {{mcol_1}}, {{group_col_name}}, {{mcol_2}}))) |>
      tally(wt= {{wt}}, name = "N") |>
      ungroup() |>
      relocate(c(N, {{group_col_name}}), .after = everything())


    output <-
      output |>
      # Add proportion to end
      mutate(Percent = xlr_percent(N / {{group_col_name_quo}}),
             # add code to convert the NA string to an NA
             "{mcol_1}" := ifelse({{ sym_mcol_1 }} == "NA",NA,vec_cast({{ sym_mcol_1 }}, character())),
             "{mcol_2}" := ifelse({{ sym_mcol_2 }} == "NA",NA,vec_cast({{ sym_mcol_2 }}, character())),
             ) |>
      arrange(across({{cols}}),{{sym_mcol_1}},{{sym_mcol_2}})

    # now tidy up the table
    final_table <-
      output |>
      xlr_table(table_title,
                 footnote)

    # Now we apply some formatting depending if wts are applied, if the are
    # we can gaurentee N is an integer, if not we treat it as a double to 1 dp
    final_table <-
      if (quo_is_null(wt_quo))
        mutate(final_table, N = xlr_integer(N))
      else
        mutate(final_table,
               N = xlr_numeric(N, dp = 1),
               "{group_col_name_quo}" := xlr_numeric({{ group_col_name_quo }},dp = 1))
  }
  final_table
}

apply_NA_rules <- function(x,
                           use_NA,
                           mcols,
                           cols = NULL,
                           seen_but_answered = NULL,
                           name_seen_but_answered = NULL){

  # first make sure the input is valid
  if (is.null(name_seen_but_answered)){
    name_seen_but_answered <- paste0(seen_but_answered,
                                     collapse = "_")
  }

  # This is the easy case:
  # With seen and unanswered, every person in the data is included, if someone
  # saw the question but did not respond to anything they are always included
  if (use_NA){
    # First lets define an NA Var
    na_var <- paste0(mcols,"_NA")

    # next if a value for the column is 'seen but answered', convert that to
    # NA.
    if (!is.null(seen_but_answered)){
      x <- x |>
        mutate(across(starts_with(mcols),
                      ~ if_else(.x %in% seen_but_answered,NA,.x)))
    }
    x <-
      x |>
      # This creates a multiple response option for the NA vars
      # It will be pivoted and can be used later
      mutate(!!na_var := if_else(if_all(starts_with(mcols), ~ is.na(.x)),"NA",NA))

    return(x)
  } else if (!is.null(seen_but_answered)){
    # next if a value for the column is 'seen but answered', is not null
    # need to create a variable (like above), which captures the number
    # of NA values
    # First lets define an NA seen but answered questions
    na_var <- paste0(mcols,"_",name_seen_but_answered)

    # we then filter out all the NA values
    x <-
      x |>
      # Lets remove all the NA lines from the multiple response colunms
      # And any of the NA groups
      filter(if_any(starts_with(mcols), ~ !is.na(.x)))

    # Next we make all of the over values NA and then do the same NA trick
    x <- x |>
      mutate(across(starts_with(mcols),
                    ~ if_else(.x %in% seen_but_answered,NA,.x))) |>
      # This creates a multiple response option for the NA vars
      # It will be pivoted and can be used later
      mutate(!!na_var := if_else(if_all(starts_with(mcols),~ is.na(.x)),
                                   name_seen_but_answered,
                                  NA))

    return(x)
  } else{
    x <-
      x |>
      # Lets remove all the NA lines from the multiple response colunms
      # And any of the NA groups
      filter(if_any(starts_with(mcols), ~ !is.na(.x))) |>
      # next filter any of the any rows in the cols
      filter(if_all({{cols}}, ~ !is.na(.x)))

    return(x)
  }
}

