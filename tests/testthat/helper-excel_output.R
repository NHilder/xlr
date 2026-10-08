# Path for an Excel file written by the tests so it can be checked manually.
# These files are not tracked by git. The writes are skipped on CRAN, as CRAN
# policy doesn't allow writing outside the temporary directory.
excel_output_path <- function(name) {
  skip_on_cran()
  dir <- test_path("_output_excel_snaps")
  dir.create(dir, showWarnings = FALSE, recursive = TRUE)
  file.path(dir, name)
}
