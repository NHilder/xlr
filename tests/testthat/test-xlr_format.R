

test_that("font_size error messages", {
  # only the correct arguments
  expect_silent(xlr_format(font_size = 1))
  expect_silent(xlr_format(font_size = 2.5))

  expect_error(xlr_format(font_size = 0))
  expect_error(xlr_format(font_size = 410))
  expect_error(xlr_format(font_size = 2.6))

  expect_snapshot(xlr_format(font_size = 0),
                  error = TRUE)
  expect_snapshot(xlr_format(font_size = 410),
                  error = TRUE)
  expect_snapshot(xlr_format(font_size = 2.6),
                  error = TRUE)
})



test_that("font_colour error messages", {
  # only the correct arguments
  expect_silent(xlr_format(font_colour = "blue"))
  expect_silent(xlr_format(font_colour = "#FFFFFF"))

  expect_error(xlr_format(font_colour = 1))
  expect_error(xlr_format(font_colour = "wee"))

})



test_that("test error messages for text_style", {
  # only the correct arguments
  expect_error(xlr_format(text_style = "a"))
  expect_error(xlr_format(text_style = c("italic","bold","a")))
  # only one of the underlines works
  expect_error(xlr_format(text_style = c("underline","underline2")))
  expect_error(xlr_format(text_style = c("bold","bold")))
})

test_that("test error messages for border", {
  # only the correct arguments
  expect_silent(xlr_format(border = "left"))
  expect_silent(xlr_format(border = "right"))
  expect_silent(xlr_format(border = "top"))
  expect_silent(xlr_format(border = "bottom"))
  expect_silent(xlr_format(border = NULL))

  expect_silent(xlr_format(border = c("left","top")))
  expect_silent(xlr_format(border = c("left","right")))
  expect_silent(xlr_format(border = c("left","top","right")))
  expect_silent(xlr_format(border = c("left","top","bottom","right")))

  # expect errors
  expect_error(xlr_format(border = "a"))
  expect_error(xlr_format(border = c("left","top","a")))
  expect_error(xlr_format(border = c("left","left")))
})

test_that("test error messages for border colour", {
  # only the correct arguments
  expect_silent(xlr_format(border_colour = "blue"))
  expect_silent(xlr_format(border = c("left","right"),
                           border_colour = c("blue","blue")))
  expect_silent(xlr_format(border = c("left","right"),
                           border_colour = "blue"))

  expect_error(xlr_format(border = c("left"),
                          border_colour = c("blue","blue")))

})

test_that("test different border styles", {
  # only the correct arguments
  expect_silent(xlr_format(border_style = "none"))
  expect_silent(xlr_format(border_style = "thin"))
  expect_silent(xlr_format(border_style = "medium"))
  expect_silent(xlr_format(border_style = "dashed"))
  expect_silent(xlr_format(border_style = "dotted"))
  expect_silent(xlr_format(border_style = "thick"))
  expect_silent(xlr_format(border_style = "double"))
  expect_silent(xlr_format(border_style = "hair"))
  expect_silent(xlr_format(border_style = "mediumDashed"))
  expect_silent(xlr_format(border_style = "dashDot"))
  expect_silent(xlr_format(border_style = "mediumDashDot"))
  expect_silent(xlr_format(border_style = "dashDotDot"))
  expect_silent(xlr_format(border_style = "mediumDashDot"))
  expect_silent(xlr_format(border_style = "dastDotDot"))
  expect_silent(xlr_format(border_style = "mediumDashDotDot"))
  expect_silent(xlr_format(border_style = "slantDashDosh"))

  expect_error(xlr_format(border = c("left"),
                          border_style = c("slantDashDosh","slantDashDosh")))
  expect_error(xlr_format(border = c("left","right","top"),
                          border_style = c("slantDashDosh","slantDashDosh")))
})

test_that("border_colour error messages", {
  # only the correct arguments
  expect_silent(xlr_format(border_colour = "blue"))
  expect_silent(xlr_format(border_colour = "#FFFFFF"))

  expect_error(xlr_format(border_colour = 1))
  expect_error(xlr_format(border_colour = "wee"))

})

test_that("halign only takes the right things error messages", {
  # only the correct arguments
  expect_silent(xlr_format(halign = "left"))
  expect_silent(xlr_format(halign = "right"))
  expect_silent(xlr_format(halign = "center"))
  expect_silent(xlr_format(halign = "justify"))


  expect_error(xlr_format(halign = 1))
  expect_error(xlr_format(halign = "cats"))
  expect_error(xlr_format(halign = NULL))
})

test_that("valign only takes the right things error messages", {
  # only the correct arguments
  expect_silent(xlr_format(valign = "top"))
  expect_silent(xlr_format(valign = "center"))
  expect_silent(xlr_format(valign = "bottom"))


  expect_error(xlr_format(valign = 1))
  expect_error(xlr_format(valign = "cats"))
  expect_error(xlr_format(valign = NULL))
})

test_that("wrap_text does the right error messages", {
  # only the correct arguments
  expect_silent(xlr_format(wrap_text = TRUE))
  expect_error(xlr_format(wrap_text = NULL))
})

test_that("text_rotation follows the rules does the right error messages", {
  # only the correct arguments
  expect_silent(xlr_format(text_rotation = 0))
  expect_silent(xlr_format(text_rotation = 0L))
  expect_silent(xlr_format(text_rotation = 90L))
  expect_silent(xlr_format(text_rotation = -90L))

  expect_error(xlr_format(text_rotation = -91L))
  expect_error(xlr_format(text_rotation = 91L))
  expect_error(xlr_format(text_rotation = 0.2))
})

test_that("text_rotation follows the rules does the right error messages", {
  # only the correct arguments
  expect_silent(xlr_format(indent = 0))
  expect_silent(xlr_format(indent = 0L))
  expect_silent(xlr_format(indent = 90L))
  expect_silent(xlr_format(indent = 250))

  expect_error(xlr_format(indent = -1L))
  expect_error(xlr_format(indent = 251L))
  expect_error(xlr_format(indent = "a"))
})

test_that("is_xlr_format works correctly", {
  # only the correct arguments
  expect_true(is_xlr_format(xlr_format(indent = 0)))
  expect_false(is_xlr_format(mtcars))

})


test_that("equality is defined correctly", {
  # only the correct arguments
  expect_false(xlr_format(font_size = 11) == xlr_format(font_size = 8))
  expect_false(xlr_format(font_colour = "blue") == xlr_format(font_colour =
                                                                  "red"))
  expect_false(xlr_format(font = "calibri") == xlr_format(font = "helvetica"))
  expect_false(xlr_format(text_style = "bold") == xlr_format(text_style = "italic"))
  expect_false(xlr_format(border = NULL) == xlr_format(border = "left"))
  expect_false(xlr_format(border_colour = "red") == xlr_format(border_colour = "blue"))
  expect_false(xlr_format(border_style = "thin") == xlr_format(border_style = "medium"))
  expect_false(xlr_format(background_colour = "red") == xlr_format(background_colour = "blue"))
  expect_false(xlr_format() == xlr_format(halign = "right"))
  expect_false(xlr_format() == xlr_format(valign = "center"))
  expect_false(xlr_format() == xlr_format(wrap_text = TRUE))
  expect_false(xlr_format() == xlr_format(text_rotation = 90))
  expect_false(xlr_format() == xlr_format(indent = 2))

  expect_true(xlr_format() == xlr_format())
  expect_true(xlr_format(font_size = 8) == xlr_format(font_size = 8))
  expect_true(xlr_format(font_colour = "blue") == xlr_format(font_colour =
                                                                 "blue"))
  expect_true(xlr_format(font = "calibri") == xlr_format(font = "calibri"))
  expect_true(xlr_format(text_style = "bold") == xlr_format(text_style = "bold"))
  expect_true(xlr_format(border = "left") == xlr_format(border = "left"))
  expect_true(xlr_format(border = c("left","right")) ==
                            xlr_format(border = c("right","left")))
  expect_true(xlr_format(border_colour = "red") == xlr_format(border_colour = "red"))
  expect_true(xlr_format(border_style = "thin") == xlr_format(border_style = "thin"))
  expect_true(xlr_format(background_colour = "red") == xlr_format(background_colour = "red"))
  expect_true(xlr_format(halign = "right") == xlr_format(halign = "right"))
  expect_true(xlr_format(valign = "center") == xlr_format(valign = "center"))
  expect_true(xlr_format(wrap_text = TRUE) == xlr_format(wrap_text = TRUE))
  expect_true(xlr_format(text_rotation = 90) == xlr_format(text_rotation = 90))
  expect_true(xlr_format(indent = 2) == xlr_format(indent = 2))

})

test_that("inequality is defined correctly", {
  # only the correct arguments
  expect_true(xlr_format(font_size = 11) != xlr_format(font_size = 8))
  expect_false(xlr_format() != xlr_format())

})

test_that("print.xlr_format looks correct", {
  # only the correct arguments
  expect_snapshot(print(xlr_format()))
  expect_snapshot(print(xlr_format(border = "left")))
  expect_snapshot(print(xlr_format(border = c("right","left"))))
})

test_that("xlr_format_numeric initialisation works and creates a xlr_format", {
  # only the correct arguments
  expect_s3_class(xlr_format_numeric(),'xlr_format')
})

test_that("xlr_format_numeric default values different", {
  # only the correct arguments
  expect_false(xlr_format_numeric() == xlr_format())
})

test_that("xlr_format_numeric default values are correct", {
  # only the correct arguments
  expect_equal(xlr_format_numeric() |> pull_attr("halign"),"right")
  expect_equal(xlr_format_numeric() |> pull_attr("valign"),"bottom")
})


test_that("setting col_width works correctly", {
  # only the correct arguments
  expect_silent(xlr_format(col_width = 1))
  expect_silent(xlr_format(col_width = 1L))
  expect_equal(xlr_format(col_width = 1L) |> pull_attr("col_width"),1)

  # errors if outside the range
  expect_snapshot(xlr_format(col_width = -1),
                  error = TRUE)
  expect_snapshot(xlr_format(col_width = 255.4),
                  error = TRUE)
})

test_that("Dot's must be empty gives correct error", {
  # errors if outside the range
  expect_snapshot(xlr_format(x=123),
                  error = TRUE)
})

