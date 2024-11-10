
test_that("write_xlsx() writes a file silently if it does not exist", {
  # first create a temporary table_of_contents file
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  # should not produce an error
  # Should not write anything.
  expect_silent(write_xlsx(mtcars,
                           tmp_file,
                           sheet_name = "Test",
                           TOC = FALSE))
  # expect it to create a file
  expect_true(file.exists(tmp_file))
})

test_that("write_xlsx() gives an error when append and overwrite is true", {
  # first create a temporary table_of_contents file
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))

  # should produce an error and not write anything
  expect_snapshot(write_xlsx(mtcars,
                             tmp_file,
                             sheet_name = "Test",
                             TOC = FALSE,
                             overwrite = TRUE,
                             append = TRUE),
                  error = TRUE)
  expect_false(file.exists(tmp_file))
})

test_that("write_xlsx() sends a message when it appends a file", {
  # first create a temporary table_of_contents file
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  # create a file to append too
  write_xlsx(mtcars,
             tmp_file,
             sheet_name = "Initial data",
             overwrite = FALSE,
             append = TRUE)
  # now that the file exists we expect to see some alerts about
  # overwriting and warnings
  expect_snapshot(write_xlsx(mtcars,
                             tmp_file,
                             sheet_name = "Test",
                             overwrite = FALSE,
                             append = TRUE),
                  transform = \(x) gsub("\\s\'.*\\.xlsx\'","",x))
})



test_that("write_xlsx() sends a message when it overwrites a file", {
  # first create a temporary table_of_contents file
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  # create a file to append too
  write_xlsx(mtcars,
             tmp_file,
             sheet_name = "Initial data",
             overwrite = FALSE)
  # now that the file exists we expect to see some alerts about
  # overwriting and warnings
  expect_snapshot(write_xlsx(mtcars,
                             tmp_file,
                             sheet_name = "Test",
                             overwrite = TRUE,
                             append = FALSE),
                  # delete the path of the file, as it changes it time
                  transform = \(x) gsub("\\s\'.*\\.xlsx\'","",x))
})



test_that("write_xlsx() sends an error when it is not allowed to modify a file", {
  # first create a temporary table_of_contents file
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  # create a file to append too
  write_xlsx(mtcars,
             tmp_file,
             sheet_name = "Initial data",
             overwrite = FALSE,
             TOC = FALSE)
  # now that the file exists we expect to see some alerts about
  # overwriting and warnings
  expect_snapshot(write_xlsx(mtcars,
                             tmp_file,
                             sheet_name = "Test",
                             overwrite = FALSE,
                             append = FALSE),
                  # delete the path of the file, as it changes it time
                  transform = \(x) gsub("\\s\'.*\\.xlsx\'","",x),
                  error = TRUE)
  # test it hasn't changed the file
  test_workbook <- loadWorkbook(tmp_file)
  # it should only contain one sheet
  expect_equal(sheets(test_workbook),"Initial data")

})
