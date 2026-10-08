
#' Write a `xlr_table`, `data.frame`, or `tibble` to an .xlsx (`Excel`) file
#'
#' This function writes `xlr_table`, `data.frame`, or `tibble` to an .xlsx
#' (`Excel` file). Like \link[openxlsx]{write.xlsx} you can also write a `list` of
#' `xlr_table`'s, `data.frame`'s, and `tibbles`'s to the one file.
#' The main use of this function is that it uses the formatting in a `xlr_table`
#' when it writes to the `Excel` sheet. See [xlr_table] for more information.
#'
#' @param x a single or `list` of types `xlr_table`, `data.frame`, or `tibble`.
#' @param file character. A valid file path.
#' @param sheet_name a sheet name (optional). Only valid for when you pass a single
#' object to `x`.
#' @param if_exists what to do if `file` already exists. One of:
#'   * `"overwrite"`: replace the file.
#'   * `"append"`: add the sheets to the existing file. Use `overwrite_sheets`
#'     to control what happens to sheets that already exist.
#'   * `"error"`: throw an error and leave the file unchanged.
#'
#' If `NULL` (the default) and the file exists, you are asked what to do in an
#' interactive session, otherwise an error is thrown. It is ignored if the file
#' does not exist.
#' @param TOC logical. Whether to create a table of contents with
#' the document. Works only when you pass a `list` to `x`. To add a table of
#' contents to an existing file, use [create_table_of_contents()].
#' @param TOC_title character. To specify the table of contents title (optional).
#' @param overwrite_sheets logical. Whether to overwrite existing sheets in a
#' file.
#' @param excel_data_table logical. Whether to save the data as an `Excel` table
#' in the worksheet. These are more accessible than data in the sheet.
#' @param overwrite,append Deprecated, use `if_exists`
#' instead.
#'
#' @return None
#'
#' @export
#'
#' @example inst/examples/write_xlsx.R
#'
#'
write_xlsx <- function(x,
                       file,
                       sheet_name = NULL,
                       if_exists = NULL,
                       TOC = FALSE,
                       TOC_title = NA_character_,
                       overwrite_sheets = TRUE,
                       excel_data_table = TRUE,
                       overwrite = NULL,
                       append = NULL){

  # Check all the types for parts that are not passed to
  # xlr_to_workbook
  type_abort(file, is_scalar_character, "character")
  if (!is.null(if_exists)){
    if (!is_character(if_exists)){
      cli_abort(c("i" = "In argument: {.arg if_exists}.",
                  "!" = "{.arg if_exists} must be a string, not {.obj_type_friendly {if_exists}}.",
                  "i" = "Did you mean to pass {.arg overwrite} or {.arg append}? Name the argument, or use {.code if_exists = \"overwrite\"}."))
    }
    if_exists <- arg_match(if_exists, c("overwrite", "append", "error"))
  }
  type_abort(TOC,
             is_true_or_false,
             string_type = "{.val {TRUE}} or {.val {FALSE}}")
  type_abort(TOC_title,
             is_scalar_character,
             string_type = "a string")
  type_abort(overwrite_sheets,
             is_true_or_false,
             string_type = "{.val {TRUE}} or {.val {FALSE}}")
  type_abort(excel_data_table,
             is_true_or_false,
             string_type = "{.val {TRUE}} or {.val {FALSE}}")

  # map the deprecated arguments on to if_exists
  if (!is.null(overwrite) || !is.null(append)){
    if_exists <- deprecated_if_exists(if_exists, overwrite, append)
  }

  # now read in the workbook file if it exists
  wb <- NULL
  if (file.exists(file)){
    if (is.null(if_exists)) if_exists <- ask_if_exists(file)

    if (if_exists == "error"){
      cli_abort("Cannot write file, {.file {file}} already exists!")
    }
    else if (if_exists == "append"){
      wb <- loadWorkbook(file)
    }
  }
  wb <- xlr_to_workbook(x,
                        sheet_name = sheet_name,
                        old_wb = wb,
                        overwrite_sheet = overwrite_sheets,
                        TOC = TOC,
                        TOC_title = TOC_title,
                        excel_data_table = excel_data_table)

  # Now send the messages as we actually change the file at this point
  if (file.exists(file)){
    if (if_exists == "overwrite"){
      cli_alert_info("Overwriting file: {.file {file}}")
    }
    else {
      cli_alert_info("Appending file: {.file {file}}")
    }
  }

  # save the file, saveWorkbook only replaces the file if it saves
  # successfully
  saveWorkbook(wb,
               file,
               overwrite = TRUE)
}

#' Ask the user what to do with an existing file
#'
#' @param file the file path.
#' @param call the caller environment.
#'
#' @return `"overwrite"` or `"append"`, or errors if the user cancels or the
#' session is not interactive.
#'
#' @noRd
ask_if_exists <- function(file,
                          call = caller_env()){
  if (!is_interactive()){
    cli_abort(c("!" = "{.file {file}} already exists.",
                "i" = "Set {.code if_exists = \"overwrite\"} or {.code if_exists = \"append\"} to write to it."),
              call = call)
  }
  choice <- utils::menu(c("Overwrite", "Append sheets", "Cancel"),
                        title = cli_fmt(cli_text("{.file {file}} already exists. What do you want to do?")))
  switch(choice + 1,
         cli_abort("Cancelled, {.file {file}} was not changed.", call = call),
         "overwrite",
         "append",
         cli_abort("Cancelled, {.file {file}} was not changed.", call = call))
}

#' Map the deprecated `overwrite` and `append` arguments to `if_exists`
#'
#' @param if_exists the `if_exists` argument.
#' @param overwrite,append the deprecated arguments, `NULL` if not passed.
#' @param call the caller environment.
#'
#' @noRd
deprecated_if_exists <- function(if_exists,
                                 overwrite,
                                 append,
                                 call = caller_env()){
  if (!is.null(if_exists)){
    cli_abort(c("!" = "You can't use {.arg if_exists} with the deprecated {.arg overwrite} or {.arg append} arguments.",
                "i" = "Use only {.arg if_exists}."),
              call = call)
  }
  # the previous defaults
  overwrite <- overwrite %||% FALSE
  append <- append %||% !overwrite
  type_abort(overwrite,
             is_true_or_false,
             string_type = "{.val {TRUE}} or {.val {FALSE}}",
             call = call)
  type_abort(append,
             is_true_or_false,
             string_type = "{.val {TRUE}} or {.val {FALSE}}",
             call = call)
  if (overwrite && append){
    cli_abort("You can only overwrite or append a file, not both.",
              call = call)
  }

  if_exists <- if (overwrite) "overwrite" else if (append) "append" else "error"
  cli_warn(c("!" = "The {.arg overwrite} and {.arg append} arguments of {.fun write_xlsx} are deprecated.",
             "i" = "Use {.code if_exists = {.val {if_exists}}} instead."),
           call = call)
  if_exists
}
