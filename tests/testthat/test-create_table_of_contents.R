

test_that("create_table_of_contents() works correctly", {
  # first create a temporary table_of_contents file
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  write.xlsx(mtcars,tmp_file)
  # should not produce an error
  expect_silent(create_table_of_contents(tmp_file))
})

test_that("create_table_of_contents() creates an error when you don't pass a valid path", {
  # should not produce an error
  expect_error(create_table_of_contents("not_a_path"))
})

test_that("create_table_of_contents() creates an error when you don't pass a character title", {
  # first create a temporary table_of_contents file
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  # now write some data to it
  write.xlsx(mtcars,tmp_file)
  # should not produce an error
  expect_snapshot(create_table_of_contents(tmp_file,
                                           title = 1),
                  error = TRUE)
})

test_that("create_table_of_contents() creates an error when you don't pass a boolean overwrite", {
  # first create a temporary table_of_contents file
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  # now write some data to it
  write.xlsx(mtcars,tmp_file)# should not produce an error
  expect_snapshot(create_table_of_contents(tmp_file,
                                           overwrite = 1),
                  error = TRUE)
})

test_that("create_table_of_contents() creates an error when you don't pass a boolean pull_titles", {
  # first create a temporary table_of_contents file
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  # now write some data to it
  write.xlsx(mtcars,tmp_file)# should not produce an error
  expect_snapshot(create_table_of_contents(tmp_file,
                                           pull_titles = 1),
                  error = TRUE)
})

test_that("create_table_of_contents() creates an error when you don't pass a TOC_sheet_name is not a character", {
  # first create a temporary table_of_contents file
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  # now write some data to it
  write.xlsx(mtcars,tmp_file)# should not produce an error
  expect_snapshot(create_table_of_contents(tmp_file,
                                           TOC_sheet_name = 1),
                  error = TRUE)

})

test_that("create_table_of_contents() creates an error when an overwrite is FALSE", {
  # first create a temporary table_of_contents file
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  # should not produce an error
  write.xlsx(list("Table of Contents" = mtcars,mtcars),tmp_file)
  expect_snapshot(create_table_of_contents(tmp_file,
                                           overwrite = FALSE),
                  error = TRUE)

})

test_that("create_table_of_contents() creates an error when there is only a sheet called Table of Contents", {
  # first create a temporary table_of_contents file
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  # should not produce an error
  write.xlsx(list("Table of Contents" = mtcars),tmp_file)
  expect_snapshot(create_table_of_contents(tmp_file,
                                           overwrite = TRUE),
                  error = TRUE)

})

test_that("create_table_of_contents() creates a TOC without pulling titles from sheets correctly", {
  # first create a temporary table_of_contents file
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))

  data = list("Sheet 1" = mtcars,"Sheet 2" = mtcars)
  write.xlsx(data,tmp_file)
  create_table_of_contents(tmp_file,
                           title = "Test title",
                           pull_titles = FALSE)
  # Check that some of the data is correct
  # annoyingly we can't check hyperlinks
  title <- read.xlsx(tmp_file,
                     "Table of Contents",
                     rows = 1,
                     cols = 1,
                     sep.names = " ")
  expect_equal(colnames(title),"Test title")
})

test_that("create_table_of_contents() creates a TOC correctly", {
  # first create a temporary table_of_contents file
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))

  data = list("Sheet 1" = mtcars,"Sheet 2" = mtcars)
  write.xlsx(data,tmp_file)
  create_table_of_contents(tmp_file,
                           title = "Test title",
                           pull_titles = TRUE)
  wb <- loadWorkbook(tmp_file)
  # Check that some of the data is correct
  # annoyingly we can't check hyperlinks
  data <- readWorkbook(wb,
                       sheet="Table of Contents",
                       rows = c(2:5),
                       cols = c(1:2),
                       skipEmptyCols = FALSE,
                       skipEmptyRows = FALSE,
                       colNames = FALSE)
  colnames(data) <- c("hyperlink","titles")
  # now test if the
  expect_equal(data[["titles"]],c("mpg","mpg"))
})

test_that("create_table_of_contents() creates a TOC without pulling titles from sheets correctly", {
  # first create a temporary table_of_contents file
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  data = list("Sheet 1" = mtcars,"Sheet 2" = mtcars)
  write.xlsx(data,tmp_file)

  # now run the file
  create_table_of_contents(tmp_file,
                           title = "Test title",
                           pull_titles = FALSE)

  # now read it back in
  title <- read.xlsx(tmp_file,
                     "Table of Contents",
                     rows = 1,
                     cols = 1,
                     sep.names = " ")
  expect_equal(colnames(title),"Test title")
})


test_that("create_table_of_contents() creates a TOC (formatting to be checked manually)", {
  skip_on_cran()

  # first create a temporary table_of_contents file
  example_path <- test_path("test_xlsx_files","example_workbook_no_TOC.xlsx")
  #
  snap_path <- test_path("_output_excel_snaps","create_table_of_contents.xlsx")
  # now we first make a copy of this example file to the snaps folder and
  # then run table of contents, and overwrite the old version if it exists
  file.copy(example_path,snap_path,overwrite = TRUE)

  create_table_of_contents(snap_path,
                           title = "Test title",
                           pull_titles = TRUE)
  expect_true(TRUE)
})

