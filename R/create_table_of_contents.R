
#' Adds a table of contents to an .xlsx (Excel) file
#'
#' This function adds a table of contents to an Excel file by reading the
#' information from the Excel sheet in, and then using that data to create
#' the table of contents. It guesses what the information is, see details below.
#'
#' @param file the file name.
#' @param title the title for the table.
#' @param overwrite logical. When `TRUE` overwrite the file, if `FALSE` it will
#'   not overwrite the file.
#' @param pull_titles when `TRUE` take the titles from the excel sheets, and add
#' them to the description in the TOC_sheet_name.
#' @param TOC_sheet_name string. the sheet name for the table of contents.
#' @return Returns a logical or error if writing the file succeeded.
#'
#' @details
#' This function uses the sheet names to create the table of contents. For the
#' titles it pulls the text that is the position A1 in each of the sheets. It
#' chooses this as this is the default location of titles when you write a
#' [xlr_table] with [write_xlsx].
#'
#'
#' @example inst/examples/create_table_of_contents.R
#' @export
create_table_of_contents <- function(file,
                                      title = NA_character_,
                                      overwrite = TRUE,
                                      pull_titles = TRUE,
                                      TOC_sheet_name = "Table of Contents"){
  # validate inputs
  if (!file.exists(file)){
    cli_abort(c("i" = "Error in arg: {.arg file}",
                "!" = "The file does not exist at the path: {.path {file}}"))
  }
  type_abort(title,is_scalar_character,"character",call = caller_env())
  type_abort(overwrite,is_true_or_false,NULL,string_type = "{.val {TRUE}} or {.val {FALSE}}",call = caller_env())
  type_abort(pull_titles,is_true_or_false,TRUE,string_type = "{.val {TRUE}} or {.val {FALSE}}",call = caller_env())
  type_abort(TOC_sheet_name,is_scalar_character,"character",call = caller_env())

  # Load the workbook up if it exists
  wb <-loadWorkbook(file)

  # Now we create the table of contents
  create_table_of_contents_workbook(wb,
                                    title,
                                    overwrite,
                                    pull_titles,
                                    TOC_sheet_name)
  # save the new workbook
 saveWorkbook(wb,
                         file,
                         overwrite = TRUE)
}

create_table_of_contents_workbook <- function(wb,
                                              title,
                                              overwrite,
                                              pull_titles,
                                              TOC_sheet_name,
                                              call = caller_env()){

  # send a warning if the table of contents already exist and overwrite is false
  if (TOC_sheet_name %in% sheets(wb)){
    if (!overwrite){
      cli_abort(c("!" = "The sheet {.val {TOC_sheet_name}} already exists in the workbook.",
                  "i" = "Set {.code overwrite = TRUE} if you wish to overwrite it."),
                call = call)
    }

  }
  else{
    # add the worksheet if it doesn't exist and make it the first worksheet
    addWorksheet(wb,TOC_sheet_name)
    # reorder the worksheets so the TOC_sheet_name is first
    # this is gross because it has to be the number not the sheet_name
    worksheetOrder(wb) <- c(length(names(wb)),1:(length(names(wb))-1))
  }
  # set the TOC_sheet_name as the active sheet (so it is the sheet you first see when you
  # open the work book)
  activeSheet(wb) <- TOC_sheet_name

  # now we've done this get the full list of sheetnames and remove the
  # table of contents
  sheet_names <- sheets(wb)
  # remove the table of contents
  sheet_names <- sheet_names[! sheet_names %in% TOC_sheet_name]
  if (length(sheet_names) == 0){
    cli_abort(c("!" = "Your workbook does not contain any sheets! Nothing to make a table of contents for.",
                "i" = "Add data to your workbook and then call create_table_of_contents().",
                "i" = "If you are exporting data from R, consider using {.fun xlr::write_xlsx} instead."),
              call = call)
  }
  # first lets add the table of contents title
  writeData(wb,
            TOC_sheet_name,
            title,
            startCol = 1,
            startRow = 1)
  # next we generate all the links
  links <- sapply(sheet_names,\(x) makeHyperlinkString(sheet = x,
                                                       row = 1,
                                                       col = 1,
                                                       text = x))

  # now we write them to the table of contents file
  writeFormula(wb,
               TOC_sheet_name,
               links,
               startCol = 1,
               startRow = 2)

  # lastly we fix the column widths so they are wide enough based on the sheet
  # names
  max_sheet_length <- max(nchar(sheet_names))
  # set the column width based on that
  # we use the same bad formula as the function create_column_widths()
  new_width <- case_when(max_sheet_length > 40 ~ 30,
                         max_sheet_length > 9 ~ max_sheet_length - 5,
                         TRUE ~ NA
  )
  setColWidths(wb,
               TOC_sheet_name,
               cols =  1,
               widths = new_width)

  # now if we want to pull the titles in we do
  # lets
  if (pull_titles){
    titles <- get_title_existing_data(wb,sheet_names)
    # next we write the titles if they exist
    writeData(wb,
              TOC_sheet_name,
              titles,
              startCol = 2,
              startRow = 2)
  }


  add_TOC_to_existing_sheet(wb,
                            TOC_sheet_name,
                            sheet_names)
}


get_title_existing_data <- function(wb,
                                    sheet_names){
  sapply(sheet_names, function(sheet){
      # first we check if there is a title/data in the first row
      # If there is not, openxlsx ignores it so we can't see if there is
      # data in it
      # we also supress warning from this class, because openxlsx throws a
      # warning if a file is empty, but that is what we are checking
      check_title <-readWorkbook(wb,
                                            sheet=sheet,
                                            check.names = FALSE,
                                            skipEmptyRows = FALSE,
                                            skipEmptyCols = FALSE,
                                            colNames = FALSE,
                                            rows = 1,
                                            cols = 1) |>
        suppressWarnings()

      # if the title is missing set it to NA
      if (is.null(check_title)){
        return(NA)
      }
      else{
        # if it is not NULL, lets pull out the title
        title <- unlist(check_title[["X1"]])
        return(title)
      }
    })
}


add_TOC_to_existing_sheet <- function(wb,
                                      TOC_sheet_name,
                                      sheet_names){
  # now we add the TOC_sheet_name Link to the last row of the dataa
  # first create the link
  toc_link <-
   makeHyperlinkString(
      sheet = TOC_sheet_name,
      row = 1, col = 1,
      text = "TOC")
  # next add it to each sheet
  lapply(sheet_names, function(sheet){
    # we need to work out where the data starts (this is annoying as openxlsx
    # skips the first empty rows of a sheet)
    # We only check the max 100 rows otherwise we throw an error
    MAX_ROW_CHECK <- 100
    start_row <- 1
    for (i in c(1:MAX_ROW_CHECK)){
      # we want to read it in, if it is NULL otherwise we have our start
      # row
      row_data <-readWorkbook(wb,
                                         sheet=sheet,
                                         check.names = FALSE,
                                         skipEmptyRows = FALSE,
                                         skipEmptyCols = FALSE,
                                         colNames = FALSE,
                                         rows = i,
                                         cols = 1) |>
        suppressWarnings()
      # if it is not null we break and start
      if (!is.null(row_data)){
        start_row <- i
        break
      }
    }
    # we now read in the first column of the data to the end
    # we read everything in
    data <-readWorkbook(wb,
                                   sheet=sheet,
                                   colNames = FALSE,
                                   check.names = FALSE,
                                   skipEmptyRows = FALSE,
                                   skipEmptyCols = FALSE,
                                   cols = 1,
                                   startRow = start_row)

    # the length of the dataset should be the last row with something in it
    # with this information we do one beyond it.
    TOC_location <- nrow(data) + start_row
   writeFormula(wb,
                           sheet,
                           startCol = 1,
                           startRow = TOC_location,
                           x = toc_link)
    # next we want to remove the style and add it
    addStyle(wb,
             sheet,
             style = createStyle(fontSize = 11,
                                 fontColour = "blue",
                                 numFmt = "TEXT",
                                 textDecoration = c("underline","italic")),
             rows = TOC_location,
             cols = 1,
             stack = TRUE)
  })
}
