remove_path <- \(x) gsub("\\s\'.*\\.xlsx\'", "", x)

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

test_that("write_xlsx() ignores if_exists when the file does not exist", {
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  expect_silent(write_xlsx(mtcars, tmp_file, "Test", if_exists = "error"))
  expect_true(file.exists(tmp_file))
})

test_that("write_xlsx() appends a file with if_exists = 'append'", {
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  write_xlsx(mtcars, tmp_file, sheet_name = "Initial data")

  expect_snapshot(write_xlsx(mtcars,
                             tmp_file,
                             sheet_name = "Test",
                             if_exists = "append"),
                  transform = remove_path)
  expect_equal(sheets(loadWorkbook(tmp_file)), c("Initial data", "Test"))
})

test_that("write_xlsx() overwrites a file with if_exists = 'overwrite'", {
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  write_xlsx(mtcars, tmp_file, sheet_name = "Initial data")

  expect_snapshot(write_xlsx(mtcars,
                             tmp_file,
                             sheet_name = "Test",
                             if_exists = "overwrite"),
                  transform = remove_path)
  expect_equal(sheets(loadWorkbook(tmp_file)), "Test")
})

test_that("write_xlsx() errors with if_exists = 'error' and leaves the file", {
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  write_xlsx(mtcars, tmp_file, sheet_name = "Initial data")

  expect_snapshot(write_xlsx(mtcars,
                             tmp_file,
                             sheet_name = "Test",
                             if_exists = "error"),
                  transform = remove_path,
                  error = TRUE)
  expect_equal(sheets(loadWorkbook(tmp_file)), "Initial data")
})

test_that("write_xlsx() errors outside an interactive session if if_exists is not set", {
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  write_xlsx(mtcars, tmp_file, sheet_name = "Initial data")

  local_mocked_bindings(is_interactive = \() FALSE)
  expect_snapshot(write_xlsx(mtcars, tmp_file, sheet_name = "Test"),
                  transform = remove_path,
                  error = TRUE)
  expect_equal(sheets(loadWorkbook(tmp_file)), "Initial data")
})

test_that("write_xlsx() asks what to do in an interactive session", {
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  write_xlsx(mtcars, tmp_file, sheet_name = "Initial data")

  local_mocked_bindings(is_interactive = \() TRUE)

  # Append
  local_mocked_bindings(menu = \(...) 2L, .package = "utils")
  suppressMessages(write_xlsx(mtcars, tmp_file, sheet_name = "Appended"))
  expect_equal(sheets(loadWorkbook(tmp_file)), c("Initial data", "Appended"))

  # Cancel
  local_mocked_bindings(menu = \(...) 3L, .package = "utils")
  expect_snapshot(write_xlsx(mtcars, tmp_file, sheet_name = "Cancelled"),
                  transform = remove_path,
                  error = TRUE)
  expect_equal(sheets(loadWorkbook(tmp_file)), c("Initial data", "Appended"))

  # Overwrite
  local_mocked_bindings(menu = \(...) 1L, .package = "utils")
  suppressMessages(write_xlsx(mtcars, tmp_file, sheet_name = "Overwritten"))
  expect_equal(sheets(loadWorkbook(tmp_file)), "Overwritten")
})

test_that("write_xlsx() validates if_exists", {
  tmp_file <- tempfile(fileext = ".xlsx")
  expect_snapshot(write_xlsx(mtcars, tmp_file, "Test", if_exists = "replace"),
                  error = TRUE)
  # a logical in the old position of `overwrite`
  expect_snapshot(write_xlsx(mtcars, tmp_file, "Test", TRUE),
                  error = TRUE)
  expect_false(file.exists(tmp_file))
})

# Deprecated arguments ---------------------------------------------------------

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

test_that("write_xlsx() maps the deprecated arguments to if_exists with a warning", {
  tmp_file <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp_file))
  write_xlsx(mtcars, tmp_file, sheet_name = "Initial data")

  # append = TRUE was the old default
  expect_snapshot(write_xlsx(mtcars, tmp_file, "Appended", overwrite = FALSE),
                  transform = remove_path)
  expect_equal(sheets(loadWorkbook(tmp_file)), c("Initial data", "Appended"))

  expect_snapshot(write_xlsx(mtcars, tmp_file, "Overwritten", overwrite = TRUE),
                  transform = remove_path)
  expect_equal(sheets(loadWorkbook(tmp_file)), "Overwritten")

  expect_snapshot(write_xlsx(mtcars, tmp_file, "Test",
                             overwrite = FALSE, append = FALSE),
                  transform = remove_path,
                  error = TRUE)
  expect_equal(sheets(loadWorkbook(tmp_file)), "Overwritten")
})

test_that("write_xlsx() errors when if_exists is used with the deprecated arguments", {
  tmp_file <- tempfile(fileext = ".xlsx")
  expect_snapshot(write_xlsx(mtcars, tmp_file, "Test",
                             if_exists = "overwrite", overwrite = TRUE),
                  error = TRUE)
})
