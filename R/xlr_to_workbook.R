#' Convert xlr types to a openxlsx workbook.
#'
#' @param x a single or `list` of types `xlr_table`, `data.frame`, or `tibble`
#' @param sheet_name a sheet name (optional). Only valid for when you pass a single
#' object to `x`.
#' @param old_wb An existing workbook to add data too. (Optional) We create a copy of
#' this workbook and do not modify the original.
#' @param overwrite_sheet An option to overwrite
#' @param TOC logical. Whether to create a table of contents with
#' the document. Works only when you pass a `list` to `x`. To add a table of
#' contents to an existing file, use [create_table_of_contents].
#' @param TOC_title a character with the table of contents title (optional.
#' @param excel_data_table logical. Whether to save the data as an `Excel` table
#' in the worksheet. These are more accessible than data in the sheet.
#' @param call the calling environment (see \link[rlang]{caller_env}).
#'
#' @return A `openxlsx` Workbook.
#'
#' @noRd
xlr_to_workbook <- function(x,
                             sheet_name = NULL,
                             old_wb = NULL,
                             overwrite_sheet = TRUE,
                             TOC = FALSE,
                             TOC_title = NA_character_,
                             excel_data_table = TRUE,
                             call = caller_env()){

  TOC_sheet_name <- "Table of Contents"

  type_abort(sheet_name,
             \(x) is.null(x) || is_scalar_character(x),
              string_type = "NULL or a string",
             call = call)
  type_abort(old_wb,
             \(x) is.null(x) || is_openxlsx_workbook(x),
             string_type = "NULL or a openxlsx Workbook",
             call = call)
  type_abort(overwrite_sheet,is_true_or_false,string_type = "{.val {TRUE}} or {.val {FALSE}}",call = call)
  type_abort(TOC,is_true_or_false,string_type = "{.val {TRUE}} or {.val {FALSE}}",call = call)
  type_abort(TOC_title,is_scalar_character,"character",call = call)
  type_abort(excel_data_table,is_true_or_false,string_type = "{.val {TRUE}} or {.val {FALSE}}",call = call)

  # Check the input data is good
  if (is_bare_list(x)){
    if (length(x) == 0){
      cli_abort(c(
        "i" = "In argument: {.arg x}.",
        "!" = "The list does not contain any elements!"
      ),
      call = call)
    }
    if (!is.null(sheet_name)){
      cli_warn(c(
        "i" = "In argument: {.arg sheet_name}.",
        "!" = "{.arg sheet_name} is not NULL. This argument does nothing when you pass a list to argument {.arg x}."
      ),
      call = call)
    }
    # now check everything is the right type
    lapply(x, function(y){
      type_abort(y,
                 \(x) is.data.frame(x) || is_tibble(x) || is_xlr_table(x),
                 NULL,
                 string_type = "<data.frame>, <tibble>, or <xlr_table>",
                 call = call)

    })

    # next if no errors we get the name of the sheets
    sheet_names <- create_list_names(x,
                                   call = call)
    # rename the names in the list
    names(x) <- sheet_names
  }
  else {
    # check it is the correct type
    type_abort(x,
               \(x) is.data.frame(x) || is_tibble(x) || is_xlr_table(x),
               string_type = "<data.frame>, <tibble>, or <xlr_table>",
               call = call)
    # check that the sheet name is not missing
    if (is.null(sheet_name)){
      cli_abort(c(
        "i" = "In argument: {.arg sheet_name}.",
        "!" = "{.arg sheet_name} cannot be missing when you provide a single sheet."
      ),
      call = call)
    }

    # finally we make it a list with the sheet_names
    x <- list(x)
    names(x) <- sheet_name
    sheet_names <- sheet_name
  }

  # Copy the old workbook object or create a new one
  # we don't want to reference the old object, as we don't want to change it
  if (!is.null(old_wb)){
    wb <- copyWorkbook(old_wb)
    # next we want to check if we are going to overwrite any sheets
    # go through each sheet and add the worksheets
    lapply(sheet_names, \(x) append_worksheet(x,
                                              wb,
                                              overwrite_sheet,
                                              call = call))
  }
  else {
    wb <- createWorkbook()
    # add all the worksheets we need too
    lapply(sheet_names, \(x) addWorksheet(wb,x))
  }

  # next we add the table of contents if we need too
  if (TOC){
    add_TOC_to_workbook(wb=wb,
                        x=x,
                        sheet_names = sheet_names,
                        old_wb = old_wb,
                        TOC_title = TOC_title,
                        TOC_sheet_name = TOC_sheet_name,
                        call = call)
  }
  # now we have sorted through all the data we now add the worksheet data

  lapply(names(x),
         function(sheet_name, call = caller_env()) {
           data <- x[[sheet_name]]
           # must be a xlr_table or data.frame
           if (is_xlr_table(data)) {
             xlr_table_to_sheet(data,
                                 wb,
                                 sheet_name,
                                 TOC = TOC,
                                 excel_data_table = excel_data_table,
                                 call = call)
           }
           else{
            dataframe_to_sheet(data,
                                wb,
                                sheet_name,
                                TOC = TOC,
                                excel_data_table = excel_data_table,
                                call = call)
           }
         })

  # now return a reference to the workbook we created
  return(wb)
}


create_list_names <- function(x,
                           call = caller_env()){
  sheet_names <- names(x)
  # now we use the names that exist in the list, or if they are empty we set them
  if (is.null(sheet_names)){
    sheet_names <- paste0("Table ",1:length(x))
  }
  # if some of the names are missing we throw a warning
  else if ("" %in% sheet_names){
    # next check that any of the existing names would be a double up
    # Throw an error if they do, otherwise add more names
    bad_sheets <- grep("table [[:alnum:]]", sheet_names,ignore.case = TRUE)
    if (length(bad_sheets) == 0){
      sheet_names[sheet_names == ""] <- paste0("Table ",1:sum("" == sheet_names))
      cli_alert("There are unnamed objects in argument {.arg x}. Generating names for the empty object.")
    }
    else{
      cli_abort(c("The sheet names provided are invalid. You can't have missing sheet names, and a sheet named {.val {sheet_names[bad_sheets[1]]}}.",
                "i" = "If you passed a named list to {.fun write_xlsx}, remove the names before preceeding, or name all the elements manually."))
    }
  }

  return(sheet_names)
}

append_worksheet <- function(sheet_name,
                             wb,
                             overwrite_sheet = TRUE,
                             call = caller_env()){
  # first check if the sheet already exists
  if (sheet_name %in% sheets(wb)){
    if (!overwrite_sheet){
      true_val <- TRUE
      cli_abort(c(
        "!" = "{.val {sheet_name}} already exists in the workbook.",
        "i" = "set {.arg overwrite_sheet} = {.val {true_val}} if you want to overwrite it."),
      call = call)
    }
    else{
      # delete the old sheet and replace it
      removeWorksheet(wb,sheet = sheet_name)
      addWorksheet(wb,sheetName = sheet_name)
    }
  }
  else{
    addWorksheet(wb,sheetName = sheet_name)
  }
  # we don't need to return the wb, as the argument 'wb' is a reference (not a copy)
  # of the underlying c++ object
}

add_TOC_to_workbook <- function(wb,
                                x,
                                sheet_names,
                                old_wb = NULL,
                                TOC_title = NA,
                                TOC_sheet_name = "Table of Contents",
                                TOC_title_format = xlr_format(font_size = 14, text_style = "bold"),
                                call = caller_env()){

  # lets pull in the old data and add the table of contents to the
  # existing data
  old_titles <- c()
  if (!is.null(old_wb)){
    # we now get all the sheet_names
    old_sheet_names <- sheets(old_wb)

    # remove the table of contents if it exists
    old_sheet_names <- old_sheet_names[!old_sheet_names %in% TOC_sheet_name]
    # we only want the titles of the sheets which we won't overwrite
    unchanged_sheets <- setdiff(old_sheet_names,sheet_names)
    # now we get the titles
    old_titles <- get_title_existing_data(old_wb,
                                          unchanged_sheets)


    # now add the TOC to the existing sheets, that we are not planning on
    # overwriting
    # This assumes that the sheets already exist in new workbook (wb)
    add_TOC_to_existing_sheet(wb,
                              TOC_sheet_name,
                              unchanged_sheets)

    # Now we pull the full list of sheets, this will be
    # the set diff and then the new sheets
    # (we won't repeat anything because we know its the set diff)
    sheet_names <- c(unchanged_sheets,sheet_names)
  }

  # If the table of contents does not already exist, lets add it
  append_worksheet(TOC_sheet_name,
                   wb,
                   overwrite_sheet = TRUE,
                   call = call)
  # reorder the worksheets so the TOC_sheet_name is first
  # this is gross because it has to be the number not the sheet_name
  number_sheets <- length(sheets(wb))
  if (number_sheets > 1){
    worksheetOrder(wb) <- c(number_sheets,1:(number_sheets-1))
  }

  # first lets add the table of contents title
  writeData(wb,
            TOC_sheet_name,
            TOC_title,
            startCol = 1,
            startRow = 1)
  # Add the style to the title
  addStyle(wb,
           TOC_sheet_name,
           style = xlr_format_to_openxlsx_format(TOC_title_format,
                                                  "TEXT"),
           rows = 1,
           cols = 1)

  # next if the old titles exist, we ne
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

  # first we pull out the titles if they exist
  titles <- sapply(x,pull_title)
  titles[lengths(titles)==0] <- NA
  # now we combine the old titles and the new ones
  titles <- c(old_titles,titles)
  # now cooerce it to a vector
  titles <- data.frame(titles = unlist(titles,use.names = FALSE))

  # next we write the titles if they exist
  writeData(wb,
            TOC_sheet_name,
            titles[["titles"]],
            startCol = 2,
            startRow = 2)
  #  set the TOC_sheet_name as the active sheet (so it is the sheet you first see when you
  # open the work book)
  activeSheet(wb) <- TOC_sheet_name
  # lastly we fix the column widths so they are wide enough based on the sheet
  # names
  max_sheet_length <- max(nchar(sheet_names))
  # set the column width based on that
  # we use the same bad formula as the function create_column_widths()
  new_width <- case_when(max_sheet_length > 40 ~ 30,
                         max_sheet_length > 20 ~ max_sheet_length - 5,
                         TRUE ~ NA
  )
  if (!is.na(new_width)){
    setColWidths(wb,
                 TOC_sheet_name,
                 cols =  1,
                 widths = new_width)
  }
}

xlr_table_to_sheet <- function(x,
                                wb,
                                sheet_name,
                                TOC = FALSE,
                                excel_data_table = FALSE,
                                TOC_sheet_name = "Table of Contents",
                                call = caller_env()){
  # check if the sheet already exists
  error_if_sheet_not_exists(wb,sheet_name,call = call)

  data <- as.data.frame(x,
                        check.names  = FALSE)

  # check it contains data or throw back
  if (ncol(data) == 0){
    cli_abort(c("i" = "In argument: {.arg x}.",
                "!" = "Your <xlr_table> {.val {sheet_name}} must contain columns."),
              call = call)
  }
  if (nrow(data) == 0){
    cli_warn(c("i" = "In argument: {.arg x}.",
                "Your <xlr_table> {.val {sheet_name}} has no data in it's rows."),
             call = call)
  }

  # pull apart the table
  title_val <- pull_title(x)
  title_option <- TRUE
  footnote_val <- pull_footnote(x)
  footnote_option <- TRUE

  # now check non-empty, we let the user leave these
  # empty, we just don't write any data
  if (length(title_val) == 0){
    title_val <- NULL
    title_option <- FALSE
  }
  if (length(footnote_val) == 0){
    footnote_val <- NULL
    footnote_option <- FALSE
  }

  # first we add the data and the styles to the sheet---------------------------
  # Add the xlr data to the sheet
  data_to_worksheet(data,
                    wb,
                    sheet_name,
                    start_row = 2,
                    excel_data_table = excel_data_table,
                    excel_table_name = "")
  # Write the title and add the style if exists
  if (title_option) {
    # add the title
    writeData(wb,
              sheet_name,
              title_val,
              startCol = 1,
              startRow = 1,
              keepNA = TRUE)
    # next we pull the title style and add it to the data
    addStyle(wb,
             sheet_name,
             style = xlr_format_to_openxlsx_format(pull_title_format(x),
                                                    "TEXT"),
             rows = 1,
             cols = 1)
  }


  # add the footnote if exists
  if (footnote_option){
    # we need to calculate the location of the bottom of the data
    # the footnote location is where the :
    #   - title (1)
    #   - data (for the number of rows + 1 columns)
    #   - footnote (add 1)
    footnote_row <- 1 + nrow(data) + 1 + 1
    writeData(wb,
              sheet_name,
              footnote_val,
              startCol = 1,
              startRow = footnote_row,
              keepNA = TRUE)
    addStyle(wb,
             sheet_name,
             style = xlr_format_to_openxlsx_format(pull_footnote_format(x),
                                                    "TEXT"),
             cols = 1,
             rows = footnote_row:(footnote_row + length(footnote_val)))
  }

  # next we add styling to the table format. This is a little different
  # from the normal xlr_formatting, as we are applying styles to the whole
  # table.
  # we do this in stages
  body_styling <- pull_table_body_format(x)
  border_style_list <- get_border_styles(body_styling,
                                          call = call)

  # now we add all the styles if we have pulled out the borders
  lapply(names(border_style_list),
         \(x)
         switch(x,
                "left" = addStyle(wb,
                                  sheet_name,
                                  border_style_list[["left"]],
                                  rows = 2:(2 + nrow(data)),
                                  cols = 1,
                                  gridExpand = FALSE,
                                  stack = TRUE),
                "right" = addStyle(wb,
                                   sheet_name,
                                   border_style_list[["right"]],
                                   rows = 2:(2 + nrow(data)),
                                   cols = ncol(data),
                                   gridExpand = FALSE,
                                   stack = TRUE),
                "top" = addStyle(wb,
                                 sheet_name,
                                 border_style_list[["top"]],
                                 rows = 3,
                                 cols = 1:ncol(data),
                                 gridExpand = FALSE,
                                 stack = TRUE),
                "bottom" = addStyle(wb,
                                    sheet_name,
                                    border_style_list[["bottom"]],
                                    rows = 2 + nrow(data),
                                    cols = 1:ncol(data),
                                    gridExpand = FALSE,
                                    stack = TRUE),
         )
  )

  # now we add all the column styles
  addStyle(wb,
           sheet_name,
           xlr_format_to_openxlsx_format(pull_column_heading_format(x),
                                          "TEXT"),
           rows = 2,
           cols = 1:ncol(data),
           gridExpand = TRUE,
           stack = FALSE)

  # next we do an extra step to make the col widths wider if needed
  col_data <- create_column_widths(data)
  setColWidths(wb,
               sheet_name,
               cols =  col_data[["index"]],
               widths = col_data[["cell_width"]])

  # finally we add a link to the Table of Contents if it is needed
  # now we put in the hyperlink data
  if (TOC){
    toc_link <-
      openxlsx::makeHyperlinkString(
        sheet = TOC_sheet_name,
        row = 1,
        col = 1,
        text = "TOC")
    # get the location
    toc_row <- 1 + nrow(data) + 1 + 1
    if (footnote_option){
      toc_row <- toc_row + length(footnote_val)
    }

    openxlsx::writeFormula(wb,
                           sheet_name,
                           startCol = 1,
                           startRow = toc_row,
                           x = toc_link)
    # next we want to remove the style and add it
    addStyle(wb,
             sheet_name,
             style = createStyle(fontSize = 11,
                                 fontColour = "blue",
                                 numFmt = "TEXT",
                                 textDecoration = c("underline","italic")),
             rows = toc_row,
             cols = 1,
             stack = TRUE)
  }


}

get_border_styles <- function(body_styling,
                              call = call){

  type_abort(body_styling,is_xlr_format,xlr_format())
  # next we pull out all the borders and their styling
  borders = attr(body_styling, which = "border")
  # if we want to style something
  if (!is.null(borders)){
    # now pull out the colours and the styles
    border_colours <- attr(body_styling, which = "border_colour")
    border_style <- attr(body_styling, which = "border_style")
    border_colour_count <- length(border_colours)
    border_style_count <- length(border_style)
    b_count <- length(borders)
    # If their is on
    if (border_style_count == 1 && border_colour_count == 1){
      style_list <- lapply(borders,
                           \(x) createStyle(border = x,
                                            borderColour = border_colours,
                                            borderStyle = border_style)
      )
    }
    else if (border_colour_count == 1){
      style_list <- lapply(1:b_count,
                           \(i) createStyle(border = borders[i],
                                            borderColour = border_colours,
                                            borderStyle = border_style[i])
      )
    }
    else if (border_style_count == 1){
      style_list <- lapply(1:b_count,
                           \(i) createStyle(border = borders[i],
                                            borderColour = border_colours[i],
                                            borderStyle = border_style)
      )
    }
    else {
      style_list <- lapply(1:b_count,
                           \(i) createStyle(border = borders[i],
                                            borderColour = border_colours[i],
                                            borderStyle = border_style[i])
      )
    }
    names(style_list) <- borders
    return(style_list)
  }
  else {
    return(NULL)
  }

}

create_column_widths <- function(x){
  c_name <- cell_width <- NULL

  # first check it is a data.frame
  if (!is.data.frame(x)){
    cli_abort("`x` must be a data.frame. You should not see this error.")
  }
  # now we just create the column widths, pulling them out of the data.frame

  col_width <- lapply(x, function(x) {
    out <- pull_attr(x,"style") |>
      pull_attr("col_width")
    if (is.null(out)){
      return(10.00)
    }
    out
  }) |>
    unlist(use.names = FALSE)
  data.frame(cell_width = col_width,
              index = 1:ncol(x))
}

dataframe_to_sheet <- function(x,
                                wb,
                                sheet_name,
                                TOC = FALSE,
                                excel_data_table = FALSE,
                                TOC_sheet_name = "Table of Contents",
                                call = caller_env()){
  # check if the sheet already exists
  error_if_sheet_not_exists(wb,sheet_name,call = call)

  data <- as.data.frame(x)
  # check it contains data or throw back
  # # check it contains data or throw back
  if (ncol(data) == 0){
    cli_abort(c("i" = "In argument: {.arg x}.",
                "!" = "Your data frame or tibble must contain columns."),
              call = call)
  }
  if (nrow(data) == 0){
    cli_warn(c("i" = "In argument: {.arg x}.",
               "!" = "Your data frame or tibble has no data in it's rows."),
             call = call)
  }

  # now we add the data in the dataframe
  data_to_worksheet(data,
                    wb,
                    sheet_name,
                    start_row = 1,
                    excel_data_table = excel_data_table,
                    excel_table_name = "")
  # next we do an extra step to make the col widths wider if needed
  col_data <- create_column_widths(data)
  setColWidths(wb,
               sheet_name,
               cols =  col_data[["index"]],
               widths = col_data[["cell_width"]])
  # finally we add a link to the Table of Contents if it is needed
  # now we put in the hyperlink data
  if (TOC){
    toc_link <-
      openxlsx::makeHyperlinkString(
        sheet = TOC_sheet_name,
        row = 1,
        col = 1,
        text = "TOC")
    # get the location
    toc_row <- 1 + nrow(data) + 1

    openxlsx::writeFormula(wb,
                           sheet_name,
                           startCol = 1,
                           startRow = toc_row,
                           x = toc_link)

    addStyle(wb,
             sheet_name,
             style = createStyle(fontSize = 11,
                                 fontColour = "blue",
                                 numFmt = "TEXT",
                                 textDecoration = c("underline","italic")),
             rows = toc_row,
             cols = 1,
             stack = TRUE)
  }
}


data_to_worksheet <- function(x,
                              wb,
                              sheet_name,
                              start_row = 2,
                              excel_data_table = FALSE,
                              excel_table_name = "",
                              call = caller_env()){

  # first check if a worksheet exists, and throw an error if it
  error_if_sheet_not_exists(wb,sheet_name,call = call)

  # also convert all the xlr_types to their basic type
  df <- convert_xlr_type_to_R(x, call)
  # now lets add the data
  if (!excel_data_table){
    writeData(wb,
              sheet_name,
              df,
              startCol = 1,
              startRow = start_row)
  } else{
    # if the table name is empty, make it the table_sheet_name
    if (excel_table_name == ""){
      excel_table_name = paste0("table_",sheet_name)
    }
    # next any spaces need to be replaced
    excel_table_name <- gsub("([[:punct:]]|[[:space:]])+","_",excel_table_name)
    # this writes to a table in `Excel`, this is more accessible
    writeDataTable(wb,
                  sheet_name,
                  df,
                  startCol = 1,
                  startRow = start_row,
                  tableName = excel_table_name,
                  tableStyle = "none",
                  headerStyle = NULL
                  )
  }

  # now lets calculate the range of the styles
  row_range <- (start_row + 1):(nrow(df) + start_row + 1)
  # create all the styles
  # now lets add on all the styles
  for (i in 1:ncol(df)){
    addStyle(wb = wb,
             sheet = sheet_name,
             style = column_to_style(x[,i]),
             rows = row_range,
             cols = i,
             gridExpand = TRUE)
  }
}

convert_xlr_type_to_R <- function(x,
                                   call = caller_env()){
  # Lets only convert xlr types, if not we skip the column
  x |>
    lapply(function(x){
        if(is_xlr_type(x)){
          if (is_xlr_n_percent(x)){
            y <- vec_cast(x,character())
            return(y)
          }
          y <- as_base_r(x)
          return(y)
        }
        x
    }) |>
    as.data.frame(check.names = FALSE)
}

#' convert a column into a format
#' @param col is a column from a data.frame
#'
#' @noRd
column_to_style <- function(col){
  # first we have rules for all the xlr types (and integers)

  if (is_xlr_n_percent(col)) {
    column_cell_format <- "GENERAL"
  }
  if (is_xlr_percent(col)){
    column_cell_format <- paste0(generate_dp(pull_dp(col)),"%")
  }
  else if(is_xlr_integer(col) || is.integer(col)){
    column_cell_format <- "0"
  }
  else if(is_xlr_numeric(col)){
    # Two different formats: One for scientific, one standard
    if (pull_attr(col, "scientific")){
      column_cell_format <- paste0(generate_dp(pull_dp(col)),"E+00")
    } else{
      column_cell_format <- generate_dp(pull_dp(col))
    }
  }
  else if(is_xlr_vector(col)){
    # Lets actually pull out the underlying data and call it again
    col <- as_base_r(col)
    # we return early, with a sneaky recursive call
    return(column_to_style(col))
  }
  # this should only capture proper doubles
  else if(is_bare_double(col)){
    column_cell_format <- "0.00"
  }
  else if(inherits(col,"Date")){
    column_cell_format <- "dd/mm/yyyy"
  }
  else if(is.numeric(col)){
    column_cell_format <- "numFmt"
  }
  else{
    column_cell_format <- "GENERAL"
  }
  # now lets pull out the xlr format information if it exists,
  # if it doesn't, we generate an empty xlr_format
  format_data <- pull_style(col)
  if (is.null(format_data)){
    format_data <- xlr_format()
  }
  # new lets create the format
  xlr_format_to_openxlsx_format(format_data,
                                 cell_format = column_cell_format)

}

#' Return the `Excel` formatted number of dp
#'
#' @param dp integer, the number of decimal places
#' @param call the caller environment
#'
#' @return a string with the format code
#'
#' @noRd
generate_dp <- function(dp,
                        call = caller_env()){

  fmt_str <- "0"
  if (dp == 0){
    return(fmt_str)
  }
  else if (dp < 0){
    cli_abort("dp must be greater than zero.",
              call = call)
  }
  else{
    return(paste0(fmt_str,".",paste0(rep(fmt_str,dp),collapse="")))
  }
}

xlr_format_to_openxlsx_format <- function(x,
                                           cell_format = "GENERAL",
                                           call = caller_env(2)){

  type_abort(x,is_xlr_format,xlr_format(),call = call)

  text_rotation <- attr(xlr_format(),which="text_rotation")
  if (text_rotation == 0){
    text_rotation <- NULL
  }
  indent <- attr(x,which="indent")
  if (indent == 0){
    indent <- NULL
  }
  createStyle(
    fontName = attr(x,which="font"),
    fontSize = attr(x,which="font_size"),
    fontColour = attr(x,which = "font_colour"),
    numFmt = cell_format,

    # border info
    border = attr(x,which = "border"),
    borderColour = attr(x,which="border_colour"),
    borderStyle = attr(x,which="border_style"),
    # cell colour
    bgFill = NULL,
    fgFill = attr(x,which="background_colour"),
    # cell formatting
    halign = attr(x,which="halign"),
    valign = attr(x,which="valign"),
    textDecoration = attr(x,which = "text_style"),
    wrapText = attr(x,which="wrap_text"),
    textRotation = text_rotation,
    indent = indent,

    # `Excel` extra's
    locked = NULL,
    hidden = NULL
  )
}


