


test_that("create_list_names() creates names for an empty list", {
   list_data <- list(1,2,3,4,5,6)
  names(list_data) <- c()
  expect_equal(create_list_names(list_data),
               c("Table 1","Table 2","Table 3","Table 4","Table 5","Table 6"))
})

test_that("create_list_names() does not create names for a named list", {
  list_data <- list(1,2,3,4,5,6)
  # should do nothing if it has names
  names(list_data) <- as.character(1:6)
  expect_equal(create_list_names(list_data),
               c('1','2','3','4','5','6'))
})


test_that("create_list_names() creates names if some of the names are missing", {
  list_data <- list(1,2,3,4,5,6)
  sheet_names <- c("","test1","","test2","","")
  names(list_data) <- sheet_names

  expect_equal(create_list_names(list_data) |>
                 suppressMessages(),
               c("Table 1","test1","Table 2","test2","Table 3","Table 4"))
})


test_that("create_list_names() creates the correct inform", {
  list_data <- list(1,2,3,4,5,6)
  sheet_names <- c("","test1","","test2","","")
  names(list_data) <- sheet_names

  expect_snapshot(create_list_names(list_data))
})

test_that("create_list_names() does not duplicate when a table is called table 1 and some is missing", {
  list_data <- list(1,2,3,4,5,6)
  sheet_names <- c("table 1","table 2","","table 3","","")
  names(list_data) <- sheet_names

  expect_snapshot(create_list_names(list_data),
                  error = TRUE)
})

test_that("append_worksheet() creates worksheets as expected",{
  sheet_names <- paste0("test",c(1:3))
  wb <- createWorkbook()

  test_wb <- createWorkbook()
  addWorksheet(test_wb,"test1")
  addWorksheet(test_wb,"test2")
  addWorksheet(test_wb,"test3")

  # test that the workbook has the correct sheets
  lapply(sheet_names,\(x) append_worksheet(x,wb))
  # we can't test directly
  expect_true(equal_workbook_sheets(test_wb,wb))
})


test_that("append_worksheet() creates an error when we try to overwrite data that exists",{
  # now test that it over-writes data that already exist
  wb <- createWorkbook()
  addWorksheet(wb,"test1")
  # now we add some data to our worksheet that it gets over-written
  writeData(wb,"test1",mtcars)
  expect_snapshot(append_worksheet("test1",wb,FALSE),
                  error = TRUE)
})



test_that("convert_xlr_type_to_R() works correctly",{

  x <- data.frame(c1 = 1:10,
                  c2 = xlr_percent(1:10/100),
                  c3 = xlr_numeric(1:10),
                  c4 = xlr_integer(1:10),
                  c5 = xlr_vector(rep("a",10)),
                  c6 = rep("a",10),
                  c7 = xlr_n_percent(1:10,1:10/100))

  output = data.frame(c1 = 1:10,
                       c2 = 1:10/100,
                       c3 = 1:10,
                       c4 = as.integer(1:10),
                       c5 = rep("a",10),
                       c6 = rep("a",10),
                      c7 = vec_cast(xlr_n_percent(1:10,1:10/100),character())
  )
  expect_equal(convert_xlr_type_to_R(x),output)

})

test_that("generate_dp() works runs",{

  expect_equal(generate_dp(0),"0")
  expect_equal(generate_dp(2),"0.00")
})

test_that("generate_dp() creates an appropriate error if dp < 0",{
  expect_snapshot(generate_dp(-1),
                  error = TRUE)
})

test_that("xlr_format_to_openxlsx_format() works correctly",{

  expect_error(xlr_format_to_openxlsx_format("car"))

  output_style <- createStyle(
    fontName = "calibri",
    fontSize = 11,
    fontColour = "black",
    numFmt = "GENERAL",
    border = NULL,
    borderColour = "black",
    borderStyle = "thin",
    bgFill = NULL,
    fgFill = NULL,
    halign = "left",
    valign = "top",
    textDecoration = NULL,
    wrapText = FALSE,
    textRotation = NULL,
    indent = NULL,
    locked = NULL,
    hidden = NULL
  )

  expect_equal(xlr_format_to_openxlsx_format(xlr_format()),
               output_style)
})

test_that("column_to_style() works with a data.frame",{
  x <- data.frame(c1 = as.double(1:10))
  expect_equal(column_to_style(x[,"c1"]),
               xlr_format_to_openxlsx_format(xlr_format(),"0.00"))

})

test_that("column_to_style() handles double() correctly",{
  expect_equal(column_to_style(as.double(1:10)),
               xlr_format_to_openxlsx_format(xlr_format(),"0.00"))
})

test_that("column_to_style() handles xlr_percent() correctly",{
  expect_equal(column_to_style(xlr_percent(1:10/100)),
             xlr_format_to_openxlsx_format(xlr_format_numeric(),"0%"))
  expect_equal(column_to_style(xlr_percent(1:10/100,2)),
               xlr_format_to_openxlsx_format(xlr_format_numeric(),"0.00%"))
})

test_that("column_to_style() handles xlr_numeric() correctly",{
  expect_equal(column_to_style(xlr_numeric(1:10,0)),
               xlr_format_to_openxlsx_format(xlr_format_numeric(),"0"))
  expect_equal(column_to_style(xlr_numeric(1:10,2)),
               xlr_format_to_openxlsx_format(xlr_format_numeric(),"0.00"))
})

test_that("column_to_style() handles xlr_numeric() and scientific notation correctly",{
  expect_equal(column_to_style(xlr_numeric(1:10,0,scientific = TRUE)),
               xlr_format_to_openxlsx_format(xlr_format_numeric(),"0E+00"))
  expect_equal(column_to_style(xlr_numeric(1:10,2,scientific = TRUE)),
               xlr_format_to_openxlsx_format(xlr_format_numeric(),"0.00E+00"))
  expect_equal(column_to_style(xlr_numeric(1:10,3,scientific = TRUE)),
               xlr_format_to_openxlsx_format(xlr_format_numeric(),"0.000E+00"))
})

test_that("column_to_style() handles xlr_integer() correctly",{
  expect_equal(column_to_style(xlr_integer(1:10)),
               xlr_format_to_openxlsx_format(xlr_format_numeric(),"0"))
})

test_that("column_to_style() handles xlr_vector() correctly",{
  expect_equal(column_to_style(xlr_vector(rep("a",10))),
               xlr_format_to_openxlsx_format(xlr_format(),"GENERAL"))
})

test_that("column_to_style() handles character() correctly",{
  expect_equal(column_to_style(rep("a",10)),
               xlr_format_to_openxlsx_format(xlr_format(),"GENERAL"))
})

test_that("column_to_style() handles Date() correctly",{
  expect_equal(column_to_style(rep(as.Date(c("2022-02-02","1999-05-03")),5)),
               xlr_format_to_openxlsx_format(xlr_format(), "dd/mm/yyyy"))
})

test_that("column_to_style() handles xlr_n_percent() correctly",{
  expect_equal(column_to_style(xlr_n_percent(1,1)),
               xlr_format_to_openxlsx_format(xlr_format_numeric(), "GENERAL"))
})


test_that("create_column_widths() test that the column width is good", {

  col1_test <- paste0(rep("a",30),collapse="")
  col2_test <- paste0(rep("a",90),collapse="")
  col3_test <- paste0(rep("a",6),collapse="")

  data <- mtcars |>
    mutate("{col1_test}" := rep("This is some text",nrow(mtcars)),
           "{col2_test}" := rep("This is some text",nrow(mtcars)),
           "{col3_test}" := rep("This is some text",nrow(mtcars)))

  col_data <- create_column_widths(data)

  expect_equal(nrow(col_data),2)
  expect_equal(col_data[["index"]],c(12,13))
  expect_equal(col_data[["cell_width"]],c(30,30))
})


test_that("get_border_styles() returns nothing if we don't specify any borders", {
  border_style <- xlr_format()
  expect_equal(get_border_styles(border_style),
               NULL)
})


test_that("get_border_styles() the default border style works for a single border", {
  border_style <- xlr_format(border = "left")

  expect_equal(get_border_styles(border_style),
               list("left" = createStyle(border = "LEFT",
                           borderColour = "black",
                           borderStyle = "thin"))
                    )
})


test_that("get_border_styles() works for multiple borders", {
  border_style <- xlr_format(border = c("left","right"))

  expect_equal(get_border_styles(border_style),
               list("left" = createStyle(border = "left",
                                         borderColour = "black",
                                         borderStyle = "thin"),
                    "right" = createStyle(border = "right",
                                         borderColour = "black",
                                         borderStyle = "thin"))
  )
})

test_that("get_border_styles() works for multiple borders and colours", {
  border_style <- xlr_format(border = c("left","right"),
                              border_colour = c("red","blue"))

  expect_equal(get_border_styles(border_style),
               list("left" = createStyle(border = "left",
                                         borderColour = "red",
                                         borderStyle = "thin"),
                    "right" = createStyle(border = "right",
                                          borderColour = "blue",
                                          borderStyle = "thin"))
  )
})

test_that("get_border_styles() works for multiple borders and style", {
  border_style <- xlr_format(border = c("left","right"),
                              border_style = c("medium","hair"))


  expect_equal(get_border_styles(border_style),
               list("left" = createStyle(border = "left",
                                         borderColour = "black",
                                         borderStyle = "medium"),
                    "right" = createStyle(border = "right",
                                          borderColour = "black",
                                          borderStyle = "hair"))
  )
})

test_that("get_border_styles() works for multiple borders, colour and style", {
  border_style <- xlr_format(border = c("left","right"),
                              border_style = c("medium","hair"),
                              border_colour = c("red","blue"))


  expect_equal(get_border_styles(border_style),
               list("left" = createStyle(border = "left",
                                         borderColour = "red",
                                         borderStyle = "medium"),
                    "right" = createStyle(border = "right",
                                          borderColour = "blue",
                                          borderStyle = "hair"))
  )
})


test_that("add_TOC_to_workbook() works", {
  test_file <- test_path("test_xlsx_files","add_TOC_to_workbook.xlsx")
  # now get it as workbook
  wb_test <- openxlsx::loadWorkbook(test_file)
  # now create a work
  wb <- createWorkbook()
  x_list_data <- list("Test Sheet 1" = xlr_table(mtcars,
                                                  "Test title 1"),
                      "Test Sheet 2" = xlr_table(mtcars,
                                                  "Test title 2"),
                      "Test Sheet 3" = xlr_table(mtcars,
                                                  "Test title 3"))


  # now create a table of contents
  add_TOC_to_workbook(wb,
                      x_list_data,
                      names(x_list_data),
                      NULL,
                      "Test TOC Title")
  expect_true(equal_workbook_sheets(wb,wb_test))
  # I can't get this test to work, openxlsx is doing something very weird
  # expect_true(equal_workbook_data(wb,wb_test))

})

test_that("add_TOC_to_workbook() adds the table of contents sheet if it does not exist",{
  wb <- createWorkbook()
  add_TOC_to_workbook(wb,mtcars,"test")
  # now test if the
  expect_true("Table of Contents" %in% sheets(wb))
})

test_that("add_TOC_to_workbook() overwrites the TOC data if it exists",{
  wb <- createWorkbook()
  toc_sheet <- "Table of Contents"
  append_worksheet(toc_sheet,wb)
  # now add the data
  writeData(wb,toc_sheet,mtcars)
  add_TOC_to_workbook(wb,
                      list(xlr_table(mtcars,"Test 1"),
                           xlr_table(mtcars,"Test 2")),
                      c("test1","test2"))

  # now read the data back in
  # If
  data <- readWorkbook(wb,
                       sheet=toc_sheet)
  # now test if the
  expect_false(isTRUE(all.equal(mtcars,data)))
})

test_that("add_TOC_to_workbook() pulls the titles and writes them if they exist",{
  wb <- createWorkbook()
  toc_sheet <- "Table of Contents"
  append_worksheet(toc_sheet,wb)
  # now add the data
  writeData(wb,toc_sheet,mtcars)
  add_TOC_to_workbook(wb,
                      list(xlr_table(mtcars,"test_1"),
                                     xlr_table(mtcars,"test_2"),
                                     mtcars,
                                     xlr_table(mtcars,"test_3")),
                      c("1","2","3","4"))

  # lets save the data
  # now read the data back in
  data <- readWorkbook(wb,
                       sheet=toc_sheet,
                       rows = c(1:5),
                       cols = c(1:2),
                       skipEmptyCols = FALSE,
                       skipEmptyRows = FALSE,
                       colNames = FALSE)
  colnames(data) <- c("hyperlink","titles")
  # now test if the
  expect_equal(data[["titles"]],c("test_1","test_2",NA,"test_3"))
})

test_that("add_TOC_to_workbook() pulls the titles and writes them if they exist",{
  wb <- createWorkbook()
  toc_sheet <- "Table of Contents"
  append_worksheet(toc_sheet,wb)
  # now add the data
  writeData(wb,toc_sheet,mtcars)
  add_TOC_to_workbook(wb,
                      list(xlr_table(mtcars,"test_1"),
                              xlr_table(mtcars,"test_2"),
                              mtcars,
                              xlr_table(mtcars,"test_3")),
                      c("1","2","3","4"))

  # lets save the data
  # now read the data back in
  data <- readWorkbook(wb,
                       sheet=toc_sheet,
                       rows = c(1:5),
                       cols = c(1:2),
                       skipEmptyCols = FALSE,
                       skipEmptyRows = FALSE,
                       colNames = FALSE)
  colnames(data) <- c("hyperlink","titles")
  # now test if the
  expect_equal(data[["titles"]],c("test_1","test_2",NA,"test_3"))
})


test_that("add_TOC_to_workbook() adds a title",{
    wb <- createWorkbook()
    toc_sheet <- "Table of Contents"
    append_worksheet(toc_sheet,wb)
    # now add the data
    writeData(wb,toc_sheet,mtcars)
    add_TOC_to_workbook(wb,
                        mtcars,
                        c("test1","test2"),
                        NULL,
                        "Did this title get added")

    # now read the data back in
    data <- readWorkbook(wb,
                         sheet=toc_sheet,
                         rows = 1,
                         cols = 1,
                         colNames = FALSE)
    expect_equal(data[1,1],"Did this title get added")
})


test_that("add_TOC_to_workbook() writes hyperlinks to each sheet correctly and saves nicely",{
  wb <- createWorkbook()
  toc_sheet <- "Table of Contents"
  sheets <- c("t1","t2","t3","t4")
  sapply(sheets,\(s) append_worksheet(s,wb))

  # add the table of contents
  add_TOC_to_workbook(wb,
                      list(xlr_table(mtcars,"test_1"),
                            xlr_table(mtcars,"test_2"),
                            mtcars,
                            xlr_table(mtcars,"test_3")),
                      sheets,
                      NULL,
                      "This is a test title")

  expect_true(TRUE)
  # now write the data
  skip_on_cran()
  test_output <- test_path("_output_excel_snaps/add_TOC_to_workbook.xlsx")
  # we use openxlsx to write it
  saveWorkbook(wb,
               test_output,
               overwrite = TRUE)
})


test_that("add_TOC_to_workbook() adds the sheet names and titles from an existing workbook",{

  # Now lets create an 'old workbook', it has a mix of sheets that
  # exist already and that don't
  old_wb <- createWorkbook()
  old_sheets <- c("t1","t2","old1","old2")
  sapply(old_sheets,\(s) append_worksheet(s,old_wb))
  # Now lets add data to all of them to test the titles
  sapply(old_sheets, \(s) writeData(old_wb,s,paste0("old_title_",s)))


  # now lets copy what we do in xlr_to_workbook and append all the old sheets
  wb <- copyWorkbook(old_wb)
  toc_sheet <- "Table of Contents"
  sheets <- c("t1","t2","t3","t4")
  sapply(sheets,\(s) append_worksheet(s,wb))

  # add the table of contents
  add_TOC_to_workbook(wb,
                      list(xlr_table(mtcars,"test_1"),
                           xlr_table(mtcars,"test_2"),
                           mtcars,
                           xlr_table(mtcars,"test_3")),
                      sheets,
                      old_wb,
                      "This is a test title")

  # next we expect the titles to be in the correct order
  data <- readWorkbook(wb,
                       sheet=toc_sheet,
                       startRow = 2,
                       cols = c(1:2),
                       skipEmptyCols = FALSE,
                       skipEmptyRows = FALSE,
                       colNames = FALSE)
  colnames(data) <- c("hyperlink","titles")
  # now test if the
  expect_equal(data[["titles"]],
               c("old_title_old1",
                 "old_title_old2",
                 "test_1",
                 "test_2",
                 NA,
                 "test_3"))
  # now write the data
  skip_on_cran()
  test_output <- test_path("_output_excel_snaps/add_TOC_to_workbook_old_workbook.xlsx")
  # we use openxlsx to write it
  saveWorkbook(wb,
               test_output,
               overwrite = TRUE)
})


test_that("data_to_worksheet() generates data correctly",{
  test_df <-
    data.frame(test_r_numeric = mtcars$mpg,
               test_r_integer = as.integer(mtcars$cyl),
               test_xlr_numeric = xlr_numeric(mtcars$disp, dp = 0),
               test_xlr_vector = xlr_vector(mtcars$hp),
               test_xlr_numeric = xlr_numeric(mtcars$drat, dp = 4),
               test_xlr_percent = xlr_percent(mtcars$wt,dp =2),
               test_r_char = rep("test",nrow(mtcars)),
               test_xlr_scientific = xlr_numeric(mtcars$qsec,scientific = TRUE),
               test_r_factor = factor(rep(c("a","b"),16)),
               test_r_complex = rep(1+1i, nrow(mtcars)),
               test_xlr_n_percent = xlr_n_percent(1:nrow(mtcars),1:nrow(mtcars)/nrow(mtcars))
    )
  wb <- createWorkbook()
  addWorksheet(wb,"Test 1")
  data_to_worksheet(test_df,wb,"Test 1")

  # next we load in our test workbook
  test_file <- test_path("test_xlsx_files","data_to_worksheet.xlsx")
  # now get it as workbook
  wb_test <- openxlsx::loadWorkbook(test_file)
  # now lets see if the data is the same
  expect_true(equal_workbook_sheets(wb,wb_test))
  expect_true(equal_workbook_data(wb,wb_test))

  # We skip saving the output on cran because it requires `Excel`-----------------
  skip_on_cran()

  # This is a like a snapshot test, we look whether the data is what we think
  # it should be
  test_output <- test_path("_output_excel_snaps/data_to_worksheet.xlsx")
  # we use openxlsx to write it
  saveWorkbook(wb,
               test_output,
               overwrite = TRUE)
})

test_that("data_to_worksheet() gives an error if a sheet doesn't exist.",{

  wb <- createWorkbook()
  expect_snapshot(data_to_worksheet(mtcars,wb,"Test 1"),
                  error = TRUE)
})


test_that("data_to_worksheet() adds data correctly, we check all types",{

  test_df <-
    data.frame(test_r_numeric = mtcars$mpg,
           test_r_integer = as.integer(mtcars$cyl),
           test_xlr_numeric = xlr_numeric(mtcars$disp, dp = 0),
           test_xlr_vector = xlr_vector(mtcars$hp),
           test_xlr_numeric = xlr_numeric(mtcars$drat, dp = 4),
           test_xlr_percent = xlr_percent(mtcars$wt,dp =2),
           test_r_char = rep("test",nrow(mtcars)),
           test_xlr_scientific = xlr_numeric(mtcars$qsec,scientific = TRUE),
           test_r_factor = factor(rep(c("a","b"),16)),
           test_r_complex = rep(1+1i, nrow(mtcars)),
           test_xlr_n_percent = xlr_n_percent(1:nrow(mtcars),1:nrow(mtcars)/nrow(mtcars))
           )

  wb <- createWorkbook()
  addWorksheet(wb,"Test 1")
  data_to_worksheet(test_df,
                    wb,
                    "Test 1",
                    excel_data_table = TRUE)

  # next we load in our test workbook
  test_file <- test_path("test_xlsx_files","data_to_worksheet.xlsx")
  # now get it as workbook
  wb_test <- openxlsx::loadWorkbook(test_file)
  # now lets see if the data is the same
  expect_true(equal_workbook_sheets(wb,wb_test))
  expect_true(equal_workbook_data(wb,wb_test))

  # We skip saving the output on cran because it requires `Excel`-----------------
  skip_on_cran()

  # This is a like a snapshot test, we look whether the data is what we think
  # it should be
  test_output <- test_path("_output_excel_snaps/data_to_worksheet_data_table.xlsx")
  # we use openxlsx to write it
  saveWorkbook(wb,
               test_output,
               overwrite = TRUE)
})

test_that("data_to_worksheet() can change the data table names",{
  test_df <-
    data.frame(test_r_numeric = mtcars$mpg,
               test_r_integer = as.integer(mtcars$cyl),
               test_xlr_numeric = xlr_numeric(mtcars$disp, dp = 0),
               test_xlr_vector = xlr_vector(mtcars$hp),
               test_xlr_numeric = xlr_numeric(mtcars$drat, dp = 4),
               test_xlr_percent = xlr_percent(mtcars$wt,dp =2),
               test_r_char = rep("test",nrow(mtcars)),
               test_xlr_scientific = xlr_numeric(mtcars$qsec,scientific = TRUE),
               test_r_factor = factor(rep(c("a","b"),16)),
               test_r_complex = rep(1+1i, nrow(mtcars)),
               test_xlr_n_percent = xlr_n_percent(1:nrow(mtcars),1:nrow(mtcars)/nrow(mtcars))
    )

  wb <- createWorkbook()
  addWorksheet(wb,"Test 1")
  data_to_worksheet(test_df,
                    wb,
                    "Test 1",
                    excel_data_table = TRUE,
                    # Look at if we are able to change the `Excel` table name
                    excel_table_name = "table_test_")
  # We haven't skipped the test, checking if it worked
  expect_true(TRUE)
  # We skip saving the output on cran because it requires `Excel`-----------------
  skip_on_cran()
  # This is a like a snapshot test, we look whether the data is what we think
  # it should be
  test_output <- test_path("_output_excel_snaps/data_to_worksheet_data_table_name.xlsx")
  # we use openxlsx to write it
  saveWorkbook(wb,
               test_output,
               overwrite = TRUE)
})

test_that("xlr_table_to_sheet() works", {
  test_file <- test_path("test_xlsx_files","xlr_table_to_sheet.xlsx")
  # now get it as workbook
  wb_test <- openxlsx::loadWorkbook(test_file)
  # now create a work
  wb <- createWorkbook()
  sheet_names <- c("Table of Contents",
                   "Test 1 - wo TOC Footnote Title",
                   "Test 2 - wo TOC Footnote",
                   "Test 3 - w TOC wo footnote",
                   "Test 4 - all")

  lapply(sheet_names,\(x) append_worksheet(x,wb))

  test_df <-
    mtcars |>
    mutate(mpg = mpg,
           cyl = as.integer(cyl),
           disp = xlr_numeric(disp, dp = 0),
           hp = xlr_vector(hp),
           drat = xlr_numeric(drat, dp = 4),
           wt = xlr_percent(wt,dp =2),
           vs = rep("test",nrow(mtcars)),
           `This is a very long title what does it look` = rep("This is some text",nrow(mtcars))) |>
    suppressWarnings()

  table_no_title_footnote <- xlr_table(test_df)
  table_no_footnote <- xlr_table(test_df,
                                  "Test title")
  table_all <- xlr_table(test_df,
                          "Test title",
                          "Test footnote")
  # now add 5 different workbooks
  xlr_table_to_sheet(table_no_title_footnote,
                      wb,
                      "Test 1 - wo TOC Footnote Title")
  xlr_table_to_sheet(table_no_footnote,
                      wb,
                      "Test 2 - wo TOC Footnote",
                      TOC = TRUE)
  xlr_table_to_sheet(table_no_footnote,
                      wb,
                      "Test 3 - w TOC wo footnote",
                      TOC = TRUE)
  xlr_table_to_sheet(table_all,
                      wb,
                      "Test 4 - all",
                      TOC = TRUE)

  expect_true(equal_workbook_sheets(wb,wb_test))

  # manually checked below, this was correct
  # expect_true(equal_workbook_data(wb,wb_test))

  # now see if they have the same data
  # expect_true(equal_openxlsx_workbook(wb,wb_test))

  #- save the data to check manually
  skip_on_cran()
  test_output <- test_path("_output_excel_snaps/xlr_table_to_sheet.xlsx")
  # we use openxlsx to write it
  saveWorkbook(wb,
               test_output,
               overwrite = TRUE)
})


test_that("xlr_table_to_sheet() aborts if the sheets don't exist", {
  wb <- createWorkbook()
  append_worksheet("mhmm",wb)

  expect_snapshot(xlr_table_to_sheet(xlr_table(data.frame()),
                                      wb,
                                      "test"),
                  error = TRUE)
})

test_that("xlr_table_to_sheet() creates the approriate error messages when x is missing columsn or rows", {
  wb <- createWorkbook()
  append_worksheet("test",wb)

  expect_snapshot(xlr_table_to_sheet(xlr_table(data.frame()),wb,"test"),
                  error = TRUE)
  expect_snapshot(xlr_table_to_sheet(xlr_table(data.frame("data"=character())),
                                      wb,
                                      "test"))

})

test_that("dataframe_to_sheet() works", {
  test_file <- test_path("test_xlsx_files","dataframe_to_sheet.xlsx")
  # now get it as workbook
  wb_test <- openxlsx::loadWorkbook(test_file)
  # now create a work
  wb <- createWorkbook()
  sheet_names <- c("Table of Contents",
                   "Test 1 - wo TOC",
                   "Test 2 - w TOC")

  lapply(sheet_names,\(x) append_worksheet(x,wb))


  test_df <-
    mtcars |>
    mutate(mpg = mpg,
           cyl = as.integer(cyl),
           disp = xlr_numeric(disp, dp = 0),
           hp = xlr_vector(hp),
           drat = xlr_numeric(drat, dp = 4),
           wt = xlr_percent(wt,dp =2),
           vs = rep("test",nrow(mtcars)),
           `This is a very long title what does it look` = rep("This is some text",nrow(mtcars))) |>
    suppressWarnings()
  # now add 2 different workbooks
  dataframe_to_sheet(test_df,
                      wb,
                     "Test 1 - wo TOC")
  dataframe_to_sheet(test_df,
                      wb,
                     "Test 2 - w TOC",
                      TOC = TRUE)

  expect_true(equal_workbook_sheets(wb,wb_test))
  # expect_true(equal_workbook_data(wb,wb_test))
  # now see if they have the same data
  # expect_true(equal_openxlsx_workbook(wb,wb_test))
  skip_on_cran()
  test_output <- test_path("_output_excel_snaps/dataframe_to_sheet.xlsx")
  # we use openxlsx to write it
  saveWorkbook(wb,
               test_output,
               overwrite = TRUE)

})

test_that("dataframe_to_sheet() errors if the sheet does not exist", {
  wb <- createWorkbook()
  expect_snapshot(dataframe_to_sheet(mtcars,
                                     wb,
                                     "Test 1 - wo TOC"),
                  error = TRUE)
})

test_that("dataframe_to_sheet() creates the approriate error messages when x is missing columsn or rows", {
  wb <- createWorkbook()
  append_worksheet("test",wb)

  expect_snapshot(dataframe_to_sheet(data.frame(),wb,"test"),
                  error = TRUE)
  expect_snapshot(dataframe_to_sheet(data.frame("data"=character()),
                                      wb,
                                      "test"))
})

test_that("xlr_to_workbook() creates an error when you pass an empty list", {

  # test that an empty list generates an error
  expect_snapshot(xlr_to_workbook(list()),
                  error = TRUE)
})


test_that("xlr_to_workbook() checks the sheet_name type correctly", {

  # test that an empty list generates an error
  expect_snapshot(xlr_to_workbook(mtcars,sheet_name = 1),
                  error = TRUE)
})

test_that("xlr_to_workbook() checks the sheet_name type correctly", {
  # test that an empty list generates an error
  expect_snapshot(xlr_to_workbook(mtcars,"test",1),
                  error = TRUE)
})
test_that("xlr_to_workbook() checks the overwrite_sheet type correctly", {
  # test that an empty list generates an error
  expect_snapshot(xlr_to_workbook(mtcars,"test",overwrite_sheet = "wee"),
                  error = TRUE)
})
test_that("xlr_to_workbook() checks the TOC type correctly", {
  # test that an empty list generates an error
  expect_snapshot(xlr_to_workbook(mtcars,"test",TOC = "wee"),
                  error = TRUE)
})
test_that("xlr_to_workbook() checks the TOC_title type correctly", {
  # test that an empty list generates an error
  expect_snapshot(xlr_to_workbook(mtcars,"test",
                                   TOC = TRUE,
                                   TOC_title = FALSE),
                  error = TRUE)
})

test_that("xlr_to_workbook() checks the excel_data_table type correctly", {
  # test that an empty list generates an error
  expect_snapshot(xlr_to_workbook(mtcars,"test",
                                   excel_data_table = "TITLE"),
                  error = TRUE)
})

test_that("xlr_to_workbook() errors when you pass a sheet_name, and a list of data", {
  # test that an empty list generates an error
  expect_snapshot(xlr_to_workbook(list(mtcars,mtcars),"test"))
})

test_that("xlr_to_workbook() errors when you pass the wrong type in a list", {
  # test that an empty list generates an error
  expect_snapshot(xlr_to_workbook(list("asd",123)),
                  error = TRUE)
})

test_that("xlr_to_workbook() errors when you pass the wrong type", {
  # test that an empty list generates an error
  expect_snapshot(xlr_to_workbook(123),
                  error = TRUE)
})

test_that("xlr_to_workbook() errors when you pass a single object but not a sheetname", {
  # test that an empty list generates an error
  expect_snapshot(xlr_to_workbook(mtcars),
                  error = TRUE)
})

test_that("xlr_to_workbook() creates a file from a list of xlr_tables w/o TOC", {
  test_file <- test_path("test_xlsx_files","xlr_table_to_workbook_no_TOC.xlsx")
  # now get it as workbook
  wb_test <- openxlsx::loadWorkbook(test_file)
  # now create a work
  test_list <- list(
    "Test 1 - no footnote title" = xlr_table(mtcars),
    "Test 2 - no Footnote" = xlr_table(mtcars,
                                        "Test title"),
    "Test 3 - all" = xlr_table(mtcars,
                                "Test title",
                                "Test footnote")
  )

  wb <- xlr_to_workbook(test_list)
  expect_true(equal_workbook_sheets(wb,wb_test))
  # expect_true(equal_workbook_data(wb,wb_test))
  # now see if they have the same data
  # expect_true(equal_openxlsx_workbook(wb,wb_test))

  skip_on_cran()
  test_output <- test_path("_output_excel_snaps/xlr_table_to_workbook.xlsx")
  # we use openxlsx to write it
  saveWorkbook(wb,
               test_output,
               overwrite = TRUE)
})

test_that("xlr_to_workbook() creates a file from a list of xlr_tables", {
  test_file <- test_path("test_xlsx_files","xlr_table_to_workbook_TOC.xlsx")
  # now get it as workbook
  wb_test <- openxlsx::loadWorkbook(test_file)
  # now create a work
  test_list <- list(
    "Test 1 - no footnote title" = xlr_table(mtcars),
    "Test 2 - no Footnote" = xlr_table(mtcars,
                                        "Test title"),
    "Test 3 - all" = xlr_table(mtcars,
                                "Test title",
                                "Test footnote")
  )

  wb <- xlr_to_workbook(test_list,
                         TOC = TRUE,
                         TOC_title = "Table of Contents Title",
                         excel_data_table = TRUE)

  # Test first it returns a wb object
  expect_true(is_openxlsx_workbook(wb))
  # when testing, because we add a table of contents and this only changes
  # the worksheet order on printing we save it as a temporary file, and then
  # load it in (and it then gets deleted)
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  saveWorkbook(wb,tmp_file)
  # Now load it in (this is stupid, but I don't know how to do this in memory)
  wb_tmp <- openxlsx::loadWorkbook(tmp_file)


  expect_true(equal_workbook_sheets(wb_tmp,wb_test))
  # expect_true(equal_workbook_data(wb,wb_test))
  # now see if they have the same data
  # expect_true(equal_openxlsx_workbook(wb,wb_test))


  skip_on_cran()
  test_output <- test_path("_output_excel_snaps/xlr_table_to_workbook_TOC.xlsx")
  # we use openxlsx to write it
  saveWorkbook(wb,
               test_output,
               overwrite = TRUE)
})


test_that("xlr_to_workbook() appends to an existing workbook", {

  wb_old <- createWorkbook()
  sheets <- c("old1","old2","old3")
  sapply(sheets,\(x) append_worksheet(x,wb_old))
  # now add the daa
  sapply(sheets,\(x) writeData(wb_old,x,mtcars))

  # now create a work
  test_list <- list(
    "Test 1 - no footnote title" = xlr_table(mtcars),
    "Test 2 - no Footnote" = xlr_table(mtcars,
                                        "Test title"),
    "Test 3 - all" = xlr_table(mtcars,
                                "Test title",
                                "Test footnote")
  )

  wb <- xlr_to_workbook(test_list,old_wb = wb_old, TOC = TRUE)

  expect_equal(sheets(wb),
              c("old1","old2","old3","Test 1 - no footnote title","Test 2 - no Footnote","Test 3 - all","Table of Contents"))
  # expect_true(equal_workbook_data(wb,wb_test))
  # now see if they have the same data
  # expect_true(equal_openxlsx_workbook(wb,wb_test))

  skip_on_cran()
  test_output <- test_path("_output_excel_snaps/xlr_table_to_workbook_old_wb.xlsx")
  # we use openxlsx to write it
  saveWorkbook(wb,
               test_output,
               overwrite = TRUE)
})

test_that("xlr_to_workbook() appends to an existing and makes the correct TOC", {

  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  bt <- xlr_table(mtcars,"title 1","footnote")
  write_xlsx(bt,tmp_file,"Test sheet",TOC = FALSE)
  # now add on the list of files
  test_list <- list(
    "Test 1 - no footnote title" = xlr_table(mtcars),
    "Test 2 - no Footnote" = xlr_table(mtcars,
                                        "Test title"),
    "Test 3 - all" = xlr_table(mtcars,
                                "Test title",
                                "Test footnote")
  )

  # now load in the old workbook
  wb_old <- loadWorkbook(tmp_file)

  wb <- xlr_to_workbook(test_list,old_wb = wb_old, TOC = TRUE)

  expect_equal(sheets(wb),
               c("Test sheet","Test 1 - no footnote title","Test 2 - no Footnote","Test 3 - all","Table of Contents"))
  # expect_true(equal_workbook_data(wb,wb_test))
  # now see if they have the same data
  # expect_true(equal_openxlsx_workbook(wb,wb_test))

  skip_on_cran()
  test_output <- test_path("_output_excel_snaps/xlr_table_to_workbook_old_wb_2.xlsx")
  # we use openxlsx to write it
  saveWorkbook(wb,
               test_output,
               overwrite = TRUE)
})

