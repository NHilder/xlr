make_table <- function() {
  xlr_table(mtcars[1:3, 1:3], "A title", "A footnote")
}

test_that("get_title() and get_footnote() return the title and footnote", {
  x <- make_table()
  expect_equal(get_title(x), "A title")
  expect_equal(get_footnote(x), "A footnote")
  expect_equal(get_title(xlr_table(mtcars)), character())
  expect_equal(get_footnote(xlr_table(mtcars)), character())
})

test_that("set_title() and set_footnote() update only that attribute", {
  x <- make_table()

  out <- set_title(x, "New title")
  expect_equal(get_title(out), "New title")
  expect_equal(get_footnote(out), get_footnote(x))
  expect_equal(as_base_r(out), as_base_r(x))

  out <- set_footnote(x, c("Note 1", "", "Note 2"))
  expect_equal(get_footnote(out), c("Note 1", "", "Note 2"))
  expect_equal(get_title(out), get_title(x))
  expect_equal(get_title_format(out), get_title_format(x))
})

test_that("set_title() and set_footnote() remove the attribute with NULL", {
  x <- make_table()
  expect_equal(get_title(set_title(x, NULL)), character())
  expect_equal(get_footnote(set_footnote(x, NULL)), character())
  expect_equal(set_title(x, NULL), set_title(x, character()))
})

test_that("the format getters and setters round trip", {
  x <- make_table()
  fmt <- xlr_format(font_size = 20, font_colour = "red")

  expect_equal(get_title_format(set_title_format(x, fmt)), fmt)
  expect_equal(get_footnote_format(set_footnote_format(x, fmt)), fmt)
  expect_equal(get_column_heading_format(set_column_heading_format(x, fmt)), fmt)
  expect_equal(get_table_body_format(set_table_body_format(x, fmt)), fmt)

  # the other formats are unchanged
  out <- set_title_format(x, fmt)
  expect_equal(get_footnote_format(out), get_footnote_format(x))
  expect_equal(get_column_heading_format(out), get_column_heading_format(x))
  expect_equal(get_table_body_format(out), get_table_body_format(x))
  expect_equal(get_title(out), get_title(x))
})

test_that("the getters match the internal attributes", {
  x <- make_table()
  expect_equal(get_title_format(x), pull_title_format(x))
  expect_equal(get_footnote_format(x), pull_footnote_format(x))
  expect_equal(get_column_heading_format(x), pull_column_heading_format(x))
  expect_equal(get_table_body_format(x), pull_table_body_format(x))
})

test_that("the getters and setters error for a non xlr_table", {
  expect_snapshot(get_title(mtcars), error = TRUE)
  expect_snapshot(set_footnote(mtcars, "a"), error = TRUE)
  expect_snapshot(get_table_body_format(1), error = TRUE)
})

test_that("the setters error for invalid values", {
  x <- make_table()
  expect_snapshot(set_title(x, c("a", "b")), error = TRUE)
  expect_snapshot(set_title(x, 1), error = TRUE)
  expect_snapshot(set_footnote(x, 1), error = TRUE)
  expect_snapshot(set_title_format(x, "bold"), error = TRUE)
})

test_that("the attributes are kept through dplyr verbs after setting them", {
  fmt <- xlr_format(font_size = 20)
  x <- make_table() |>
    set_title("New title") |>
    set_footnote(c("Note 1", "Note 2")) |>
    set_table_body_format(fmt) |>
    dplyr::filter(cyl > 4) |>
    dplyr::mutate(mpg2 = mpg * 2)
  expect_s3_class(x, "xlr_table")
  expect_equal(get_title(x), "New title")
  expect_equal(get_footnote(x), c("Note 1", "Note 2"))
  expect_equal(get_table_body_format(x), fmt)
})

test_that("xlr_table() treats NULL as no title or footnote", {
  out <- xlr_table(mtcars, title = NULL, footnote = NULL)
  expect_equal(get_title(out), character())
  expect_equal(get_footnote(out), character())
  expect_equal(as_xlr_table(mtcars, title = NULL, footnote = NULL), out)
})
