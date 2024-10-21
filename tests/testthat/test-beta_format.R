

test_that("font_size error messages", {
  # only the correct arguments
  expect_silent(beta_format(font_size = 1))
  expect_silent(beta_format(font_size = 2.5))

  expect_error(beta_format(font_size = 0))
  expect_error(beta_format(font_size = 410))
  expect_error(beta_format(font_size = 2.6))

  expect_snapshot(beta_format(font_size = 0),
                  error = TRUE)
  expect_snapshot(beta_format(font_size = 410),
                  error = TRUE)
  expect_snapshot(beta_format(font_size = 2.6),
                  error = TRUE)
})



test_that("font_colour error messages", {
  # only the correct arguments
  expect_silent(beta_format(font_colour = "blue"))
  expect_silent(beta_format(font_colour = "#FFFFFF"))

  expect_error(beta_format(font_colour = 1))
  expect_error(beta_format(font_colour = "wee"))

})



test_that("test error messages for text_style", {
  # only the correct arguments
  expect_error(beta_format(text_style = "a"))
  expect_error(beta_format(text_style = c("italic","bold","a")))
  # only one of the underlines works
  expect_error(beta_format(text_style = c("underline","underline2")))
  expect_error(beta_format(text_style = c("bold","bold")))
})

test_that("test error messages for border", {
  # only the correct arguments
  expect_silent(beta_format(border = "left"))
  expect_silent(beta_format(border = "right"))
  expect_silent(beta_format(border = "top"))
  expect_silent(beta_format(border = "bottom"))
  expect_silent(beta_format(border = NULL))

  expect_silent(beta_format(border = c("left","top")))
  expect_silent(beta_format(border = c("left","right")))
  expect_silent(beta_format(border = c("left","top","right")))
  expect_silent(beta_format(border = c("left","top","bottom","right")))

  # expect errors
  expect_error(beta_format(border = "a"))
  expect_error(beta_format(border = c("left","top","a")))
  expect_error(beta_format(border = c("left","left")))
})

test_that("test error messages for border colour", {
  # only the correct arguments
  expect_silent(beta_format(border_colour = "blue"))
  expect_silent(beta_format(border = c("left","right"),
                           border_colour = c("blue","blue")))
  expect_silent(beta_format(border = c("left","right"),
                           border_colour = "blue"))

  expect_error(beta_format(border = c("left"),
                          border_colour = c("blue","blue")))

})

test_that("test different border styles", {
  # only the correct arguments
  expect_silent(beta_format(border_style = "none"))
  expect_silent(beta_format(border_style = "thin"))
  expect_silent(beta_format(border_style = "medium"))
  expect_silent(beta_format(border_style = "dashed"))
  expect_silent(beta_format(border_style = "dotted"))
  expect_silent(beta_format(border_style = "thick"))
  expect_silent(beta_format(border_style = "double"))
  expect_silent(beta_format(border_style = "hair"))
  expect_silent(beta_format(border_style = "mediumDashed"))
  expect_silent(beta_format(border_style = "dashDot"))
  expect_silent(beta_format(border_style = "mediumDashDot"))
  expect_silent(beta_format(border_style = "dashDotDot"))
  expect_silent(beta_format(border_style = "mediumDashDot"))
  expect_silent(beta_format(border_style = "dastDotDot"))
  expect_silent(beta_format(border_style = "mediumDashDotDot"))
  expect_silent(beta_format(border_style = "slantDashDosh"))

  expect_error(beta_format(border = c("left"),
                          border_style = c("slantDashDosh","slantDashDosh")))
  expect_error(beta_format(border = c("left","right","top"),
                          border_style = c("slantDashDosh","slantDashDosh")))
})

test_that("border_colour error messages", {
  # only the correct arguments
  expect_silent(beta_format(border_colour = "blue"))
  expect_silent(beta_format(border_colour = "#FFFFFF"))

  expect_error(beta_format(border_colour = 1))
  expect_error(beta_format(border_colour = "wee"))

})

test_that("halign only takes the right things error messages", {
  # only the correct arguments
  expect_silent(beta_format(halign = "left"))
  expect_silent(beta_format(halign = "right"))
  expect_silent(beta_format(halign = "center"))
  expect_silent(beta_format(halign = "justify"))


  expect_error(beta_format(halign = 1))
  expect_error(beta_format(halign = "cats"))
  expect_error(beta_format(halign = NULL))
})

test_that("valign only takes the right things error messages", {
  # only the correct arguments
  expect_silent(beta_format(valign = "top"))
  expect_silent(beta_format(valign = "center"))
  expect_silent(beta_format(valign = "bottom"))


  expect_error(beta_format(valign = 1))
  expect_error(beta_format(valign = "cats"))
  expect_error(beta_format(valign = NULL))
})

test_that("wrap_text does the right error messages", {
  # only the correct arguments
  expect_silent(beta_format(wrap_text = TRUE))
  expect_error(beta_format(wrap_text = NULL))
})

test_that("text_rotation follows the rules does the right error messages", {
  # only the correct arguments
  expect_silent(beta_format(text_rotation = 0))
  expect_silent(beta_format(text_rotation = 0L))
  expect_silent(beta_format(text_rotation = 90L))
  expect_silent(beta_format(text_rotation = -90L))

  expect_error(beta_format(text_rotation = -91L))
  expect_error(beta_format(text_rotation = 91L))
  expect_error(beta_format(text_rotation = 0.2))
})

test_that("text_rotation follows the rules does the right error messages", {
  # only the correct arguments
  expect_silent(beta_format(indent = 0))
  expect_silent(beta_format(indent = 0L))
  expect_silent(beta_format(indent = 90L))
  expect_silent(beta_format(indent = 250))

  expect_error(beta_format(indent = -1L))
  expect_error(beta_format(indent = 251L))
  expect_error(beta_format(indent = "a"))
})

test_that("is_beta_format works correctly", {
  # only the correct arguments
  expect_true(is_beta_format(beta_format(indent = 0)))
  expect_false(is_beta_format(mtcars))

})


test_that("equality is defined correctly", {
  # only the correct arguments
  expect_false(beta_format(font_size = 11) == beta_format(font_size = 8))
  expect_false(beta_format(font_colour = "blue") == beta_format(font_colour =
                                                                  "red"))
  expect_false(beta_format(font = "calibri") == beta_format(font = "helvetica"))
  expect_false(beta_format(text_style = "bold") == beta_format(text_style = "italic"))
  expect_false(beta_format(border = NULL) == beta_format(border = "left"))
  expect_false(beta_format(border_colour = "red") == beta_format(border_colour = "blue"))
  expect_false(beta_format(border_style = "thin") == beta_format(border_style = "medium"))
  expect_false(beta_format(background_colour = "red") == beta_format(background_colour = "blue"))
  expect_false(beta_format() == beta_format(halign = "right"))
  expect_false(beta_format() == beta_format(valign = "center"))
  expect_false(beta_format() == beta_format(wrap_text = TRUE))
  expect_false(beta_format() == beta_format(text_rotation = 90))
  expect_false(beta_format() == beta_format(indent = 2))

  expect_true(beta_format() == beta_format())
  expect_true(beta_format(font_size = 8) == beta_format(font_size = 8))
  expect_true(beta_format(font_colour = "blue") == beta_format(font_colour =
                                                                 "blue"))
  expect_true(beta_format(font = "calibri") == beta_format(font = "calibri"))
  expect_true(beta_format(text_style = "bold") == beta_format(text_style = "bold"))
  expect_true(beta_format(border = "left") == beta_format(border = "left"))
  expect_true(beta_format(border = c("left","right")) ==
                            beta_format(border = c("right","left")))
  expect_true(beta_format(border_colour = "red") == beta_format(border_colour = "red"))
  expect_true(beta_format(border_style = "thin") == beta_format(border_style = "thin"))
  expect_true(beta_format(background_colour = "red") == beta_format(background_colour = "red"))
  expect_true(beta_format(halign = "right") == beta_format(halign = "right"))
  expect_true(beta_format(valign = "center") == beta_format(valign = "center"))
  expect_true(beta_format(wrap_text = TRUE) == beta_format(wrap_text = TRUE))
  expect_true(beta_format(text_rotation = 90) == beta_format(text_rotation = 90))
  expect_true(beta_format(indent = 2) == beta_format(indent = 2))

})

test_that("inequality is defined correctly", {
  # only the correct arguments
  expect_true(beta_format(font_size = 11) != beta_format(font_size = 8))
  expect_false(beta_format() != beta_format())

})

test_that("print.beta_format looks correct", {
  # only the correct arguments
  expect_snapshot(print(beta_format()))
  expect_snapshot(print(beta_format(border = "left")))
  expect_snapshot(print(beta_format(border = c("right","left"))))
})



