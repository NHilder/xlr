test_that("is_openxlsx_workbook() works", {
  wb <- createWorkbook()
  expect_true(is_openxlsx_workbook(wb))
  wb2 <- copyWorkbook(wb)
  addWorksheet(wb,"test")
  expect_true(is_openxlsx_workbook(wb2))

  # not workbooks
  expect_false(is_openxlsx_workbook(mtcars))
})

test_that("is_workbook_error() works", {
  wb <- createWorkbook()
  expect_silent(is_workbook_error(wb))
  expect_error(is_workbook_error(mtcars))
})

test_that("equal_workbook_sheet() works", {
  wb <- createWorkbook()
  # create a reference to our first workbook
  wb_ref <- wb
  expect_true(equal_workbook_sheets(wb,wb_ref))
  wb2 <- copyWorkbook(wb)
  addWorksheet(wb,"test")
  # this should be false
  expect_false(equal_workbook_sheets(wb,wb2))

})

test_that("equal_workbook_data() works", {
  wb <- createWorkbook()
  # add data
  addWorksheet(wb,"test")
  writeData(wb,"test",mtcars)

  # now make a copy
  wb2 <- copyWorkbook(wb)

  # now see if they have the same data
  expect_true(equal_workbook_data(wb,wb2))
  # now add data and see if not equal
  # add data
  addWorksheet(wb,"test2")
  writeData(wb,"test2",mtcars)

  # this should be false
  expect_false(equal_workbook_data(wb,wb2))

})
#
# test_that("getStyles_safe() works", {
#   wb <- createWorkbook()
#   # add data
#   addWorksheet(wb,"test")
#   writeData(wb,"test",mtcars)
#
#   # now see if they have the same data
#   expect_equal(getStyles_safe(wb),NULL)
#   # now add a style
#   testStyle <- createStyle(fontSize = 14)
#   addStyle(wb,"test",testStyle,1,1)
#   # this should be false
#   expect_(getStyles_safe(wb))
#
# })
