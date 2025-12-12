#' Summarise a question block
#'
#' This function helps analyse a block of questions or matrix questions into a
#' single table. It also lets the user cut these questions by other questions in
#' the data. The block of questions mush have the same response options.
#'
#' @param x a data frame or tidy object
#' @param block_cols <\link[tidyr]{tidyr_tidy_select}> statement. These are the
#' columns that make up the question block, they must have the same response
#' option. Most question block columns start with the same piece of text, so
#' you should use `starts_with('column_text')`. See the Examples below.
#' @param cols <\link[tidyr]{tidyr_tidy_select}> statement. These are the column(s) that we
#' want to cut the questions in the question block by.
#' @param table_title a string. The title of the table sheet
#' @param use_questions a logical. If the data has column labels (was a imported .sav)
#' file, convert the column label to a footnote with the question.
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
#' This function and its family ([build_table], [build_qtable]) is designed to
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
#' @example inst/examples/build_question_block_table.R
#'
#' @export
build_qtable <- function(
    x,
    block_cols,
    cols = NULL,
    table_title = "",
    use_questions = FALSE,
    use_NA = FALSE,
    wt = NULL,
    footnote = ""){
  `Question Block` <- N <- value <- combined_col <- name <- label <- NULL
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
                                    c(!!enquo(cols),!!enquo(wt),
                                      !!enquo(block_cols)))

  # Validate the block question that each column has the same values or throw
  # an error
  # First jsut select the question block questions
  x_block_cols <- select(x, {{block_cols}})
  # First we check that they are all the same type
  # To explain this code: sapply pulls the class of each of the
  # columns, if they are all the same when we take the unique value
  # of them, the length of that vector must be 1

  # Class can return multiple things because of inheritance
  # This is experimental, and might still give weird answers but will work
  # in most cases.

  # Make the erorr a warning as the function might still be able to function
  start <- class(x_block_cols[[1]])[1]
  check_type <- sapply(x_block_cols,\(x) class(x)[1] == start)
  if (!all(check_type)){
    # As we know there is a false, then we can assue which has an element in it
    first_col_pos <- which(check_type == FALSE)[1]
    # we get the column names from using sapply, so we can call names
    first_col_name <- colnames(x_block_cols)[[first_col_pos]]
    cli_abort(c("!"= "Error in your block column selection.",
                "!" = "The columns you selected as your question block do not have the same type!",
                "i" = "Check the type of column {.col {first_col_name}}?")
              )
  }
  # Now if we can coerce the type as a factor, are all the elements the same?
  # First if it is haven labelled, convert to a factor
  #
  # We can select the first as we have guaranteed above they are all the
  # same type
  # If they are haven labelled convert to a factor using haven
  if (haven::is.labelled(x_block_cols[[1]])){
    x_block_cols_factor <- mutate(x_block_cols,
                           across(everything(),
                                  \(.f) {
                                        .f <- haven::as_factor(.f)
                                        attr(.f, "label") <- NULL
                                        .f}
                                  ))

  }
  else if (is.factor(x_block_cols[[1]])){
    x_block_cols_factor <- x_block_cols
  }
  else {
    # if the data is not a factor then coerce the data
    x_block_cols_factor <- mutate(x_block_cols,
                           across(everything(),~ as.factor(.x)))
  }
  # now lets get the levels and see if they are the same
  # now get a matrix of the levels
  block_levels <- lapply(x_block_cols_factor,levels)
  # Get the levels for the column in the first position
  start <- block_levels[[1]]
  # Now test that all the levels are the same
  # 1. Go through and see if all the elements in the vector
  #     are equal to the first element (start), which therefore
  #     means they are all equal (we don't care about order).
  check_factor <- sapply(block_levels,\(y) setequal(start,y))
  # 2. Use all to check this is all true.
  if (!all(check_factor)){
    # If it is not equal we can try and given an informative error message
    # Find the first element that is a different type
    # As we know there is a false, then we can assume which has an element in it
    first_col_pos <- which(check_factor == FALSE)[1]
    # Get the column names, and then use the position from the which statement
    first_col_name <- colnames(x_block_cols)[[first_col_pos]]
    cli_abort(c("!"= "Error in your block column selection.",
                "!" = "The columns you selected have different elements.",
                "i" = "Consider converting your columns to factors before using `build_qtable()`.",
                "i" = "Or start by checking the levels of column {.col {first_col_name}}?")
    )
  }

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

  # Lets make a block_cols quo to use later
  # block_cols_quo <- sym(block_cols)
  # Additional information on the questions-------------------------------------
  # Pull out the labels for each colum and create a data.frame to join
  # onto
  null_to_na <- \(x) if (is.null(x)) return(NA) else return(x)
   # set up the options for labels
  label_exist <- FALSE
  # First lets get the labels from the columns
  question_labels_list <-
    x |>
    summarise(across({{block_cols}}, ~ attr(.x,which="label", exact = TRUE)))

  question_labels <- tibble::tibble(`Question Block`= c(),"label"=c())

  # if the labels exist then we pivot it
  if (length(question_labels_list) > 0){
    label_exist <- TRUE
    question_labels <- question_labels_list |>
      pivot_longer(everything(),names_to = "Question Block", values_to = "label")
  }


  # lastly if empty title or footnote set it to null
  if (table_title == "") table_title <- character()
  if (footnote == "") footnote <- character()

  # pull out the questions and include them in the footnote if true
  if (use_questions & length(footnote) == 0){
    footnote <- get_question_from_label(x,!!enquo(cols))
  }

  # Aggregation ---------------------------------------------------------------

  # now pivot longer so we can put everything in the one table
  long_data <-
    x_selected |>
    pivot_longer(cols = {{block_cols}},
                 names_to = "Question Block") |>
    # remove the NA"s if we need too
    remove_NA_opt(use_NA)

  # now we have the long data we need calculate the summary table
  # and pivot it wider
  final_table <-
    long_data |>
    mutate(across(where(haven::is.labelled),
                  \(.f) {
                    .f <- haven::as_factor(.f)
                    attr(.f, "label") <- NULL
                    .f
                  })) |>
    group_by(across(!!enquo(cols)),`Question Block`,value) |>
    # uses the weight if it is not null, if NULL, it get's ignored
    tally(wt = {{wt}}, name = "N") |>
    mutate(Percent = xlr_percent(N/sum(N))) |>
    ungroup()


  #* This is some tricky code that joins on the question labels for the
  #* block, questions, irrespective of whether or not you use an option
  #* or the quesiton actually has labels
  #
  #* If there are no labels we skip this peice of code
  if (label_exist){
    final_table <-
      final_table |>
      left_join(question_labels, by = "Question Block") |>
      mutate(`Question Block` = ifelse(is.na(label),`Question Block`,label)) |>
      select(-label)
  }


  final_table <-
    final_table |>
    xlr_table(table_title,
               footnote)

  # Now we apply some formatting depending if wts are applied, if the are
  # we can gaurentee N is an integer, if not we treat it as a double to 1 dp

  if (quo_is_null(wt_quo))
    mutate(final_table, N = xlr_integer(N))
  else
    mutate(final_table, N = xlr_numeric(N, dp = 1))

}



