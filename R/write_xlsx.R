
#' Write a `xlr_table`, `data.frame`, or `tibble` to an .xlsx (Excel) file
#'
#' This function writes `xlr_table`, `data.frame`, or `tibble` to an .xlsx
#' (Excel file). Like \link[openxlsx]{write.xlsx} you can also write a `list` of
#' `xlr_table`'s, `data.frame`'s, and `tibbles`'s to the one file.
#' The main use of this function is that it uses the formatting in a `xlr_table`
#' when it writes to the Excel sheet. See [xlr_table] for more information.
#'
#' @param x a single or `list` of types `xlr_table`, `data.frame`, or `tibble`.
#' @param file character. A valid file path.
#' @param sheet_name a sheet name (optional). Only valid for when you pass a single
#' object to `x`.
#' @param overwrite logical. Whether to overwrite the file/worksheet or not.
#' @param append logical. Whether or not to append a worksheet to an existing
#' file.
#' @param TOC logical. Whether to create a table of contents with
#' the document. Works only when you pass a `list` to `x`. To add a table of
#' contents to an existing file, use [create_table_of_contents()].
#' @param TOC_title character. To specify the table of contents title (optional).
#' @param overwrite_sheets logical. Whether to overwrite existing sheets in a
#' file.
#' @param excel_data_table logical. Whether to save the data as an Excel table
#' in the worksheet. These are more accessible than data in the sheet.
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
                        overwrite = FALSE,
                        append = TRUE,
                        TOC = FALSE,
                        TOC_title = NA_character_,
                        overwrite_sheets = TRUE,
                        excel_data_table = TRUE){

  # Check all the types for parts that are not passed to
  # xlr_to_workbook
  type_abort(file, is_scalar_character, "character", call = caller_env())
  type_abort(overwrite,
             is_true_or_false,
             string_type = "{.val {TRUE}} or {.val {FALSE}}",
             call = caller_env())
  type_abort(append,
             is_true_or_false,
             string_type = "{.val {TRUE}} or {.val {FALSE}}",
             call = caller_env())
  type_abort(TOC,
             is_true_or_false,
             string_type = "{.val {TRUE}} or {.val {FALSE}}",
             call = caller_env())
  type_abort(TOC_title,
             is_scalar_character,
             string_type = "{.val {TRUE}} or {.val {FALSE}}",
             call = caller_env())
  type_abort(overwrite_sheets,
             is_true_or_false,
             string_type = "{.val {TRUE}} or {.val {FALSE}}",
             call = caller_env())
  type_abort(excel_data_table,
             is_true_or_false,
             string_type = "{.val {TRUE}} or {.val {FALSE}}",
             call = caller_env())

  # validate the options
  if (overwrite && append){
    cli_abort("You can only overwrite or append a file, not both.")
  }


  # now read in the workbook file if it exists
  wb <- NULL
  if (file.exists(file)){
    if (overwrite){
      # do nothing
    }
    else if (append){
      wb <- loadWorkbook(file)
    }
    else {
      cli_abort("Cannot write file, {.file {file}} already exists!")
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
    if (overwrite){
      cli_alert_info("Overwriting file: {.file {file}}")
    }
    else if (append){
      cli_alert_info("Appending file: {.file {file}}")
    }
    # if the creation of the workbook succeeds, delete the existing file
    file.remove(file)
  }

  # save the file
  saveWorkbook(wb,
               file)
}
