# create_list_names() creates the correct inform

    Code
      create_list_names(list_data)
    Message
      > There are unnamed objects in argument `x`. Generating names for the empty object.
    Output
      [1] "Table 1" "test1"   "Table 2" "test2"   "Table 3" "Table 4"

# create_list_names() does not duplicate when a table is called table 1 and some is missing

    Code
      create_list_names(list_data)
    Condition
      Error in `create_list_names()`:
      ! The sheet names provided are invalid. You can't have missing sheet names, and a sheet named "table 1".
      i If you passed a named list to `write_xlsx()`, remove the names before preceeding, or name all the elements manually.

# append_worksheet() creates an error when we try to overwrite data that exists

    Code
      append_worksheet("test1", wb, FALSE)
    Condition
      Error:
      ! "test1" already exists in the workbook.
      i set `overwrite_sheet` = TRUE if you want to overwrite it.

# generate_dp() creates an appropriate error if dp < 0

    Code
      generate_dp(-1)
    Condition
      Error:
      ! dp must be greater than zero.

# data_to_worksheet() gives an error if a sheet doesn't exist.

    Code
      data_to_worksheet(mtcars, wb, "Test 1")
    Condition
      Error:
      ! The sheet "Test 1" does not exist in your workbook.
      i Add it first with `openxlsx::addWorkSheet()`.

# xlr_table_to_sheet() aborts if the sheets don't exist

    Code
      xlr_table_to_sheet(xlr_table(data.frame()), wb, "test")
    Condition
      Error:
      ! The sheet "test" does not exist in your workbook.
      i Add it first with `openxlsx::addWorkSheet()`.

# xlr_table_to_sheet() creates the approriate error messages when x is missing columsn or rows

    Code
      xlr_table_to_sheet(xlr_table(data.frame()), wb, "test")
    Condition
      Error:
      i In argument: `x`.
      ! Your <xlr_table> "test" must contain columns.

---

    Code
      xlr_table_to_sheet(xlr_table(data.frame(data = character())), wb, "test")
    Condition
      Warning:
      i In argument: `x`.
      Your <xlr_table> "test" has no data in it's rows.

# dataframe_to_sheet() errors if the sheet does not exist

    Code
      dataframe_to_sheet(mtcars, wb, "Test 1 - wo TOC")
    Condition
      Error:
      ! The sheet "Test 1 - wo TOC" does not exist in your workbook.
      i Add it first with `openxlsx::addWorkSheet()`.

# dataframe_to_sheet() creates the approriate error messages when x is missing columsn or rows

    Code
      dataframe_to_sheet(data.frame(), wb, "test")
    Condition
      Error:
      i In argument: `x`.
      ! Your data frame or tibble must contain columns.

---

    Code
      dataframe_to_sheet(data.frame(data = character()), wb, "test")
    Condition
      Warning:
      i In argument: `x`.
      ! Your data frame or tibble has no data in it's rows.

# xlr_to_workbook() creates an error when you pass an empty list

    Code
      xlr_to_workbook(list())
    Condition
      Error:
      i In argument: `x`.
      ! The list does not contain any elements!

# xlr_to_workbook() checks the sheet_name type correctly

    Code
      xlr_to_workbook(mtcars, sheet_name = 1)
    Condition
      Error:
      i In argument: `sheet_name`.
      ! `sheet_name` must be NULL or a string, not a number.

---

    Code
      xlr_to_workbook(mtcars, "test", 1)
    Condition
      Error:
      i In argument: `old_wb`.
      ! `old_wb` must be NULL or a openxlsx Workbook, not a number.

# xlr_to_workbook() checks the overwrite_sheet type correctly

    Code
      xlr_to_workbook(mtcars, "test", overwrite_sheet = "wee")
    Condition
      Error:
      i In argument: `overwrite_sheet`.
      ! `overwrite_sheet` must be TRUE or FALSE, not a string.

# xlr_to_workbook() checks the TOC type correctly

    Code
      xlr_to_workbook(mtcars, "test", TOC = "wee")
    Condition
      Error:
      i In argument: `TOC`.
      ! `TOC` must be TRUE or FALSE, not a string.

# xlr_to_workbook() checks the TOC_title type correctly

    Code
      xlr_to_workbook(mtcars, "test", TOC = TRUE, TOC_title = FALSE)
    Condition
      Error:
      i In argument: `TOC_title`.
      ! `TOC_title` must be a string, not `FALSE`.

# xlr_to_workbook() checks the excel_data_table type correctly

    Code
      xlr_to_workbook(mtcars, "test", excel_data_table = "TITLE")
    Condition
      Error:
      i In argument: `excel_data_table`.
      ! `excel_data_table` must be TRUE or FALSE, not a string.

# xlr_to_workbook() errors when you pass a sheet_name, and a list of data

    Code
      xlr_to_workbook(list(mtcars, mtcars), "test")
    Condition
      Warning:
      i In argument: `sheet_name`.
      ! `sheet_name` is not NULL. This argument does nothing when you pass a list to argument `x`.
    Output
      A Workbook object.
       
      Worksheets:
       Sheet 1: "Table 1"
       
      	Custom column widths (column: width)
      	  1: 10, 2: 10, 3: 10, 4: 10, 5: 10, 6: 10, 7: 10, 8: 10, 9: 10, 10: 10, 11: 10 
       
      
       Sheet 2: "Table 2"
       
      	Custom column widths (column: width)
      	  1: 10, 2: 10, 3: 10, 4: 10, 5: 10, 6: 10, 7: 10, 8: 10, 9: 10, 10: 10, 11: 10 
       
      
       
       Worksheet write order: 1, 2
       Active Sheet 1: "Table 1" 
      	Position: 1
      

# xlr_to_workbook() errors when you pass the wrong type in a list

    Code
      xlr_to_workbook(list("asd", 123))
    Condition
      Error:
      i In argument: `y`.
      ! `y` must be <data.frame>, <tibble>, or <xlr_table>, not a string.

# xlr_to_workbook() errors when you pass the wrong type

    Code
      xlr_to_workbook(123)
    Condition
      Error:
      i In argument: `x`.
      ! `x` must be <data.frame>, <tibble>, or <xlr_table>, not a number.

# xlr_to_workbook() errors when you pass a single object but not a sheetname

    Code
      xlr_to_workbook(mtcars)
    Condition
      Error:
      i In argument: `sheet_name`.
      ! `sheet_name` cannot be missing when you provide a single sheet.

