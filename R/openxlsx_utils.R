
is_openxlsx_workbook <- function(wb){
  inherits(wb,what = c("Workbook","openxlsx"))
}

is_workbook_error <- function(wb,
                              call = caller_env()){
  argname <- deparse(substitute(wb))
  if (!is_openxlsx_workbook(wb)){
    cli_abort(c("!" = "Argument {.arg {argname}} is not an `openxlsx` workbook."),
              call = call)
  }
}
# utils for openxlsx
equal_workbook_sheets <- function(wb1,wb2){
  is_workbook_error(wb1)
  is_workbook_error(wb2)
  isTRUE(all.equal(sheets(wb1),sheets(wb2)))
}

error_if_sheet_not_exists <- function(wb,
                                    sheet,
                                    call = caller_env()){
  if (!(sheet %in% names(wb))){
    cli_abort(c("!" = "The sheet {.val {sheet}} does not exist in your workbook.",
                "i" = "Add it first with {.fun openxlsx::addWorkSheet}."),
              call = call)
  }
}

detect_title_in_sheet <- function(wb,
                                  sheet){
  is_workbook_error(wb)
  error_if_sheet_not_exists(wb,sheet)

  # we define a title exists if the first row only has data in 1,1
  first_row_data <-
    readWorkbook(wb,
                 sheet=sheet,
                 rows = 1) |>
      suppressWarnings()
  # openxlsx always returns a data.frame
  # now we look at the number of columns, if it is one there is
  # a title, if not it does not contain a title

  ifelse(is.null(first_row_data),FALSE,ncol(first_row_data) == 1)
}

get_all_workbook_data <- function(wb,
                                  detect_title = TRUE){
  is_workbook_error(wb)
  lapply(sheets(wb), function(x){
    s_row <- ifelse(detect_title_in_sheet(wb,x) && detect_title,2,1)

    readWorkbook(wb,x,startRow = s_row) |>
      suppressWarnings()
  })
}

equal_workbook_data <- function(wb1,wb2){
  is_workbook_error(wb1)
  is_workbook_error(wb2)

  # read the data from both and see if it is equal
  data1 <- get_all_workbook_data(wb1)
  data2 <- get_all_workbook_data(wb2)
  # return true if these are nearly equal
  isTRUE(all.equal(data1,data2))
}
# This is broken because GetStyle is broken
# getStyles_safe <- function(wb,
#                            call = caller_env()){
#
#   # first catch if it is a workbook
#   tryCatch(getStyles(wb),
#            error = function(e){
#              if(conditionMessage(e)=="Workbook has no existing styles."){
#                return(NULL)
#              }
#              else{
#                return(e)
#              }
#            })
# }
#
# equal_workbook_styles <- function(wb1,wb2){
#   # for some reason openxlsx returns an error if there are no styles
#   # instead of a warning, we need to catch it, and return NULL if it is an
#   # error
#   is_workbook_error(wb1)
#   is_workbook_error(wb2)
#   isTRUE(all.equal(getStyles_safe(wb1),getStyles_safe(wb2)))
# }

# now we define equal workbooks
equal_openxlsx_workbook <- function(wb1,wb2){
  # first test both are openxlsx workbooks
  is_workbook_error(wb1)
  is_workbook_error(wb2)
  # next test the contents
  any(equal_workbook_sheets(wb1,wb2),
      equal_workbook_data(wb1,wb2)
      # equal_workbook_styles(wb1,wb2)
      )
}
